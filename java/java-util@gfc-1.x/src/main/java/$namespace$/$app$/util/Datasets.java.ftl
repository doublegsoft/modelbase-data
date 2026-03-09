<#import '/$/modelbase.ftl' as modelbase>
<#import "/$/modelbase4java.ftl" as modelbase4java>
<#if license??>
${java.license(license)}
</#if>
package ${namespace}.${app.name}.util;

import java.io.*;
import java.nio.file.Files;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.lang.reflect.*;
import java.util.*;
import java.util.function.*;
import java.util.stream.*;

/**
 * It's the string utility.
 * 
 * @author <a href="mailto:guo.guo.gan@gmail.com">Christian Gann</a>
 *
 * @since 2.0
 */
public class Datasets {

  /**
   * 对 List<T> 按若干属性分组，并一次性完成所有 AggSpec 中声明的聚合。
   * <p>
   *   返回值为 {@code List<Map<String,Object>>}：<br>
   *   - 每个 Map 代表一个分组；<br>
   *   - Map 中的键为 AggSpec.name（如 "totalAmount"），值为对应聚合结果。
   *
   * @param dataset          原始数据集合
   * @param aggSpecs         需要执行的聚合列表（可以有任意数量）
   * @param groupColumnNames 用来分组的属性名（一个或多个）
   * @param <T>              列表元素的类型
   * @return List<Map<String,Object>>
   */
  @SuppressWarnings("unchecked") 
  public static <T> List<Map<String,Object>> group(
      List<T> dataset,
      List<AggregateSpecification> aggSpecs,
      String... groupColumnNames) {

    if (dataset == null || dataset.isEmpty()) return Collections.emptyList();
    if (aggSpecs == null || aggSpecs.isEmpty())
      throw new IllegalArgumentException("aggSpecs must not be empty");

    /* -------------------------------------------------
     * 为每个分组列生成一次性取值函数（避免遍历时每条记录都走反射）
     * ------------------------------------------------- */
    List<Function<T,Object>> groupExtractors = Arrays.stream(groupColumnNames)
        .map(col -> (Function<T,Object>) buildExtractor(col))
        .collect(Collectors.toList());

    /* -------------------------------------------------
     * 为每个 AggSpec 生成对应的取值函数
     * ------------------------------------------------- */
    List<Function<?, Object>> valueExtractors = aggSpecs.stream()
        .<Function<T,Object>>map(spec -> {
          if (spec.getField() == null) return (Function<T,Object>) t -> null;
          // 数值聚合需要转成 Number，其他聚合保留原始 Object
          if (EnumSet.of(AggregateType.SUM, AggregateType.AVG,
              AggregateType.MIN, AggregateType.MAX, AggregateType.DISTINCT_COUNT)
              .contains(spec.getType())) {
            return buildNumberExtractor(spec.getField());
          }
          return buildExtractor(spec.getField());
        })
        .collect(Collectors.toList());

    /* -------------------------------------------------
     * 分组 + 多聚合（自定义 Collector）
     * ------------------------------------------------- */
    Map<String, Map<String,Object>> intermediate = dataset.stream()
        .collect(Collectors.groupingBy(
            item -> groupExtractors.stream()
                .map(fn -> fn.apply(item))
                .map(Object::toString)                 // 拼接成唯一键
                .collect(Collectors.joining("|")),
            Collector.of(
                // ---------- supplier ----------
                () -> new AggregateAccumulator(aggSpecs, valueExtractors),

                // ---------- accumulator ----------
                (acc, elem) -> acc.accept(elem),

                // ---------- combiner ----------
                (a, b) -> { a.combine(b); return a; },

                // ---------- finisher ----------
                AggregateAccumulator::toResultMap,
                Collector.Characteristics.UNORDERED)));

    /* -------------------------------------------------
     * 把内部 Map 转成 List<Map>（保持插入顺序更友好）
     * ------------------------------------------------- */
    List<Map<String,Object>> finalResult = new ArrayList<>(intermediate.size());
    for (Map.Entry<String, Map<String,Object>> e : intermediate.entrySet()) {
      String groupKeyValues = e.getKey();      // 按顺序存放的分组列值
      Map<String,Object> aggMap = e.getValue();    // 聚合结果

      // **把分组列写进结果 map**
      LinkedHashMap<String,Object> row = new LinkedHashMap<>();
      String[] groupVals = groupKeyValues.split("\\|");
      for (int i = 0; i < groupColumnNames.length; i++) {
        row.put(groupColumnNames[i], groupVals[i]);
      }
      // 再写入聚合列
      row.putAll(aggMap);
      finalResult.add(row);
    }
    return finalResult;
  }
  
