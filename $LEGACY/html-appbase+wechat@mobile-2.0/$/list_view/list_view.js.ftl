<#import '/$/modelbase.ftl' as modelbase>

<#macro print_imports_of_list_view obj indent>
${''?left_pad(indent)}const createRecycleContext = require('miniprogram-recycle-view')
</#macro>

<#macro print_members_of_list_view obj indent>
${''?left_pad(indent)}/**
${''?left_pad(indent)} * ${js.nameType(obj.name)} objects.
${''?left_pad(indent)} */
${''?left_pad(indent)}${js.nameVariable(modelbase.get_object_plural(obj))}: []
</#macro>

<#macro print_methods_of_list_view obj indent>
${''?left_pad(indent)}/*
${''?left_pad(indent)}** 根据条件搜索列表。
${''?left_pad(indent)}*/
${''?left_pad(indent)}search: async function(params) {
${''?left_pad(indent)}  const ctx = createRecycleContext({
${''?left_pad(indent)}    id: 'recycle${js.nameVariable(modelbase.get_object_plural(obj))}',
${''?left_pad(indent)}    dataKey: '${js.nameVariable(modelbase.get_object_plural(obj))}',
${''?left_pad(indent)}    page: this,
${''?left_pad(indent)}    itemSize: {
${''?left_pad(indent)}      height: (32 / 750) * wx.getSystemInfoSync().windowWidth,
${''?left_pad(indent)}      width: '100%'
${''?left_pad(indent)}    }
${''?left_pad(indent)}  })
${''?left_pad(indent)}
${''?left_pad(indent)}  this.start = 0;
${''?left_pad(indent)}  params = params || {};
${''?left_pad(indent)}  params.start = this.start;
${''?left_pad(indent)}  this.params = params;
${''?left_pad(indent)}  this.${js.nameVariable(modelbase.get_object_plural(obj))} = [];
${''?left_pad(indent)}
${''?left_pad(indent)}  let resp = await stdbiz.pcm.findPatients();
${''?left_pad(indent)}  this.${js.nameVariable(modelbase.get_object_plural(obj))} = this.${js.nameVariable(modelbase.get_object_plural(obj))}.concat(resp.data)
${''?left_pad(indent)}  ctx.append(this.${js.nameVariable(modelbase.get_object_plural(obj))});
${''?left_pad(indent)}},
${''?left_pad(indent)}
${''?left_pad(indent)}/*
${''?left_pad(indent)}** 根据条件搜索列表。
${''?left_pad(indent)}*/
${''?left_pad(indent)}append: async function() {
${''?left_pad(indent)}  this.start += this.limit;
${''?left_pad(indent)}  this.params.start = this.start;
${''?left_pad(indent)}  let data = await stdbiz.emr.findGestationParturitions(this.params);
${''?left_pad(indent)}  this.setData({
    ${''?left_pad(indent)}${js.nameVariable(modelbase.get_object_plural(obj))}: this.${js.nameVariable(modelbase.get_object_plural(obj))}.concat(data)
${''?left_pad(indent)}  })
${''?left_pad(indent)}}
</#macro>