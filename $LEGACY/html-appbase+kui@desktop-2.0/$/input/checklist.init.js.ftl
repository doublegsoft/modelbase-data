<#assign objname = pageOwner.module?substring(pageOwner.module?index_of('/') + 1)>
this.checklist${js.nameType(id)}.render('checklist${js.nameType(id)}', {
  selections: ${java.nameVariable(pageOwner.getOption('bound'))}Data ? ${java.nameVariable(pageOwner.getOption('bound'))}Data.${java.nameVariable(id)} : []
});