<#import '/$/modelbase.ftl' as modelbase>
<#if license??>
${java.license(license)}
</#if>
package <#if namespace??>${namespace}.</#if>${app.name}.model;

/**
 * ${app.name}常量定义。
 *
 * @author <a href="mailto:guo.guo.gan@gmail.com">Christian Gann</a>
 *
 * @since ${version}
 */
public interface Constants {

  String TRUE = "T";

  String FALSE = "F";

  String ENABLED = "E";

  String DISABLED = "D";

<#assign constants = {}>
<#list model.objects as obj>
  <#if obj.isLabelled('generated')><#continue></#if>
  <#list obj.attributes as attr>
    <#if attr.constraint.domainType.name?index_of('enum') == 0>
      <#assign pairs = typebase.enumtype(attr.constraint.domainType.name)>
      <#list pairs as pair>
        <#assign constants = constants + {attr.name + '_' + pair.key: pair}>
      </#list>
    </#if>
  </#list>
</#list>
<#list constants as name, pair>
  // ${pair.value}
  String ${name?upper_case} = "${pair.key}";

</#list>
<#list model.objects as obj>
  <#if obj.isLabelled('generated') || (!obj.isLabelled('value') && !obj.isLabelled('entity'))><#continue></#if>
  // ${modelbase.get_object_label(obj)}，${obj.persistenceName!''}
  String REF_${obj.name?upper_case} = "${app.name?upper_case}.${obj.name?upper_case}";

</#list>
}
