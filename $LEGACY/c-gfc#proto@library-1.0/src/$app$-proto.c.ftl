<#import "/$/modelbase.ftl" as modelbase>
<#import "/$/appbase.ftl" as appbase>
<#if license??>
${c.license(license)}
</#if>

#include <stdlib.h>
#include <string.h>

#include <gfc.h>

#include "${app.name}-proto.h"
<#list model.objects as obj>

void
${app.name}_init_${obj.name}(${app.name}_${obj.name}_t* pd)
{
<#list obj.attributes as attr>
  <#if attr.isLabelled("varsized")>
  pd->${attr.name} = NULL;
  pd->${attr.name}_len = 0;
  <#elseif attr.type.name == "int">
  pd->${attr.name} = 0;
  <#elseif attr.type.name == "string">
    <#if attr.type.length?? && attr.type.length != 0>
  pd->${attr.name}[0] = '\0';
    <#else>
  pd->${attr.name} = NULL;  
    </#if>
  <#elseif attr.type.name == "byte">
  memset(pd->${attr.name}, 0, ${attr.type.length});
  <#elseif attr.type.isCustom()>
  memset(&pd->${attr.name}, 0, sizeof(${app.name}_${attr.type.name}_t));
  </#if>
</#list>
}

int
${app.name}_read_${obj.name}(${app.name}_${obj.name}_t* pd, FILE* fp)
{
  int ret = 0;
<#list obj.attributes as attr>
  <#if attr.type.name == "int">
  fread(&pd->${attr.name}, ${attr.type.length!"sizeof(int)"}, 1, fp);
  ret += ${attr.type.length!"sizeof(int)"};
  <#elseif attr.type.isCustom()>
    <#assign objname = appbase.get_domain_type_name(attr.constraint.domainType)>
  ret += ${app.name}_read_${objname}(&pd->${attr.name}, fp);  
  <#elseif attr.type.isDomain()>
  // TODO
  <#elseif attr.type.name == "byte">
    <#if attr.isLabelled("varsized")>
  if (pd->${attr.name}_len > 0)
  {  
    pd->${attr.name} = (byte*) gfc_gc_malloc(sizeof(byte), pd->${attr.name}_len); 
    fread(pd->${attr.name}, pd->${attr.name}_len, 1, fp);  
    ret += pd->${attr.name}_len;      
  }
    <#else>
  fread(pd->${attr.name}, ${attr.type.length}, 1, fp);  
  ret += ${attr.type.length};
    </#if>
  <#elseif attr.type.name == "string">
    <#if attr.isLabelled("varsized")>
  if (pd->${attr.name}_len > 0)
  {  
    pd->${attr.name} = (char*) gfc_gc_malloc(sizeof(char), pd->${attr.name}_len); 
    fread(pd->${attr.name}, pd->${attr.name}_len, 1, fp);  
    ret += pd->${attr.name}_len;    
  }
    <#else>
      <#if attr.type.length?? && attr.type.length != 0>
  fread(pd->${attr.name}, ${attr.type.length}, 1, fp);  
  ret += ${attr.type.length};
      <#else>
  if (pd->${attr.name}_len > 0)
  {  
    pd->${attr.name} = (char*) gfc_gc_malloc(sizeof(char), pd->${attr.name}_len);  
    fread(pd->${attr.name}, pd->${attr.name}_len, 1, fp);  
    ret += pd->${attr.name}_len;    
  }    
      </#if>
    </#if>
  </#if>
</#list>
  return ret;
}
</#list>