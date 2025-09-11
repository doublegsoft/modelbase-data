<#import "/$/modelbase.ftl" as modelbase>
<#assign obj = listable>
<#assign idAttr = modelbase.get_id_attributes(obj)[0]>
<#assign levelledAttrs = modelbase.level_object_attributes(obj)>
<view class="page">
  <view style="position: fixed; top: -1px; padding: 8px;z-index: 999999; width: 100%; background-color: white;">
    <view class="search-bar">
      <icon type="search" color="#999" class="icon" />
      <input type="text" style="width: 200px;" placeholder-class="placeholder" placeholder="搜索" 
            bind:tap="gotoSearch" value="{{searchCriteria}}" disabled="true"/>
    </view>
  </view>
  <view class="gx-pos-relative" style="top: 56px;">
    <gx-list-vew id="list${js.nameType(obj.name)}" local="{{${js.nameVariable(inflector.pluralize(obj.name))}}}" height="{{viewHeight - 48}}" 
                 enableLoadMore="{{true}}" bind:doLoad="fetch${js.nameType(inflector.pluralize(obj.name))}">
      <view class="gx-d-flex align-items-center list-group-item gx-bl-0 gx-br-0 gx-bb-1" style="padding: 8px 16px;" 
            wx:for="{{${js.nameVariable(inflector.pluralize(obj.name))}}}" wx:key="${modelbase.get_attribute_sql_name(idAttr)}" wx:for-item="item">
<#if levelledAttrs["image"]?size != 0>          
        <image class="gx-wh-64 gx-mr-16" style="border-radius: 10px;" src="{{item.${modelbase.get_attribute_sql_name(levelledAttrs["image"][0])}}}" />
</#if>      
        <view class="pl-2" style="flex: 1; display: flex; flex-direction: column;">
<#if levelledAttrs["primary"]?size != 0>       
          <text class="gx-fs-15">{{item.${modelbase.get_attribute_sql_name(levelledAttrs["primary"][0])}}}</text>
</#if>        
<#if levelledAttrs["secondary"]?size != 0> 
          <view class="gx-fs-12 gx-text-secondary gx-mt-4">{{item.${modelbase.get_attribute_sql_name(levelledAttrs["secondary"][0])}}}</view>
</#if>        
        </view>
<#if levelledAttrs["accent"]?size != 0>       
        <view class="ms-auto gx-color-error gx-fb">{{item.${modelbase.get_attribute_sql_name(levelledAttrs["accent"][0])}}}</view>
</#if>      
      </view>
    </gx-list-vew>
  </view>
</view>