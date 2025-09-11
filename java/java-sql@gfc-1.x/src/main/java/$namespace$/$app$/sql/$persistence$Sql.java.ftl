 <#import "/$/modelbase.ftl" as modelbase>
<#import "/$/modelbase4java.ftl" as modelbase4java>
<#if license??>
${java.license(license)}
</#if>
<#assign obj = persistence>
<#assign idAttrs = modelbase.get_id_attributes(obj)>
package ${namespace}.${app.name}.sql;

import java.io.Serializable;
import java.util.ArrayList;
<#list modelbase4java.get_imports(obj)?sort as imp>
import ${imp};
</#list>

/*!
** 【${modelbase.get_object_label(obj)}】
*/
public class ${java.nameType(obj.name)}Sql {

  public static String getInsertSql(${java.nameType(obj.name)}Query query) {
    StringBuilder retVal = new StringBuilder();
    return retVal.toString();
  }
  
  public static String getUpdateSql(${java.nameType(obj.name)}Query query) {
    StringBuilder retVal = new StringBuilder();
    return retVal.toString();
  }
  
  public static String getDeleteSql(${java.nameType(obj.name)}Query query) {
    StringBuilder retVal = new StringBuilder();
    return retVal.toString();
  }

  public static String getSelectSql(${java.nameType(obj.name)}Query query) {
    StringBuilder retVal = new StringBuilder();
    return retVal.toString();
  }

}