<#import '/$/modelbase.ftl' as modelbase>
package com.hk.abpms.data.api.service.${modelbase.get_object_module(obj)}.impl;

import com.hk.abpms.data.api.service.${modelbase.get_object_module(obj)}.${java.nameType(obj.name)}DataService;
import com.hk.abpms.data.api.dao.${modelbase.get_object_module(obj)}.${java.nameType(obj.name)}Mapper;
import com.hk.abpms.model.dto.${modelbase.get_object_module(obj)}.${java.nameType(obj.name)}Query;
import com.hk.abpms.model.entity.${modelbase.get_object_module(obj)}.${java.nameType(obj.name)}Entity;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.collections4.CollectionUtils;
import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.beans.BeanUtils;

import javax.annotation.Resource;
import java.math.BigDecimal;
import java.util.*;
import java.util.stream.Collectors;

<#assign idAttrs = modelbase.get_id_attributes(obj)>
/**
 * 【${modelbase.get_object_label(obj)}】的服务实现
 *
 * @author 甘果
 */
@Slf4j
@Service
public class ${java.nameType(obj.name)}DataServiceImpl implements ${java.nameType(obj.name)}DataService {
    
    @Resource
    private ${java.nameType(obj.name)}Mapper ${java.nameVariable(obj.name)}Mapper;
    
    /**
     * 查询【${modelbase.get_object_label(obj)}】数据
     */
    @Override 
    public List<${java.nameType(obj.name)}Entity> find${java.nameType(modelbase.get_object_plural(obj))}(${java.nameType(obj.name)}Query query) {
        return ${java.nameVariable(obj.name)}Mapper.select${java.nameType(obj.name)}(query);
    }
    
    @Override 
    public void save${java.nameType(obj.name)}(${java.nameType(obj.name)}Entity entity) {
<#if idAttrs?size == 0>
        ${java.nameVariable(obj.name)}Mapper.insert${java.nameType(obj.name)}(entity);
<#else>
        if (<#list idAttrs as idAttr><#if (idAttr?index > 0)> && </#if>entity.get${java.nameType(modelbase.get_attribute_sql_name(idAttr))}() != null</#list>) {
          ${java.nameVariable(obj.name)}Mapper.update${java.nameType(obj.name)}(entity);
        } else {
          ${java.nameVariable(obj.name)}Mapper.insert${java.nameType(obj.name)}(entity);
        }
</#if>
    }
}
