<#-- 获取对象的标识 ，目前支持单个标识 -->
<#function get_id obj>
  <#list obj.attributes as attr>
    <#if attr.identifiable>
      <#return attr>
    </#if>
  </#list>
  <#return null>
</#function>

<#-- 获取对象的名称属性 -->
<#function get_name obj>
  <#list obj.attributes as attr>
    <#if attr.constraint.domainType.toString()?index_of('name') == 0>
      <#return attr>
    </#if>
  </#list>
  <#return null>
</#function>

<#-- 检查是否含有值对象 -->
<#function has_value model appname>
  <#list model.objects as obj>
    <#if obj.getLabelledOptions('module')['name']?? && obj.isLabelled('value') && obj.getLabelledOptions('module')['name'] == appname>
      <#return true>
    </#if>
  </#list>
  <#return false>
</#function>

<#function has_entity model appname>
  <#list model.objects as obj>
    <#if obj.getLabelledOptions('module')['name']?? && obj.isLabelled('entity') && obj.getLabelledOptions('module')['name'] == appname>
      <#return true>
    </#if>
  </#list>
  <#return false>
</#function>

<#-- 获得依赖的包名称 -->
<#function get_deps model>
  <#assign deps = {}>
  <#list model.objects as obj>
    <#if obj.getLabelledOptions('module')['name']??>
      <#assign deps = deps + {obj.getLabelledOptions('module')['name']: ''}>
    </#if>
  </#list>
  <#return deps?keys>
</#function>

<#-- 获取对象的标识 ，目前支持单个标识 -->
<#function get_ref attr model>
  <#if !attr.type??>
    <#return null>
  </#if>
  <#assign typename = ''>
  <#if attr.type.class.name == 'com.doublegsoft.jcommons.metabean.type.CollectionType'>
    <#assign typename = attr.type.componentType.name>
  <#elseif attr.type.class.name == 'com.doublegsoft.jcommons.metabean.type.CustomType'>
    <#assign typename = attr.type.name>
  </#if>
  <#if typename == ''>
    <#return null>
  </#if>
  <#return model.findObjectByName(typename)>
</#function>

<#-- 获取单一对象引用 -->
<#function get_single_ref attr model>
  <#if !attr.type??>
    <#return null>
  </#if>
  <#assign typename = ''>
  <#if attr.type.class.name == 'com.doublegsoft.jcommons.metabean.type.CustomType'>
    <#assign typename = attr.type.name>
  </#if>
  <#if typename == ''>
    <#return null>
  </#if>
  <#assign ret = model.findObjectByName(typename)>
  <#return ret>
</#function>

<#-- 获取某个对象是否被多对多表所关联，如果关联，则返回在关联表中的另一个关联实体的属性，【多对多算法】 -->
<#function get_m2m_rel entObj model>
  <#assign ret = {}>
  <#list model.objects as obj>
    <#if !obj.isLabelled('relationship')>
      <#continue>
    </#if>
    <#assign hasEntity = false>
    <#list obj.attributes as objAttr>
      <#if !objAttr.persistenceName??>
        <#continue>
      </#if>
      <#if objAttr.constraint.domainType.toString()?index_of('&' + entObj.name) == 0>
        <#assign entObjAttr = objAttr>
        <#assign hasEntity = true>
      </#if>
    </#list>
    <#list obj.attributes as objAttr>
      <#if hasEntity && entObjAttr?? && entObjAttr.name != objAttr.name && objAttr.constraint.domainType.toString()?index_of('&') == 0>
        <#assign ret = ret + {objAttr.name: objAttr}>
      </#if>
    </#list>
  </#list>
  <#return ret?values>
</#function>

<#-- 获取refObj中与obj有关联关系的属性 -->
<#function get_ref_attr refObj obj>
  <#list refObj.attributes as attr>
    <#if attr.constraint.domainType.toString()?index_of('&' + obj.name) == 0>
      <#return attr>
    </#if>
  </#list>
  <#return null>
</#function>

<#-- 列出标识字段，作为方法参数 -->
<#function state_id obj>
  <#assign ret = ''>
  <#list obj.attributes as attr>
    <#if attr.identifiable>
      <#if ret != ''>
        <#assign ret = ret + ', '>
      </#if>
      <#assign ret = ret + typebase.typename(attr.constraint.domainType.toString(), 'java', 'String') + ' ' + java.nameVariable(attr.name)>
    </#if>
  </#list>
  <#return ret>
</#function>

<#-- 列出非标识字段，作为方法参数 -->
<#function state_attrs obj>
  <#assign ret = ''>
  <#list obj.attributes as attr>
    <#if !attr.identifiable>
      <#if ret != ''>
        <#assign ret = ret + ', '>
      </#if>
      <#assign ret = ret + typebase.typename(attr.constraint.domainType.toString(), 'java', 'String') + ' ' + java.nameVariable(attr.name)>
    </#if>
  </#list>
  <#return ret>
