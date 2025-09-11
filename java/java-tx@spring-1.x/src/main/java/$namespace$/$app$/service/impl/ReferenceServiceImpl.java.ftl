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
package <#if namespace??>${namespace}.</#if>${app.name}.service.impl;

import java.util.List;
import java.util.ArrayList;

import org.apache.ibatis.session.RowBounds;
import org.springframework.beans.factory.annotation.*;
import org.springframework.transaction.annotation.*;
import org.springframework.stereotype.*;

import <#if namespace??>${namespace}.</#if>${app.name}.dto.payload.*;
import <#if namespace??>${namespace}.</#if>${app.name}.service.*;
import <#if namespace??>${namespace}.</#if>${app.name}.util.*;

@Service("<#if namespace??>${namespace}.</#if>${app.name}.service.ReferenceService") 
public class ReferenceServiceImpl implements ReferenceService {
<#list model.objects as obj>
  <#if obj.isLabelled("generated")><#continue></#if>

  @Autowired
  private ${java.nameType(obj.name)}Service ${java.nameVariable(obj.name)}Service;
</#list>    
  
  @Override
  public <T> T readReference(Object id, String type) throws ServiceException {
    if (type == null || id == null) {
      return null;
    }
    switch(type) {
<#list model.objects as obj>
  <#if obj.isLabelled("generated")><#continue></#if>
  <#assign idAttrs = modelbase.get_id_attributes(obj)>
  <#if (idAttrs?size > 1 || idAttrs?size == 0)><#continue></#if>
      case REF_${obj.name?upper_case}: {
        ${java.nameType(obj.name)}Query query = new ${java.nameType(obj.name)}Query();
        query.${modelbase4java.name_setter(idAttrs[0])}(Safe.safe(id, ${modelbase4java.type_attribute_primitive(idAttrs[0])}.class));
        return (T)${java.nameVariable(obj.name)}Service.read${java.nameType(obj.name)}(query);
      }
</#list>
      default:
        return null;
    }
  }
  
  @Override
  public <T> List<T> findReferences(List<${pktype}> ids, String type) throws ServiceException {
    switch(type) {
<#list model.objects as obj>
  <#if obj.isLabelled("generated")><#continue></#if>
  <#assign idAttrs = modelbase.get_id_attributes(obj)>
  <#if (idAttrs?size > 1 || idAttrs?size == 0)><#continue></#if>
      case REF_${obj.name?upper_case}: {
        ${java.nameType(obj.name)}Query query = new ${java.nameType(obj.name)}Query();
        query.${modelbase4java.name_getter(idAttrs[0])}s().addAll(ids);
        return (List<T>)${java.nameVariable(obj.name)}Service.find${java.nameType(inflector.pluralize(obj.name))}(query);
      }
</#list>
      default:
        return (List<T>)new ArrayList<T>();
    }
  }
}
