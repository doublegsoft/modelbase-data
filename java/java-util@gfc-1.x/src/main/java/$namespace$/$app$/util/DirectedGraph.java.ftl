<#import '/$/modelbase.ftl' as modelbase>
<#import "/$/modelbase4java.ftl" as modelbase4java>
<#if license??>
${java.license(license)}
</#if>
package ${namespace}.${app.name}.util;

import java.lang.reflect.Field;
import java.util.*;

/**
 * Generic Directed Graph based on reflection.
 *
 * @param <A> Action type
 * @param <C> Connection type
 */
public class DirectedGraph<A, C> {

  private final Map<String, A> actionMap = new HashMap<>();
  private final Map<String, Set<String>> nextMap = new HashMap<>();
  private final Map<String, Set<String>> prevMap = new HashMap<>();

  private final String actionIdField;
  private final String fromField;
  private final String toField;

  public DirectedGraph(
      List<A> actions,
      List<C> connections,
      String actionIdField,
      String fromField,
      String toField
  ) {
    this.actionIdField = actionIdField;
    this.fromField = fromField;
    this.toField = toField;

    // init actions
    for (A a : actions) {
      String id = getFieldValue(a, actionIdField);
      actionMap.put(id, a);
      nextMap.put(id, new LinkedHashSet<>());
      prevMap.put(id, new LinkedHashSet<>());
    }

    // build edges
    for (C c : connections) {
      String from = getFieldValue(c, fromField);
      String to = getFieldValue(c, toField);

      if (!actionMap.containsKey(from) || !actionMap.containsKey(to)) {
        throw new IllegalArgumentException("Invalid connection: " + from + " -> " + to);
      }

      nextMap.get(from).add(to);
      prevMap.get(to).add(from);
    }
  }

  /** Reflection helper */
  private String getFieldValue(Object obj, String fieldName) {
    try {
      Field f = getFieldRecursive(obj.getClass(), fieldName);
      if (f == null) {
        throw new RuntimeException("Field not found: " + fieldName);
      }
      f.setAccessible(true);
      Object v = f.get(obj);
      return v == null ? null : v.toString();
    } catch (Exception e) {
      throw new RuntimeException(e);
    }
  }

  private Field getFieldRecursive(Class<?> cls, String name) {
    Class<?> cur = cls;
    while (cur != null) {
      try {
        return cur.getDeclaredField(name);
      } catch (NoSuchFieldException e) {
        cur = cur.getSuperclass();
      }
    }
    return null;
  }

  // ===== APIs =====

  public List<A> getPrev(String actionId) {
    return prevMap.getOrDefault(actionId, Set.of())
        .stream()
        .map(actionMap::get)
        .toList();
  }

  public List<A> getNext(String actionId) {
    return nextMap.getOrDefault(actionId, Set.of())
        .stream()
        .map(actionMap::get)
        .toList();
  }

  public List<A> getStartActions() {
    return actionMap.keySet().stream()
        .filter(id -> prevMap.get(id).isEmpty())
        .map(actionMap::get)
        .toList();
  }

  public List<A> getEndActions() {
    return actionMap.keySet().stream()
        .filter(id -> nextMap.get(id).isEmpty())
        .map(actionMap::get)
        .toList();
  }

  // ===== Demo =====
  public static void main(String[] args) {

    class Action {
      String actionId;
      Action(String id) { this.actionId = id; }
      public String toString() { return actionId; }
    }

    class Conn {
      String from;
      String to;
      Conn(String f, String t) { this.from = f; this.to = t; }
    }

    List<Action> actions = List.of(
        new Action("A"),
        new Action("B"),
        new Action("C"),
        new Action("D")
    );

    List<Conn> conns = List.of(
        new Conn("A", "B"),
        new Conn("A", "C"),
        new Conn("B", "D")
    );

    DirectedGraph<Action, Conn> graph =
        new DirectedGraph<>(actions, conns,
            "actionId", "from", "to");

    System.out.println("Start: " + graph.getStartActions());
    System.out.println("End: " + graph.getEndActions());
    System.out.println("Next(A): " + graph.getNext("A"));
    System.out.println("Prev(D): " + graph.getPrev("D"));
  }
}
