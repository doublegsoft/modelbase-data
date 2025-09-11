<#import "/$/modelbase.ftl" as modelbase>
<#assign hasThemeable = false>
<#list model.objects as obj>
  <#if obj.isLabelled("themeable")>
    <#assign hasThemeable = true>
  </#if>
</#list>
<template>
  <view class="content">
<#list model.objects as obj>
  <#if obj.isLabelled("advertisable") && obj.getLabelledOptions("advertisable")["mode"] == "cyclenavigator">
    <#assign count = obj.getLabelledOptions("advertisable")["count"]!"5">
    <#assign imagePath = obj.getLabelledOptions("advertisable")["image"]!"image_path">
    <swiper
      class="swiper"
      indicator-dots="true"
      autoplay="true"
      interval="3000"
      duration="500"
      circular="true">
      <swiper-item v-for="(item, index) in top${count}${js.nameType(inflector.pluralize(obj.name))}" :key="index" 
                   @tap="route.goto${js.nameType(obj.name)}Detail(item)">
        <image :src="item.${java.nameVariable(imagePath)}" mode="aspectFill" class="slide-image"/>
      </swiper-item>
    </swiper>
  </#if>
</#list> 
<#-- 应用程序存在主题入口 -->  
<#if hasThemeable>
    <div class="buttons-grid" style="margin: 10px;">
  <#list model.objects as obj>
    <#if obj.isLabelled("themeable")>
      <button class="btn-square" onclick="toggleSelected(this)">
        <span class="btn-icon">⭐</span>
        <span class="btn-label">${modelbase.get_object_label(obj)}</span>
      </button>
    </#if>
  </#list>  
    </div>
</#if>  
<#list model.objects as obj>
  <#if obj.isLabelled("advertisable") && obj.getLabelledOptions("advertisable")["mode"] == "scrollnavigator">
    <#assign count = obj.getLabelledOptions("advertisable")["count"]!"5">
    <#assign imagePath = obj.getLabelledOptions("advertisable")["image"]!"image_path">
    <view class="gx-px-16 gx-my-16 gx-d-flex gx-lh-32">
      <view class="gx-fs-16 gx-fb">${modelbase.get_object_label(obj)}</view>
      <view class="gx-fs-12 gx-text-primary gx-ml-auto" @tap="route.goto${js.nameType(obj.name)}List">更多</view>
    </view>
    <swiper class="swiper" circular="true" display-multiple-items="3" style="height:120px;">
      <swiper-item v-for="(item, index) in top${count}${js.nameType(inflector.pluralize(obj.name))}" :key="index"
                   @tap="route.goto${js.nameType(obj.name)}Detail(item)" style="height:120px;width:200px;padding:0 10px;">
        <image :src="item.${java.nameVariable(imagePath)}" mode="aspectFill" class="slide-image"/>
      </swiper-item>
    </swiper>
  </#if>
