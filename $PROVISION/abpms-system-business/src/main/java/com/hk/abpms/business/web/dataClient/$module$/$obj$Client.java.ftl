<#import '/$/modelbase.ftl' as modelbase>
package com.hk.abpms.business.web.dataClient.${modelbase.get_object_module(obj)};

import com.hk.abpms.model.dto.${java.nameVariable(modelbase.get_object_module(obj))}.${java.nameType(obj.name)}Query;
import com.hk.abpms.model.entity.${java.nameVariable(modelbase.get_object_module(obj))}.${java.nameType(obj.name)}Entity;
import com.hk.platform.common.bean.ResponseData;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.ModelAttribute;

import java.util.List;

/**
 * 【${modelbase.get_object_label(obj)}】客户端SDK。
 *
 * @author 甘果
 */
@FeignClient(name = "${r"${"}dataClient.name}", path = "/${r"${"}dataClient.path}/v1/${java.nameVariable(obj.name)}", contextId = "${java.nameType(obj.name)}Client"
    ,url="http://10.12.100.50:8092")
public interface ${java.nameType(obj.name)}Client {

    /**
     * 查询【${modelbase.get_object_label(obj)}】数据。
     */
    @PostMapping(value = "/save/save${java.nameType(obj.name)}")
    ResponseData<Void> save${java.nameType(obj.name)}(@RequestBody ${java.nameType(obj.name)}Entity entity);

    /**
     * 保存【${modelbase.get_object_label(obj)}】数据。
     */
    @PostMapping(value = "/query/find${java.nameType(modelbase.get_object_plural(obj))}")
    ResponseData<List<${java.nameType(obj.name)}Entity>> find${java.nameType(modelbase.get_object_plural(obj))}(@RequestBody ${java.nameType(obj.name)}Query query);

}
