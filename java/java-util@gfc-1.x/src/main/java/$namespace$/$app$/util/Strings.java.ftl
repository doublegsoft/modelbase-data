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
import java.util.Date;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.UUID;

/**
 * It's the string utility.
 * 
 * @author <a href="mailto:guo.guo.gan@gmail.com">Christian Gann</a>
 *
 * @since 2.0
 */
public class Strings {

  public static boolean isBlank(Object str) {
    if (str == null) {
      return true;
    }
    if (str instanceof String) {
      if (str == null || trim((String)str).isEmpty()) {
        return true;
      }
    }
    return false;
  }

  /**
   * Trims the string. If the string is null, and gets an empty string.
   * 
   * @param str
   *          the string to trim
   * 
   * @return the trimmed string
   * 
   * @since 2.0
   */
  public static String trim(String str) {
    if (str == null) {
      return "";
    }
    return str.trim();
  }

  public static String id() {
    UUID uuid = UUID.randomUUID();
    return uuid.toString().toUpperCase();
  }
  
  public static String format(Object obj) {
    if (obj == null) {
      return null;
    }
    if (obj instanceof Date) {
      return new java.sql.Timestamp(((Date)obj).getTime()).toString();
    }
    return obj.toString();
  }

  private Strings() {

  }
}
