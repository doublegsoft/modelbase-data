
<#assign entries = []>
<#list model.objects as obj>
  <#if !obj.isLabelled('desktop')><#continue></#if>
  <#list obj.attributes as attr>
    <#if attr.isLabelled('entry')>
      <#assign entries = entries + [attr]>
    </#if>
  </#list>
</#list>
{
  "home": {
    "text": "首页",
    "icon": "nav-icon icon-speedometer",
    "url": "javascript:ajax.view('home.html', 'container');"
  },
  "groups": [{
    "title": "其他",
    "menus": [{
      "text": "${app.name?upper_case}",
      "icon": "nav-icon fa fa-industry",
      "items": [{
<#list entries as entry>
  <#assign alias = entry.parent.getLabelledOptions('desktop')['alias']!entry.parent.name>
  <#assign pageType = typebase.customObjectType(entry.constraint.domainType.toString())>
  <#if entry?index != 0>
      }, {
  </#if>
        "text": "${pageType.getAttributeValue('title')!'TODO'}",
        "icon": "nav-icon fa fa-user",
        "url": "javascript:ajax.view({url: 'html/${app.name}/${alias}/${entry.name}.html', containerId: 'container'});"
</#list>        
      }]
    }]
  }]
}