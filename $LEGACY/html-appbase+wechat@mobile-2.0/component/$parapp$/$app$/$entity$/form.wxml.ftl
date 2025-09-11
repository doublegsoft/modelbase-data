<#import '/$/modelbase.ftl' as modelbase>
<#assign attrId = modelbase.get_id_attributes(entity)[0]>
<mp-form id="{{formId}}" rules="{{rules}}" models="{{formData}}">
  <mp-cells title="${modelbase.get_object_label(entity)}" footer="">
<#list entity.attributes as attr>
  <#if attr.constraint.identifiable><#continue></#if>
  <#if attr.type.collection><#continue></#if>
  <#if modelbase.is_attribute_system(attr)><#continue></#if>
  <#if attr.type.custom>
    <#assign refObj = model.findObjectByName(attr.type.name)>
    <mp-cell has-header="{{false}}" ext-class="weui-cell_select">
      <picker bindchange="" value="{{${js.nameVariable(attr.name)}Index}}" range="{{${js.nameVariable(modelbase.get_object_plural(refObj))}}}">
        <view class="weui-select">{{${js.nameVariable(modelbase.get_object_plural(entity))}[${js.nameVariable(attr.name)}Index]}}</view>
      </picker>
    </mp-cell>
  <#elseif attr.constraint.domainType.name?index_of('enum') == 0>
    <mp-cell title="${modelbase.get_attribute_label(attr)}" ext-class="">
      <picker mode="selector" value="{{${modelbase.get_attribute_sql_name(attr)}Text}}" range-key="text" range="{{${attr.name?upper_case}_VALUES}}"
              bindchange="onChange${js.nameType(modelbase.get_attribute_sql_name(attr))}">
        <view class="weui-input">{{${modelbase.get_attribute_sql_name(attr)}Text}}</view>
      </picker>
    </mp-cell>
  <#elseif attr.type.name == 'date' || attr.type.name == 'datetime'>
    <mp-cell prop="date" title="${modelbase.get_attribute_label(attr)}" ext-class="">
      <picker data-field="date" mode="date" value="{{${modelbase.get_attribute_sql_name(attr)}}}" 
              bindchange="onChange${js.nameType(modelbase.get_attribute_sql_name(attr))}">
        <view class="weui-input">{{${modelbase.get_attribute_sql_name(attr)}}}</view>
      </picker>
    </mp-cell>
  <#elseif attr.type.name == 'text' || (attr.type.name == 'string' && attr.type.length >=  100)>
    <mp-cell has-header="{{false}}" has-footer="{{false}}" title="" ext-class="">
      <textarea class="weui-textarea" placeholder="${modelbase.get_attribute_label(attr)}" style="height: 3.3em" />
      <!--view class="weui-textarea-counter">0/200</view-->
    </mp-cell>
  <#elseif attr.type.name == 'integer'>
     <mp-cell prop="${modelbase.get_attribute_sql_name(attr)}" title="${modelbase.get_attribute_label(attr)}" ext-class="">
      <input bindinput="" data-field="${modelbase.get_attribute_sql_name(attr)}" class="weui-input" type="number"/>
    </mp-cell>
  <#elseif attr.type.name == 'number'>
     <mp-cell prop="${modelbase.get_attribute_sql_name(attr)}" title="${modelbase.get_attribute_label(attr)}" ext-class="">
      <input bindinput="" data-field="${modelbase.get_attribute_sql_name(attr)}" class="weui-input" type="digit"/>
    </mp-cell>
  <#else> 
    <mp-cell prop="${modelbase.get_attribute_sql_name(attr)}" title="${modelbase.get_attribute_label(attr)}" ext-class="">
      <input bindinput="" data-field="${modelbase.get_attribute_sql_name(attr)}" class="weui-input" placeholder=""/>
    </mp-cell>
  </#if>
</#list>
  </mp-cells>
</mp-form>