</#function>

<#-- 列出字段，作为方法参数 -->
<#function state_params attrs>
  <#assign ret = ''>
  <#list attrs as attr>
    <#if ret != ''>
      <#assign ret = ret + ', '>
    </#if>
    <#assign ret = ret + typebase.typename(attr.constraint.domainType.toString(), 'java', 'String') + ' ' + java.nameVariable(attr.name)>
  </#list>
  <#return ret>
</#function>

<#-- 列出引用了其他对象的属性字段，作为方法参数 -->
<#function state_ref_params attrs model>
  <#assign ret = ''>
  <#list attrs as attr>
    <#if ret != ''>
      <#assign ret = ret + ', '>
    </#if>
    <#assign refObj = appbase.get_ref(attr, model)>
    <#if refObj.isLabelled('value')>
      <#assign typename = refObj.alias>
    <#else>
      <#assign typename = refObj.name>
    </#if>
    <#if attr.constraint.domainType.array>
      <#assign ret = ret + 'List<' + java.nameType(typename) + '> ' + java.nameVariable(attr.name)>  
    <#else>
      <#assign ret = ret + java.nameType(typename) + ' ' + java.nameVariable(attr.name)>
    </#if>
  </#list>
  <#return ret>
</#function>

<#-- 获取测试值 -->
<#function test_value attr dflt>
  <#assign domaintype = typebase.domainType(attr.constraint.domainType.toString())>
  <#assign str = tatabase.value(domaintype, 'java')>
  <#if str == 'null'>
    <#assign str = dflt>
  </#if>
  <#assign str = '"' + str + '"'>
  <#if domaintype.name() == 'date'>
    <#return 'Date.valueOf(' + str + ')'>
  <#elseif domaintype.name() == 'datetime' || domaintype.name() == 'now'>
    <#return 'Timestamp.valueOf(' + str + ')'>
  <#elseif domaintype.name() == 'int'>
    <#return 'Integer.valueOf(' + str + ')'>
  <#elseif domaintype.name() == 'number' || domaintype.name() == 'money'>
    <#return 'new BigDecimal(' + str + ')'>
  <#elseif domaintype.name() == 'state'>
    <#return '"A"'>
  <#elseif domaintype.name() == 'bool'>
    <#return '"T"'>
  <#elseif domaintype.name() == 'enum'>
    <#-- 枚举值获取第一个值 -->
    <#assign dt = typebase.domainType(attr.constraint.domainType.toString())>
    <#assign pairs = dt.getOption('pairs')>
    <#return '"' + pairs[0].key + '"'>
  </#if>
  <#return str>
</#function>

<#-- 获取默认值 -->
<#function default_value attr>
  <#if !attr.constraint.defaultValue??>
    <#return null>  
  </#if>
  <#assign domaintype = typebase.domainType(attr.constraint.domainType.toString())>
  <#assign str = attr.constraint.defaultValue>
  <#assign str = '"' + str?substring(1, str?length - 1) + '"'>
  <#if domaintype.name() == 'date'>
    <#return 'java.sql.Date.valueOf(' + str + ')'>
  <#elseif domaintype.name() == 'datetime' || domaintype.name() == 'now'>
    <#return 'Timestamp.valueOf(' + str + ')'>
  <#elseif domaintype.name() == 'int'>
    <#return 'Integer.valueOf(' + str + ')'>
  <#elseif domaintype.name() == 'number' || domaintype.name() == 'money'>
    <#return 'new BigDecimal(' + str + ')'>
  </#if>
  <#return str>
</#function>

<#-- 书写对象属性 -->
<#macro write_obj_attr attr>
  /**
   * ${attr.text!'TODO'}.
   */
  <#if attr.constraint.domainType.array>
    <#if appbase.get_ref(attr, model)??>
      <#local refObj = appbase.get_ref(attr, model)>
      <#local typename = "">
      <#if refObj.isLabelled('value')>
        <#local typename = refObj.alias>
      <#else>
        <#local typename = refObj.name>
      </#if>
  private final List<${java.nameType(typename)}> ${java.nameVariable(attr.name)} = new ArrayList<>();
    <#else>
  private final List<${typebase.typename(attr.constraint.domainType.toString(), 'java', 'String')}> ${java.nameVariable(attr.name)} = new ArrayList<>();
    </#if>
  <#else>
    <#-- SPEC: 一般属性和关联属性，包括单一关联和集合关联 -->
    <#if appbase.get_single_ref(attr, model)??>
      <#assign refObj = appbase.get_single_ref(attr, model)>
      <#assign typename = ''>
      <#if refObj.isLabelled('value')>
        <#assign typename = refObj.alias>
      <#else>
        <#assign typename = refObj.name>
      </#if>
  private ${java.nameType(typename)} ${java.nameVariable(attr.name)};
    <#else>
  private ${typebase.typename(attr.constraint.domainType.toString(), 'java', 'String')} ${java.nameVariable(attr.name)}<#if appbase.default_value(attr)??> = ${appbase.default_value(attr)}</#if>;
    </#if>
  </#if>  
  
