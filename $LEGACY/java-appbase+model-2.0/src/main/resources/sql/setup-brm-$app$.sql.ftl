<#import '/$/modelbase.ftl' as modelbase>

<#list model.objects as obj>
  <#if !obj.persistenceName?? || obj.isLabelled('generated')><#continue></#if>
  <#assign attrIds = modelbase.get_id_attributes(obj)>
  <#assign label = modelbase.get_object_label(obj)!''>
  <#if obj.isLabelled('entity')>
insert into tn_brm_bizproc (bizprocid, bizproccd, bizprocnm, bizproctyp, param, srp, nt, sta, lmt)
values ('STDBIZ/${app.name?upper_case}/${obj.name?upper_case}/SAVE', 'STDBIZ/${app.name?upper_case}/${obj.name?upper_case}/SAVE', 
        '保存【${label}】实体对象', 'SV', '{
    <#list obj.attributes as attr>
      <#if attr.type.collection>
  "${modelbase.get_attribute_sql_name(attr)}":[]<#if attr?index != obj.attributes?size - 1>,</#if>
      <#else>
  "${modelbase.get_attribute_sql_name(attr)}":"${r'${'}${modelbase.get_attribute_sql_name(attr)}${r"!''''}"}"<#if attr?index != obj.attributes?size - 1>,</#if>  
      </#if>
    </#list>      
}', 'stdbiz/${app.name}/${obj.name}/save', null, 'E', current_timestamp);

insert into tn_brm_bizproc (bizprocid, bizproccd, bizprocnm, bizproctyp, param, srp, nt, sta, lmt)
values ('STDBIZ/${app.name?upper_case}/${obj.name?upper_case}/READ', 'STDBIZ/${app.name?upper_case}/${obj.name?upper_case}/READ', 
        '读取【${label}】实体对象', 'RD', '{
    <#list attrIds as attrId>
  "${modelbase.get_attribute_sql_name(attrId)}":"${r'${'}${modelbase.get_attribute_sql_name(attrId)}${r"!''''}"}"<#if attrId?index != attrIds?size - 1>,</#if>    
    </#list>      
}', 'stdbiz/${app.name}/${obj.name}/read', null, 'E', current_timestamp);

insert into tn_brm_bizproc (bizprocid, bizproccd, bizprocnm, bizproctyp, param, srp, nt, sta, lmt)
values ('STDBIZ/${app.name?upper_case}/${obj.name?upper_case}/MERGE', 'STDBIZ/${app.name?upper_case}/${obj.name?upper_case}/MERGE', 
        '合并【${label}】实体对象', 'MG', '{
    <#list obj.attributes as attr>
      <#if attr.type.collection>
  "${modelbase.get_attribute_sql_name(attr)}":[]<#if attr?index != obj.attributes?size - 1>,</#if>
      <#else>
  "${modelbase.get_attribute_sql_name(attr)}":"${r'${'}${modelbase.get_attribute_sql_name(attr)}${r"!''''}"}"<#if attr?index != obj.attributes?size - 1>,</#if>  
      </#if>
    </#list>    
}', 'stdbiz/${app.name}/${obj.name}/merge', null, 'E', current_timestamp);

insert into tn_brm_bizproc (bizprocid, bizproccd, bizprocnm, bizproctyp, param, srp, nt, sta, lmt)
values ('STDBIZ/${app.name?upper_case}/${obj.name?upper_case}/DELETE', 'STDBIZ/${app.name?upper_case}/${obj.name?upper_case}/DELETE', 
        '删除【${label}】实体对象', 'DL', '{
    <#list attrIds as attrId>
  "${modelbase.get_attribute_sql_name(attrId)}":"${r'${'}${modelbase.get_attribute_sql_name(attrId)}${r"!''''}"}"<#if attrId?index != attrIds?size - 1>,</#if>    
    </#list>
}', 'stdbiz/${app.name}/${obj.name}/delete', null, 'E', current_timestamp);

insert into tn_brm_bizproc (bizprocid, bizproccd, bizprocnm, bizproctyp, param, srp, nt, sta, lmt)
values ('STDBIZ/${app.name?upper_case}/${obj.name?upper_case}/FIND', 'STDBIZ/${app.name?upper_case}/${obj.name?upper_case}/FIND', 
        '查询【${label}】实体对象', 'FD', '{
  "otherSelects":"",
  "leftJoins":"",
  "andConditions":"",
  "orderBy":""
}', 'stdbiz/${app.name}/${obj.name}/find', null, 'E', current_timestamp);

