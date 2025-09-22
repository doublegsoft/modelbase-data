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
import java.util.HashMap;

/**
 * It's the string utility.
 * 
 * @author <a href="mailto:guo.guo.gan@gmail.com">Christian Gann</a>
 *
 * @since 2.0
 */
public class Datasets {

  public static List<List<Map<String,Object>>> group(List<Map<String,Object>> dataset, String... groupColumnNames) {
    List<List<Map<String,Object>>> retVal = new ArrayList<>();
    if (dataset == null || dataset.isEmpty()) {
      return retVal;
    }
    Map<Object,List<Map<String,Object>>> groups = new HashMap<>();
    List<Map<String,Object>> currentGroup = null;
    Object currentGroupValue = null;
    for (Map<String,Object> row : dataset) {
      Object groupValue = "";
      for (String groupColumnName : groupColumnNames) {
        groupValue += (row.get(groupColumnName) == null ? "null" : row.get(groupColumnName).toString());
      }
      if (groups.containsKey(groupValue)) {
        currentGroup = groups.get(groupValue);
      } else {
        currentGroup = new ArrayList<>();
        groups.put(groupValue, currentGroup);
        retVal.add(currentGroup);
      }
      currentGroup.add(row);
    }
    return retVal;
  }

  private Datasets() {

  }
}
