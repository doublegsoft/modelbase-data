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
import java.lang.reflect.Field;
import java.util.Date;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

/**
 * It's the bean utility.
 */
public class Beans {

  public static Map<String,Object> beanToMap(Object bean) {
    if (bean == null) return Collections.emptyMap();
    Map<String,Object> map = new LinkedHashMap<>();
    Class<?> cls = bean.getClass();

    // 包含本类 + 父类的所有字段（private 也能访问）
    for (Field f : getAllFields(cls)) {
      f.setAccessible(true);
      try {
        Object v = f.get(bean);
        if (v != null) map.put(f.getName(), v);
      } catch (IllegalAccessException ignored) {}
    }
    return map;
  }

  private static List<Field> getAllFields(Class<?> cls) {
    List<Field> fields = new ArrayList<>();
    for (Class<?> c = cls; c != null; c = c.getSuperclass()) {
      fields.addAll(Arrays.asList(c.getDeclaredFields()));
    }
    return fields;
  }

  private Beans() {

  }
}
