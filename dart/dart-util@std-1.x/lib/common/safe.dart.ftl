<#if license??>
${dart.license(license)}
</#if>
import 'package:intl/intl.dart';

typedef StringConvert = String Function(dynamic data);

class Safe {
  static int? safeInt(dynamic obj) {
    if (obj == null) {
      return null;
    }
    if (obj is int) {
      return obj; // 修复：去掉了 "as int"
    }
    try {
      return int.parse(obj.toString());
    } catch (ex) {
      return null;
    }
  }

  static List<int> safeInts(List array) {
    List<int> ret = <int>[];
    for (dynamic row in array) {
      int? val = safeInt(row);
      if (val != null) {
        ret.add(val);
      }
    }
    return ret;
  }

  static double? safeDouble(dynamic obj) {
    if (obj == null) {
      return null;
    }
    if (obj is double) {
      return obj; // 修复：去掉了 "as double"
    }
    // 额外兼容：如果传入的是 int，比如 10，可以直接转为 10.0
    if (obj is num) {
      return obj.toDouble();
    }
    try {
      return double.parse(obj.toString());
    } catch (ex) {
      return null;
    }
  }

  static bool safeBool(dynamic obj) {
    if (obj == null) {
      return false;
    }
    if (obj is bool) {
      return obj; // 修复：去掉了 "as bool"
    }
    try {
      return bool.parse(obj.toString());
    } catch (ex) {
      return false;
    }
  }

  static DateTime? safeDateTime(dynamic obj) {
    if (obj == null) {
      return null;
    }
    if (obj is DateTime) {
      return obj; // 修复：去掉了 "as DateTime"
    }
    String str = obj.toString();
    if (str.contains(' ')) {
      try {
        return DateFormat('yyyy-MM-dd HH:mm:ss').parse(str);
      } catch (ex) {
        return null;
      }
    } else if (str.contains('-')) {
      try {
        return DateFormat('yyyy-MM-dd').parse(str);
      } catch (ex) {
        return null;
      }
    } else if (str.contains(':')) {
      try {
        return DateFormat('HH:mm:ss').parse(str);
      } catch (ex) {
        return null;
      }
    }
    return null; // 显式兜底返回 null
  }

  static String safeString(dynamic obj, {StringConvert? convert}) {
    if (obj == null) {
      return '';
    }
    if (convert == null) {
      return obj.toString();
    } else {
      return convert(obj);
    }
  }
}