</#macro>

<#-- 书写对象属性的Getter、Setter方法 -->
<#macro write_attr_accessor attr>
  <#local typename = "">
  <#if appbase.get_ref(attr, model)??>
    <#-- SPEC: 处理【实体或值】形式的关联  -->
    <#local refObj = appbase.get_ref(attr, model)>
    <#if refObj.isLabelled('value')>
      <#local typename = refObj.alias>
    <#else>
      <#local typename = refObj.name>
    </#if>
    <#if attr.constraint.domainType.array>
  public List<${java.nameType(typename)}> get${java.nameType(attr.name)}() {
    return ${java.nameVariable(attr.name)};
  }
    <#else>
  public ${java.nameType(typename)} get${java.nameType(attr.name)}() {
    return ${java.nameVariable(attr.name)};
  }
  
  public void set${java.nameType(attr.name)}(${java.nameType(typename)} ${java.nameVariable(attr.name)}) {
    this.${java.nameVariable(attr.name)} = ${java.nameVariable(attr.name)};
  }
    </#if> 
  <#else>
    <#if attr.constraint.domainType.array>
  public List<${typebase.typename(attr.constraint.domainType.toString(), 'java', 'String')}> get${java.nameType(attr.name)}() {
    return ${java.nameVariable(attr.name)};
  }
    <#else>
  public ${typebase.typename(attr.constraint.domainType.toString(), 'java', 'String')} get${java.nameType(attr.name)}() {
    return ${java.nameVariable(attr.name)};
  }
  
  public void set${java.nameType(attr.name)}(${typebase.typename(attr.constraint.domainType.toString(), 'java', 'String')} ${java.nameVariable(attr.name)}) {
    this.${java.nameVariable(attr.name)} = ${java.nameVariable(attr.name)};
  }
    </#if>  
  </#if>
  
</#macro>

<#-- 书写 【服务接口】的状态属性衍生方法 -->
<#macro write_service_state entity attr>
  <#if attr.constraint.domainType.toString() == 'state'>
    <#-- SPEC: 处理实体状态 -->
  /**
   * 激活${entity.text!'TODO'}对象。
   *
   * @param ${java.nameVariable(attrId.name)} 
   *      ${entity.text!'TODO'}标识
   *
   * @throws ServiceException
   *     一旦发生任何异常，则抛出服务异常
   */
  void activate${java.nameType(entity.name)}(${appbase.state_id(entity)}) throws ServiceException;
  
  /**
   * 禁用${entity.text!'TODO'}对象。
   *
   * @param ${java.nameVariable(attrId.name)} 
   *      ${entity.text!'TODO'}标识
   *
   * @throws ServiceException
   *     一旦发生任何异常，则抛出服务异常
   */
  void deactivate${java.nameType(entity.name)}(${appbase.state_id(entity)}) throws ServiceException;
  
  </#if>
</#macro>

<#-- 书写【服务实现】的状态属性衍生方法 -->
<#macro write_service_default_state entity attr>
  <#assign attrId = get_id(entity)>
  <#if attr.constraint.domainType.toString() == 'state'>
    <#-- SPEC: 处理实体状态 -->
  /**
   * {@inheritDoc}
   */
  @Override
  public void activate${java.nameType(entity.name)}(${appbase.state_id(entity)}) throws ServiceException {
    // validate
    ${java.nameType(entity.name)}Validation validation = new ${java.nameType(entity.name)}Validation(getCommonService());
    String message = validation.validate(${java.nameVariable(attrId.name)}, "${attrId.text!'TODO'}不能为空值！");
    if (message != null) {
      throw new ServiceException(message);
    }
    
    SqlParams params = new SqlParams();
    params.set("${attrId.persistenceName}", ${java.nameVariable(attrId.name)});
    params.set("${attr.persistenceName}", "A");
    commonService.execute("${entity.persistenceName!'TODO'}.state", params);
  }
  
  /**
   * {@inheritDoc}
   */
  @Override
  public void deactivate${java.nameType(entity.name)}(${appbase.state_id(entity)}) throws ServiceException {
    // validate
    ${java.nameType(entity.name)}Validation validation = new ${java.nameType(entity.name)}Validation(getCommonService());
    String message = validation.validate(${java.nameVariable(attrId.name)}, "${attrId.text!'TODO'}不能为空值！");
    if (message != null) {
      throw new ServiceException(message);
    }
    
    SqlParams params = new SqlParams();
    params.set("${attrId.persistenceName}", ${java.nameVariable(attrId.name)});
    params.set("${attr.persistenceName}", "D");
    commonService.execute("${entity.persistenceName!'TODO'}.state", params);
  }
  
  </#if>
