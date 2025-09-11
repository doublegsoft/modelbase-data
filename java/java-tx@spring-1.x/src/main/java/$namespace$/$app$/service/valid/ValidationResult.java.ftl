<#import '/$/modelbase.ftl' as modelbase>
<#if license??>
${java.license(license)}
</#if>
package <#if namespace??>${namespace}.</#if>${app.name}.service.valid;

import java.util.List;
import java.util.ArrayList;
import java.util.Map;
import java.util.HashMap;
import java.math.BigDecimal;
import java.io.Serializable;
import java.sql.Date;
import java.sql.Timestamp;

import org.springframework.beans.factory.annotation.*;
import org.springframework.transaction.annotation.*;
import org.springframework.stereotype.*;

import <#if namespace??>${namespace}.</#if>${app.name}.poco.*;
import <#if namespace??>${namespace}.</#if>${app.name}.orm.assembler.*;
import <#if namespace??>${namespace}.</#if>${app.name}.dto.assembler.*;
import <#if namespace??>${namespace}.</#if>${app.name}.dto.payload.*;
import <#if namespace??>${namespace}.</#if>${app.name}.dao.*;
import <#if namespace??>${namespace}.</#if>${app.name}.service.*;
import <#if namespace??>${namespace}.</#if>${app.name}.util.*;

/**
 * 
 *
 * @author <a href="mailto:guo.guo.gan@gmail.com">Christian Gann</a>
 *
 * @since ${version}
 */
public class ValidationResult {

  public static final ValidationResult SUCCESS = new ValidationResult();
  
  private boolean valid;
  
  private String message;
  
  private int code = 0;
  
  public ValidationResult(boolean valid, int code, String message) {
    this.valid = valid;
    this.code = code;
    this.message = message;
  }
  
  public ValidationResult() {
    this(true, 0, null);
  }
  
  public boolean isValid() {
    return valid;
  }
  
  public void setValid(boolean valid) {
    this.valid = valid;
  }
  
  public String getMessage() {
    return message;
  }
  
  public void setMessage(String message) {
    this.message = message;
  }
  
  public int getCode() {
    return code;
  }
  
  public void setCode(int code) {
    this.code = code;
  }
  
}
