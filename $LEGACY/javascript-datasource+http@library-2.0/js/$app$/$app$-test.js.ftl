<#import '/$/modelbase.ftl' as modelbase>
<#import '/$/appbase.ftl' as appbase>

if (typeof ${app.name} === 'undefined')
  ${app.name} = {};

<#list model.objects as obj>
${app.name}.URL_${obj.name?upper_case}_FIND = '/api/v3/test/data/${app.name}/${obj.name}/find';
${app.name}.URL_${obj.name?upper_case}_PAGINATE = '/api/v3/test/data/${app.name}/${obj.name}/paginate';
${app.name}.URL_${obj.name?upper_case}_READ = '/api/v3/test/data/${app.name}/${obj.name}/read';
</#list>