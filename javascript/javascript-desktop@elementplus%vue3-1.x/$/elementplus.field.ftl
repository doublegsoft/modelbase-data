<#--
 ### 【迷你图】需要的全部变量。
 -->
<#macro print_field_sparkline obj indent>
/**
 * 【${modelbase.get_object_label(obj)}】迷你图变量。
 */
const sparkline${js.nameType(obj.name)} = ref();
let sparklineInst${js.nameType(obj.name)} = null;
</#macro> 

<#--
 ### 可编辑表单
 -->
<#macro print_field_editable_form obj indent>
${""?left_pad(indent)}
${""?left_pad(indent)}const props = defineProps({
${""?left_pad(indent)}  ${js.nameVariable(obj.name)}: { type: Object, default: {}},
${""?left_pad(indent)}});
${""?left_pad(indent)}
${""?left_pad(indent)}const refForm${js.nameType(obj.name)} = ref<FormInstance>(); 
${""?left_pad(indent)}
${""?left_pad(indent)}const rules${js.nameType(obj.name)} = reactive<FormRules>({
<#assign index = 0>
<#list obj.attributes as attr>  
  <#if attr.identifiable><#continue></#if>
  <#if modelbase.is_attribute_system(attr)><#continue></#if>
  <#if attr.type.collection><#continue></#if>
  <#if attr.constraint.nullable && 
       (!attr.constraint.maxSize?? || attr.constraint.maxSize == 0) &&
       !modelbase.is_attribute_number(attr)>
    <#continue>
  </#if>   
${""?left_pad(indent)}  ${modelbase.get_attribute_sql_name(attr)}: [
  <#if attr.type.name == "string">
    <#if !attr.constraint.nullable>
${""?left_pad(indent)}    { required: true, message: '${modelbase.get_attribute_label(attr)}必须填写', trigger: 'blur', },
    </#if>
    <#if attr.constraint.maxSize?? && attr.constraint.maxSize != 0>
${""?left_pad(indent)}    { max: ${attr.constraint.maxSize}, message: '输入长度不能超过${attr.constraint.maxSize}个', trigger: 'blur', },
    </#if>
  </#if>
  <#if modelbase.is_attribute_date(attr)>
${""?left_pad(indent)}    { type: 'date',<#if !attr.constraint.nullable> required: true,</#if> message: '${modelbase.get_attribute_label(attr)}必须选择', trigger: 'change', },
  </#if>
  <#if modelbase.is_attribute_enum(attr)>
${""?left_pad(indent)}    { <#if !attr.constraint.nullable>required: true,</#if> message: '${modelbase.get_attribute_label(attr)}必须选择', trigger: 'change', },
  </#if>
  <#if modelbase.is_attribute_number(attr)>
    <#if !attr.constraint.nullable>
${""?left_pad(indent)}   { required: true, message: '${modelbase.get_attribute_label(attr)}必须填写', trigger: 'blur', },
    </#if>
${""?left_pad(indent)}    { 
${""?left_pad(indent)}      validator: (rule, value, callback) => {
${""?left_pad(indent)}        if (value && value != "" && isNaN(value)) {
${""?left_pad(indent)}          callback(new Error('${modelbase.get_attribute_label(attr)}必须是数字'));
${""?left_pad(indent)}          return;
${""?left_pad(indent)}        }
${""?left_pad(indent)}        callback();
${""?left_pad(indent)}      }, 
${""?left_pad(indent)}      trigger: 'blur',
${""?left_pad(indent)}    },
  </#if>
${""?left_pad(indent)}  ],
</#list>  
${""?left_pad(indent)}});
</#macro> 