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
 * It's the object utility.
 * 
 * @author <a href="mailto:guo.guo.gan@gmail.com">Christian Gann</a>
 *
 * @since 2.0
 */
public class Objects {

  public static boolean isEmpty(Object str) {
    if (str == null) {
      return true;
    }
    if (str instanceof String) {
      if (str == null || Strings.trim((String)str).isEmpty()) {
        return true;
      }
    }
    return false;
  }

  private Objects() {

  }
}