  /**
   * 两条 List 按指定键横向合并，返回 Map<key, Object>。
   * value 实际是一个 Map<String,Object>（也可以是自定义 DTO）。
   *
   * @param listA   第一个列表（类型 A）
   * @param keyFnA  从 A 中取匹配键的函数
   * @param listB   第二个列表（类型 B）
   * @param keyFnB  从 B 中取匹配键的函数
   * @param merger  合并函数，接收 Optional<A>、Optional<B>，返回属性 Map
   * @param <K>    键的类型（本例使用 String）
   * @param <A>    列表 A 的元素类型
   * @param <B>    列表 B 的元素类型
   * @return Map<String, Object>
   */
  public static <K, A, B> Map<String, Object> merge(
      List<A> listA,
      Function<? super A, K> keyFnA,
      List<B> listB,
      Function<? super B, K> keyFnB,
      BiFunction<Optional<A>, Optional<B>, Map<String, Object>> merger) {

    // ① 把两条 List 先转成 Map<key, element>
    Map<K, A> mapA = listA.stream()
        .collect(Collectors.toMap(keyFnA, Function.identity(),
                (v1, v2) -> v1));      // 键冲突保留第一个

    Map<K, B> mapB = listB.stream()
        .collect(Collectors.toMap(keyFnB, Function.identity(),
                (v1, v2) -> v1));

    // ② 键并集 → 对每个键执行合并 → 直接收集成 Map<String,Object>
    return Stream.concat(mapA.keySet().stream(), mapB.keySet().stream())
        .distinct()
        .collect(Collectors.toMap(
            key -> key.toString(),                     // 外层键转为 String
            key -> merger.apply(
                Optional.ofNullable(mapA.get(key)),
                Optional.ofNullable(mapB.get(key)))));
  }

  /* ==============================================================
   * 1）一对一 LEFT JOIN → Map<LeftKey, Map<String,Object>>
   * ============================================================== */
  public static <L, R, K> Map<K, Map<String,Object>> leftJoinOneToOne(
      List<L> left,
      List<R> right,
      Function<? super L, K> leftKeyFn,
      Function<? super R, K> rightKeyFn,
      BiFunction<L,R,Map<String,Object>> merger) {

    // ① 把右表放进 Map<K,R>（如果出现冲突保留第一个）
    Map<K,R> rightMap = right.stream()
        .collect(Collectors.toMap(rightKeyFn, Function.identity(),
                (a,b) -> a));

    // ② 遍历左表，构造合并后的 Map
    Map<K,Map<String,Object>> result = new LinkedHashMap<>();
    for (L l : left) {
      K key   = leftKeyFn.apply(l);
      R rObj = rightMap.get(key);                     // 可能为 null
      result.put(key, merger.apply(l, rObj));
    }
    return result;
  }

  /* ==============================================================
   * 2）一对多 LEFT JOIN → Map<LeftKey, List<Map<String,Object>>>
   * ============================================================== */
  public static <L, R, K> Map<K, List<Map<String,Object>>> leftJoinOneToMany(
      List<L> left,
      List<R> right,
      Function<? super L, K> leftKeyFn,
      Function<? super R, K> rightKeyFn,
      BiFunction<L,R,Map<String,Object>> merger) {

    // ① 把右表聚成 Map<K,List<R>>
    Map<K, List<R>> rightGrouped = right.stream()
        .collect(Collectors.groupingBy(rightKeyFn));

    // ② 遍历左表，生成 List<Map>（若没有匹配则返回空列表）
    Map<K, List<Map<String,Object>>> result = new LinkedHashMap<>();
    for (L l : left) {
      K key = leftKeyFn.apply(l);
      List<R> matches = rightGrouped.getOrDefault(key, Collections.emptyList());

      // 如果没有匹配，仍然需要返回一条空记录（LEFT 的语义）
      if (matches.isEmpty()) {
        result.put(key, Collections.singletonList(merger.apply(l, null)));
      } else {
        List<Map<String,Object>> combined = new ArrayList<>(matches.size());
        for (R r : matches) {
          combined.add(merger.apply(l, r));
        }
        result.put(key, combined);
      }
    }
    return result;
  }

