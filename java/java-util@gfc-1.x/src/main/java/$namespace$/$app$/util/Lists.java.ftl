<#import '/$/modelbase.ftl' as modelbase>
<#import "/$/modelbase4java.ftl" as modelbase4java>
<#if license??>
${java.license(license)}
</#if>
package ${namespace}.${app.name}.util;

import java.util.*;
import java.util.function.Function;
import java.util.function.Predicate;
import java.util.stream.Collectors;

/**
 * List 工具类，提供合并、去重、过滤、转换、交并差等常用静态方法。
 * 所有方法均为 null 安全、线程安全（不可变返回）。
 */
public class Lists {

  // ------------------ 合并 ------------------

  /**
   * 合并多个 List（不去重）
   */
  @SafeVarargs
  public static <T> List<T> merge(List<T>... lists) {
    if (lists == null || lists.length == 0) {
      return new ArrayList<>();
    }
    List<T> result = new ArrayList<>();
    for (List<T> list : lists) {
      if (list != null) {
        result.addAll(list);
      }
    }
    return result;
  }

  /**
   * 合并多个 List 并去重（保持插入顺序）
   */
  @SafeVarargs
  public static <T> List<T> mergeDistinct(List<T>... lists) {
    if (lists == null || lists.length == 0) {
      return new ArrayList<>();
    }
    Set<T> set = new LinkedHashSet<>();
    for (List<T> list : lists) {
      if (list != null) {
        set.addAll(list);
      }
    }
    return new ArrayList<>(set);
  }

  // ------------------ 去重 ------------------

  /**
   * 去重（保持插入顺序）
   */
  public static <T> List<T> distinct(List<T> list) {
    if (list == null || list.isEmpty()) {
      return new ArrayList<>();
    }
    return new ArrayList<>(new LinkedHashSet<>(list));
  }

  /**
   * 根据 key 去重（保持第一个出现的顺序）
   */
  public static <T, K> List<T> distinctBy(List<T> list, Function<? super T, ? extends K> keyMapper) {
    if (list == null || list.isEmpty()) {
      return new ArrayList<>();
    }
    Map<K, T> map = new LinkedHashMap<>();
    for (T item : list) {
      K key = keyMapper.apply(item);
      map.putIfAbsent(key, item);
    }
    return new ArrayList<>(map.values());
  }

  // ------------------ 过滤 ------------------

  /**
   * 过滤符合条件的元素
   */
  public static <T> List<T> filter(List<T> list, Predicate<? super T> predicate) {
    if (list == null || list.isEmpty() || predicate == null) {
      return new ArrayList<>();
    }
    return list.stream()
      .filter(predicate)
      .collect(Collectors.toList());
  }

  // ------------------ 转换 ------------------

  /**
   * List 转 Map（key 冲突保留最后一个）
   */
  public static <T, K, V> Map<K, V> toMap(List<T> list,
                                          Function<? super T, ? extends K> keyMapper,
                                          Function<? super T, ? extends V> valueMapper) {
    if (list == null || list.isEmpty()) {
      return new HashMap<>();
    }
    return list.stream()
      .collect(Collectors.toMap(keyMapper, valueMapper, (oldVal, newVal) -> newVal));
  }

  /**
   * List 转 Set
   */
  public static <T> Set<T> toSet(List<T> list) {
    if (list == null || list.isEmpty()) {
      return new HashSet<>();
    }
    return new HashSet<>(list);
  }

  // ------------------ 交并差集 ------------------

  /**
   * 交集（list1 ∩ list2）
   */
  public static <T> List<T> intersect(List<T> list1, List<T> list2) {
    if (list1 == null || list2 == null) {
      return new ArrayList<>();
    }
    Set<T> set = new HashSet<>(list1);
    set.retainAll(list2);
    return new ArrayList<>(set);
  }

  /**
   * 并集（list1 ∪ list2，去重）
   */
  public static <T> List<T> union(List<T> list1, List<T> list2) {
    if (list1 == null) return new ArrayList<>(list2 != null ? list2 : new ArrayList<>());
    if (list2 == null) return new ArrayList<>(list1);
    Set<T> set = new LinkedHashSet<>(list1);
    set.addAll(list2);
    return new ArrayList<>(set);
  }

  /**
   * 差集（list1 - list2）
   */
  public static <T> List<T> difference(List<T> list1, List<T> list2) {
    if (list1 == null || list1.isEmpty()) {
      return new ArrayList<>();
    }
    if (list2 == null || list2.isEmpty()) {
      return new ArrayList<>(list1);
    }
    Set<T> set = new LinkedHashSet<>(list1);
    set.removeAll(list2);
    return new ArrayList<>(set);
  }

  // ------------------ 其他常用 ------------------

  /**
   * 判空
   */
  public static boolean isEmpty(List<?> list) {
    return list == null || list.isEmpty();
  }

  /**
   * 判非空
   */
  public static boolean isNotEmpty(List<?> list) {
    return !isEmpty(list);
  }

  /**
   * 获取第一个元素（null 安全）
   */
  public static <T> T first(List<T> list) {
    return isEmpty(list) ? null : list.get(0);
  }

  /**
   * 获取最后一个元素（null 安全）
   */
  public static <T> T last(List<T> list) {
    return isEmpty(list) ? null : list.get(list.size() - 1);
  }
}