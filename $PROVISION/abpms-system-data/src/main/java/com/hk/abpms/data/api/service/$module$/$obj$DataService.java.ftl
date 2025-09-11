<#import '/$/modelbase.ftl' as modelbase>
package com.hk.abpms.data.api.service.${modelbase.get_object_module(obj)};

import com.hk.abpms.data.api.service.${modelbase.get_object_module(obj)}.${java.nameType(obj.name)}DataService;
import com.hk.abpms.data.api.dao.${modelbase.get_object_module(obj)}.${java.nameType(obj.name)}Mapper;
import com.hk.abpms.model.dto.${modelbase.get_object_module(obj)}.${java.nameType(obj.name)}Query;
import com.hk.abpms.model.entity.${modelbase.get_object_module(obj)}.${java.nameType(obj.name)}Entity;

import java.math.BigDecimal;
import java.util.Date;
import java.util.List;

/**
 * 针对表【${modelbase.get_object_label(obj)}】的核心服务接口
 *
 * @author 甘果
 */
public interface ${java.nameType(obj.name)}DataService {
    
    /**
     * 查询【${modelbase.get_object_label(obj)}】数据
     */
    List<${java.nameType(obj.name)}Entity> find${java.nameType(modelbase.get_object_plural(obj))}(${java.nameType(obj.name)}Query query);
    
    /**
     * 保存（创建或更新）【${modelbase.get_object_label(obj)}】数据
     */
    void save${java.nameType(obj.name)}(${java.nameType(obj.name)}Entity entity);
    
}
