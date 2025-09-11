<#macro print_sdk_remote>
<#assign constants = {}>
<#list model.objects as obj>
  <#if obj.isLabelled('generated')><#continue></#if>
  <#list obj.attributes as attr>
    <#if attr.constraint.domainType.name?index_of('enum') == 0>
      <#assign pairs = typebase.enumtype(attr.constraint.domainType.name)>
      <#list pairs as pair>
        <#assign constants = constants + {obj.name + '_' + attr.name + '_' + pair.key: pair}>
      </#list>
    </#if>
  </#list>
</#list>
${parentApplication}.${app.name} = {
<#list model.objects as obj>
  <#if obj.isLabelled('generated')><#continue></#if>
  <#list obj.attributes as attr>
    <#if attr.constraint.domainType.name?index_of('enum') == 0>
      <#-- 属性类型为枚举类型 -->
      <#assign pairs = typebase.enumtype(attr.constraint.domainType.name)>
  ${obj.name?upper_case}_${attr.name?upper_case}: {
      <#list pairs as pair>
    '${pair.key}': '${pair.value}'<#if pair?index != pairs?size - 1>,</#if>
      </#list>
  },
  ${obj.name?upper_case}_${attr.name?upper_case}_VALUES: [
      <#list pairs as pair>
    {value: '${pair.key}', text: '${pair.value}'}<#if pair?index != pairs?size - 1>,</#if>
      </#list>
  ],
    </#if>
  </#list>
  ${obj.name?upper_case}: '${parentApplication?upper_case}.${app.name?upper_case}.${obj.name?upper_case}',
</#list>
<#list constants as name, pair>
  // ${pair.value}
  ${name?upper_case}: '${pair.key}',
</#list>
  ENABLED: 'E',
  DISABLED: 'D',
  TRUE: 'T',
  FALSE: 'F'
};


<#list model.objects as obj>
  <#if obj.isLabelled('generated')><#continue></#if>
  <#assign attrIds = modelbase.get_id_attributes(obj)>
  <#if attrIds?size == 0><#continue></#if>
  <#assign attrId = modelbase.get_id_attributes(obj)[0]>
  <#assign implicitReferences = modelbase.get_object_implicit_references(obj)>
// 验证【${modelbase.get_object_label(obj)}】对象的属性的有效性
${parentApplication}.${app.name}.validate${js.nameType(obj.name)} = function (containerId) {
  var errors = $('#' + containerId).validate();
  if (errors.length > 0) {
    dialog.error(utils.message(errors));
    return null;
  }
  return $('#' + containerId).formdata();
};

/** 
 * 保存【${modelbase.get_object_label(obj)}】对象。
 */
${parentApplication}.${app.name}.save${js.nameType(obj.name)} = async function (params) {
  return await xhr.promise({
    url: '/api/v3/common/script/${parentApplication}/${app.name}/${obj.name}/save',
    params: params,
  });
};

/** 
 * 合并【${modelbase.get_object_label(obj)}】对象。
 */
${parentApplication}.${app.name}.merge${js.nameType(obj.name)} = async function (params) {
  return await xhr.promise({
    url: '/api/v3/common/script/${parentApplication}/${app.name}/${obj.name}/merge',
    params: params,
  });
};

/** 
 * 批量【${modelbase.get_object_label(obj)}】对象。
 */
${parentApplication}.${app.name}.batch${js.nameType(modelbase.get_object_plural(obj))} = async function (params) {
  return await xhr.promise({
    url: '/api/v3/common/script/${parentApplication}/${app.name}/${obj.name}/batch',
    params: params,
  });
};

/**
 * 读取【${modelbase.get_object_label(obj)}】对象。
 */
${parentApplication}.${app.name}.read${js.nameType(obj.name)} = async function (params) {
  return await xhr.promise({
    url: '/api/v3/common/script/${parentApplication}/${app.name}/${obj.name}/read',
    params: params,
  });
};

/**
 * 查询【${modelbase.get_object_label(obj)}】对象列表。
 */
${parentApplication}.${app.name}.find${js.nameType(obj.plural)} = async function (params) {
  return await xhr.promise({
    url: '/api/v3/common/script/${parentApplication}/${app.name}/${obj.name}/<#if obj.isLabelled('entity') || obj.isLabelled('constant')>find<#else>get</#if>',
    params: params,
  });
};

/**
 * 分页【${modelbase.get_object_label(obj)}】对象列表。
 */
${parentApplication}.${app.name}.paginate${js.nameType(obj.plural)} = async function (params) {
  return await xhr.promise({
    url: '/api/v3/common/script/${parentApplication}/${app.name}/${obj.name}/<#if obj.isLabelled('entity')>paginate<#else>get</#if>',
    params: params,
  });
};

/**
 * 聚合【${modelbase.get_object_label(obj)}】对象列表。
 */
${parentApplication}.${app.name}.aggregate${js.nameType(obj.plural)} = async function (params) {
  return await xhr.promise({
    url: '/api/v3/common/script/${parentApplication}/${app.name}/${obj.name}/aggregate',
    params: params,
  });
};

/**
 * 删除【${modelbase.get_object_label(obj)}】对象列表。
 */
${parentApplication}.${app.name}.delete${js.nameType(obj.name)} = async function (params) {
  return await xhr.promise({
    url: '/api/v3/common/script/${parentApplication}/${app.name}/${obj.name}/delete',
    params: params,
  });
};

/**
 * 包含【${modelbase.get_object_label(obj)}】对象。
 */
${parentApplication}.${app.name}.include${js.nameType(obj.name)} = async function (params) {
  return await xhr.promise({
    url: '/api/v3/common/script/${parentApplication}/${app.name}/${obj.name}/include',
    params: params,
  });
};

