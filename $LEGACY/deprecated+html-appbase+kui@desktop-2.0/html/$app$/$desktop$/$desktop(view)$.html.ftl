<#import '/$/modelbase.ftl' as modelbase>
<#import '/$/appbase.ftl' as appbase>
<#assign alias = desktop.getLabelledOptions('desktop')['alias']!desktop.name>
<#assign domainType = view.constraint.domainType.toString()>
<#assign pageType = typebase.customObjectType(domainType)>
<#assign pageStyle = pageType.getAttributeValue('style')!''>
<#assign widgetChildren = appbase.get_page_widgets(pageType.children)>
<div id="page${js.nameType(alias)}${js.nameType(view.name)}" class="page ${pageStyle}">
<#list pageType.children as child>
<@appbase.html_widget_layout indent=2 customObject=child />
</#list>
</div>
<script>
function Page${js.nameType(alias)}${js.nameType(view.name)}() {
  this.page = dom.find('#page${js.nameType(alias)}${js.nameType(view.name)}');
<#list widgetChildren as child>
<@appbase.js_widget_query indent=2 customObject=child pageStyle=pageType.getAttributeValue('style') />
</#list>
};

Page${js.nameType(alias)}${js.nameType(view.name)}.prototype.setup = function(params) {
  let self = this;
<#list widgetChildren as child>

<@appbase.js_widget_declare indent=2 customObject=child />
</#list>

<#if pageStyle == 'full'>
  dom.bind(this.page, 'click', function() {
    self.page.remove();
  });
</#if>
};

Page${js.nameType(alias)}${js.nameType(view.name)}.prototype.show = function(params) {
  this.setup(params);
};

page${js.nameType(alias)}${js.nameType(view.name)} = new Page${js.nameType(alias)}${js.nameType(view.name)}();
page${js.nameType(alias)}${js.nameType(view.name)}.show();
</script>