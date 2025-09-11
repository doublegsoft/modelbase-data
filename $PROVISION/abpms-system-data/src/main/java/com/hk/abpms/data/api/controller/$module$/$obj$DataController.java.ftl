<#import '/$/modelbase.ftl' as modelbase>
package com.hk.abpms.data.api.controller.${modelbase.get_object_module(obj)};

import com.hk.abpms.model.dto.${java.nameVariable(modelbase.get_object_module(obj))}.${java.nameType(obj.name)}Query;
import com.hk.abpms.model.entity.${java.nameVariable(modelbase.get_object_module(obj))}.${java.nameType(obj.name)}Entity;
import com.hk.abpms.data.api.service.${java.nameVariable(modelbase.get_object_module(obj))}.${java.nameType(obj.name)}DataService;
import com.hk.platform.common.bean.ResponseData;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.ModelAttribute;

import javax.annotation.Resource;
import java.util.List;

/**
 * 【${modelbase.get_object_label(obj)}】数据层网络API。
 */
@Tag(name = "${java.nameType(obj.name)}", description = "${modelbase.get_object_label(obj)}")
@RestController
@RequestMapping("/${r"${"}dataClient.path}/v1/${java.nameVariable(obj.name)}")
@Slf4j
public class ${java.nameType(obj.name)}DataController {
    
    @Resource
    private ${java.nameType(obj.name)}DataService ${java.nameVariable(obj.name)}DataService;
    
    /**
     * 查询【${modelbase.get_object_label(obj)}】数据
     */
    @Operation(summary = "查询【${modelbase.get_object_label(obj)}】数据")
    @PostMapping(value = "/query/find${java.nameType(modelbase.get_object_plural(obj))}")
    public ResponseData<List<${java.nameType(obj.name)}Entity>> find${java.nameType(modelbase.get_object_plural(obj))}(@RequestBody ${java.nameType(obj.name)}Query query) {
        return ResponseData.success(${java.nameVariable(obj.name)}DataService.find${java.nameType(modelbase.get_object_plural(obj))}(query));
    }
    
    /**
     * 保存（创建或更新）【${modelbase.get_object_label(obj)}】数据
     */
    @Operation(summary = "保存【${modelbase.get_object_label(obj)}】数据")
    @PostMapping(value = "/save/save${java.nameType(modelbase.get_object_plural(obj))}")
    public ResponseData save${java.nameType(modelbase.get_object_plural(obj))}(@RequestBody ${java.nameType(obj.name)}Entity entity) {
        try {
          ${java.nameVariable(obj.name)}DataService.save${java.nameType(obj.name)}(entity);
          return ResponseData.success();
        } catch (Throwable cause) {
          return ResponseData.error(cause.getMessage());
        }
    }

}
