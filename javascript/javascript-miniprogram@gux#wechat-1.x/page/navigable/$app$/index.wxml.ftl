<#import "/$/modelbase.ftl" as modelbase>
<gx-navigation-bar id="navigationBar" title="页面索引" backable="{{false}}"/>
<view class="page navigable" style="top:{{top}}px;">  
<#list model.objects as obj>  
  <navigator bindtap="goto${js.nameType(obj.name)}" url="#" class="gx-tile gx-pl-20 gx-py-12 gx-fs-14" role="navigator">
    <text class="gx-tile-body">${modelbase.get_object_label(obj)}</text>
    <view class="gx-i gx-i-arrow-right gx-fs-16"></view>
  </navigator>
</#list>  
</view>