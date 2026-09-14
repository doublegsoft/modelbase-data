<#import "/$/modelbase.ftl" as modelbase>
<#function pair_result name>
  <#list model.objects as obj>
    <#if !obj.isLabelled("result")><#continue></#if>
    <#assign rslt = obj>
    <#assign rsltname = rslt.getLabelledOption("result", "name")>
    <#if rsltname == name>
      <#return rslt>
    </#if>
  </#list>
</#function>
package ${namespace}.${java.nameNamespace(app.name)}.service;

import java.util.List;
import ${namespace}.${java.nameNamespace(app.name)}.service.payload.*;

public interface ${java.nameType(module)}Service {
<#list model.objects as obj>
  <#if !obj.isLabelled("params")><#continue></#if>
  <#if (obj.getLabelledOption("module","name")!"") != module><#continue></#if>

  <#if pair_result(obj.getLabelledOption("params","name"))??>
    <#assign rslt = pair_result(obj.getLabelledOption("params","name"))>
  ${java.nameType(rslt.name)} ${java.nameVariable(obj.name)}(${java.nameType(obj.name)} params);
  <#else>
  void ${java.nameVariable(obj.name)}(${java.nameType(obj.name)} params);
  </#if>
</#list>
}