<#import "/$/modelbase.ftl" as modelbase>
<#import "/$/modelbase4cpp.ftl" as modelbase4cpp>
## ${app.name}二进制协议
<#list model.objects as obj>
  <#if obj.isLabelled("generated")><#continue></#if>
  
### ${modelbase.get_object_label(obj)}
<table>
  <tr>
    <th>名称</th>
    <th>字段</th>
    <th>类型</th>
    <th>字节数</th>
    <th>顺序</th>
  </tr>
  <#list obj.attributes as attr>
  <tr>
    <td>${modelbase.get_attribute_label(attr)}</td>
    <td>${modelbase4cpp.name_attribute(attr)}</td>
    <#assign attrtype = modelbase4cpp.type_attribute(attr)>
    <#if attr.type.name == "string" ||
         attr.type.name == "id" ||
         attr.type.name == "uuid">  
    <td>string</td>
    <td>0...n</td>
    <#elseif attr.type.name == "date">
    <td>string</td>
    <td>10</td>
    <#elseif attr.type.name == "datetime">
    <td>string</td>
    <td>19</td>
    <#elseif attr.type.name == "int" ||
             attr.type.name == "integer">
    <td>int</td>
    <td>4</td>         
    <#elseif attr.type.custom>
    <td>bytes</td>
    <td>0...n</td>
    <#else>
    <td></td>
    <td></td>
    </#if>      
    <td>${attr?index}</td>
  </tr>
  </#list>
</table>
</#list>