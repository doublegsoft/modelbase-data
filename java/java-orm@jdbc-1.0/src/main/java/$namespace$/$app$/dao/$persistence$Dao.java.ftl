<#if license??>
${java.license(license)}
</#if>
<#assign obj = persistence>
package ${namespace}.${app}.dao;

import ${namespace}.${app}.dto.$java.nameType(obj.name)}Query;

public interface ${java.nameType(obj.name)}Dao {

    

}
