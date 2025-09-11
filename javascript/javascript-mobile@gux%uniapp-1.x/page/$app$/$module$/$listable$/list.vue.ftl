<#import "/$/modelbase.ftl" as modelbase>
<#assign obj = listable>
<#assign levelledAttrs = modelbase.level_object_attributes(obj)>
<template>
  <view class="container">
<#if obj.isLabelled("searchable")>     
    <view class="header"  @tap="route.goto${js.nameType(obj.name)}Search(doSearch)">
      <view><input placeholder="搜索关键字" disabled /></view>
      <view class="search-btn">
        <view class="gx-i gx-i-search" />
      </view>      
    </view>  
</#if>     
    <uni-scroll-view refresher-enabled="true"
                     @refresherpulling="doSearch"
                     @refresherrefresh="refresherrefresh"
                     scroll-y="true">
      <view v-for="(item, index) in ${java.nameVariable(modelbase.get_object_plural(obj))}" :key="index"
            @tap="route.goto${js.nameType(obj.name)}Detail(item)" 
            class="gx-d-flex gx-py-8 gx-px-16 gx-bb-1" style="align-items: center;">
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
    </uni-scroll-view>
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
      params: {},
      ${java.nameVariable(modelbase.get_object_plural(obj))}: [],
    };
  },
  
  onLoad(params) {
    this.params = params || {};
    this.fetch${java.nameType(modelbase.get_object_plural(obj))}();
  },
  
  onPullDownRefresh() {
    this.doSearch(this.params);
  },
  
  onReachBottom() {
    this.fetch${java.nameType(modelbase.get_object_plural(obj))}();
  },
  
  methods: {
    
    doSearch(params) {
      this.params = params || {};
      this.${java.nameVariable(modelbase.get_object_plural(obj))} = [];
      this.fetch${java.nameType(modelbase.get_object_plural(obj))}();
    },
    
    /*!
    ** 获取【${modelbase.get_object_label(obj)}】数据。
    */
    async fetch${java.nameType(modelbase.get_object_plural(obj))}() {
      let start = this.${java.nameVariable(modelbase.get_object_plural(obj))}.length;
      let res = await sdk.find${java.nameType(modelbase.get_object_plural(obj))}({
        ...this.params,
        start: start,
        limit: 10,
      });
      this.${java.nameVariable(modelbase.get_object_plural(obj))}.push(...res.data);
    },
  }
};
</script>

<style>
.container {
  padding: 0;
  background-color: #f0f0f0;
  min-height: 100vh;
}

.header {
  position: sticky;
  top: 42px;
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 20rpx 30rpx;
  background-color: #ffffff;
  z-index: 1;
}

.back-btn, .search-btn {
  width: 80rpx;
  text-align: center;
}

.icon {
  font-size: 40rpx;
}
</style>