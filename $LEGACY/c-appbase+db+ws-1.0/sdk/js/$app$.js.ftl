<#import '/$/modelbase.ftl' as modelbase>
<#import '/$/appbase.ftl' as appbase>
<#if license??>
${js.license(license)}
</#if>

if (typeof ${namespace} == 'undefined') 
  ${namespace} = {};

${namespace}.OP_ERROR = 'error';
<#list model.objects as obj>
  <#if !obj.isLabelled("request")><#continue></#if>
${namespace}.OP_${obj.name?replace('_request', '')?upper_case} = '${js.nameVariable(obj.name?replace('_request', ''))}';
</#list>  

${namespace}.init = () => {
  ${namespace}.ws = new WebSocket('wss://${namespace}.cq-fyy.com');
  ${namespace}.handlers = {};
  ${namespace}.ws.onmessge = (event) => {
    let data = event.data;
    let op = data.op;
<#list model.objects as obj>
  <#if !obj.isLabelled("request")><#continue></#if>
    if (op == ${namespace}.OP_${obj.name?replace('_request', '')?upper_case}) {
      ${namespace}.handlers[op](data.data, data.error);
    }
</#list>  
  };
};

<#list model.objects as obj>
  <#if !obj.isLabelled("request")><#continue></#if>
${namespace}.${js.nameVariable(obj.name?replace('_request', ''))} = async (params) => {
  let req = {
    operation: '${js.nameVariable(obj.name?replace('_request', ''))}',
    payload: {
  <#list obj.attributes as attr>
      ${js.nameVariable(attr.name)}: params.${js.nameVariable(attr.name)},
  </#list>      
    }
  };
  ${namespace}.send(JSON.stringify(req));
};

</#list>
