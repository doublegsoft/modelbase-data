<#assign objname = pageOwner.module?substring(pageOwner.module?index_of('/') + 1)>
this.checktree${js.nameType(id)}.render('checktree${js.nameType(id)}', {
  selections: ${java.nameVariable(pageOwner.getOption('bound'))}Data ? ${java.nameVariable(pageOwner.getOption('bound'))}Data.${java.nameVariable(id)} : []
});