</#macro>

<#-- 书写【服务接口】【一对一值对象】的衍生方法 -->
<#macro write_service_value entity attr model>
  <#assign attrId = appbase.get_id(entity)>
  <#local typename = ''>
  <#if appbase.get_single_ref(attr, model)??>
    <#-- SPEC: 处理【实体或值】形式的关联  -->
    <#assign refObj = appbase.get_single_ref(attr, model)>
    <#if refObj.isLabelled('value')>
      <#local typename = refObj.alias>
    <#else>
      <#local typename = refObj.name>
    </#if>
    <#list refObj.attributes as refObjAttr>
      <#if refObjAttr.getType().getName()?? && refObjAttr.getType().getName() == entity.name>
        <#assign refObjRefAttr = refObjAttr>
        <#break>
      </#if>
    </#list>
    <#if refObj.isLabelled('value')>
  /**
   * 添加${attr.text!'TODO'}值。
   *
   * @param ${java.nameVariable(refObjRefAttr.persistenceName!'TODO')}
   *      ${refObjRefAttr.text!'TODO'}  
   *
   * @param ${java.nameVariable(refObj.singular)}
   *      ${refObj.text!'TODO'}值
   *
   * @return ${appbase.get_id(refObj).text!'TODO'}
   *
   * @throws ServiceException
   *      一旦发生任何异常，则抛出服务异常
   */
  ${typebase.typename(appbase.get_id(refObj), 'java', 'String')} create${java.nameType(refObj.singular)}(${typebase.typename(refObjRefAttr.constraint.domainType.toString(), 'java', 'String')} ${java.nameVariable(refObjRefAttr.persistenceName!'TODO')}, ${java.nameType(typename)} ${java.nameVariable(refObj.singular)}) throws ServiceException;
  
  /**
   * 更新${attr.text!'TODO'}值。
      <#list refObj.attributes as refObjAttr>
        <#-- SPEC: 从【值】中获取引用的父实体 -->
        <#if refObjAttr.getType().getName()?? && refObjAttr.getType().getName() == entity.name>
   *
   * @param ${java.nameVariable(refObjAttr.persistenceName!'TODO')}
   *      ${attr.text!'TODO'}
        </#if>
      </#list>
   *
   * @return ${attr.text}集合
   *
   * @throws ServiceException
   *      一旦发生任何异常，则抛出服务异常
   */
  void update${java.nameType(refObj.singular)}(${typebase.typename(refObjRefAttr.constraint.domainType.toString(), 'java', 'String')} ${java.nameVariable(refObjRefAttr.persistenceName!'TODO')}, ${java.nameType(typename)} ${java.nameVariable(refObj.singular)}) throws ServiceException;
  
  /**
   * 删掉${attr.text!'TODO'}值。
      <#list refObj.attributes as attr>
        <#if attr.identifiable>
   *
   * @param ${java.nameVariable(attr.name)}
   *      ${attr.text!'TODO'}
        </#if>
      </#list>
   *
   * @throws ServiceException
   *      一旦发生任何异常，则抛出服务异常
   */
  void delete${java.nameType(refObj.singular)}(${appbase.state_id(refObj)}) throws ServiceException;
  
    </#if>
  </#if>
</#macro>

