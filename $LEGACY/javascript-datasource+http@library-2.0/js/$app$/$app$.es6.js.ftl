<#import '/$/modelbase.ftl' as modelbase>
<#import '/$/appbase.ftl' as appbase>
const { stdbiz } = require('../stdbiz');
const { xhr } = require('../xhr');

<@appbase.print_sdk_remote/>

module.exports = { ${parentApplication} };
