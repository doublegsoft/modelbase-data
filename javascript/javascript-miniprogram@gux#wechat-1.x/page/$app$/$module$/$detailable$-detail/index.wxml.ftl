<#import "/$/modelbase.ftl" as modelbase>
<#import "/$/modelbase4js.ftl" as modelbase4js>
<#assign obj = detailable>
<#assign idAttr = modelbase.get_id_attributes(obj)[0]>
<#assign levelledAttrs = modelbase.level_object_attributes(obj)>
<view class="container">
  <view class="gx-pos-top" style="top: {{topOfBack}}px; left: 8px; z-index: 9999;">
    <view class="gx-b-round gx-b-1 gx-d-flex" bind:tap="doNavigateBack" style="height: 32px; width: 32px;">
      <text class="gx-i gx-i-arrow-left  gx-fs-20 gx-m-auto"></text>
    </view>
  </view>
<#if levelledAttrs["image"]?size != 0>
  <image class="product-image" src="{{${js.nameVariable(obj.name)}.${modelbase.get_attribute_sql_name(levelledAttrs["image"][0])}}}" mode="aspectFill" />
</#if>  

  <view class="price-section">
<#if levelledAttrs["primary"]?size != 0>  
    <text class="price">{{${js.nameVariable(obj.name)}.${modelbase.get_attribute_sql_name(levelledAttrs["primary"][0])}}}</text>
</#if>    
<#if levelledAttrs["secondary"]?size != 0>  
    <text class="description">{{${js.nameVariable(obj.name)}.${modelbase.get_attribute_sql_name(levelledAttrs["secondary"][0])}}}</text>
</#if>    
  </view>
  <view class="variations">
    <text class="section-title">Variations</text>
    <scroll-view scroll-x class="variation-scroll">
      <view class="variation-items">
        <view class="variation-item" wx:for="{{productInfo.variations}}" wx:key="index">
          <image src="{{item.image}}" mode="aspectFill"/>
        </view>
      </view>
    </scroll-view>
  </view>

  <!-- 规格信息 -->
  <view class="specifications">
    <text class="section-title">Specifications</text>
    <view class="spec-item">
      <text class="spec-label">Material</text>
      <text class="spec-value">{{productInfo.material}}</text>
    </view>
    <view class="spec-item">
      <text class="spec-label">Origin</text>
      <text class="spec-value">{{productInfo.origin}}</text>
    </view>
  </view>

  <!-- 配送选项 -->
  <view class="delivery">
    <text class="section-title">Delivery</text>
    <view class="delivery-options">
      <view class="delivery-option {{selectedDelivery === 'standard' ? 'selected' : ''}}" bindtap="selectDelivery" data-type="standard">
        <view class="option-info">
          <text class="option-name">Standard</text>
          <text class="option-time">5-7 days</text>
        </view>
        <text class="option-price">$3.00</text>
      </view>
      <view class="delivery-option {{selectedDelivery === 'express' ? 'selected' : ''}}" bindtap="selectDelivery" data-type="express">
        <view class="option-info">
          <text class="option-name">Express</text>
          <text class="option-time">1-2 days</text>
        </view>
        <text class="option-price">$12.00</text>
      </view>
    </view>
  </view>
<#-- 评论部分内容 -->  
<#if obj.isLabelled("commentable")> 
</#if>
<#-- 底部的固定栏位可能展示位 -->  
<#if obj.isLabelled("purchasable")>
  <view class="bottom-bar" style="bottom: 24px;">
    <view class="cart-btn" bind:tap="doAddToCart">加入购物车</view>
    <view class="buy-btn" bind:tap="doPurchase">直接购买</view>
  </view>  
<#elseif obj.isLabelled("commentable")>  
  <view class="bottom-bar gx-d-flex" style="padding: 8px 16px; bottom: 20px;">
    <view class="gx-fs-15 gx-py-4 gx-px-8" style="width: 33%;background-color: #CDCDCD; color: white;">发表评论</view>
    <view class="gx-d-flex" style="flex: 1">
      <view class="gx-i gx-i-heart gx-fs-24 gx-m-auto" bind:tap="doLikeIt"></view>
    </view>
    <view class="gx-d-flex" style="flex: 1">
      <view class="gx-i gx-i-star gx-fs-24 gx-m-auto" bind:tap="doAddToFavourite"></view>
    </view>
    <view class="gx-d-flex" style="flex: 1">
      <view class="gx-i gx-i-transfer gx-fs-24 gx-m-auto" bind:tap="doRetweet"></view>
    </view>
  </view>
</#if>  
</view>