  /* ==============================================================
   * 3）统一的属性提取帮助函数（可复用）
   * ============================================================== */
  /** 把 POJO 的属性转成 Map（不包括 null 项） */
  public static Map<String,Object> beanToMap(Object bean) {
    if (bean == null) return Collections.emptyMap();
    Map<String,Object> map = new LinkedHashMap<>();
    Class<?> cls = bean.getClass();

    // 先查字段（包括 private），再查 getter
    for (Field f : getAllFields(cls)) {
      f.setAccessible(true);
      try {
        Object v = f.get(bean);
        if (v != null) map.put(f.getName(), v);
      } catch (IllegalAccessException ignored) {}
    }
    return map;
  }

  /** 递归收集类及其父类的所有字段 */
  private static List<Field> getAllFields(Class<?> clazz) {
    List<Field> fields = new ArrayList<>();
    for (Class<?> c = clazz; c != null; c = c.getSuperclass()) {
      fields.addAll(Arrays.asList(c.getDeclaredFields()));
    }
    return fields;
  }

  private static class AggregateAccumulator {
    private final List<AggregateSpecification> specs;
    private final List<Function<?,Object>> valueGetters; // 与 specs 对齐
    private final List<Object> states;                    // 中间状态

    @SuppressWarnings("unchecked")
    AggregateAccumulator(List<AggregateSpecification> specs,
                  List<Function<?,Object>> valueGetters) {
      this.specs       = specs;
      this.valueGetters= valueGetters;
      this.states      = new ArrayList<>(Collections.nCopies(specs.size(), null));

      // 初始化每个聚合的中间状态
      for (int i = 0; i < specs.size(); i++) {
        AggregateSpecification s = specs.get(i);
        switch (s.getType()) {
          case COUNT:           states.set(i, 0L);            break; // long
          case SUM:
          case AVG:             states.set(i, 0.0);          break; // double
          case MIN:             states.set(i, Double.MAX_VALUE); break;
          case MAX:             states.set(i, -Double.MAX_VALUE);break;
          case DISTINCT_COUNT: states.set(i, new HashSet<>());break;
          case FIRST:           states.set(i, new Object[]{null,false}); break; // {value,filled}
          case LAST:            states.set(i, null);          break;
        }
      }
    }

    /** 处理单条记录 */
    @SuppressWarnings("unchecked")
    void accept(Object elem) {
      for (int i = 0; i < specs.size(); i++) {
        AggregateSpecification spec = specs.get(i);
        Function<Object,Object> getter = (Function<Object,Object>) valueGetters.get(i);
        Object raw = spec.getField() == null ? null : getter.apply(elem);

        switch (spec.getType()) {
          case COUNT:
            states.set(i, (Long)states.get(i) + 1L);
            break;
          case SUM:
          case AVG:
            if (raw != null) {
              double v = ((Number)raw).doubleValue();
              states.set(i, (Double)states.get(i) + v);
            }
            break;
          case MIN:
            if (raw != null) {
              double v = ((Number)raw).doubleValue();
              double cur = (Double)states.get(i);
              if (v < cur) states.set(i, v);
            }
            break;
          case MAX:
            if (raw != null) {
              double v = ((Number)raw).doubleValue();
              double cur = (Double)states.get(i);
              if (v > cur) states.set(i, v);
            }
            break;
          case DISTINCT_COUNT:
            if (raw != null) ((Set<Object>)states.get(i)).add(raw);
            break;
          case FIRST:
            Object[] holder = (Object[])states.get(i); // [value,filled?]
            if (!((Boolean)holder[1]) && raw != null) {
              holder[0] = raw;
              holder[1] = true;
            }
            break;
          case LAST:
            if (raw != null) states.set(i, raw);
            break;
        }
      }
    }

