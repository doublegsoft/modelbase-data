<#import '/$/modelbase.ftl' as modelbase>
<view class="page__bd">
  <mp-cells ext-class="my-cells" title="">
<#list entity.attributes as attr>
  <#if attr.constraint.identifiable><#continue></#if>
  <#if attr.type.collection><#continue></#if>
  <#if modelbase.is_attribute_system(attr)><#continue></#if>
    <mp-cell value="${modelbase.get_attribute_label(attr)}" footer="{{${modelbase.get_attribute_sql_name(attr)}}}"></mp-cell>
</#list>
  </mp-cells>
</view>