<#import '/$/modelbase.ftl' as modelbase>
<#if license??>
${java.license(license)}
</#if>
package <#if namespace??>${namespace}.</#if>${app.name}.mvc;

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
import org.springframework.web.bind.annotation.*;

import <#if namespace??>${namespace}.</#if>${app.name}.poco.*;
import <#if namespace??>${namespace}.</#if>${app.name}.dto.payload.*;
import <#if namespace??>${namespace}.</#if>${app.name}.service.*;

/**
 * 【REST请求应答】。
 *
 * @author <a href="mailto:guo.guo.gan@gmail.com">Christian Gann</a>
 *
 * @since ${version}
 */
public class RestResult {
  
  private int code;
  
  private String message;
  
  private long total;
  
  private Object data;
  
  public RestResult(int code, String message) {
    this.code = code;
    this.message = message;
  }
  
  public RestResult(Object data) {
    this.code = 200;
    this.data = data;
  }
  
  public RestResult() {
    this.code = 200;
  }
  
  public int getCode() {
    return code;
  }
  
  public void setCode(int code) {
    this.code = code;
  }
  
  public String getMessage() {
    return message;
  }
  
  public void setMessage(String message) {
    this.message = message;
  }
  
  public long getTotal() {
    return total;
  }
  
  public void setTotal(long total) {
    this.total = total;
  }
  
  public Object getData() {
    return data;
  }
  
  public void setData(Object data) {
    this.data = data;
  }
  
}
