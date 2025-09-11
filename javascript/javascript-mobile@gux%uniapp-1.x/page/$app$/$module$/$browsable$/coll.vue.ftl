<#import "/$/modelbase.ftl" as modelbase>
<#assign obj = browsable>
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
                     scroll-y="true" class="products-grid">               
      <view class="product-card" 
            v-for="(item, index) in ${java.nameVariable(modelbase.get_object_plural(obj))}" 
            :key="index"
            @tap="route.goto${js.nameType(obj.name)}Detail(item)">
        <view class="product-image-container">
<#if (levelledAttrs["image"]?size > 0)>   
          <image :src="item.${modelbase.get_attribute_sql_name(levelledAttrs["image"][0])}" style="width:100%;height:100%;border-radius:10px;"></image>
</#if> 
        </view>
        <view class="product-info">
          <view class="gx-fs-14 gx-fb">{{ item.<#if levelledAttrs["primary"]?size == 0>notSet<#else>${modelbase.get_attribute_sql_name(levelledAttrs["primary"][0])}</#if> }}</view>
          <text class="">{{ item.<#if levelledAttrs["secondary"]?size == 0>notSet<#else>${modelbase.get_attribute_sql_name(levelledAttrs["secondary"][0])}</#if> }}</text>
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
  },
};
</script>

<style>
.container {
  display: flex;
  flex-direction: column;
  min-height: 100vh;
  background-color: #f5f7fa;
  position: relative;
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

.back-btn, .profile-btn {
  width: 60rpx;
  height: 60rpx;
  display: flex;
  align-items: center;
  justify-content: center;
}

.icon {
  font-family: 'uniicons';
}

.search-container {
  padding: 0 30rpx 20rpx;
}

.search-bar {
  background-color: #edf1f7;
  border-radius: 40rpx;
  padding: 20rpx 30rpx;
  display: flex;
  align-items: center;
}

.search-icon {
  margin-right: 20rpx;
  color: #8f9bb3;
}

.search-input {
  flex: 1;
  font-size: 28rpx;
  color: #2e3a59;
}

.products-grid {
  display: flex;
  flex-wrap: wrap;
  padding: 0 20rpx;
}

.product-card {
  width: calc(50% - 20rpx);
  padding: 20rpx;
  box-sizing: border-box;
}

.product-image-container {
  background-color: #ffffff;
  border-radius: 20rpx;
  overflow: hidden;
  height: 300rpx;
  display: flex;
  align-items: center;
  justify-content: center;
}

.product-image-placeholder {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 100%;
  height: 100%;
  background-color: #f8f8f8;
}

.image-placeholder-icon {
  font-size: 80rpx;
  color: #d3d3d3;
}

.product-info {
  padding: 20rpx 10rpx;
}

.product-price {
  font-size: 32rpx;
  font-weight: bold;
  color: #222b45;
}

.product-name {
  font-size: 26rpx;
  color: #8f9bb3;
  margin-top: 8rpx;
}
</style>