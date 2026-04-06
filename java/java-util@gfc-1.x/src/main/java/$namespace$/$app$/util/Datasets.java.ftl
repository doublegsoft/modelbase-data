<#import '/$/modelbase.ftl' as modelbase>
<#import "/$/modelbase4java.ftl" as modelbase4java>
<#if license??>
${java.license(license)}
</#if>
package ${namespace}.${app.name}.util;

import java.io.*;
import java.lang.reflect.*;
import java.util.*;
import java.util.function.*;
import java.util.stream.*;

/**
 * It's the string utility.

 */
public class Datasets {

  /**
   * Groups a list of elements by given fields and performs multiple aggregations.
   *
   * <p>The result is a list of maps where:
   * <ul>
   *   <li>Each map represents a group</li>
   *   <li>Keys are aggregation names defined in {@code AggregateSpecification}</li>
   *   <li>Values are aggregation results</li>
   * </ul>
   *
   * @param dataset the source data list
   * @param aggSpecs the aggregation specifications (must not be empty)
   * @param groupColumnNames the field names used for grouping (one or more)
   * @param <T> the type of elements in the dataset
   * @return a list of grouped aggregation results
   * @throws IllegalArgumentException if {@code aggSpecs} is empty
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
   * 两条 List 按指定键横向合并，返回结果集。
   * value 实际是一个 Map（也可以是自定义 DTO）。
   *
   * @param listA   第一个列表（类型 A）
   * @param keyFnA  从 A 中取匹配键的函数
   * @param listB   第二个列表（类型 B）
   * @param keyFnB  从 B 中取匹配键的函数
   * @param merger  合并函数，接收两个集合对象，返回属性 Map
   * @param <K>    键的类型（本例使用 String）
   * @param <A>    列表 A 的元素类型
   * @param <B>    列表 B 的元素类型
   * @return 合并后的结果，键为连接键的字符串形式，值为 merger 生成的属性 Map
   * @throws IllegalArgumentException if listA or listB is null
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

  /**
   * 两个 List 的 LEFT JOIN（左表 → 右表），返回 List（每一次匹配产生一条记录）。
   *
   * @param left          左表集合（必返回全部记录）
   * @param right         右表集合
   * @param leftKeyFn     从左表元素提取连接键的函数
   * @param rightKeyFn    从右表元素提取连接键的函数
   * @param merger        合并函数： (L left, R right) -> OUT
   *                     right 为 null 时表示左侧没有匹配
   * @param <L>          左表元素类型
   * @param <R>          右表元素类型
   * @param <K>          连接键类型（必须实现 equals / hashCode）
   * @param <OUT>        合并后返回的对象类型（可以是 Map、DTO、或原始对象的子类）
   * @return 每一次匹配（或左侧无匹配）产生的记录集合
   */
  public static <L, R, K, OUT> List<OUT> join(
      List<L> left,
      List<R> right,
      Function<? super L, K> leftKeyFn,
      Function<? super R, K> rightKeyFn,
      BiFunction<? super L, ? super R, OUT> merger) {

    // 把右表聚成 Map<K, List<R>>
    Map<K, List<R>> rightMap = right.stream()
        .collect(Collectors.groupingBy(rightKeyFn));

    // 遍历左表，产生合并结果
    List<OUT> result = new ArrayList<>();

    for (L l : left) {
      K key = leftKeyFn.apply(l);
      List<R> matches = rightMap.get(key);

      // 没有匹配 → 只产生一条（右侧为 null）的记录
      if (matches == null || matches.isEmpty()) {
        result.add(merger.apply(l, null));
      } else {
        // 有匹配 → 每一条右记录都产生一次合并输出
        for (R r : matches) {
          result.add(merger.apply(l, r));
        }
      }
    }
    return result;
  }

