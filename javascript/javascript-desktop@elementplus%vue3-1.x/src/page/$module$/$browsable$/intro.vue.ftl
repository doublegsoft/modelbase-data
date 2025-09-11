<#import "/$/modelbase.ftl" as modelbase>
<#assign obj = browsable>
<#assign idAttr = modelbase.get_id_attributes(obj)[0]>
<#assign levelledAttrs = modelbase.level_object_attributes(obj)>
<template>
  <el-card style="width: 100%;" @click="gotoDetail">
    <div style="display:flex;">
<#if (levelledAttrs["image"]?size > 0)>     
      <div style="width:96px;height:96px;border-radius:10px;margin-right: 10px;">  
        <img :src="props.${js.nameVariable(obj.name)}.${modelbase.get_attribute_sql_name(levelledAttrs["image"][0])}" 
             style="width:100%;height:100%;border-radius:10px;" /> 
      </div>
</#if>      
      <div>
        <div style="font-size:16px;font-weight:600;margin-bottom:8px;">{{ props.${js.nameVariable(obj.name)}.<#if levelledAttrs["primary"]?size == 0>notSet<#else>${modelbase.get_attribute_sql_name(levelledAttrs["primary"][0])}</#if> }}</div>
<#if levelledAttrs["secondary"]?size != 0>        
        <div class="font-size:14px;color:var(--color-text-secondary);margin-bottom:8px;">{{ props.${js.nameVariable(obj.name)}.${modelbase.get_attribute_sql_name(levelledAttrs["secondary"][0])} }}</div>
</#if> 
<#if levelledAttrs["tertiary"]?size != 0>        
        <div class="font-size:14px;color:var(--color-text-secondary);margin-bottom:8px;">{{ props.${js.nameVariable(obj.name)}.${modelbase.get_attribute_sql_name(levelledAttrs["tertiary"][0])} }}</div>
</#if>        
      </div>
<#if levelledAttrs["accent"]?size != 0>        
      <div style="display:flex;width:72px;justify-content:center;align-items:center;margin-left:auto;">
        <el-tag type="primary">{{ props.${js.nameVariable(obj.name)}.${modelbase.get_attribute_sql_name(levelledAttrs["accent"][0])} }}</el-tag>
      </div>
</#if>       
    </div>
<#if levelledAttrs["startDate"]?size != 0>
    <div class="font-size:14px;color:var(--color-text-secondary);margin-bottom:8px;">
      <span>{{ dayjs(props.${js.nameVariable(obj.name)}.${modelbase.get_attribute_sql_name(levelledAttrs["startDate"][0])}).format("YYYY-MM-DD") }}</span>
  <#if levelledAttrs["startTime"]?size != 0>      
      <span>&nbsp;</span>
      <span>{{ dayjs(props.${js.nameVariable(obj.name)}.${modelbase.get_attribute_sql_name(levelledAttrs["startTime"][0])}).format("HH:mm") }}</span>
  </#if>    
      <span> - </span>
  <#if levelledAttrs["dueDate"]?size != 0>    
      <span>{{ dayjs(props.${js.nameVariable(obj.name)}.${modelbase.get_attribute_sql_name(levelledAttrs["dueDate"][0])}).format("YYYY-MM-DD") }}</span>
      <span>&nbsp;</span>
  </#if>
  <#if levelledAttrs["dueTime"]?size != 0>      
      <span>{{ dayjs(props.${js.nameVariable(obj.name)}.${modelbase.get_attribute_sql_name(levelledAttrs["dueTime"][0])}).format("HH:mm") }}</span>
  </#if>    
    </div>
</#if>
<#if obj.isLabelled("shareable")>    
    <div class="gap-4" style="margin-top:16px;display:flex;font-size:13px;">
      <div class="w-4/12 px-4" style="display:flex;">
        <div class="gx-i gx-i-shares" style="font-size:15px;"></div>
        <div style="line-height:20px;margin-left:auto;">{{ props.shares || 0 }}</div>
      </div>
      <div class="w-4/12 px-4" style="display:flex;">
        <div class="gx-i gx-i-heart" style="font-size:15px;"></div>
        <div style="line-height:20px;margin-left:auto;">{{ props.likes || 0 }}</div>
      </div>
      <div class="w-4/12 px-4" style="display:flex;">
        <div class="gx-i gx-i-comments" style="font-size:15px;"></div>
        <div style="line-height:20px;margin-left:auto;">{{ props.comments || 0 }}</div>
      </div>
    </div>
</#if>    
  </el-card>
</template>

<script setup>
import dayjs from 'dayjs';
import { ref, onMounted } from 'vue';

import { sdk } from '@/sdk/sdk';
import router from '@/router/index';

const props = defineProps({
  ${js.nameVariable(obj.name)}: {
    type: Object,
    require: true,
  },
});

const gotoDetail = () => {
  router.goto${js.nameType(obj.name)}Detail(props.${js.nameVariable(obj.name)}.${modelbase.get_attribute_sql_name(idAttr)});
}

</script>

<style scoped>

.el-card {
  margin-bottom: 10px;
}
</style>