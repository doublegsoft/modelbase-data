<#import '/$/modelbase.ftl' as modelbase>
<#assign attrId = modelbase.get_id_attributes(entity)[0]>
<#assign attrPrimary = modelbase.get_object_primary(entity)!''>
<#assign attrSecondary = modelbase.get_object_secondary(entity)!''>
<#assign attrTertiary = modelbase.get_object_tertiary(entity)!''>
<#assign attrImage = modelbase.get_object_image(entity)!''>
<recycle-view batch="{{batchSetRecycleData}}" id="list${js.nameType(entity.name)}"
              bindscrolltolower="load" bindscrolltoupper="reload">
  <recycle-item wx:for="{{${js.nameVariable(modelbase.get_object_plural(entity))}}}" wx:key="${modelbase.get_attribute_sql_name(attrId)}" style="width: 100%;">
    <navigator url='form?${modelbase.get_attribute_sql_name(attrId)}={{item.${modelbase.get_attribute_sql_name(attrId)}}}'>
      <view class='item'>
        <image class='poster' src='<#if attrImage != ''>{{item.${modelbase.get_attribute_sql_name(attrImage)}}}<#else>https://via.placeholder.com/128</#if>'></image>
        <view class='meta'>
          <text class='title'><#if attrPrimary != ''>{{item.${modelbase.get_attribute_sql_name(attrPrimary)}}}<#else>{{item.primary}}</#if></text>
          <text class='sub-title'><#if attrSecondary != ''>{{item.${modelbase.get_attribute_sql_name(attrSecondary)}}}<#else>{{item.secondary}}</#if></text>
          <view class='rating'>
            <text><#if attrTertiary != ''>{{item.${modelbase.get_attribute_sql_name(attrTertiary)}}}<#else>{{item.tertiary}}</#if></text>
          </view>
        </view>
      </view>
    </navigator>
  </recycle-item>
</recycle-view>
