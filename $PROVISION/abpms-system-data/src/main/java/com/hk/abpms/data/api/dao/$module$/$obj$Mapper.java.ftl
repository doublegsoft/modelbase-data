<#import '/$/modelbase.ftl' as modelbase>
package com.hk.abpms.data.api.dao.${modelbase.get_object_module(obj)};


import org.apache.ibatis.annotations.Mapper;
import com.hk.abpms.data.api.config.BaseCommonMapper;
import com.hk.abpms.model.entity.${modelbase.get_object_module(obj)}.${java.nameType(obj.name)}Entity;
import com.hk.abpms.model.dto.${modelbase.get_object_module(obj)}.${java.nameType(obj.name)}Query;

import java.util.List;
import java.util.Map;

/**
 * 【${modelbase.get_object_label(obj)}】数据访问层接口。
 *
 * @author 甘果
 */
@Mapper
public interface ${java.nameType(obj.name)}Mapper extends BaseCommonMapper<${java.nameType(obj.name)}Entity> {
  
    /**
     * 查询【${modelbase.get_object_label(obj)}】数据
     */
    List<${java.nameType(obj.name)}Entity> select${java.nameType(obj.name)}(${java.nameType(obj.name)}Query query);
    
    /**
     * 插入【${modelbase.get_object_label(obj)}】数据
     */
    void insert${java.nameType(obj.name)}(${java.nameType(obj.name)}Entity entity);
    
    /**
     * 更新【${modelbase.get_object_label(obj)}】数据
     */
    void update${java.nameType(obj.name)}(${java.nameType(obj.name)}Entity entity);
  
}
