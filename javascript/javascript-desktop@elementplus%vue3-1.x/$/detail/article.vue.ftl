<#import "/$/modelbase.ftl" as modelbase>
<template>
  <div class="min-h-screen bg-gray-50">
    <main class="max-w-4xl mx-auto py-8 px-4 sm:px-6 lg:px-8">
      <div class="mb-8">
<#list obj.attributes as attr>  
  <#if modelbase.is_attribute_primary(attr)>          
        <h1 class="text-3xl font-bold text-gray-900 mb-2">{{ ${js.nameVariable(obj.name)}.${modelbase.get_attribute_sql_name(attr)} }}</h1>
  </#if>
</#list> 
<#list obj.attributes as attr>  
  <#if modelbase.is_attribute_date(attr)>          
        <p class="text-gray-600">{{ ${js.nameVariable(obj.name)}.${modelbase.get_attribute_sql_name(attr)} }}</p>
    <#break>    
  </#if>
</#list>
      </div>     
<#list obj.attributes as attr>  
  <#if modelbase.is_attribute_image(attr)>    
      <div class="mb-8">
        <img :src="${js.nameVariable(obj.name)}.${modelbase.get_attribute_sql_name(attr)}" class="w-full h-64 object-cover rounded-lg shadow-lg"/>
      </div>
  </#if>    
</#list>      
<#list obj.attributes as attr>  
  <#if !attr.isLabelled("section")><#continue></#if>
      <section class="mb-8">
        <h2 class="text-xl font-bold text-gray-900 mb-4">${modelbase.get_attribute_label(attr)}</h2>
        <p class="text-gray-700 leading-relaxed">{{ ${js.nameVariable(obj.name)}.${modelbase.get_attribute_sql_name(attr)} }}</p>
      </section>
</#list>       
<#list obj.attributes as attr>  
  <#if !attr.type.collection><#continue></#if>
  <#assign collObj = model.findObjectByName(attr.type.componentType.name)>
  <#assign collObjIdAttrs = modelbase.get_id_attributes(collObj)>
  <#list collObjIdAttrs as attr>
    <#if attr.type.name != obj.name>
      <#assign collObjIdAttr = attr>
      <#break>
    </#if>
  </#list>
      <section class="mb-8">
        <h2 class="text-xl font-bold text-gray-900 mb-6">Associated Training Drills</h2>
        <div class="space-y-6">
          <div 
            v-for="row in ${js.nameVariable(obj.name)}.${modelbase.get_attribute_sql_name(attr)}" 
            :key="row.${modelbase.get_attribute_sql_name(collObjIdAttr)}"
            class="flex items-start space-x-4 bg-white p-4 rounded-lg border border-gray-200">
            <div class="flex-shrink-0">
              <img 
                :src="drill.image" 
                :alt="drill.title"
                class="w-24 h-16 object-cover rounded"/>
            </div>
            <div class="flex-1">
              <div class="flex items-start justify-between">
                <div>
                  <h3 class="font-semibold text-gray-900">{{ drill.title }}</h3>
                  <p class="text-gray-600 text-sm mt-1">{{ drill.description }}</p>
                </div>
                <span class="text-xs text-gray-500 bg-gray-100 px-2 py-1 rounded">
                  Drill {{ drill.id }}
                </span>
              </div>
            </div>
          </div>
        </div>
      </section>
</#list>      
    </main>
  </div>
</template>
<#include "$script$.vue.ftl">
<style scoped>
/* Custom styles if needed */
</style>