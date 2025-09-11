<#import '/$/modelbase.ftl' as modelbase>
<#import '/$/appbase.ftl' as appbase>
if (typeof ${parentApplication} === 'undefined') ${parentApplication} = {};
if (typeof ${parentApplication}.${app.name} === 'undefined') ${parentApplication}.${app.name} = {};

<@appbase.print_sdk_remote/>
