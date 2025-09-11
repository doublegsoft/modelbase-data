<#import '/$/appbase.ftl' as appbase>
<#import '/$/modelbase.ftl' as modelbase>
<#if license??>
${java.license(license)}
</#if>
package <#if namespace??>${namespace}.</#if>${app.name}.model.value;

public class Placeholder {
  
}