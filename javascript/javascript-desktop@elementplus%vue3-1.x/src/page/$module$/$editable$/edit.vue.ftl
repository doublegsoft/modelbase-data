<#import "/$/modelbase.ftl" as modelbase>
<#import "/$/elementplus.layout.ftl" as epl>
<#import "/$/elementplus.field.ftl" as epf>
<#import "/$/elementplus.method.ftl" as epm>
<#assign obj = editable>
<template>
<@epl.print_layout_editable_form obj=obj indent=2 /> 
<div class="mb-4">
  <el-button type="primary" @click="doSave${js.nameType(obj.name)}">保存</el-button>
  <el-button type="danger" @click="doClose${js.nameType(obj.name)}Edit">关闭</el-button>
</div>
</template>

<script lang="ts" setup>
import { reactive, ref, onMounted, toRaw } from 'vue';
import type { FormInstance, FormRules } from 'element-plus';
import { ElMessage } from 'element-plus';
import { sdk } from '@/sdk/sdk';
const emit = defineEmits(['close'])
<@epf.print_field_editable_form obj=obj indent=0 />
<@epm.print_method_editable_form obj=obj indent=0 />

onMounted(() => {
  
});
</script>

<style>
<#if modelbase.has_attribute_avatar(obj)>
.el-form-item__content {
  width: 100%;
}

.avatar-uploader .avatar {
  width: 96px;
  height: 96px;
  display: block;
  border-radius: 9999px;
  margin: auto;
}

.avatar-uploader {
  display: flex;
  align-items: center;
  justify-content: center;
  margin-bottom: 16px;
}
.avatar-uploader .el-upload {
  border: 1px dashed var(--el-border-color);
  border-radius: 9999px;
  cursor: pointer;
  position: relative;
  overflow: hidden;
  transition: var(--el-transition-duration-fast);
}

.avatar-uploader .el-upload:hover {
  border-color: var(--el-color-primary);
}

.el-icon.avatar-uploader-icon {
  font-size: 28px;
  color: #8c939d;
  width: 96px;
  height: 96px;
  text-align: center;
}
</#if>
<#if modelbase.has_attribute_cover(obj)>
.cover-uploader .cover {
  width: 300px;
  height: 96px;
  display: block;
  border-radius: 9999px;
}

.cover-uploader {
  display: flex;
  align-items: center;
  justify-content: center;
  margin-bottom: 16px;
}

.cover-uploader .el-upload {
  width: 100%;
  border: 1px dashed var(--el-border-color);
  border-radius: 16px;
  cursor: pointer;
  position: relative;
  overflow: hidden;
  transition: var(--el-transition-duration-fast);
}

.cover-uploader .el-upload:hover {
  border-color: var(--el-color-primary);
}

.el-icon.cover-uploader-icon {
  font-size: 28px;
  color: #8c939d;
  width: 96px;
  height: 96px;
  text-align: center;
}
</#if>
</style>
