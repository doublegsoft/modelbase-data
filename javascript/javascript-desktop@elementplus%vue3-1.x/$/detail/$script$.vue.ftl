<script setup>
import { ref, onMounted } from 'vue';
import { useRoute } from 'vue-router';
import { sdk } from '@/sdk/sdk';

const route = useRoute();

/**
 * 【${modelbase.get_object_label(obj)}】
 */
const ${js.nameVariable(obj.name)} = ref({});
<#-- 列出所有集合类型的属性 -->
<#list obj.attributes as attr>
  <#if !attr.type.collection><#continue></#if>
/**
 * 【${modelbase.get_attribute_label(attr)}】
 */  
const ${js.nameVariable(attr.name)} = ref([]);  
</#list>

/*!
** Vue组件挂接调用函数。
*/
onMounted(() => {
<#list idAttrs as idAttr>
  const ${modelbase.get_attribute_sql_name(idAttr)} = route.params.${modelbase.get_attribute_sql_name(idAttr)};
</#list>
  fetch${js.nameType(obj.name)}(<#list idAttrs as idAttr><#if idAttr?index != 0>, </#if>${modelbase.get_attribute_sql_name(idAttr)}</#list>);
<#list obj.attributes as attr>
  <#if !attr.type.collection><#continue></#if>
  fetch${js.nameType(attr.name)}(<#list idAttrs as idAttr><#if idAttr?index != 0>, </#if>${modelbase.get_attribute_sql_name(idAttr)}</#list>);
</#list>    
});

/*!
** 获取【${modelbase.get_object_label(obj)}】数据。
*/
const fetch${js.nameType(obj.name)} = async (<#list idAttrs as idAttr><#if idAttr?index != 0>,</#if>${modelbase.get_attribute_sql_name(idAttr)}</#list>) => {
  try {
    let data = await sdk.read${js.nameType(obj.name)}({
<#list idAttrs as idAttr>
      ${modelbase.get_attribute_sql_name(idAttr)}: ${modelbase.get_attribute_sql_name(idAttr)},
</#list>
    });
  ${js.nameVariable(obj.name)}.value = data;
  } catch (error) {
    // error handler
  }
};
<#list obj.attributes as attr>
  <#if !attr.type.collection><#continue></#if>
  <#assign collObj = model.findObjectByName(attr.type.componentType.name)>

/**
 * 获取【${modelbase.get_attribute_label(attr)}】数据。
 */  
const fetch${js.nameType(attr.name)} = async (<#list idAttrs as idAttr><#if idAttr?index != 0>,</#if>${modelbase.get_attribute_sql_name(idAttr)}</#list>) => {
  try {
    let data = await sdk.find${js.nameType(modelbase.get_object_plural(collObj))}({
      limit: -1,
  <#list idAttrs as idAttr>
      ${modelbase.get_attribute_sql_name(idAttr)}: ${modelbase.get_attribute_sql_name(idAttr)},
  </#list>
    });
    ${js.nameVariable(attr.name)}.value = data;
  } catch (error) {
    // error handler
  }
};
</#list>
</script>
