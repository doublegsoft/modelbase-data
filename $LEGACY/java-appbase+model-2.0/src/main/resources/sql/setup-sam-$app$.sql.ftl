<#import '/$/modelbase.ftl' as modelbase>

<#assign index = 0>
<#assign funid = statics["java.util.UUID"].randomUUID()?string?upper_case>
<#assign rootfunid = funid>
insert into tn_sam_fun (funid, parfunid, funnm, funtyp, ico, entpt, ordpos)
values ('${rootfunid}', null, '${description}', 'G', null, null, ${index});
<#list model.objects as obj>
  <#if !obj.isLabelled('entity') || obj.isLabelled('generated')><#continue></#if>

  <#assign index = index + 1>
  <#assign funid = statics["java.util.UUID"].randomUUID()?string?upper_case>
insert into tn_sam_fun (funid, parfunid, funnm, funtyp, ico, entpt, ordpos)
values ('${funid}', '${rootfunid}', '${modelbase.get_object_label(obj)}', 'E', null, 'html/stdbiz/${app.name}/${obj.name}/main.html', ${index});
  <#assign parfunid = funid>
  <#assign funid = statics["java.util.UUID"].randomUUID()?string?upper_case>
insert into tn_sam_fun (funid, parfunid, funnm, funtyp, ico, entpt, ordpos)
values ('${funid}', '${parfunid}', '修改', 'T', null, null, 0);
  <#assign funid = statics["java.util.UUID"].randomUUID()?string?upper_case>
insert into tn_sam_fun (funid, parfunid, funnm, funtyp, ico, entpt, ordpos)
values ('${funid}', '${parfunid}', '删除', 'T', null, null, 0);
  <#assign funid = statics["java.util.UUID"].randomUUID()?string?upper_case>
insert into tn_sam_fun (funid, parfunid, funnm, funtyp, ico, entpt, ordpos)
values ('${funid}', '${parfunid}', '查看', 'T', null, null, 0);
</#list>

<#assign index = 0>
<#list model.objects as obj>
  <#if !obj.isLabelled('entity') || obj.isLabelled('generated')><#continue></#if>
  <#assign index = index + 1>
  <#assign attrId = modelbase.get_id_attributes(obj)[0]>
  <#assign entyid = statics["java.util.UUID"].randomUUID()?string?upper_case>

insert into tn_sam_auth (authid, authnm, authtyp, reftyp, refid, crtrtyp, crtrid, sta, srp, opt)
values ('${obj.name?upper_case}.GROUP', '集团数据', 'G', 'STDBIZ.SAM.MANAGED_ENTITY', '${obj.name?upper_case}', 'STDBIZ', 'STDBIZ', 'E', '
', '
{
  "viewable": "T",
  "appendable": "F",
  "editable": "F",
  "removable": "F"
}
');

insert into tn_sam_auth (authid, authnm, authtyp, reftyp, refid, crtrtyp, crtrid, sta, srp, opt)
values ('${obj.name?upper_case}.COMPANY', '公司数据', 'C', 'STDBIZ.SAM.MANAGED_ENTITY', '${obj.name?upper_case}', 'STDBIZ', 'STDBIZ', 'E', '
', '
{
  "viewable": "T",
  "appendable": "F",
  "editable": "F",
  "removable": "F"
}
');

insert into tn_sam_auth (authid, authnm, authtyp, reftyp, refid, crtrtyp, crtrid, sta, srp, opt)
values ('${obj.name?upper_case}.DEPARTMENT', '部门数据', 'D', 'STDBIZ.SAM.MANAGED_ENTITY', '${obj.name?upper_case}', 'STDBIZ', 'STDBIZ', 'E', '
', '
{
  "viewable": "T",
  "appendable": "F",
  "editable": "F",
  "removable": "F"
}
');

insert into tn_sam_auth (authid, authnm, authtyp, reftyp, refid, crtrtyp, crtrid, sta, srp, opt)
values ('${obj.name?upper_case}.TEAM', '小组数据', 'T', 'STDBIZ.SAM.MANAGED_ENTITY', '${obj.name?upper_case}', 'STDBIZ', 'STDBIZ', 'E', '
', '
{
  "viewable": "T",
  "appendable": "F",
  "editable": "F",
  "removable": "F"
}
');

insert into tn_sam_auth (authid, authnm, authtyp, reftyp, refid, crtrtyp, crtrid, sta, srp, opt)
values ('${obj.name?upper_case}.PERSONAL', '个人数据', 'P', 'STDBIZ.SAM.MANAGED_ENTITY', '${obj.name?upper_case}', 'STDBIZ', 'STDBIZ', 'E', '
', '
{
  "viewable": "T",
  "appendable": "T",
  "editable": "T",
  "removable": "T"
}
');

insert into tn_sam_mngdenty (mngdentyid, mngdentynm, mngdentytyp, selsql, sts, sta)
values ('${obj.name?upper_case}', '${modelbase.get_object_label(obj)}', 'BIZ', '
${r'<#if user.employee.leader>'}
crtr in (
    with recursive dpt (dptid, dptnm, pardptid, emplid) as (
    select     dpt.dptid,
               dptnm,
               pardptid,
               emplid
    from       tn_oms_dpt dpt
    left join tx_oms_dptempl dptempl on dptempl.dptid = dpt.dptid
    where      dpt.dptid in (select dptid from tx_oms_dptempl where emplid = ${r'${user.id}'})
    union all
    select     pardpt.dptid,
               pardpt.dptnm,
               pardpt.pardptid,
               dptempl.emplid
    from       tn_oms_dpt pardpt
    left join tx_oms_dptempl dptempl on pardpt.dptid = dptempl.dptid
    inner join dpt
            on pardpt.pardptid = dpt.dptid
  )
  select distinct * from dpt
)
${r'<#else>'}
crtr = ${r'${user.id}'}
${r'</#if>'}
', '99', 'E');
  <#list obj.attributes as attr>

insert into tn_sam_mngdentyfld (mngdentyfldid, mngdentyid, mngdentyfldnm, mngdentyfldtyp, refid, reftyp, ordpos, sts, sta)
values ('${obj.name?upper_case}:${attr.name?upper_case}', '${obj.name?upper_case}', '${modelbase.get_attribute_label(attr)}', 'BIZ', '${obj.name?upper_case}:${attr.name?upper_case}', 'STDBIZ.DMM.COLUMN', ${attr?index + 1}, '99', 'E');
  </#list>
</#list>