<#-- 书写【服务实现】【一对一值对象】的衍生方法 -->
<#macro write_service_default_value entity attr model>
  <#assign attrId = appbase.get_id(entity)>
  <#local typename = ''>
  <#if appbase.get_single_ref(attr, model)??>
    <#-- SPEC: 处理【实体或值】形式的关联  -->
    <#assign refObj = appbase.get_single_ref(attr, model)>
    <#if refObj.isLabelled('value')>
      <#local typename = refObj.alias>
    <#else>
      <#local typename = refObj.name>
    </#if>
    <#list refObj.attributes as refObjAttr>
      <#if refObjAttr.getType().getName()?? && refObjAttr.getType().getName() == entity.name>
        <#assign refObjRefAttr = refObjAttr>
        <#break>
      </#if>
    </#list>
    <#if refObj.isLabelled('value')>
  /**
   * {@inheritDoc}
   */
  @Override
  public ${typebase.typename(appbase.get_id(refObj), 'java', 'String')} create${java.nameType(refObj.singular)}(${typebase.typename(refObjRefAttr.constraint.domainType.toString(), 'java', 'String')} ${java.nameVariable(refObjRefAttr.persistenceName!'TODO')}, ${java.nameType(typename)} ${java.nameVariable(refObj.singular)}) throws ServiceException {
    <#-- SPEC: 必填项的服务器端校验 -->
    // validate the ${java.nameVariable(refObj.singular)}
    ${java.nameType(refObj.alias)}Validation validation = new ${java.nameType(refObj.alias)}Validation(getCommonService());
    String message = validation.validate(${java.nameVariable(refObj.singular)});
    if (message != null) {
      throw new ServiceException(message);
    }
    
    <#assign ret = ''>
    <#list refObj.attributes as refObjAttr>
      <#if refObjAttr.identifiable>
        <#assign ret = java.nameVariable(refObjAttr.name)>
    // persist the ${java.nameVariable(refObj.name)}
    ${typebase.typename(refObjAttr.constraint.domainType.toString(), 'java', 'String')} ${java.nameVariable(refObjAttr.name)} = Strings.id();
    ${java.nameVariable(refObj.alias)}.set${java.nameType(refObjAttr.name)}(${java.nameVariable(refObjAttr.name)});
      </#if>
    </#list>
    SqlParams params = ${java.nameType(refObj.singular)}.toSqlParams(${java.nameVariable(refObj.alias)});
    params.set("${java.nameVariable(refObjRefAttr.persistenceName!'TODO')}", ${java.nameVariable(refObjRefAttr.persistenceName!'TODO')});
    commonService.execute("${refObj.persistenceName}.create", params);
    return ${ret};
  }
  
  /**
   * {@inheritDoc}
   */
  @Override
  public void update${java.nameType(refObj.singular)}(${typebase.typename(refObjRefAttr.constraint.domainType.toString(), 'java', 'String')} ${java.nameVariable(refObjRefAttr.persistenceName!'TODO')}, ${java.nameType(typename)} ${java.nameVariable(refObj.singular)}) throws ServiceException {
    <#-- SPEC: 必填项的服务器端校验 -->
    // validate the ${java.nameVariable(refObj.singular)}
    ${java.nameType(refObj.alias)}Validation validation = new ${java.nameType(refObj.alias)}Validation(getCommonService());
    String message = validation.validate(${java.nameVariable(refObj.singular)});
    if (message != null) {
      throw new ServiceException(message);
    }
    
    SqlParams params = ${java.nameType(refObj.singular)}.toSqlParams(${java.nameVariable(refObj.alias)});
    params.set("${java.nameVariable(refObjRefAttr.persistenceName!'TODO')}", ${java.nameVariable(refObjRefAttr.persistenceName!'TODO')});
    commonService.execute("${refObj.persistenceName}.update", params);
  }
  
  /**
   * {@inheritDoc}
   */
  @Override
  public void delete${java.nameType(refObj.singular)}(${appbase.state_id(refObj)}) throws ServiceException {
    commonService.execute("${refObj.persistenceName}.delete", new SqlParams().set("${appbase.get_id(refObj).persistenceName}", id));
  }
  
    </#if>
  </#if>
</#macro>

