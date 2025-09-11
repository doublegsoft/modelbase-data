<#import '/$/modelbase.ftl' as modelbase>
<#import '/$/modelbase4java.ftl' as modelbase4java>
<#if license??>
${java.license(license)}
</#if>
<#list model.objects as obj>
  <#assign idAttrs = modelbase.get_id_attributes(obj)>
  <#assign pktype = modelbase4java.type_attribute_primitive(idAttrs[0])>
  <#break>
</#list>
package <#if namespace??>${namespace}.</#if>${app.name}.service;

import java.util.List;

public interface ReferenceService {
<#list model.objects as obj>
  <#if obj.isLabelled("generated")><#continue></#if>

  static String REF_${obj.name?upper_case} = "${obj.name?upper_case}";
</#list>  
  
  <T> T readReference(Object id, String type) throws ServiceException;
  
  <T> List<T> findReferences(List<${pktype}> ids, String type) throws ServiceException;
}
