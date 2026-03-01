<#import '/$/modelbase.ftl' as modelbase>
<#import "/$/modelbase4java.ftl" as modelbase4java>
<#if license??>
${java.license(license)}
</#if>
package ${namespace}.${app.name}.util;

import java.math.BigDecimal;
import java.math.RoundingMode;

/**
 * 数字工具类，提供常用数字转换、计算、比较等静态方法。
 * 所有方法均为线程安全、null 安全。
 */
public class Numbers {

  public static BigDecimal of(String value) {
    return value == null ? BigDecimal.ZERO : new BigDecimal(value.trim());
  }

  public static BigDecimal of(double value) {
    return BigDecimal.valueOf(value);
  }

  public static BigDecimal add(BigDecimal a, BigDecimal b) {
    return (a == null ? BigDecimal.ZERO : a)
      .add(b == null ? BigDecimal.ZERO : b);
  }

  public static BigDecimal subtract(BigDecimal a, BigDecimal b) {
    return (a == null ? BigDecimal.ZERO : a)
      .subtract(b == null ? BigDecimal.ZERO : b);
  }

  public static BigDecimal multiply(BigDecimal a, BigDecimal b) {
    return (a == null ? BigDecimal.ZERO : a)
      .multiply(b == null ? BigDecimal.ZERO : b);
  }

  public static BigDecimal divide(BigDecimal a, BigDecimal b) {
    return divide(a, b, 2);
  }

  public static BigDecimal divide(BigDecimal a, BigDecimal b, int scale) {
    if (b == null || b.compareTo(BigDecimal.ZERO) == 0) {
      throw new ArithmeticException("Division by zero");
    }
    return (a == null ? BigDecimal.ZERO : a)
      .divide(b, scale, RoundingMode.HALF_UP);
  }

  public static boolean eq(BigDecimal a, BigDecimal b) {
    return a == b || (a != null && b != null && a.compareTo(b) == 0);
  }

  public static boolean gt(BigDecimal a, BigDecimal b) {
    return a != null && b != null && a.compareTo(b) > 0;
  }

  public static boolean ge(BigDecimal a, BigDecimal b) {
    return a != null && b != null && a.compareTo(b) >= 0;
  }

  public static String format(BigDecimal value, int scale) {
    if (value == null) return "0.00";
    return value.setScale(scale, RoundingMode.HALF_UP).toPlainString();
  }

  public static String formatMoney(BigDecimal value) {
    return format(value, 2);
  }

  public static BigDecimal abs(BigDecimal value) {
    return value == null ? BigDecimal.ZERO : value.abs();
  }

  public static BigDecimal negate(BigDecimal value) {
    return value == null ? BigDecimal.ZERO : value.negate();
  }

  public static boolean isZero(BigDecimal value) {
    return value != null && value.compareTo(BigDecimal.ZERO) == 0;
  }

  public static boolean isPositive(BigDecimal value) {
    return value != null && value.compareTo(BigDecimal.ZERO) > 0;
  }

  private Numbers() {

  }
}