<#-- 书写【服务接口】【一对多值对象】的衍生方法 -->
<#macro write_service_values entity attr model>
  <#assign attrId = appbase.get_id(entity)>
  <#local typename = ''>
  <#if appbase.get_ref(attr, model)??>
    <#-- SPEC: 处理【实体或值】形式的关联  -->
    <#assign refObj = appbase.get_ref(attr, model)>
    <#if refObj.isLabelled('value')>
      <#local typename = refObj.alias>
    <#else>
      <#local typename = refObj.name>
    </#if>
    <#list refObj.attributes as refObjAttr>
      <#if refObjAttr.getType().getName()?? && refObjAttr.getType().getName() == entity.name>
        <#assign refObjRefAttr = refObjAttr>
        <#break>
      </#if>
    </#list>
    <#if attr.constraint.domainType.array && refObj.isLabelled('value')>
  /**
   * 添加一个${attr.text!'TODO'}值。
   *
   * @param ${java.nameVariable(refObjRefAttr.persistenceName!'TODO')}
   *      ${refObjRefAttr.text!'TODO'}  
   *
   * @param ${java.nameVariable(refObj.singular)}
   *      ${refObj.text!'TODO'}值
   *
   * @return ${appbase.get_id(refObj).text!'TODO'}
   *
   * @throws ServiceException
   *      一旦发生任何异常，则抛出服务异常
   */
  ${typebase.typename(appbase.get_id(refObj), 'java', 'String')} add${java.nameType(refObj.singular)}(${typebase.typename(refObjRefAttr.constraint.domainType.toString(), 'java', 'String')} ${java.nameVariable(refObjRefAttr.persistenceName!'TODO')}, ${java.nameType(typename)} ${java.nameVariable(refObj.singular)}) throws ServiceException;
  
  /**
   * 修改一个${attr.text!'TODO'}值。 
   *
   * @param ${java.nameVariable(refObjRefAttr.persistenceName!'TODO')}
   *      ${refObjRefAttr.text!'TODO'}  
   *
   * @param ${java.nameVariable(refObj.singular)}
   *      ${refObj.text!'TODO'}值
   *
   * @return ${appbase.get_id(refObj).text!'TODO'}
   *
   * @throws ServiceException
   *      一旦发生任何异常，则抛出服务异常
   */
  void modify${java.nameType(refObj.singular)}(${typebase.typename(refObjRefAttr.constraint.domainType.toString(), 'java', 'String')} ${java.nameVariable(refObjRefAttr.persistenceName!'TODO')}, ${java.nameType(typename)} ${java.nameVariable(refObj.singular)}) throws ServiceException;
  
  /**
   * 获取全部${attr.text!'TODO'}值。
      <#list refObj.attributes as refObjAttr>
        <#-- SPEC: 从【值】中获取引用的父实体 -->
        <#if refObjAttr.getType().getName()?? && refObjAttr.getType().getName() == entity.name>
   *
   * @param ${java.nameVariable(refObjAttr.persistenceName!'TODO')}
   *      ${attr.text!'TODO'}
        </#if>
      </#list>
   *
   * @return ${attr.text}集合
   *
   * @throws ServiceException
   *      一旦发生任何异常，则抛出服务异常
   */
  List<${java.nameType(typename)}> get${java.nameType(refObj.plural)}(${typebase.typename(refObjRefAttr.constraint.domainType.toString(), 'java', 'String')} ${java.nameVariable(refObjRefAttr.persistenceName!'TODO')}) throws ServiceException;
  
  /**
   * 删掉一个${attr.text!'TODO'}值。
      <#list refObj.attributes as attr>
        <#if attr.identifiable>
   *
   * @param ${java.nameVariable(attr.name)}
   *      ${attr.text!'TODO'}
        </#if>
      </#list>
   *
   * @throws ServiceException
   *      一旦发生任何异常，则抛出服务异常
   */
  void remove${java.nameType(refObj.singular)}(${appbase.state_id(refObj)}) throws ServiceException;
  
    </#if>
  </#if>
</#macro>

