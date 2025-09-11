<#import "/$/modelbase.ftl" as modelbase>
<#assign obj = detailable>
<template>
<div class="p-4">
<#list obj.attributes as attr>  
  <#if !attr.isLabelled("section")><#continue></#if>
  <div class="section">
    <h2 class="section-title">${modelbase.get_attribute_label(attr)}</h2>
    <p class="objectives-text">{{ lessonPlan.${modelbase.get_attribute_sql_name(attr)} }}</p>
  </div>
</#list>  
  <div class="grid">
    <div class="section">
      <h2 class="section-title">Resources</h2>
      <div>
        <div v-for="resource in lessonPlan.resources" :key="resource.id" class="resource-item">
          <div class="resource-icon">{{ resource.icon }}</div>
          <span>{{ resource.name }}</span>
        </div>
      </div>
    </div>
    <div class="section">
      <h2 class="section-title">Assessments</h2>
      <div>
        <div v-for="assessment in lessonPlan.assessments" :key="assessment.id" class="assessment-item">
          <div class="resource-icon">{{ assessment.icon }}</div>
          <span>{{ assessment.name }}</span>
        </div>
      </div>
    </div>
  </div>
<#assign parts = []>
<#list obj.attributes as attr>
  <#if attr.type.custom && attr.isLabelled("aggregatable")>  
    <#assign refObj = model.findObjectByName(attr.type.name)>
  <h2 class="section-title">${modelbase.get_object_label(refObj)}</h2>   
  <${java.nameType(refObj.name)}Detail />
  </#if>
</#list>
<#list obj.attributes as attr>
  <#if attr.type.collection>
    <#assign collObj = model.findObjectByName(attr.type.componentType.name)>
    <#if attr.isLabelled("separatable")>
      <#assign parts += [{"title":""}]>
    <#else>
      <#assign parts += [{"title":modelbase.get_object_label(collObj), "obj":collObj}]>
    </#if>  
  <#elseif attr.type.custom && !attr.isLabelled("aggregatable")>
    <#assign refObj = model.findObjectByName(attr.type.name)>
    <#assign parts += [{"title":modelbase.get_object_label(refObj), "obj":refObj}]>
  </#if>
</#list>
<#if parts?size != 0>
  <el-tabs v-model="activeTab" type="card">
  <#list parts as part>
    <el-tab-pane label="${part.title}" name="tab${js.nameType(part.obj.name)}">
      <div class="tab-content">Welcome to the Home tab!</div>
    </el-tab-pane>
  </#list>
  </el-tabs>
</#if>  
</div>
</template>
<script setup>
import { reactive, ref } from 'vue';
<#list obj.attributes as attr>
  <#if attr.type.custom && attr.isLabelled("aggregatable")>  
    <#assign refObj = model.findObjectByName(attr.type.name)>
import ${js.nameType(refObj.name)}Detail from '@/page/${modelbase.get_object_module(refObj)}/${refObj.name?replace("_","-")}/detail.vue';
  </#if>
</#list>

const lessonPlan = reactive({
  title: 'Lesson Plan Title',
  description: 'Lesson Plan Description',
  objectives: 'By the end of this lesson, participants will be able to: - Understand the key concepts of the topic. - Apply the learned techniques in practical scenarios. - Evaluate the effectiveness of different approaches.',
  modules: [
    {
      id: 1,
      title: 'Module 1',
      description: 'Introduction to the topic'
    },
    {
      id: 2,
      title: 'Module 2',
      description: 'Deep dive into key concepts'
    },
    {
      id: 3,
      title: 'Module 3',
      description: 'Practical application and exercises'
    },
    {
      id: 4,
      title: 'Module 4',
      description: 'Review and Q&A'
    }
  ],
  schedule: [
    {
      id: 1,
      module: 'Module 1',
      time: '9:00 AM - 10:00 AM'
    },
    {
      id: 2,
      module: 'Module 2',
      time: '10:00 AM - 11:30 AM'
    },
    {
      id: 3,
      module: 'Module 3',
      time: '11:30 AM - 12:30 PM'
    },
    {
      id: 4,
      module: 'Module 4',
      time: '12:30 PM - 1:00 PM'
    }
  ],
  materials: [
    {
      id: 1,
      name: 'Whiteboard or Flip Chart',
      icon: '📝'
    },
    {
      id: 2,
      name: 'Markers',
      icon: '✏️'
    },
    {
      id: 3,
      name: 'Projector',
      icon: '📽️'
    },
    {
      id: 4,
      name: 'Handouts (provided)',
      icon: '📄'
    }
  ],
  resources: [
    {
      id: 1,
      name: 'Presentation Slides',
      icon: '📊'
    },
    {
      id: 2,
      name: 'Exercise Sheets',
      icon: '📄'
    },
    {
      id: 3,
      name: 'Additional Reading',
      icon: '📚'
    }
  ],
  assessments: [
    {
      id: 1,
      name: 'Quiz',
      icon: '❓'
    },
    {
      id: 2,
      name: 'Practical Exercise',
      icon: '🎯'
    }
  ]
});
</script>

<style>
.lesson-header {
  margin-bottom: 32px;
}

.lesson-title {
  font-size: 32px;
  font-weight: 700;
  margin-bottom: 8px;
  color: #212529;
}

.lesson-description {
  color: #6c757d;
  font-size: 16px;
}

.section {
  background: white;
  border-radius: 12px;
  padding: 24px;
  margin-bottom: 24px;
  box-shadow: 0 1px 3px rgba(0,0,0,0.1);
}

.section-title {
  font-size: 20px;
  font-weight: 600;
  margin-bottom: 16px;
  color: #212529;
}

.objectives-text {
  line-height: 1.6;
  color: #495057;
}

.module-list {
  display: flex;
  flex-direction: column;
  gap: 16px;
}

.module-item {
  display: flex;
  align-items: flex-start;
  gap: 12px;
  padding: 16px;
  background: #f8f9fa;
  border-radius: 8px;
  transition: background-color 0.2s;
}

.module-item:hover {
  background: #e9ecef;
}

.module-icon {
  width: 20px;
  height: 20px;
  color: #6c757d;
  margin-top: 2px;
}

.module-content {
  flex: 1;
}

.module-title {
  font-weight: 600;
  margin-bottom: 4px;
  color: #212529;
}

.module-description {
  color: #6c757d;
  font-size: 14px;
}

.schedule-item {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 12px 0;
  border-bottom: 1px solid #e9ecef;
}

.schedule-item:last-child {
  border-bottom: none;
}

.schedule-icon {
  width: 20px;
  height: 20px;
  color: #6c757d;
}

.time-range {
  color: #6c757d;
  font-size: 14px;
}

.resource-item, .assessment-item {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 12px 0;
}

.resource-icon {
  width: 20px;
  height: 20px;
  color: #6c757d;
}

.grid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 24px;
}
</style>