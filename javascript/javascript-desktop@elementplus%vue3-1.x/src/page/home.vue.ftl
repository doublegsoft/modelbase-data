<#import "/$/modelbase.ftl" as modelbase>
<template>
  <div class="p-4">
    <div class="grid-cols-3 gap-6 mb-8" style="display:grid;">
<#list model.objects as obj>  
  <#if !obj.isLabelled("aggregatable")><#continue></#if>
      <div class="bg-white rounded-lg shadow p-6">
        <div class="flex items-center justify-between">
          <div>
            <h3 class="text-sm font-medium text-gray-500">${modelbase.get_object_label(obj)}</h3>
            <p class="text-3xl font-bold text-gray-900 mt-1">150</p>
          </div>
          <div ref="sparkline${js.nameType(obj.name)}" style="width:180px;height:60px;"></div>
          <div class="w-12 h-12 bg-blue-100 rounded-lg flex items-center justify-center">
            <i class="fas fa-users text-blue-600 text-xl"></i>
          </div>
        </div>
      </div>
</#list>
    </div>
    <div class="grid grid-cols-1 lg:grid-cols-2 gap-8">
<#list model.objects as obj>    
  <#if !obj.isLabelled("schedulable")><#continue></#if>
      <div class="bg-white rounded-lg shadow">
        <div class="p-6 border-b border-gray-200">
          <h3 class="text-lg font-semibold text-gray-800">即将开始的${modelbase.get_object_label(obj)}</h3>
        </div>
        <div class="p-6 space-y-4">
          <div v-for="row in ${js.nameVariable(modelbase.get_object_plural(obj))}" :key="row.id" class="flex items-center justify-between p-4 border border-gray-200 rounded-lg">
            <div>
              <h4 class="font-medium text-gray-800">{{ row.title }}</h4>
              <p class="text-sm text-gray-600">{{ row.datetime }} - {{ row.location }}</p>
            </div>
            <span :class="['px-3 py-1 rounded-full text-xs font-medium', 
                          row.status === 'Confirmed' ? 'bg-green-100 text-green-800' : 'bg-yellow-100 text-yellow-800']">
              {{ row.status }}
            </span>
          </div>
          <a href="#" class="text-blue-600 hover:text-blue-800 text-sm font-medium">View all sessions</a>
        </div>
      </div>
</#list>
<#list model.objects as obj>    
  <#if !obj.isLabelled("actionable")><#continue></#if>
      <div class="bg-white rounded-lg shadow">
        <div class="p-6 border-b border-gray-200">
          <h3 class="text-lg font-semibold text-gray-800">近期活动</h3>
        </div>
        <div class="p-6 space-y-4">
          <div v-for="row in ${js.nameVariable(modelbase.get_object_plural(obj))}" :key="row.auditLogId" class="flex items-start space-x-3">
            <div :class="['w-8 h-8 rounded-full flex items-center justify-center text-xs', row.iconBg]">
              <i :class="[row.icon, 'text-white']"></i>
            </div>
            <div class="flex-1">
              <p class="text-sm text-gray-800">
                <span>{{ row.username }}</span>
                <span>{{ row.actionName }}</span>
              </p>
              <p class="text-xs text-gray-500 mt-1">{{ dayjs(row.actionTime).format('YYYY年MM月DD日 HH:mm') }}</p>
            </div>
          </div>
        </div>
      </div>
  <#break>    
</#list>  
<#list model.objects as obj>    
  <#if !obj.isLabelled("browsable")><#continue></#if>
  <#assign idAttr = modelbase.get_id_attributes(obj)[0]>
      <div class="bg-white rounded-lg shadow">
        <div class="p-6 border-b border-gray-200">
          <h3 class="text-lg font-semibold text-gray-800">${modelbase.get_object_label(obj)}</h3>
        </div>
        <el-row :gutter="20" class="p-6">
          <el-col :span="12" v-for="row in ${js.nameVariable(modelbase.get_object_plural(obj))}" :key="row.${modelbase.get_attribute_sql_name(idAttr)}">
            <${js.nameType(obj.name)}Intro :${js.nameVariable(obj.name)}="row" />
          </el-col>
        </el-row>
      </div>
</#list>   
    </div>     
  </div>
</template>

<script setup>
import dayjs from 'dayjs';
import * as echarts from 'echarts';
import { onMounted, onBeforeUnmount, ref } from 'vue';
import '/src/asset/style/main.css';
import { sdk } from '@/sdk/sdk';
<#list model.objects as obj>
  <#if obj.isLabelled("browsable")>
import ${js.nameType(obj.name)}Intro from '@/page/${modelbase.get_object_module(obj)}/${obj.name?replace("_","-")}/intro.vue';  
  </#if>
  <#if obj.isLabelled("schedulable")>
import ${js.nameType(obj.name)}Slot from '@/page/${modelbase.get_object_module(obj)}/${obj.name?replace("_","-")}/slot.vue';  
  </#if>
</#list>
<#assign fetchObjs = {}>
<#list model.objects as obj>    
  <#if !obj.isLabelled("schedulable") || fetchObjs[obj.name]??><#continue></#if>
  <#assign fetchObjs += {obj.name: obj}>
  
/**
 * 在主页展示的【${modelbase.get_object_label(obj)}】数据
 */  
const ${js.nameVariable(modelbase.get_object_plural(obj))} = ref([]);    
</#list>  
<#list model.objects as obj>    
  <#if !obj.isLabelled("actionable") || fetchObjs[obj.name]??><#continue></#if>
  <#assign fetchObjs += {obj.name: obj}>
  
/**
 * 在主页展示的【${modelbase.get_object_label(obj)}】数据
 */    
