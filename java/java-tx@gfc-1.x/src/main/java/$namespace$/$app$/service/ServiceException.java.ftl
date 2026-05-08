<#import '/$/modelbase.ftl' as modelbase>
<#if license??>
${java.license(license)}
</#if>
package <#if namespace??>${namespace}.</#if>${app.name}.service;

import java.util.List;
import java.util.ArrayList;
import java.util.Map;
import java.util.HashMap;
import java.math.BigDecimal;
import java.io.Serializable;
import java.sql.Date;
import java.sql.Timestamp;

import <#if namespace??>${namespace}.</#if>${app.name}.poco.*;
import <#if namespace??>${namespace}.</#if>${app.name}.dto.payload.*;

/**
 * 存储事务化的服务规范。
 *
 * @author <a href="mailto:guo.guo.gan@gmail.com">Christian Gann</a>
 *
 * @since ${version}
 */
public class ServiceException extends Exception {
  
  private int code;
  
  private String message;
  
  private Throwable cause;
  
  public ServiceException(int code, String message, Throwable cause) {
    this.code = code;
    this.message = message;
    this.cause = cause;
  }
  
  public ServiceException(int code, String message) {
    this(code, message, null);
  }
  
  public ServiceException(int code, Throwable cause) {
    this(code, cause.getMessage(), cause);
  }
  
  public int getCode() {
    return code;
  }
  
  public String getMessage() {
    return message;
  }
  
  public Throwable getCause() {
    return cause;
  }
  
}
