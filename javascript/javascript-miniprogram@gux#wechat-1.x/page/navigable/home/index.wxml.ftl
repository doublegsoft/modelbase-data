<#import "/$/modelbase.ftl" as modelbase>
<view class="page navigable">
<#list model.objects as obj>
  <#if obj.isLabelled("advertisable") && obj.getLabelledOptions("advertisable")["mode"] == "cyclenavigator">
    <#assign count = obj.getLabelledOptions("advertisable")["count"]!"5">
    <#assign imagePath = obj.getLabelledOptions("advertisable")["image"]!"image_path">
  <swiper class="swiper-container" autoplay="true" interval="3000" duration="500" circular="true">
    <swiper-item wx:for="{{top${count}${js.nameType(inflector.pluralize(obj.name))}}}" wx:key="index"
                 bind:tap="goto${js.nameType(obj.name)}Detail" data-${obj.name?replace("_","-")}="{{item}}">
      <image class="slide-advertisement" mode="scaleToFill" src="{{item.${js.nameVariable(imagePath)}}}" mode="aspectFill"></image>
    </swiper-item>
  </swiper>
  </#if>
</#list>
<#assign hasThemeable = false>  
<#list model.objects as obj>
  <#if obj.isLabelled("themeable")>
    <#assign hasThemeable = true>
    <#break>
  </#if>
</#list>  
<#if hasThemeable>
  <view class="square-menu">
  <#list model.objects as obj>
    <#if !obj.isLabelled("themeable")><#continue></#if>
    <#if obj.isLabelled("browsable")>
    <navigator url="/page/${app.name}/${modelbase.get_object_module(obj)}/${obj.name?replace("_","-")}-coll/index" class="entry btn" style="width: 24%;">
    <#elseif obj.isLabelled("listable")>
    <navigator url="/page/${app.name}/${modelbase.get_object_module(obj)}/${obj.name?replace("_","-")}-list/index" class="entry btn" style="width: 24%;">
    <#elseif obj.isLabelled("schedulable")>
    <navigator url="/page/${app.name}/${modelbase.get_object_module(obj)}/${obj.name?replace("_","-")}-daily/index" class="entry btn" style="width: 24%;">
    <#else>
    <navigator url="/page/${app.name}/${modelbase.get_object_module(obj)}/${obj.name?replace("_","-")}/index" class="entry btn" style="width: 24%;">
    </#if>
      <view class="d-flex flex-column">
        <text class="gx-i gx-i-home1 gx-m-auto gx-fs-28"></text>
        <view class="gx-fs-16 gx-mt-2">${modelbase.get_object_label(obj)}</view>
      </view>
    </navigator>
  </#list>
  </view>
</#if>  
<#list model.objects as obj>
  <#if obj.isLabelled("advertisable") && obj.getLabelledOptions("advertisable")["mode"] == "scrollnavigator">
    <#assign count = obj.getLabelledOptions("advertisable")["count"]!"5">
    <#assign imagePath = obj.getLabelledOptions("advertisable")["image"]!"image_path">
  <view class="gx-px-16 gx-my-16 gx-d-flex gx-lh-32">
    <view class="gx-fs-18 gx-fb">${modelbase.get_object_label(obj)}</view>
    <view class="gx-fs-12 gx-text-primary gx-ml-auto" bind:tap="goto${js.nameType(obj.name)}List">更多</view>
  </view>  
  <swiper autoplay="{{false}}" circular="true" display-multiple-items="3" style="height:120px;">
    <swiper-item wx:for="{{top${count}${js.nameType(inflector.pluralize(obj.name))}}}" wx:key="index"
                 bind:tap="goto${js.nameType(obj.name)}Detail" data-${obj.name?replace("_","-")}="{{item}}">
      <image class="slide-feature" mode="scaleToFill" src="{{item.${js.nameVariable(imagePath)}}}" mode="aspectFill"></image>
    </swiper-item>
  </swiper>
  </#if>
</#list>   
<#list model.objects as obj>
  <#if obj.isLabelled("browsable")>  
    <#assign idAttr = modelbase.get_id_attributes(obj)[0]>
    <#assign levelledAttrs = modelbase.level_object_attributes(obj)>
  <view class="gx-px-16 gx-my-16 gx-d-flex gx-lh-32">
    <view class="gx-fs-18 gx-fb">${modelbase.get_object_label(obj)}</view>
    <view class="gx-fs-12 gx-text-primary gx-ml-auto" bind:tap="goto${js.nameType(obj.name)}Coll">更多</view>
  </view> 
  <view wx:for="{{top4${js.nameType(inflector.pluralize(obj.name))}}}" wx:key="${modelbase.get_attribute_sql_name(idAttr)}" class="gx-d-flex gx-mb-16 gx-ml-16 gx-mr-16" 
        style="background:var(--color-surface-secondary); box-shadow: 2px 2px 0 var(--color-divider);padding:0;border-radius:10px;height: 135px;">
    <view class="gx-d-flex" 
          style="width:35%;height:100%;background:var(--color-surface);border-radius:10px 95px 0 10px;">
      <image src="{{item.<#if levelledAttrs["image"]?size == 0>notSet<#else>${modelbase.get_attribute_sql_name(levelledAttrs["image"][0])}</#if>}}" class="gx-m-auto"
             style="width:78px;height:78px;position:relative;bottom:-25rpx;border-radius: 9999px;"></image>
    </view>
    <view class="gx-ml-auto gx-d-flex gx-p-16" 
          style="width: 65%;flex-direction: column;justify-content:space-between;">
      <view>
        <view class="gx-fs-18 gx-fb" style="text-align: right;">{{item.<#if levelledAttrs["primary"]?size == 0>notSet<#else>${modelbase.get_attribute_sql_name(levelledAttrs["primary"][0])}</#if>}}</view>
        <view class="gx-fs-12 gx-mt-4 gx-text-secondary" style="text-align:right;">{{item.<#if levelledAttrs["secondary"]?size == 0>notSet<#else>${modelbase.get_attribute_sql_name(levelledAttrs["secondary"][0])}</#if>}}</view>
      </view>
      <button class="gx-b-round gx-fs-14 gx-mr-0 tile-button" 
              style="width: 120px;margin-right: 0;" data-${obj.name?replace("_","-")}="{{item}}"
              bind:tap="goto${js.nameType(obj.name)}Detail">查看详情</button>
    </view>
  </view>
  </#if>
</#list>  
</view>