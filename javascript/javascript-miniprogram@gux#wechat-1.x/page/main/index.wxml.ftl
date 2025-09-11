<view>
  <gx-navigable-page id="nav-0" visible="{{activeIndex == 0}}">
    <page-home />
  </gx-navigable-page>
<#assign index = 1>  
<#list model.objects as obj>  
  <#if obj.isLabelled("navigable")>
  <gx-navigable-page id="nav-${index}" visible="{{activeIndex == 1}}">
    <page-${obj.name?replace("_","-")} id="page${js.nameType(obj.name)}" />
  </gx-navigable-page>
    <#assign index += 1>
  </#if>
</#list>  
  <gx-navigable-page id="nav-${index}" visible="{{activeIndex == 2}}">
    <page-user />
  </gx-navigable-page>
  <gx-tab-bar id="nav" navigators="{{entries}}" activeIndex="0"
   bind:active-changed="doTabBarActiveChanged" />
</view>