  public static <A, B, C, K1, K2, AB, OUT> List<OUT> join3(
      List<A> listA,
      List<B> listB,
      List<C> listC,
      Function<? super A, K1> keyAtoB,
      Function<? super B, K1> keyB,
      Function<? super A, K2> keyAtoC,
      Function<? super C, K2> keyC,
      BiFunction<? super A, ? super B, AB> abMerger,
      BiFunction<? super AB, ? super C, OUT> finalMerger) {

    // 1️⃣ 构建索引
    Map<K1, List<B>> mapB = listB.stream()
        .collect(Collectors.groupingBy(keyB));

    Map<K2, List<C>> mapC = listC.stream()
        .collect(Collectors.groupingBy(keyC));

    List<OUT> result = new ArrayList<>();

    for (A a : listA) {

      List<B> bs = mapB.getOrDefault(
          keyAtoB.apply(a),
          Collections.singletonList(null));

      List<C> cs = mapC.getOrDefault(
          keyAtoC.apply(a),
          Collections.singletonList(null));

      // 2️⃣ 笛卡尔展开
      for (B b : bs) {
        AB ab = abMerger.apply(a, b);

        for (C c : cs) {
          result.add(finalMerger.apply(ab, c));
        }
      }
    }

    return result;
  }

  public static <A, B, C, D, K1, K2, K3, AB, ABC, OUT> List<OUT> join4(
      List<A> listA,
      List<B> listB,
      List<C> listC,
      List<D> listD,
      Function<? super A, K1> keyAtoB,
      Function<? super B, K1> keyB,
      Function<? super A, K2> keyAtoC,
      Function<? super C, K2> keyC,
      Function<? super A, K3> keyAtoD,
      Function<? super D, K3> keyD,
      BiFunction<? super A, ? super B, AB> abMerger,
      BiFunction<? super AB, ? super C, ABC> abcMerger,
      BiFunction<? super ABC, ? super D, OUT> finalMerger) {

    Map<K1, List<B>> mapB = listB.stream()
        .collect(Collectors.groupingBy(keyB));

    Map<K2, List<C>> mapC = listC.stream()
        .collect(Collectors.groupingBy(keyC));

    Map<K3, List<D>> mapD = listD.stream()
        .collect(Collectors.groupingBy(keyD));

    List<OUT> result = new ArrayList<>();

    for (A a : listA) {

      List<B> bs = mapB.getOrDefault(keyAtoB.apply(a), Collections.singletonList(null));
      List<C> cs = mapC.getOrDefault(keyAtoC.apply(a), Collections.singletonList(null));
      List<D> ds = mapD.getOrDefault(keyAtoD.apply(a), Collections.singletonList(null));

      for (B b : bs) {
        AB ab = abMerger.apply(a, b);

        for (C c : cs) {
          ABC abc = abcMerger.apply(ab, c);

          for (D d : ds) {
            result.add(finalMerger.apply(abc, d));
          }
        }
      }
    }

    return result;
  }


  public enum AggregateType {
    COUNT,          // 计数（不需要指定字段，默认对整个记录计数）
    SUM,            // 求和
    AVG,            // 平均值（内部会根据 SUM + COUNT 计算）
    MIN,            // 最小值
    MAX,            // 最大值
    DISTINCT_COUNT, // 去重计数
    FIRST,          // 第一个（保持流的顺序）
    LAST            // 最后一个
  }

  public static class AggregateSpecification {
    private final String   name;   // 结果中使用的键名
    private final AggregateType  type;
    private final String   field;  // 需要聚合的属性名（COUNT、FIRST、LAST 可 null）

    public AggregateSpecification(String name, AggregateType type, String field) {
      this.name  = name;
      this.type  = type;
      this.field = field;
    }

    public String getName()   { return name;   }
    public AggregateType getType() { return type;   }
    public String getField() { return field;   }

    /** 方便创建（可链式调用） */
    public static AggregateSpecification sum(String name, String field) {
      return new AggregateSpecification(name, AggregateType.SUM, field);
    }
    public static AggregateSpecification avg(String name, String field) {
      return new AggregateSpecification(name, AggregateType.AVG, field);
    }
    public static AggregateSpecification min(String name, String field) {
      return new AggregateSpecification(name, AggregateType.MIN, field);
    }
    public static AggregateSpecification max(String name, String field) {
      return new AggregateSpecification(name, AggregateType.MAX, field);
    }
    public static AggregateSpecification distinctCount(String name, String field) {
      return new AggregateSpecification(name, AggregateType.DISTINCT_COUNT, field);
    }
    public static AggregateSpecification count(String name) {
      return new AggregateSpecification(name, AggregateType.COUNT, null);
    }
    public static AggregateSpecification first(String name, String field) {
      return new AggregateSpecification(name, AggregateType.FIRST, field);
    }
    public static AggregateSpecification last(String name, String field) {
      return new AggregateSpecification(name, AggregateType.LAST, field);
    }
  }

  public static class AggregateAccumulator {
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

