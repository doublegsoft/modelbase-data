<#import "/$/modelbase.ftl" as modelbase>
<#assign obj = browsable>
<#assign idAttr = modelbase.get_id_attributes(obj)[0]>
<template>
  <el-form label-width="150"
           label-position="left"
           :model="params"
           :size="default"
           style="padding:16px;">
    <el-row :gutter="20">
<#list obj.attributes as attr>    
  <#if !attr.isLabelled("filterable")><#continue></#if>
  <#if attr.type.name == "date" || attr.type.name == "datetime">
      <el-col :span="8">       
        <el-form-item label="开始${modelbase.get_attribute_label(attr)}">
          <el-date-picker
              v-model="params.${modelbase.get_attribute_sql_name(attr)}0"
              type="date"
              style="width: 100%" />
        </el-form-item>
      </el-col> 
      <el-col :span="8">       
        <el-form-item label="结束${modelbase.get_attribute_label(attr)}">
         <el-date-picker
              v-model="params.${modelbase.get_attribute_sql_name(attr)}1"
              type="date"
              style="width: 100%" />
        </el-form-item>
      </el-col> 
  <#elseif attr.constraint.domainType.name?starts_with("enum")>
    <#assign pairs = typebase.enumtype(attr.constraint.domainType.name)>
      <el-col :span="8">
        <el-form-item label="${modelbase.get_attribute_label(attr)}">
          <el-select multiple v-model="params.${modelbase.get_attribute_sql_name(attr)}" clearable placeholder="全部">
    <#list pairs as pair>
            <el-option label="${pair.value}" value="${pair.key}" />
    </#list>
          </el-select>
        </el-form-item>
      </el-col>
  <#else>
      <el-col :span="8">       
        <el-form-item label="${modelbase.get_attribute_label(attr)}">
          <el-input v-model="params.${modelbase.get_attribute_sql_name(attr)}" />
        </el-form-item>
      </el-col>   
  </#if>    
</#list>      
      <el-col :span="8">
        <el-form-item>
          <el-button type="primary" @click="doSearch">搜索</el-button>
          <el-button type="warning" @click="doReset">重置</el-button>
          <el-button type="success" @click="gotoEdit({})">新增</el-button>
        </el-form-item>
      </el-col>
    </el-row>     
  </el-form>
  <div ref="loadingEl" style="padding:10px 10px 0 10px;flex:1;overflow-y:auto;">
    <el-row :gutter="20">
      <el-col v-for="item in ${js.nameVariable(modelbase.get_object_plural(obj))}" 
        :key="item.${modelbase.get_attribute_sql_name(idAttr)}" 
        :span="8">
        <${js.nameType(obj.name)}Intro :${js.nameVariable(obj.name)}="item" />
      </el-col>
    </el-row>
    <div v-if="total == 0" style="text-align:center;padding:20px;color:#999;">
      <el-empty :image-size="120" description="没有满足条件的数据" />
    </div>
    <div style="height:10px;"></div>
  </div>
  <div style="position:sticky;bottom:16px;padding-right:16px;">
    <el-pagination background layout="prev, pager, next" 
                   style="display: flex; justify-content: flex-end;"
                   @current-change="doChangePage" 
                   :page-size="limit" :total="total" />
  </div>
<#if obj.isLabelled("editable")>  
  <el-drawer v-model="isEditing" title="${modelbase.get_object_label(obj)}信息编辑" direction="rtl"
             :before-close="doCloseEdit">
    <${js.nameType(obj.name)}Edit />
  </el-drawer>
</#if>    
</template>

<script setup>
import { ref, onMounted } from 'vue';
import { ElLoading } from 'element-plus';
import { sdk } from '@/sdk/sdk';
import ${js.nameType(obj.name)}Intro from './intro.vue';
<#if obj.isLabelled("editable")>
import ${js.nameType(obj.name)}Edit from '@/page/${modelbase.get_object_module(obj)}/${obj.name?replace("_","-")}/edit.vue';
</#if>

const props = defineProps({
  limit: {
    type: Number,
    default: 12,
  },
});

const limit = ref(props.limit);
const start = ref(0);
const total = ref(0);
const params = ref({});
const ${js.nameVariable(modelbase.get_object_plural(obj))} = ref([]);

const loadingEl = ref(null);
<#if obj.isLabelled("editable")>

/*!
** 正在编辑的控制变量
*/
const isEditing = ref(false)
</#if>

onMounted(() => {
  fetch${js.nameType(modelbase.get_object_plural(obj))}();
});

/*!
** 获取【${modelbase.get_object_label(obj)}】数据。
*/
const fetch${js.nameType(modelbase.get_object_plural(obj))} = async () => {
  const loading = ElLoading.service({
    target: loadingEl.value,
    text: '数据加载中...',
  });
  let res = await sdk.find${js.nameType(modelbase.get_object_plural(obj))}({
    ...params.value,
    start: start.value,
    limit: limit.value,
  });
  total.value = res.total;
  ${js.nameVariable(modelbase.get_object_plural(obj))}.value = res.data;
  loading.close();
};

/*!
** 翻页。
*/
const doChangePage = (page) => {
  start.value = (page - 1) * limit.value;
  fetch${js.nameType(modelbase.get_object_plural(obj))}();
};

/*!
** 清除查询条件。
*/
const doReset = () => {
  params.value = {};
};

/*!
** 重新搜索。
*/
const doSearch = () => {
  doChangePage(0);
};
<#if obj.isLabelled("editable")>

/*!
** 跳转到【${modelbase.get_object_label(obj)}】编辑页面。
*/
const gotoEdit = (row) => {
  isEditing.value = true;
};

const doCloseEdit = () => {
  isEditing.value = false
};
</#if>
</script>

<style scoped>
.card {
  text-align: center;
  padding: 16px;
  border-radius: 8px;
  margin-bottom: 10px;
  max-height: 180px;
}
</style>

<style scoped>

</style>