    /** 合并两个累计器（并行流需要） */
    @SuppressWarnings("unchecked")
    AggregateAccumulator combine(AggregateAccumulator other) {
      for (int i = 0; i < specs.size(); i++) {
        AggregateSpecification spec = specs.get(i);
        switch (spec.getType()) {
          case COUNT:
            states.set(i, (Long)states.get(i) + (Long)other.states.get(i));
            break;
          case SUM:
          case AVG:
            states.set(i, (Double)states.get(i) + (Double)other.states.get(i));
            break;
          case MIN:
            states.set(i, Math.min((Double)states.get(i), (Double)other.states.get(i)));
            break;
          case MAX:
            states.set(i, Math.max((Double)states.get(i), (Double)other.states.get(i)));
            break;
          case DISTINCT_COUNT:
            ((Set<Object>)states.get(i)).addAll((Set<Object>)other.states.get(i));
            break;
          case FIRST:
            Object[] thisFirst = (Object[])states.get(i);
            Object[] otherFirst = (Object[])other.states.get(i);
            if (!((Boolean)thisFirst[1]) && (Boolean)otherFirst[1]) {
              thisFirst[0] = otherFirst[0];
              thisFirst[1] = true;
            }
            break;
          case LAST:
            if (other.states.get(i) != null) states.set(i, other.states.get(i));
            break;
        }
      }
      return this;
    }

    /** 把内部状态转成最终的 Map<String,Object>（外层聚合结果） */
    Map<String,Object> toResultMap() {
      Map<String,Object> out = new LinkedHashMap<>();
      for (int i = 0; i < specs.size(); i++) {
        AggregateSpecification s = specs.get(i);
        Object v = states.get(i);
        switch (s.getType()) {
          case COUNT:
            out.put(s.getName(), v);
            break;
          case SUM:
            out.put(s.getName(), v);
            break;
          case AVG:
            long cnt = findCountForAvg();          // 可能用户自己声明过 COUNT
            double avg = cnt == 0 ? 0d : ((Double)v) / cnt;
            out.put(s.getName(), avg);
            break;
          case MIN:
            out.put(s.getName(),
                ((Double)v).equals(Double.MAX_VALUE) ? null : v);
            break;
          case MAX:
            out.put(s.getName(),
                ((Double)v).equals(-Double.MAX_VALUE) ? null : v);
            break;
          case DISTINCT_COUNT:
            out.put(s.getName(), (long)((Set<?>)v).size());
            break;
          case FIRST:
            Object[] arr = (Object[])v;
            out.put(s.getName(), (Boolean)arr[1] ? arr[0] : null);
            break;
          case LAST:
            out.put(s.getName(), v);
            break;
        }
      }
      return out;
    }

    /** 查找本组里对应的 COUNT（如果用户没有声明 COUNT，则默认 1 条记录） */
    private long findCountForAvg() {
      for (int i = 0; i < specs.size(); i++) {
        if (specs.get(i).getType() == AggregateType.COUNT) {
          return (Long)states.get(i);
        }
      }
      return 1L; // 至少有一条记录
    }
  }

  private static <T> Function<T,Object> buildExtractor(String columnName) {
    return (T instance) -> {
      if (instance == null) return null;
      Class<?> clazz = instance.getClass();

      // 直接访问字段（private、protected 也能）
      try {
        Field f = getFieldRecursive(clazz, columnName);
        if (f != null) {
          f.setAccessible(true);
          return f.get(instance);
        }
      } catch (IllegalAccessException ignored) {}

      // 按 JavaBean 规范找 getter
      String getter = "get" + capitalize(columnName);
      try {
        Method m = clazz.getMethod(getter);
        return m.invoke(instance);
      } catch (Exception ignored) {}

      // 布尔型 isXxx
      String isGetter = "is" + capitalize(columnName);
      try {
        Method m = clazz.getMethod(isGetter);
        return m.invoke(instance);
      } catch (Exception ignored) {}

      return null;   // 未找到返回 null
    };
  }

  private static <T> Function<T,Object> buildNumberExtractor(String fieldName) {
    return (Function<T,Object>) buildExtractor(fieldName).andThen(o -> (Object)o);
  }

  private static Field getFieldRecursive(Class<?> clazz, String name) {
    Class<?> cur = clazz;
    while (cur != null) {
      try {
        return cur.getDeclaredField(name);
      } catch (NoSuchFieldException e) {
        cur = cur.getSuperclass();
      }
    }
    return null;
  }

  private static String capitalize(String s) {
    if (s == null || s.isEmpty()) return s;
    return s.substring(0,1).toUpperCase() + s.substring(1);
  }

  private Datasets() {

  }
}
