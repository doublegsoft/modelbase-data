<#import "/$/modelbase.ftl" as modelbase>
<#import "/$/modelbase4js.ftl" as modelbase4js>
<template>
  <el-menu :default-active="$route.path"
           class="el-menu-vertical-demo"
           @open="doOpen"
           @close="doClose"
           style="height:calc(100% - 68px);"
           router>
    <el-menu-item index="/">
      <i class="gx-i gx-i-home" style="margin-right:16px;"></i>
      <span>首页</span>
    </el-menu-item>
<#list model.objects as obj>    
  <#if !obj.isLabelled('manageable')><#continue></#if>
  <#if obj.isLabelled("browsable")>
    <el-menu-item index="/${modelbase4js.get_object_page_path(obj)}/coll">
  <#else>  
    <el-menu-item index="/${modelbase4js.get_object_page_path(obj)}/list">
  </#if>
      <i class="gx-i gx-i-app" style="margin-right:16px;"></i>
      <span>${modelbase.get_object_label(obj)}</span>
    </el-menu-item>
</#list>    
  </el-menu>
</template>
<script setup>
import {} from 'vue';

const doOpen = (key, keyPath) => {
      
};

const doClose = (key, keyPath) => {
  
};
</script>

<style scoped>
.el-menu {
  /*box-shadow: 0 2px 4px rgba(0,0,0,0.1), 0 8px 16px rgba(0,0,0,0.1);*/
  background-color: rgb(255, 255, 255);
  border-right: solid 0;
}
.el-menu-item {
  color: var(--el-menu-text-color); 
  font-size: 0.875rem;
  line-height: 1.25rem;
  font-weight: 600;
  padding-top: 0.75rem;
  padding-bottom: 0.75rem;
  padding-left: 1.5rem;
  padding-right: 1.5rem;
}
.el-menu-item.is-active {
  border-color: var(--el-menu-active-color);
  background-color: var(--el-color-primary-light-9);
  border-right: solid 2px;
}
.el-menu span {
  font-size:16px;
  position:relative;
}
</style>