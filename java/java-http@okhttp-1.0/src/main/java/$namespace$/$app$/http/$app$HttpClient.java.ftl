<#import '/$/modelbase.ftl' as modelbase>
<#if license??>
${java.license(license)}
</#if>
package <#if namespace??>${namespace}.</#if>${app.name}.httpc;

import java.sql.Date;
import java.sql.Timestamp;
import java.util.List;
import java.util.ArrayList;
import java.util.Map;
import java.util.HashMap;
import java.math.BigDecimal;
import java.io.Serializable;
import java.io.IOException;

import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.Response;

import <#if namespace??>${namespace}.</#if>${app.name}.httpc.payload.*;

/**
 * HTTP客户端。
 *
 * @author <a href="mailto:guo.guo.gan@gmail.com">Christian Gann</a>
 *
 * @since 1.0.0
 */
public class ${java.nameType(app.name)}HttpClient {

  private final OkHttpClient client = new OkHttpClient();

<#list model.objects as obj>  
  <#if !obj.isLabelled("request")><#continue></#if>
  <#assign response = obj.getLabelledOptions("request")["response"]>
  <#assign respObj = model.findObjectByName(response)>
  <#assign httpmethod = obj.getLabelledOptions("http")["method"]>
  /*!
  **
  */
  public ${java.nameType(respObj.name)} process${java.nameType(obj.name)}(${java.nameType(obj.name)} request) throws IOException {
  <#if httpmethod == "get">
    String url = ${obj.getLabelledOptions("request")["url"]!"TODO"};
    <#list obj.attributes as attr>
    
    </#list> 
    Request req = new Request.Builder().url(url).build();
    try (Response resp = client.newCall(req).execute()) {
      String content = resp.body().string();
    }
  <#elseif httpmethod == "post">
    RequestBody body = RequestBody.create("{}", JSON);
    Request req = new Request.Builder()
        .url(url)
        .post(body)
        .build();
    try (Response resp = client.newCall(req).execute()) {
      String content = response.body().string();
    }
  </#if>
    return null;
  } 
</#list>
}