const ${js.nameVariable(modelbase.get_object_plural(obj))} = ref([]);    
</#list>  
<#list model.objects as obj>    
  <#if !obj.isLabelled("browsable") || fetchObjs[obj.name]??><#continue></#if>
  <#assign fetchObjs += {obj.name: obj}>

/**
 * 在主页展示的【${modelbase.get_object_label(obj)}】数据
 */    
const ${js.nameVariable(modelbase.get_object_plural(obj))} = ref([]);  
</#list>  
<#list model.objects as obj>  
  <#if !obj.isLabelled("aggregatable")><#continue></#if>
  
const sparkline${js.nameType(obj.name)} = ref();
let sparklineInst${js.nameType(obj.name)} = null;
</#list>
<#assign fetchObjs = {}>
<#list model.objects as obj>    
  <#if !obj.isLabelled("schedulable") || fetchObjs[obj.name]??><#continue></#if>
  <#assign fetchObjs += {obj.name: obj}>
  
const fetch${js.nameType(modelbase.get_object_plural(obj))} = async () => {
  let res = await sdk.find${js.nameType(modelbase.get_object_plural(obj))}({
    limit: 3,
  });
  ${js.nameVariable(modelbase.get_object_plural(obj))}.value = res.data;
};   
</#list>  
<#list model.objects as obj>    
  <#if !obj.isLabelled("actionable") || fetchObjs[obj.name]??><#continue></#if>
  <#assign fetchObjs += {obj.name: obj}>
  
const fetch${js.nameType(modelbase.get_object_plural(obj))} = async () => {
  let res = await sdk.find${js.nameType(modelbase.get_object_plural(obj))}({
    limit: 3,
  });
  ${js.nameVariable(modelbase.get_object_plural(obj))}.value = res.data;
};   
</#list>  
<#list model.objects as obj>    
  <#if !obj.isLabelled("browsable") || fetchObjs[obj.name]??><#continue></#if>
  <#assign fetchObjs += {obj.name: obj}>
  
const fetch${js.nameType(modelbase.get_object_plural(obj))} = async () => {
  let res = await sdk.find${js.nameType(modelbase.get_object_plural(obj))}({
    limit: 3,
  });
  ${js.nameVariable(modelbase.get_object_plural(obj))}.value = res.data;
};
</#list> 
onMounted(() => {
<#list model.objects as obj>    
  <#if !obj.isLabelled("schedulable")><#continue></#if>
  fetch${js.nameType(modelbase.get_object_plural(obj))}();
</#list>
<#list model.objects as obj>    
  <#if !obj.isLabelled("actionable")><#continue></#if>
  fetch${js.nameType(modelbase.get_object_plural(obj))}();
</#list>
<#list model.objects as obj>    
  <#if !obj.isLabelled("browsable")><#continue></#if>
  fetch${js.nameType(modelbase.get_object_plural(obj))}();
</#list>
<#list model.objects as obj>  
  <#if !obj.isLabelled("aggregatable")><#continue></#if>
  renderSparkline${js.nameType(obj.name)}();
</#list>  
});

onBeforeUnmount(() => {
  
});
<#list model.objects as obj>  
  <#if !obj.isLabelled("aggregatable")><#continue></#if>

/**
 * 渲染【${modelbase.get_object_label(obj)}】迷你趋势图。
 */
const renderSparkline${js.nameType(obj.name)} = () => {
  if (!sparkline${js.nameType(obj.name)}.value) return;
  sparklineInst${js.nameType(obj.name)} = echarts.init(sparkline${js.nameType(obj.name)}.value);
  sparklineInst${js.nameType(obj.name)}.setOption({
    grid: { left: 0, right: 0, top: 0, bottom: 0 },
    xAxis: { type: 'category', show: false, data: [10, 15, 13, 18, 16, 22, 19].map((_, i) => i) },
    yAxis: { type: 'value', show: false },
    tooltip: { show: false },
    series: [{
      type: 'line',
      data: [10, 15, 13, 18, 16, 22, 19],
      smooth: true,
      symbol: 'none',
      lineStyle: {
        width: 2
      },
    }],
  });
};
</#list>

const scheduleItems = ref([
  {
    id: 1,
    title: 'U10 Team Practice',
    datetime: 'Tomorrow, 4:00 PM',
    location: 'Field A',
    status: 'Confirmed'
  },
  {
    id: 2,
    title: 'Goalkeeper Clinic',
    datetime: 'Oct 28, 10:00 AM',
    location: 'Indoor Facility',
    status: 'Pending'
  },
  {
    id: 3,
    title: 'U12 Scrimmage vs. Rovers FC',
    datetime: 'Nov 4, 2:00 PM',
    location: 'Main Stadium',
    status: 'Confirmed'
  }
])

const recentActivity = ref([
  {
    id: 1,
    icon: 'fas fa-user-plus',
    iconBg: 'bg-blue-500',
    text: 'New player <span class="font-medium text-blue-600">Alex Johnson</span> registered.',
    time: '2 hours ago'
  },
  {
    id: 2,
    icon: 'fas fa-dollar-sign',
    iconBg: 'bg-green-500',
    text: 'Payment of <span class="font-medium text-green-600">$150</span> received from <span class="font-medium text-blue-600">Sarah Miller</span>.',
    time: 'Yesterday'
  },
  {
    id: 3,
    icon: 'fas fa-calendar',
    iconBg: 'bg-purple-500',
    text: 'U10 practice scheduled by <span class="font-medium text-blue-600">Coach Davis</span>.',
    time: '3 days ago'
  }
])
</script>

<style scoped>
.card {
  background-color: var(--el-card-bg-color);
  border: 1px solid var(--el-card-border-color);
  border-radius: var(--el-card-border-radius);
  color: var(--el-text-color-primary);
  overflow: hidden;
  transition: var(--el-transition-duration);
}
</style>
