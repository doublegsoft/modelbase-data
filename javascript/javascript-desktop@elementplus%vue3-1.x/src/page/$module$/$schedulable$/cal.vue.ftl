<#import "/$/modelbase.ftl" as modelbase>
<#assign obj = schedulable>
<#assign idAttr = modelbase.get_id_attributes(obj)[0]>
<#assign levelledAttrs = modelbase.level_object_attributes(obj)>
<template>
  <div class="w-full max-w-md mx-auto" style="margin-bottom: 10px;">
    <div class="relative bg-gradient-to-br from-purple-500 to-purple-600 rounded-3xl p-1 shadow-xl">
      <div class="bg-white bg-opacity-95 backdrop-blur-sm rounded-2xl p-6">
        <div class="flex items-center justify-between mb-4">
          <span class="text-gray-400 text-sm font-medium">Name your activity</span>
          <button @click="toggleTimer"
            class="w-10 h-10 rounded-full bg-green-500 hover:bg-green-600 transition-all duration-200 flex items-center justify-center shadow-md hover:shadow-lg hover:-translate-y-0.5">
            <!-- Pause Icon -->
            <svg
              v-if="isRunning"
              class="w-5 h-5 text-white"
              viewBox="0 0 24 24"
              fill="currentColor">
              <path d="M6 4h4v16H6V4zm8 0h4v16h-4V4z" />
            </svg>
            <svg
              v-else
              class="w-5 h-5 text-white ml-0.5"
              viewBox="0 0 24 24"
              fill="currentColor">
              <path d="M8 5v14l11-7z" />
            </svg>
          </button>
        </div>
        <!-- Activity Name -->
        <div class="flex items-center gap-2 mb-6">
          <input
            v-if="isEditing"
            ref="editInput"
            v-model="editValue"
            @blur="saveEdit"
            @keydown.enter="saveEdit"
            @keydown.escape="cancelEdit"
            class="text-2xl font-bold text-gray-900 bg-transparent border-none outline-none flex-1 border-b-2 border-purple-500 pb-1"
          />
          <h2 v-else class="text-2xl font-bold text-gray-900 flex-1">
            {{ activityName }}
          </h2>
          <button
            v-if="!isEditing"
            @click="startEdit"
            class="p-1 text-gray-400 hover:text-gray-600 transition-colors duration-200 rounded">
            <svg class="w-4 h-4" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
              <path d="m18 2 4 4-6 6-4-4 6-6z"></path>
              <path d="m14.5 5.5-7.5 7.5-1 4 4-1 7.5-7.5z"></path>
            </svg>
          </button>
        </div>
        <div class="flex items-end justify-between">
          <div>
            <p class="text-gray-500 text-sm mb-1">{{ formattedDate }}</p>
            <p class="text-gray-400 text-xs">{{ timeRange }}</p>
          </div>
          <div class="text-right">
            <div class="text-3xl font-bold text-gray-900 font-mono">
              {{ formattedTime }}
            </div>
          </div>
        </div>
        <div v-if="isRunning" class="absolute top-4 right-4">
          <div class="w-2 h-2 bg-green-500 rounded-full animate-pulse"></div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
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
};

</script>

<style scoped>
.el-card {
  
}
</style>