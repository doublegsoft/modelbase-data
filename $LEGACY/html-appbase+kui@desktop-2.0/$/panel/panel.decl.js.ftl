<#assign objname = pageOwner.module?substring(pageOwner.module?index_of('/') + 1)>
this.${js.nameVariable(id)} = $('#${js.nameVariable(id)}');
this.${js.nameVariable(id)?replace('widget', 'widgetBody')} = $('#${js.nameVariable(id)} div.card-body');