</#list>
<#list model.objects as obj>
  <#if obj.isLabelled("browsable")>
    <#assign idAttr = modelbase.get_id_attributes(obj)[0]>
    <#assign levelledAttrs = modelbase.level_object_attributes(obj)>
    <view class="gx-px-16 gx-my-16 gx-d-flex gx-lh-32">
      <view class="gx-fs-16 gx-fb">${modelbase.get_object_label(obj)}</view>
      <view class="gx-fs-12 gx-text-primary gx-ml-auto" @tap="route.goto${js.nameType(obj.name)}Coll">更多</view>
    </view>
    <view v-for="item in top4${js.nameType(inflector.pluralize(obj.name))}" :key="item.${modelbase.get_attribute_sql_name(idAttr)}" 
         @tap="route.goto${js.nameType(obj.name)}Detail(item)" class="gx-d-flex gx-py-8 gx-px-16 gx-bb-1" style="align-items: center;">
      <view class="gx-mr-8" style="width:72px;height:72px;">
   <#if (levelledAttrs["image"]?size > 0)>   
        <image :src="item.${modelbase.get_attribute_sql_name(levelledAttrs["image"][0])}" style="width:100%;height:100%;border-radius:10px;"></image>
   </#if>     
      </view>
      <view style="flex-grow: 1;">
        <view class="gx-fs-14">{{ item.<#if levelledAttrs["primary"]?size == 0>notSet<#else>${modelbase.get_attribute_sql_name(levelledAttrs["primary"][0])}</#if> }}</view>
        <text class="">{{ item.<#if levelledAttrs["secondary"]?size == 0>notSet<#else>${modelbase.get_attribute_sql_name(levelledAttrs["secondary"][0])}</#if> }}</text>
   <#if (levelledAttrs["tertiary"]?size > 0)>     
        <view class="text-muted gx-fs-13">
          <text class="">{{ item.${modelbase.get_attribute_sql_name(levelledAttrs["tertiary"][0])} }}</text>
        </view>
   </#if>   
      </view>
      <view class="text-end">
        <p class="fw-semibold mb-1">{{ item.<#if levelledAttrs["accent"]?size == 0>notSet<#else>${modelbase.get_attribute_sql_name(levelledAttrs["accent"][0])}</#if> }}</p>
      </view>
    </view>
  </#if>
  <#if obj.isLabelled("listable")>
    <#assign idAttr = modelbase.get_id_attributes(obj)[0]>
    <#assign levelledAttrs = modelbase.level_object_attributes(obj)>
    <view class="gx-px-16 gx-my-16 gx-d-flex gx-lh-32">
      <view class="gx-fs-16 gx-fb">${modelbase.get_object_label(obj)}</view>
      <view class="gx-fs-12 gx-text-primary gx-ml-auto" @tap="route.goto${js.nameType(obj.name)}List">更多</view>
    </view>
    <view v-for="item in top4${js.nameType(inflector.pluralize(obj.name))}" :key="item.${modelbase.get_attribute_sql_name(idAttr)}" 
         @tap="route.goto${js.nameType(obj.name)}Detail(item)" class="gx-d-flex gx-py-8 gx-px-16 gx-bb-1" style="align-items: center;">
      <view class="gx-mr-8" style="width:72px;height:72px;">
   <#if (levelledAttrs["image"]?size > 0)>   
        <image :src="item.${modelbase.get_attribute_sql_name(levelledAttrs["image"][0])}" style="width:100%;height:100%;border-radius:10px;"></image>
   </#if>     
      </view>
      <view style="flex-grow: 1;">
        <view class="gx-fs-14 gx-fb">{{ item.<#if levelledAttrs["primary"]?size == 0>notSet<#else>${modelbase.get_attribute_sql_name(levelledAttrs["primary"][0])}</#if> }}</view>
        <text class="">{{ item.<#if levelledAttrs["secondary"]?size == 0>notSet<#else>${modelbase.get_attribute_sql_name(levelledAttrs["secondary"][0])}</#if> }}</text>
   <#if (levelledAttrs["tertiary"]?size > 0)>     
        <view class="text-muted gx-fs-13">
          <text class="">{{ item.${modelbase.get_attribute_sql_name(levelledAttrs["tertiary"][0])} }}</text>
        </view>
   </#if>   
      </view>
      <view class="text-end">
        <p class="fw-semibold mb-1">{{ item.<#if levelledAttrs["accent"]?size == 0>notSet<#else>${modelbase.get_attribute_sql_name(levelledAttrs["accent"][0])}</#if> }}</p>
      </view>
    </view>
  </#if>
</#list>   
  </view>
</template>

<script>
const app = getApp();
import { sdk } from '@/sdk/sdk';
import * as route from '@/route';
import '@/app.css';

export default {
  data() {
    return {
      route: route,
<#list model.objects as obj>
  <#if obj.isLabelled("advertisable")>
    <#assign count = obj.getLabelledOptions("advertisable")["count"]!"5">
      top${count}${js.nameType(inflector.pluralize(obj.name))}: [],
  </#if>
  <#if obj.isLabelled("browsable")>
      top4${js.nameType(inflector.pluralize(obj.name))}: [],
  </#if>
</#list>    
    }
  },
  
  onLoad(options) {
<#list model.objects as obj>
  <#if obj.isLabelled("advertisable")>
    <#assign count = obj.getLabelledOptions("advertisable")["count"]!"5">
    this.fetchTop${count}${js.nameType(inflector.pluralize(obj.name))}();
  </#if>
  <#if obj.isLabelled("browsable")>
    this.fetchTop4${js.nameType(inflector.pluralize(obj.name))}();
  </#if>
</#list>
  },
  
  methods: {
<#list model.objects as obj>
  <#if obj.isLabelled("advertisable")>
    <#assign count = obj.getLabelledOptions("advertisable")["count"]!"5">
    <#assign imagePath = obj.getLabelledOptions("advertisable")["image"]!"image_path">
    
    async fetchTop${count}${js.nameType(inflector.pluralize(obj.name))}() {
      let page = await sdk.find${js.nameType(inflector.pluralize(obj.name))}({});
      let top${count} = [];
      for (let i = 0; i < page.data.length; i++) {
        if (top${count}.length >= ${count}) break;
        top${count}.push(page.data[i]);
      }
      this.top${count}${js.nameType(inflector.pluralize(obj.name))} = top${count};
    },
  </#if>
  <#if obj.isLabelled("browsable")>
    
    async fetchTop4${js.nameType(inflector.pluralize(obj.name))}() {
      let page = await sdk.find${js.nameType(inflector.pluralize(obj.name))}({});
      let top4 = [];
      for (let i = 0; i < page.data.length; i++) {
        if (top4.length >= 4) break;
        top4.push(page.data[i]);
      }
      this.top4${js.nameType(inflector.pluralize(obj.name))} = top4;
    },
  </#if>  
</#list>  
  },   
}
</script>

<style scoped>
.content {

}
.swiper {
  height: 200px;
}
.slide-image {
  width: 100%;
  height: 100%;
}
<#if hasThemeable>

.btn-square {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  background-color: white;
  border: none;
  border-radius: 8px;
  box-shadow: 0 2px 5px rgba(0,0,0,0.1);
  cursor: pointer;
  transition: all 0.2s ease;
  padding: 10px;
  text-align: center;
}

.btn-square:hover {
  background-color: #e6f2ff;
  transform: translateY(-2px);
}

.btn-square.selected {
  background-color: #2684ff;
  color: white;
}

.btn-icon {
  font-size: 24px;
}

.btn-label {
  font-size: 14px;
  font-weight: 500;
}

/* Single row layout */
.buttons-row {
  display: flex;
  overflow-x: auto;
  gap: 15px;
  padding-bottom: 15px;
  margin-bottom: 30px;
}

.buttons-row .btn-square {
  flex: 0 0 60px;
  height: 60px;
}

/* Multi-row grid layout */
.buttons-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 10px;
}

.buttons-grid .btn-square {
  aspect-ratio: 1/1;
  width: 100%;
}
</#if>
</style>