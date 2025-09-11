<#import "/$/modelbase.ftl" as modelbase>
<#if license??>
${java.license(license)}
</#if>
<#assign obj = persistence>
<#assign idAttrs = modelbase.get_id_attributes(obj)>
<#assign persistedAttrs = []>
<#list obj.attributes as attr>
  <#if attr.persistenceName??>
    <#assign persistedAttrs += [attr]>
  </#if>
</#list>  
package ${namespace}.${app}.dao;

import ${namespace}.${app}.dto.$java.nameType(obj.name)}Query;

public class ${java.nameType(obj.name)}DaoImpl implements ${java.nameType(obj.name)}Dao {
  
  public static final String SQL_INSERT = "insert into ${obj.persistenceName} " +
      "(<#list persistedAttrs as attr><#if attr?index != 0>, </#if>${attr.persistenceName}</#list>) " +
      "values (<#list persistedAttrs as attr><#if attr?index != 0>, </#if>?</#list>)";

  public static final String SQL_DELETE = "delete from ${obj.persistenceName} " +
      "where <#list idAttrs as attr><#if attr?index != 0>and </#if>${attr.persistenceName} = ?</#list>"; 

  public void save${java.nameType(obj.name)}(${java.nameType(obj.name)}Query query) {
    
    
  }

  private String getSelectSql(${java.nameType(obj.name)}Query query) {
    StringBuilder retVal = new StringBuilder("select <#list persistedAttrs as attr><#if attr?index != 0>, </#if>${attr.persistenceName}</#list> from ${obj.persistenceName} where 1=1 ");
  }
}
