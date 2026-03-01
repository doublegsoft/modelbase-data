<#import '/$/modelbase.ftl' as modelbase>
<#import "/$/modelbase4java.ftl" as modelbase4java>
<#if license??>
${java.license(license)}
</#if>
package ${namespace}.${app.name}.util;

import java.time.*;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
import java.time.temporal.ChronoUnit;

/**
 * 日期工具类，提供常用日期格式化、解析、计算等静态方法。
 * 所有方法均为线程安全、null 安全。
 */
public class Dates {

  // ------------------ 当前时间 ------------------

  /**
   * 获取当前时间 ISO 8601 格式（带毫秒和 Z）
   * 示例: 2026-03-01T12:34:56.789Z
   */
  public static String nowIso() {
    return Instant.now().toString();
  }

  /**
   * 获取当前时间默认格式 yyyy-MM-dd HH:mm:ss
   */
  public static String nowDefault() {
    return LocalDateTime.now()
      .format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));
  }

  /**
   * 获取当前日期 yyyy-MM-dd
   */
  public static String todayDate() {
    return LocalDate.now()
      .format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));
  }

  // ------------------ 格式化 ------------------

  /**
   * 格式化 LocalDateTime 为指定模式
   */
  public static String format(LocalDateTime dateTime, String pattern) {
    if (dateTime == null) {
      return null;
    }
    return dateTime.format(DateTimeFormatter.ofPattern(pattern));
  }

  /**
   * 格式化 LocalDate 为指定模式
   */
  public static String format(LocalDate date, String pattern) {
    if (date == null) {
      return null;
    }
    return date.format(DateTimeFormatter.ofPattern(pattern));
  }

  // ------------------ 解析 ------------------

  /**
   * 解析字符串为 LocalDateTime
   */
  public static LocalDateTime parseLocalDateTime(String dateStr, String pattern) {
    if (dateStr == null || dateStr.trim().isEmpty()) {
      return null;
    }
    try {
      return LocalDateTime.parse(dateStr, DateTimeFormatter.ofPattern(pattern));
    } catch (DateTimeParseException e) {
      throw new IllegalArgumentException("Cannot parse: " + dateStr);
    }
  }

  /**
   * 解析字符串为 LocalDate
   */
  public static LocalDate parseLocalDate(String dateStr, String pattern) {
    if (dateStr == null || dateStr.trim().isEmpty()) {
      return null;
    }
    try {
      return LocalDate.parse(dateStr, DateTimeFormatter.ofPattern(pattern));
    } catch (DateTimeParseException e) {
      throw new IllegalArgumentException("Cannot parse: " + dateStr);
    }
  }

  // ------------------ 当天起止时间 ------------------

  /**
   * 获取当天 00:00:00
   */
  public static LocalDateTime todayStart() {
    return LocalDate.now().atStartOfDay();
  }

  /**
   * 获取当天 23:59:59.999999999
   */
  public static LocalDateTime todayEnd() {
    return LocalDate.now().atTime(LocalTime.MAX);
  }

  // ------------------ 时间差计算 ------------------

  /**
   * 计算两个日期之间的天数差（不含结束日）
   */
  public static long daysBetween(LocalDate start, LocalDate end) {
    if (start == null || end == null) {
      return 0;
    }
    return ChronoUnit.DAYS.between(start, end);
  }

  /**
   * 计算两个日期时间之间的秒数差
   */
  public static long secondsBetween(LocalDateTime start, LocalDateTime end) {
    if (start == null || end == null) {
      return 0;
    }
    return ChronoUnit.SECONDS.between(start, end);
  }

  // ------------------ 友好时间 ------------------

  /**
   * 友好时间格式（刚刚、几分钟前、昨天、几天前）
   */
  public static String friendlyTime(LocalDateTime time) {
    if (time == null) {
      return "";
    }
    LocalDateTime now = LocalDateTime.now();
    long seconds = ChronoUnit.SECONDS.between(time, now);
    if (seconds < 60) {
      return "刚刚";
    }
    if (seconds < 3600) {
      return seconds / 60 + "分钟前";
    }
    if (seconds < 86400) {
      return seconds / 3600 + "小时前";
    }
    long days = ChronoUnit.DAYS.between(time.toLocalDate(), now.toLocalDate());
    if (days == 1) {
      return "昨天";
    }
    if (days < 7) {
      return days + "天前";
    }
    return time.format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));
  }

  private Dates() {

  }
}