insert into tn_brm_bizproc (bizprocid, bizproccd, bizprocnm, bizproctyp, param, srp, nt, sta, lmt)
values ('STDBIZ/${app.name?upper_case}/${obj.name?upper_case}/PAGINATE', 'STDBIZ/${app.name?upper_case}/${obj.name?upper_case}/PAGINATE', 
        '分页【${label}】实体对象', 'PG', '{
  "otherSelects":"",
  "leftJoins":"",
  "andConditions":"",
  "orderBy":""      
}', 'stdbiz/${app.name}/${obj.name}/paginate', null, 'E', current_timestamp);

insert into tn_brm_bizproc (bizprocid, bizproccd, bizprocnm, bizproctyp, param, srp, nt, sta, lmt)
values ('STDBIZ/${app.name?upper_case}/${obj.name?upper_case}/TREERIZE', 'STDBIZ/${app.name?upper_case}/${obj.name?upper_case}/TREERIZE', 
        '树化【${label}】实体对象', 'TR', '{
  "otherSelects":"",
  "leftJoins":"",
  "andConditions":"",
  "orderBy":""
}', 'stdbiz/${app.name}/${obj.name}/treerize', null, 'E', current_timestamp);

insert into tn_brm_bizproc (bizprocid, bizproccd, bizprocnm, bizproctyp, param, srp, nt, sta, lmt)
values ('STDBIZ/${app.name?upper_case}/${obj.name?upper_case}/AGGREGATE', 'STDBIZ/${app.name?upper_case}/${obj.name?upper_case}/AGGREGATE', 
        '运算【${label}】实体对象', 'AG', '{
  "otherSelects":"",
  "leftJoins":"",
  "andConditions":"",
  "orderBy":"" 
}', 'stdbiz/${app.name}/${obj.name}/aggregate', null, 'E', current_timestamp);

  <#elseif obj.isLabelled('value')>
insert into tn_brm_bizproc (bizprocid, bizproccd, bizprocnm, bizproctyp, param, srp, nt, sta, lmt)
values ('STDBIZ/${app.name?upper_case}/${obj.name?upper_case}/ADD', 'STDBIZ/${app.name?upper_case}/${obj.name?upper_case}/ADD', 
        '添加【${label}】值对象', 'AD', '{
    <#list obj.attributes as attr>
      <#if attr.type.collection>
  "${modelbase.get_attribute_sql_name(attr)}":[]<#if attr?index != obj.attributes?size - 1>,</#if>
      <#else>
  "${modelbase.get_attribute_sql_name(attr)}":"${r'${'}${modelbase.get_attribute_sql_name(attr)}${r"!''''}"}"<#if attr?index != obj.attributes?size - 1>,</#if>  
      </#if>
    </#list>    
}', 'stdbiz/${app.name}/${obj.name}/add', null, 'E', current_timestamp);

insert into tn_brm_bizproc (bizprocid, bizproccd, bizprocnm, bizproctyp, param, srp, nt, sta, lmt)
values ('STDBIZ/${app.name?upper_case}/${obj.name?upper_case}/REMOVE', 'STDBIZ/${app.name?upper_case}/${obj.name?upper_case}/REMOVE', 
        '去除【${label}】值对象', 'RM', '{
    <#list attrIds as attrId>
  "${modelbase.get_attribute_sql_name(attrId)}":"${r'${'}${modelbase.get_attribute_sql_name(attrId)}${r"!''''}"}"<#if attrId?index != attrIds?size - 1>,</#if>    
    </#list>  
}', 'stdbiz/${app.name}/${obj.name}/remove', null, 'E', current_timestamp);

insert into tn_brm_bizproc (bizprocid, bizproccd, bizprocnm, bizproctyp, param, srp, nt, sta, lmt)
values ('STDBIZ/${app.name?upper_case}/${obj.name?upper_case}/GET', 'STDBIZ/${app.name?upper_case}/${obj.name?upper_case}/GET', 
        '获取【${label}】值对象', 'GT', '{
  "otherSelects":"",
  "leftJoins":"",
  "andConditions":"",
  "orderBy":"" 
}', 'stdbiz/${app.name}/${obj.name}/get', null, 'E', current_timestamp);

insert into tn_brm_bizproc (bizprocid, bizproccd, bizprocnm, bizproctyp, param, srp, nt, sta, lmt)
values ('STDBIZ/${app.name?upper_case}/${obj.name?upper_case}/AGGREGATE', 'STDBIZ/${app.name?upper_case}/${obj.name?upper_case}/AGGREGATE', 
        '运算【${label}】值对象', 'AG', '{
  "otherSelects":"",
  "leftJoins":"",
  "andConditions":"",
  "orderBy":"" 
}', 'stdbiz/${app.name}/${obj.name}/aggregate', null, 'E', current_timestamp);

  </#if>
</#list>
