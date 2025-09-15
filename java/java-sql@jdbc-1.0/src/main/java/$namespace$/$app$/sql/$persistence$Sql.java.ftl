<#import "/$/modelbase.ftl" as modelbase>
<#import "/$/modelbase4java.ftl" as modelbase4java>
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
package ${namespace}.${app}.sql;

import ${namespace}.${app}.dto.${java.nameType(obj.name)}Query;

public class ${java.nameType(obj.name)}Sql {
  
  public static final String SQL_INSERT = "insert into ${obj.persistenceName} " +
      "(<#list persistedAttrs as attr><#if attr?index != 0>, </#if>${attr.persistenceName}</#list>) " +
      "values (<#list persistedAttrs as attr><#if attr?index != 0>, </#if>?</#list>)";

  public static final String SQL_DELETE = "delete from ${obj.persistenceName} " +
      "where <#list idAttrs as attr><#if attr?index != 0>and </#if>${attr.persistenceName} = ?</#list>"; 

  public static directInsertSql(${java.nameType(obj.name)}Query query) {
    StringBuilder retVal = new StringBuilder();
    retVal.append("insert into ${obj.persistenceName} (");
<#list persistedAttrs as attr>
    retVal.append("${attr.persistenceName}")<#if attr?index != persistedAttrs?size - 1>.append(", ")</#if>;
</#list>    
    retVal.append(") values (");
<#list persistedAttrs as attr>
    retVal.append(Strings.escape(query.${modelbase4java.name_getter(attr)}(), "'", "''"))<#if attr?index != persistedAttrs?size - 1>.append(", ")</#if>;
</#list>  
    retVal.append(")");    
    return retVal.toString();
  }

  public static String prepareInsertSql(${java.nameType(obj.name)}Query query) {
    return SQL_INSERT;
  }

  public static directUpdateSql(${java.nameType(obj.name)}Query query) {
    StringBuilder retVal = new StringBuilder();
    retVal.append("update ${obj.persistenceName} set ");
    boolean updated = false;
<#list persistedAttrs as attr>
    if (!Strings.isBlank(query.${modelbase4java.name_getter(attr)}())) {
      if (updated) {
        retVal.append(", ");
      } 
      retVal.append("${attr.persistenceName}").append(Strings.escape(query.${modelbase4java.name_getter(attr)}(), "'", "''"));
      updated = true;
    }
</#list>    
    retVal.append(" where ");
    int idCount = 0;
<#list idAttrs as attr>
    if (query.${modelbase4java.name_getter(attr)}() != null) {
      if (idCount != 0) {
        retVal.append(" and ");
      }
      retVal.append("${attr.persistenceName} = ").append(Strings.escape(query.${modelbase4java.name_getter(attr)}(), "'", "''"));
      idCount++;
    }
</#list>
    if (idCount == 0) {
      throw new IllegalArgumentException("No id attributes were set when updating ${obj.name}");
    }
    return retVal.toString();
  }

  public static String prepareUpdateSql(${java.nameType(obj.name)}Query query) {
    StringBuilder retVal = new StringBuilder();
    retVal.append("update ${obj.persistenceName} set ");
    boolean updated = false;
<#list persistedAttrs as attr>
    if (!Strings.isBlank(query.${modelbase4java.name_getter(attr)}())) {
      if (updated) {
        retVal.append(", ");
      } 
      retVal.append("${attr.persistenceName} = ?");
      updated = true;
    }
</#list>    
    retVal.append(" where ");
    int idCount = 0;
<#list idAttrs as attr>
    if (query.${modelbase4java.name_getter(attr)}() != null) {
      if (idCount != 0) {
        retVal.append(" and ");
      }
      retVal.append("${attr.persistenceName} = ?");
      idCount++;
    }
</#list>
    if (idCount == 0) {
      throw new IllegalArgumentException("No id attributes were set when updating ${obj.name}");
    }
    return retVal.toString();
  }

  public static directDeleteSql(${java.nameType(obj.name)}Query query) {
    StringBuilder retVal = new StringBuilder();
    retVal.append("update ${obj.persistenceName} set ");
    boolean updated = false;
<#list persistedAttrs as attr>
    if (!Strings.isBlank(query.${modelbase4java.name_getter(attr)}())) {
      if (updated) {
        retVal.append(", ");
      } 
      retVal.append("${attr.persistenceName}").append(Strings.escape(query.${modelbase4java.name_getter(attr)}(), "'", "''"));
      updated = true;
    }
</#list>    
    retVal.append(" where ");
    int idCount = 0;
<#list idAttrs as attr>
    if (query.${modelbase4java.name_getter(attr)}() != null) {
      if (idCount != 0) {
        retVal.append(" and ");
      }
      retVal<#if attr?index != 0>.append(" and ")</#if>.append("${attr.persistenceName} = ").append(Strings.escape(query.${modelbase4java.name_getter(attr)}(), "'", "''"));
      idCount++;
    }
</#list>
    if (idCount == 0) {
      throw new IllegalArgumentException("No id attributes were set when deleting ${obj.name}");
    }
    return retVal.toString();
  }

  public static String prepareDeleteSql(${java.nameType(obj.name)}Query query) {
    StringBuilder retVal = new StringBuilder();
    retVal.append("delete ${obj.persistenceName} where ");  
    int idCount = 0;
<#list idAttrs as attr>
    if (query.${modelbase4java.name_getter(attr)}() != null) {
      if (idCount != 0) {
        retVal.append(" and ");
      }
      retVal.append("${attr.persistenceName} = ?");
      idCount++;
    }
</#list>
    if (idCount == 0) {
      throw new IllegalArgumentException("No id attributes were set when deleting ${obj.name}");
    }
    return retVal.toString();
  }

  public static directSelectSql(${java.nameType(obj.name)}Query query) {
    StringBuilder retVal = new StringBuilder();
    return retVal.toString();
  }

  public static String prepareSelectSql(${java.nameType(obj.name)}Query query) {
    StringBuilder retVal = new StringBuilder();
    return retVal.toString();
  }
}
