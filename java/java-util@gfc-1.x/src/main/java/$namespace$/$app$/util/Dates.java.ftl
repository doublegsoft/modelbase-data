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
import java.util.Date;
import java.util.List;
import java.util.Set;
import java.util.HashSet;

/**
 * 日期工具类，支持 java.util.Date 和 java.time.* API。
 * 所有方法均为 null 安全、线程安全。
 */
public class Dates {

  // ------------------ 当前时间 ------------------

  public static String nowIso() {
    return Instant.now().toString();  // 示例: 2026-03-01T12:34:56.789Z
  }

  public static String nowDefault() {
    return LocalDateTime.now()
      .format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));
  }

  public static String todayDate() {
    return LocalDate.now()
      .format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));
  }

  // ------------------ 格式化 ------------------

  public static String format(Object date, String pattern) {
    if (date == null) {
      return null;
    }

    DateTimeFormatter formatter = DateTimeFormatter.ofPattern(pattern);

    if (date instanceof Date) {
      return Instant.ofEpochMilli(((Date) date).getTime())
        .atZone(ZoneId.systemDefault())
        .toLocalDateTime()
        .format(formatter);
    }

    if (date instanceof LocalDateTime) {
      return ((LocalDateTime) date).format(formatter);
    }

    if (date instanceof LocalDate) {
      return ((LocalDate) date).format(formatter);
    }

    if (date instanceof Instant) {
      return ((Instant) date).atZone(ZoneId.systemDefault())
        .toLocalDateTime()
        .format(formatter);
    }

    throw new IllegalArgumentException("Unsupported date type: " + date.getClass().getName());
  }

  public static String formatDefault(Object date) {
    return format(date, "yyyy-MM-dd HH:mm:ss");
  }

  // ------------------ 解析 ------------------

  public static Date parseDate(String dateStr, String pattern) {
    if (dateStr == null || dateStr.trim().isEmpty()) {
      return null;
    }
    try {
      LocalDateTime ldt = LocalDateTime.parse(dateStr, DateTimeFormatter.ofPattern(pattern));
      return Date.from(ldt.atZone(ZoneId.systemDefault()).toInstant());
    } catch (DateTimeParseException e) {
      throw new IllegalArgumentException("Cannot parse: " + dateStr);
    }
  }

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

  public static LocalDateTime todayStart() {
    return LocalDate.now().atStartOfDay();
  }

  public static LocalDateTime todayEnd() {
    return LocalDate.now().atTime(LocalTime.MAX);
  }

  public static Date todayStartAsDate() {
    return Date.from(todayStart().atZone(ZoneId.systemDefault()).toInstant());
  }

  public static Date todayEndAsDate() {
    return Date.from(todayEnd().atZone(ZoneId.systemDefault()).toInstant());
  }

  // ------------------ 天数差 ------------------

  /**
   * 计算两个日期之间的天数差（不含结束日）
   * 支持 Date / LocalDate / LocalDateTime / Instant
   */
  public static long daysBetween(Object start, Object end) {
    LocalDate startDate = toLocalDate(start);
    LocalDate endDate = toLocalDate(end);
    if (startDate == null || endDate == null) {
      return 0;
    }
    return ChronoUnit.DAYS.between(startDate, endDate);
  }

  // ------------------ 工作日计算 ------------------

  /**
   * 计算从 startDate 开始，经过 workDays 个工作日后的日期
   * 假日列表 holidays 为 LocalDate 的 Set 或 List，会被跳过
   * 周末（周六、周日）自动视为非工作日
   */
  public static LocalDate addWorkdays(LocalDate startDate, int workDays, List<LocalDate> holidays) {
    if (startDate == null) {
      return null;
    }
    if (workDays == 0) {
      return startDate;
    }

    Set<LocalDate> holidaySet = holidays == null ? new HashSet<>() : new HashSet<>(holidays);

    LocalDate current = startDate;
    int added = 0;

    while (added < workDays) {
      current = current.plusDays(1);
      DayOfWeek dow = current.getDayOfWeek();
      // 不是周末，且不在假日列表中 → 算一个工作日
      if (dow != DayOfWeek.SATURDAY && dow != DayOfWeek.SUNDAY && !holidaySet.contains(current)) {
        added++;
      }
    }

    return current;
  }

  /**
   * 重载：支持 java.util.Date 类型输入
   */
  public static Date addWorkdays(Date startDate, int workDays, List<LocalDate> holidays) {
    if (startDate == null) {
      return null;
    }
    LocalDate localStart = startDate.toInstant()
      .atZone(ZoneId.systemDefault())
      .toLocalDate();
    LocalDate result = addWorkdays(localStart, workDays, holidays);
    return result == null ? null : Date.from(result.atStartOfDay(ZoneId.systemDefault()).toInstant());
  }

  // ------------------ 辅助转换 ------------------

  private static LocalDate toLocalDate(Object obj) {
    if (obj == null) {
      return null;
    }
    if (obj instanceof Date) {
      return ((Date) obj).toInstant()
        .atZone(ZoneId.systemDefault())
        .toLocalDate();
    }
    if (obj instanceof LocalDate) {
      return (LocalDate) obj;
    }
    if (obj instanceof LocalDateTime) {
      return ((LocalDateTime) obj).toLocalDate();
    }
    if (obj instanceof Instant) {
      return ((Instant) obj).atZone(ZoneId.systemDefault()).toLocalDate();
    }
    throw new IllegalArgumentException("Unsupported date type: " + obj.getClass().getName());
  }

  // ------------------ 友好时间 ------------------

  public static String friendlyTime(Object time) {
    if (time == null) {
      return "";
    }

    LocalDateTime ldt;
    if (time instanceof Date) {
      ldt = ((Date) time).toInstant()
        .atZone(ZoneId.systemDefault())
        .toLocalDateTime();
    } else if (time instanceof LocalDateTime) {
      ldt = (LocalDateTime) time;
    } else {
      throw new IllegalArgumentException("Unsupported time type: " + time.getClass().getName());
    }

    LocalDateTime now = LocalDateTime.now();
    long seconds = ChronoUnit.SECONDS.between(ldt, now);

    if (seconds < 60) {
      return "刚刚";
    }
    if (seconds < 3600) {
      return seconds / 60 + "分钟前";
    }
    if (seconds < 86400) {
      return seconds / 3600 + "小时前";
    }

    long days = ChronoUnit.DAYS.between(ldt.toLocalDate(), now.toLocalDate());
    if (days == 1) {
      return "昨天";
    }
    if (days < 7) {
      return days + "天前";
    }

    return format(ldt, "yyyy-MM-dd");
  }
}