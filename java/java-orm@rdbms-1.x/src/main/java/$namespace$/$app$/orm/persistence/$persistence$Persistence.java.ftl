<#import "/$/modelbase.ftl" as modelbase>
<#import "/$/modelbase4java.ftl" as modelbase4java>
<#if license??>
${java.license(license)}
</#if>
<#assign obj=persistence>
package ${namespace}.${app.name}.orm.persistence;

/*!
** 【${modelbase.get_object_label(obj)}】
*/
public class ${java.nameType(obj.name)}Persistence {

  /*!
  ** Get persistence name for attribute name.
  */
  public static String getPersistenceName() {
    return "${obj.persistenceName!""}";
  }

  /*!
  ** Get persistence name for object name.
  */
  public static String getPersistenceName(String attrname) {
<#list obj.attributes as attr>    
  <#if !attr.persistenceName??><#continue></#if>
    if ("${modelbase.get_attribute_sql_name(attr)}".equalsIgnoreCase(attrname)) {
      return "${attr.persistenceName!""}";
    }  
</#list>
    return null;
  }

  public static String getPersistenceName(String alias, String attrname) {
    String pname = getPersistenceName(attrname);
    if (pname == null) {
      return null;
    } 
    if (alias == null || alias.trim().equals("")) {
      return pname;
    }
    return alias + "." + pname;
  }

}