<#-- 书写【服务实现】【一对多值对象】的衍生方法 -->
<#macro write_service_default_values entity attr model>
  <#local typename = ''>
  <#if appbase.get_ref(attr, model)??>
    <#local refObj = appbase.get_ref(attr, model)>
    <#if refObj.isLabelled('value')>
      <#local typename = refObj.alias>
    <#else>
      <#local typename = refObj.name>
    </#if>
    <#list refObj.attributes as refObjAttr>
      <#if refObjAttr.getType().getName()?? && refObjAttr.getType().getName() == entity.name>
        <#assign refObjRefAttr = refObjAttr>
        <#break>
      </#if>
    </#list>
    <#if attr.constraint.domainType.array && refObj.isLabelled('value')>
  /**
   * {@inheritDoc}
   */
  @Override
  public ${typebase.typename(appbase.get_id(refObj), 'java', 'String')} add${java.nameType(refObj.singular)}(${typebase.typename(refObjRefAttr.constraint.domainType.toString(), 'java', 'String')} ${java.nameVariable(refObjRefAttr.persistenceName!'TODO')}, ${java.nameType(typename)} ${java.nameVariable(refObj.singular)}) throws ServiceException {
    // validate
    ${java.nameType(refObj.singular)}Validation validation = new ${java.nameType(refObj.singular)}Validation(getCommonService());
    String message = validation.validate(${java.nameVariable(refObjRefAttr.persistenceName)}, "${refObjRefAttr.text!'TODO'}不能为空值！");
    if (message != null) {
      throw new ServiceException(message);
    }  
    message = validation.validate(${java.nameVariable(refObj.singular)});
    if (message != null) {
      throw new ServiceException(message);
    }  
    
    SqlParams params = new SqlParams();
      <#local ret = ''>
      <#list refObj.attributes as refAttr>
        <#if refAttr.identifiable>
          <#local ret = java.nameVariable(refAttr.name)>
    ${typebase.typename(refAttr.constraint.domainType.toString(), 'java', 'String')} ${java.nameVariable(refAttr.name)} = Strings.id();
    params.set("${refAttr.persistenceName}", ${java.nameVariable(refAttr.name)});
    params.set("${refObjRefAttr.persistenceName}", ${java.nameVariable(refObjRefAttr.persistenceName)});
        <#elseif refAttr.persistenceName?? && !appbase.get_ref(refAttr, model)??>
        <#-- SPEC: 【值】对父引用的关联不需要处理，模型中只是定义，实现中【值】不能引用任何实体 -->
    params.set("${refAttr.persistenceName}", ${java.nameVariable(refObj.singular)}.get${java.nameType(refAttr.name)}());
        </#if>
      </#list>
    commonService.execute("${refObj.persistenceName}.create", params);
    return ${ret};
  }
  
  /**
   * {@inheritDoc}
   */
  @Override
  public void modify${java.nameType(refObj.alias)}(${typebase.typename(refObjRefAttr.constraint.domainType.toString(), 'java', 'String')} ${java.nameVariable(refObjRefAttr.persistenceName!'TODO')}, ${java.nameType(typename)} ${java.nameVariable(refObj.singular)}) throws ServiceException {
    // validate
    ${java.nameType(refObj.singular)}Validation validation = new ${java.nameType(refObj.singular)}Validation(getCommonService());
    String message = validation.validate(${java.nameVariable(refObjRefAttr.persistenceName)}, "${refObjRefAttr.text!'TODO'}不能为空值！");
    if (message != null) {
      throw new ServiceException(message);
    }  
    message = validation.validate(${java.nameVariable(refObj.singular)});
    if (message != null) {
      throw new ServiceException(message);
    }  
    
    SqlParams params = new SqlParams();
      <#local ret = ''>
      <#list refObj.attributes as refAttr>
        <#if refAttr.identifiable>
          <#local ret = java.nameVariable(refAttr.name)>
    params.set("${refAttr.persistenceName}", ${java.nameVariable(refObj.singular)}.get${java.nameType(refAttr.name)}());
    params.set("${refObjRefAttr.persistenceName}", ${java.nameVariable(refObjRefAttr.persistenceName)});
        <#elseif refAttr.persistenceName?? && !appbase.get_ref(refAttr, model)??>
        <#-- SPEC: 【值】对父引用的关联不需要处理，模型中只是定义，实现中【值】不能引用任何实体 -->
    params.set("${refAttr.persistenceName}", ${java.nameVariable(refObj.singular)}.get${java.nameType(refAttr.name)}());
        </#if>
      </#list>
    commonService.execute("${refObj.persistenceName}.update", params);
  }
  
  /**
   * {@inheritDoc}
   */
  public List<${java.nameType(typename)}> get${java.nameType(refObj.plural)}(${typebase.typename(refObjRefAttr.constraint.domainType.toString(), 'java', 'String')} ${java.nameVariable(refObjRefAttr.persistenceName!'TODO')}) throws ServiceException {
    // validate
    ${java.nameType(refObj.singular)}Validation validation = new ${java.nameType(refObj.singular)}Validation(getCommonService());
    String message = validation.validate(${java.nameVariable(refObjRefAttr.persistenceName)}, "${refObjRefAttr.text!'TODO'}不能为空值！");
    if (message != null) {
      throw new ServiceException(message);
    }  
    
    List<${java.nameType(typename)}> retVal = new ArrayList<>();
    SqlParams params = new SqlParams();
      <#list refObj.attributes as refObjAttr>
        <#if refObjAttr.getType().getName()?? && refObjAttr.getType().getName() == entity.name>
    params.set("${java.nameVariable(refObjAttr.persistenceName!'TODO')}", ${java.nameVariable(refObjAttr.persistenceName!'TODO')});
        </#if>
      </#list>
    List<ObjectMap> data = commonService.many("${refObj.persistenceName}.find", params);
    for (ObjectMap obj : data) {
      retVal.add(${java.nameType(typename)}.from(obj));
    }
    return retVal;
  }
  
  /**
   * {@inheritDoc}
   */
  @Override
  public void remove${java.nameType(refObj.singular)}(${appbase.state_id(refObj)}) throws ServiceException {
    SqlParams params = new SqlParams();
      <#list refObj.attributes as refAttr>
        <#if refAttr.identifiable>
    params.set("${refAttr.persistenceName}", ${java.nameVariable(refAttr.name)});
        </#if>
      </#list>
    commonService.execute("${refObj.persistenceName}.delete", params);
  }
  
    </#if>
  </#if>
</#macro>