/**
 * 排斥【${modelbase.get_object_label(obj)}】对象。
 */
${parentApplication}.${app.name}.exclude${js.nameType(obj.name)} = async function (params) {
  return await xhr.promise({
    url: '/api/v3/common/script/${parentApplication}/${app.name}/${obj.name}/exclude',
    params: params,
  });
};

/**
 * 排序【${modelbase.get_object_label(obj)}】对象。
 */
${parentApplication}.${app.name}.reorder${js.nameType(obj.name)} = async function (params) {
  return await xhr.promise({
    url: '/api/v3/common/script/${parentApplication}/${app.name}/${obj.name}/reorder',
    params: params,
  });
};

/**
 * 连接【${modelbase.get_object_label(obj)}】对象。
 */
${parentApplication}.${app.name}.link${js.nameType(obj.name)} = async function (params) {
  return await xhr.promise({
    url: '/api/v3/common/script/${parentApplication}/${app.name}/${obj.name}/link',
    params: params,
  });
};

/**
 * 断开【${modelbase.get_object_label(obj)}】对象列表。
 */
${parentApplication}.${app.name}.unlink${js.nameType(obj.name)} = async function (params) {
  return await xhr.promise({
    url: '/api/v3/common/script/${parentApplication}/${app.name}/${obj.name}/unlink',
    params: params,
  });
};

/**
 * 增加${modelbase.get_object_label(obj)}】值对象到实体对象。
 */
${parentApplication}.${app.name}.add${js.nameType(obj.name)} = async function (params) {
  return await xhr.promise({
    url: '/api/v3/common/script/${parentApplication}/${app.name}/${obj.name}/add',
    params: params,
  });
};

/**
 * 去掉${modelbase.get_object_label(obj)}】值对象从实体对象。
 */
${parentApplication}.${app.name}.remove${js.nameType(obj.name)} = async function (params) {
  return await xhr.promise({
    url: '/api/v3/common/script/${parentApplication}/${app.name}/${obj.name}/remove',
    data: params,
  });
};

/**
 * 获取${modelbase.get_object_label(obj)}】值对象。
 */
${parentApplication}.${app.name}.get${js.nameType(obj.plural)} = async function (params) {
  return await xhr.promise({
    url: '/api/v3/common/script/${parentApplication}/${app.name}/${obj.name}/get',
    params: params,
  });
};

  <#-- 通过属性判断模式化得方法 -->
  <#list obj.attributes as attr>
    <#if attr.name == 'state'>
    <#-- 属性为系统状态 -->
/**
 * 激活【${modelbase.get_object_label(obj)}】对象。
 */
${parentApplication}.${app.name}.enable${js.nameType(obj.name)} = async function (params) {
  return xhr.promise({
    url: '/api/v3/common/script/${parentApplication}/${app.name}/${obj.name}/enable',
    params: params,
  });
};

/**
 * 禁用【${modelbase.get_object_label(obj)}】对象。
 */
${parentApplication}.${app.name}.disable${js.nameType(obj.name)} = async function (params) {
  return await xhr.promise({
    url: '/api/v3/common/script/${parentApplication}/${app.name}/${obj.name}/disable',
    params: params,
  });
};

    <#elseif attr.name == 'status'>
    <#-- 属性为业务状态 -->
/**
 * 改变${modelbase.get_object_label(obj)}】的业务状态。
 */
${parentApplication}.${app.name}.status${js.nameType(obj.name)} = async function (params) {
  return await xhr.promise({
    url: '/api/v3/common/script/${parentApplication}/${app.name}/${obj.name}/merge',
    params: params,
  });
};

    <#elseif attr.type.custom>
    <#-- 属性为自定义对象 -->
/**
 * 加载【${modelbase.get_attribute_label(attr)}】对应的对象集合。
 */
${parentApplication}.${app.name}.load${js.nameType(attr.name)}${js.nameType(obj.name)} = async function(params) {
  return await xhr.promise({
    url: '/api/v3/common/script/${parentApplication}/${app.name}/${attr.type.name}/find',
    params: params,
  });
};

    <#elseif attr.type.collection>
    <#-- 属性为集合对象 -->
// 加载【${modelbase.get_attribute_label(attr)}】对应的对象集合
${parentApplication}.${app.name}.load${js.nameType(obj.name)}${js.nameType(attr.name)} = async function(params) {
  return await xhr.promise({
    url: '/api/v3/common/script/${parentApplication}/${app.name}/${attr.type.name}/find',
    params: params,
  });
};

    </#if>
  </#list>
  <#-- 隐式引用所对应的模型方法 -->
  <#list implicitReferences as implicitReferenceName, implicitReference>
    <#assign attrRefId = ''>
    <#assign attrRefType = ''>
    <#list implicitReference as value, attr>
      <#if value == 'type'>
        <#assign attrRefType = attr>
      <#elseif value == 'id'>
        <#assign attrRefId = attr>
      </#if>
    </#list>
// 加载隐式引用的${implicitReferenceName}对应的对象集合
${parentApplication}.${app.name}.load${js.nameType(implicitReferenceName)} = function(referenceType, callback) {
  xhr.post({
    url: '/api/v3/common/script' + referenceType.toLowerCase().replace('\\.', '/') + '/find',
    data: {
      state: ${parentApplication}.${app.name}.ENABLED
    },
    success: function (resp) {
      if (resp.error) {
        dialog.error(resp.error.message);
        return;
      }
      if (callback)
        callback(resp.data);
    }
  });
};

  </#list>
</#list>
</#macro>