<#import "/$/modelbase.ftl" as modelbase>
<#function pair_response path>
  <#list model.objects as obj>
    <#if !obj.isLabelled("response")><#continue></#if>
    <#if (obj.getLabelledOption("module", "name")!"") != module><#continue></#if>
    <#assign resp = obj>
    <#assign respPath = resp.getLabelledOption("response", "path")>
    <#if respPath == path>
      <#return resp>
    </#if>
  </#list>
</#function>
package ${namespace}.${java.nameNamespace(app.name)}.http;

import java.util.List;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.*;
import ${namespace}.${java.nameNamespace(app.name)}.http.payload.*;

@FeignClient(name = "${java.nameVariable(module)}Client")
public interface ${java.nameType(module)}Client {
<#list model.objects as obj>
  <#if !obj.isLabelled("request")><#continue></#if>
  <#if (obj.getLabelledOption("module", "name")!"") != module><#continue></#if>
  <#assign req = obj>
  <#assign path = req.getLabelledOption("request", "path")>

  @PostMapping("${obj.getLabelledOption("request", "path")}")
  <#if pair_response(path)??>
    <#assign resp = pair_response(path)>
  ${java.nameType(resp.name)} execute${java.nameType(req.name)}(@RequestBody ${java.nameType(req.name)} request);
  <#else>
  void execute${java.nameType(req.name)}(@RequestBody ${java.nameType(req.name)} request);
  </#if>
</#list>
}