<#-- 书写【服务接口】修改少量属性的方法 -->
<#macro write_service_set entity>
  <#assign attrId = appbase.get_id(entity)>
  <#assign methods = {}>
  <#-- 准备数据，注意去重 -->
  <#list entity.attributes as attr>
    <#if attr.isLabelled('set')>
      <#assign methodName = attr.getLabelledOptions('set')['service']>
      <#assign methodParams = []>
      <#if methods[methodName]??>
        <#assign methodParams = methods[methodName]>
      </#if>
      <#assign methodParams = methodParams + [attr]>
      <#assign methods = methods + {methodName: methodParams}>
    </#if>
  </#list>
  <#list methods?keys as methodName>
    <#assign methodParams = methods[methodName]>
    <#assign methodParams = [attrId] + methodParams>
  /**
   * 改变${entity.text!'TODO'}的<#list methodParams as param><#if param?index == 0><#continue></#if>${param.text!'TODO'}<#if param?index != methodParams?size - 1>、</#if></#list>。
   * 
    <#list methodParams as param>
   * @param ${java.nameVariable(param.name)}
   *      ${param.text!'TODO'}
   *
    </#list>
   * @throws ServiceException
   *      一旦发生任何异常，则抛出服务异常
   */  
  public void ${java.nameMethod('', methodName)}(${appbase.state_params(methodParams)}) throws ServiceException;
  
  </#list>
</#macro>

<#-- 书写【服务实现】修改少量属性的方法 -->
<#macro write_service_default_set entity>
  <#assign attrId = appbase.get_id(entity)>
  <#assign methods = {}>
  <#-- 准备数据，注意去重 -->
  <#list entity.attributes as attr>
    <#if attr.isLabelled('set')>
      <#assign methodName = attr.getLabelledOptions('set')['service']>
      <#assign methodParams = []>
      <#if methods[methodName]??>
        <#assign methodParams = methods[methodName]>
      </#if>
      <#assign methodParams = methodParams + [attr]>
      <#assign methods = methods + {methodName: methodParams}>
    </#if>
  </#list>
  <#list methods?keys as methodName>
    <#assign methodParams = methods[methodName]>
    <#assign methodParams = [attrId] + methodParams>
  /**
   * {@inheritDoc}
   */  
  @Override
  public void ${java.nameMethod('', methodName)}(${appbase.state_params(methodParams)}) throws ServiceException {
    // validate
    ${java.nameType(entity.name)}Validation validation = new ${java.nameType(entity.name)}Validation(getCommonService());
    List<Object[]> valuesAndMessages = new ArrayList<>();
    <#list methodParams as param>
    valuesAndMessages.add(new Object[] {${java.nameVariable(param.name)}, "${param.text!'TODO'}不能为空！"});
    </#list>
    String requiredMessage = validation.validate(valuesAndMessages);
    if (requiredMessage != null) {
      throw new ServiceException(requiredMessage);
    }
    StringBuilder message = new StringBuilder();
<@appbase.write_validation_valid attrs=methodParams prefix='validation.'/>
    if (message.length() > 0) {
      throw new ServiceException(message.toString());
    }
    // persist
    SqlParams params = new SqlParams();
    <#list methodParams as param>
    params.set("${param.persistenceName}", ${java.nameVariable(param.name)});
    </#list>
    commonService.execute("${entity.persistenceName}.${methodName}", params);
  }
  
  </#list>
</#macro>

<#-- 书写【必填验证】 -->
<#macro write_validation_required attrs prefix>
  <#list attrs as attr>
    <#if !attr.constraint.nullable>
    if (${prefix}isNullOrEmpty(${java.nameVariable(entity.name)}.get${java.nameType(attr.name)}())) {
      message.append("${attr.text!'TODO'}不能为空！").append("\n");
    }
    </#if>
  </#list>
</#macro>

<#-- 书写【有效性验证】 -->
<#macro write_validation_valid attrs prefix>
  <#list attrs as attr>
    <#assign domaintype = attr.constraint.domainType.toString()>
    <#if domaintype == 'email'>
    if (!${prefix}validateEmail(${java.nameVariable(attr.name)})) {
      message.append("${attr.text!'TODO'}不满足规则！").append("\n");
    }
    <#elseif domaintype == 'mobile'>
    if (!${prefix}validateMobile(${java.nameVariable(attr.name)})) {
      message.append("${attr.text!'TODO'}不满足规则！").append("\n");
    }
    <#elseif domaintype == 'bool'>
    if (!${prefix}validateBool(${java.nameVariable(attr.name)})) {
      message.append("${attr.text!'TODO'}不满足规则！").append("\n");
    }
    <#elseif domaintype == 'state'>
    if (!${prefix}validateState(${java.nameVariable(attr.name)})) {
      message.append("${attr.text!'TODO'}不满足规则！").append("\n");
    }
    <#elseif domaintype?index_of('enum') == 0>
      <#assign dt = typebase.domainType(domaintype)>
      <#assign pairs = dt.options['pairs']>
    if (!${prefix}validateEnum(${java.nameVariable(attr.name)}, new String[]{<#list pairs as pair>"${pair.key}"<#if pair?index != pairs?size - 1>, </#if></#list>})) {
      message.append("${attr.text!'TODO'}不满足规则！").append("\n");
    }
    </#if>
  </#list>
</#macro>