  public static void main(String[] args) {

    List<Team> teams = List.of(
        new Team(1L, "Barcelona"),
        new Team(2L, "Real Madrid"),
        new Team(3L, "Bayern")
    );

    List<Match> matches = List.of(
        new Match(100L, 1L, 2L),
        new Match(101L, 2L, 3L),
        new Match(102L, 1L, 99L) // away 不存在
    );

    List<MatchView> result = join3(
        matches,
        teams,
        teams,

        // home join
        Match::getHomeTeamId,
        Team::getId,

        // away join
        Match::getAwayTeamId,
        Team::getId,

        // A + B（match + home）
        (match, home) -> new MatchHome(match, home),

        // (match+home) + away
        (mh, away) -> new MatchView(
            mh.match,
            mh.home,
            away
        )
    );

    System.out.println("===== MATCH JOIN =====");
    result.forEach(System.out::println);

    List<Action> actions = List.of(
        new Action(1L, "Start"),
        new Action(2L, "Approve"),
        new Action(3L, "Finish")
    );

    List<Connection> conns = List.of(
        new Connection(1L, 2L, 3L),
        new Connection(2L, 3L, 99L) // next 不存在
    );

    List<ConnView> result1 = join4(
        conns,
        actions,
        actions,
        actions,

        // prev
        Connection::getPrevActionId,
        Action::getId,

        // curr
        Connection::getCurrActionId,
        Action::getId,

        // next
        Connection::getNextActionId,
        Action::getId,

        // step1: conn + prev
        (conn, prev) -> new ConnPrev(conn, prev),

        // step2: (conn+prev) + curr
        (cp, curr) -> new ConnPrevCurr(cp.conn, cp.prev, curr),

        // step3: + next
        (cpc, next) -> new ConnView(
            cpc.conn,
            cpc.prev,
            cpc.curr,
            next
        )
    );

    System.out.println("===== WORKFLOW JOIN =====");
    result1.forEach(System.out::println);
  }

  static class Team {
    Long id;
    String name;

    public Team(Long id, String name) {
      this.id = id;
      this.name = name;
    }

    public Long getId() { return id; }

    public String toString() { return name; }
  }

  static class Match {
    Long id;
    Long homeTeamId;
    Long awayTeamId;

    public Match(Long id, Long homeTeamId, Long awayTeamId) {
      this.id = id;
      this.homeTeamId = homeTeamId;
      this.awayTeamId = awayTeamId;
    }

    public Long getHomeTeamId() { return homeTeamId; }
    public Long getAwayTeamId() { return awayTeamId; }
  }

  static class MatchHome {
    Match match;
    Team home;

    public MatchHome(Match m, Team h) {
      this.match = m;
      this.home = h;
    }
  }

  static class MatchView {
    Match match;
    Team home;
    Team away;

    public MatchView(Match m, Team h, Team a) {
      this.match = m;
      this.home = h;
      this.away = a;
    }

    public String toString() {
      return "Match " + match.id +
          ": " + home + " vs " + away;
    }

  }

  static class Action {
    Long id;
    String name;

    public Action(Long id, String name) {
      this.id = id;
      this.name = name;
    }

    public Long getId() { return id; }

    public String toString() { return name; }
  }

  static class Connection {
    Long prevActionId;
    Long currActionId;
    Long nextActionId;

    public Connection(Long p, Long c, Long n) {
      this.prevActionId = p;
      this.currActionId = c;
      this.nextActionId = n;
    }

    public Long getPrevActionId() { return prevActionId; }
    public Long getCurrActionId() { return currActionId; }
    public Long getNextActionId() { return nextActionId; }
  }

  static class ConnPrev {
    Connection conn;
    Action prev;

    public ConnPrev(Connection c, Action p) {
      this.conn = c;
      this.prev = p;
    }
  }

  static class ConnPrevCurr {
    Connection conn;
    Action prev;
    Action curr;

    public ConnPrevCurr(Connection c, Action p, Action cur) {
      this.conn = c;
      this.prev = p;
      this.curr = cur;
    }
  }

  static class ConnView {
    Connection conn;
    Action prev;
    Action curr;
    Action next;

    public ConnView(Connection c, Action p, Action cur, Action n) {
      this.conn = c;
      this.prev = p;
      this.curr = cur;
      this.next = n;
    }

    public String toString() {
      return "[" + prev + " → " + curr + " → " + next + "]";
    }
  }

}
