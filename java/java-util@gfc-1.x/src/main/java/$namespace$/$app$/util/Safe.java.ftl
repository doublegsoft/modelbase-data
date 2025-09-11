<#import '/$/modelbase.ftl' as modelbase>
<#import "/$/modelbase4java.ftl" as modelbase4java>
<#if license??>
${java.license(license)}
</#if>
package ${namespace}.${app.name}.util;

import java.math.BigDecimal;
import java.sql.Timestamp;
import java.sql.Clob;
import java.sql.SQLException;
import java.util.List;
import java.util.ArrayList;
import java.io.Reader;
import java.io.BufferedReader;
import java.io.IOException;

public class Safe {

  public static String safeString(Integer val) {
    if (val == null) {
      return null;
    }
    return val.toString();
  }

  public static String safeString(Long val) {
    if (val == null) {
      return null;
    }
    return val.toString();
  }

  public static String safeString(BigDecimal val) {
    if (val == null) {
      return null;
    }
    return val.toPlainString();
  }

  public static String safeString(java.sql.Date val) {
    if (val == null) {
      return null;
    }
    return val.toString();
  }

  public static String safeString(java.sql.Timestamp val) {
    if (val == null) {
      return null;
    }
    return val.toString();
  }

  public static Integer safeInteger(String val) {
    try {
      return Integer.valueOf(val);
    } catch (Exception ex) {
      return null;
    }
  }

  public static Integer safeInteger(Long val) {
    if (val == null) {
      return null;
    }
    return val.intValue();
  }

  public static Long safeLong(String val) {
    try {
      return Long.valueOf(val);
    } catch (Exception ex) {
      return null;
    }
  }

  public static Long safeLong(Integer val) {
    if (val == null) {
      return null;
    }
    return val.longValue();
  }

  public static BigDecimal safeBigDecimal(String val) {
    try {
      return new BigDecimal(val);
    } catch (Exception ex) {
      return null;
    }
  }

  public static java.sql.Date safeDate(String val) {
    try {
      return java.sql.Date.valueOf(val);
    } catch (Exception ex) {
      return null;
    }
  }

  public static java.sql.Date safeDate(Long val) {
    if (val == null) {
      return null;
    }
    return new java.sql.Date(val);
  }
  
  public static java.sql.Time safeTime(String val) {
    try {
      return java.sql.Time.valueOf(val);
    } catch (Exception ex) {
      return null;
    }
  }

  public static java.sql.Time safeTime(Long val) {
    if (val == null) {
      return null;
    }
    return new java.sql.Time(val);
  }

  public static java.sql.Timestamp safeTimestamp(String val) {
    try {
      if (val != null && val.contains("T")) {
        val = val.replaceAll("T", " ");
        if (val.length() == 16) {
          val += ":00";
        }
      }
      return java.sql.Timestamp.valueOf(val);
    } catch (Exception ex) {
      return null;
    }
  }

  public static java.sql.Timestamp safeTimestamp(Long val) {
    if (val == null) {
      return null;
    }
    return new java.sql.Timestamp(val);
  }

  public static <T> T safe(Object val, Class<T> clazz) {
    if (val == null) {
      return null;
    }
    if (val.getClass() == clazz) {
      return (T) val;
    }
    String str = val.toString();
    if (clazz == String.class) {
      if (str.trim().equals("")) {
        return (T) "";
      }
    }

    if (str == null || str.trim().length() == 0) {
      return null;
    }
    if (clazz == String.class) {
      if (Clob.class.isAssignableFrom(val.getClass())) {
        return (T) clobToString((Clob)val);
      }
      return (T) str;
    } else if (clazz == BigDecimal.class) {
      return (T) safeBigDecimal(str);
    } else if (clazz == Timestamp.class) {
      return (T) safeTimestamp(str);
    } else if (clazz == java.sql.Date.class) {
      return (T) safeDate(str);
    } else if (clazz == java.sql.Time.class) {
      return (T) safeTime(str);
    } else if (clazz == java.util.Date.class) {
      return (T) safeTimestamp(str);
    } else if (clazz == Integer.class) {
      return (T) safeInteger(str);
    } else if (clazz == Long.class) {
      return (T) safeLong(str);
    } 
    return (T) val;
  }

  public static <T> T safe(String val, Class<T> clazz) {
    if (val == null) {
      return null;
    }
    String str = val;
    if (str == null || str.trim().length() == 0) {
      return null;
    }
    if (clazz == String.class) {
      return (T) str;
    } else if (clazz == BigDecimal.class) {
      return (T) safeBigDecimal(str);
    } else if (clazz == Timestamp.class) {
      return (T) safeTimestamp(str);
    } else if (clazz == java.sql.Date.class) {
      return (T) safeDate(str);
    } else if (clazz == java.util.Date.class) {
      return (T) safeTimestamp(str);
    } else if (clazz == Integer.class) {
      return (T) safeInteger(str);
    } else if (clazz == Long.class) {
      return (T) safeLong(str);
    }
    return (T) val;
  }
  
  public static <T> List<T> safeMore(List<Object> vals, Class<T> clazz) {
    List<T> retVal = new ArrayList<>();
    for (Object val : vals) {
      retVal.add(safe(val, clazz));
    }
    return retVal;
  }
  
  public static String clobToString(Clob clob) {
    if (clob == null) {
      return null;
    }

    StringBuilder sb = new StringBuilder();
    try (Reader reader = clob.getCharacterStream();
         BufferedReader br = new BufferedReader(reader)) {
      String line;
      while ((line = br.readLine()) != null) {
        sb.append(line).append(System.lineSeparator());
      }
    } catch (IOException | SQLException ex) {
      return null;
    }
    return sb.toString();
  }

  private Safe() {

  }

}
