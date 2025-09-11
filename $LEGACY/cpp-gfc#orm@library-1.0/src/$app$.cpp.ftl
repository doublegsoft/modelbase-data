<#if license??>
${c.license(license)}
</#if>

namespace ${app.name}
{

<#list model.objects as obj>
class ${cpp.nameType(obj.name)}
{
  private: 
}

</#list>
}