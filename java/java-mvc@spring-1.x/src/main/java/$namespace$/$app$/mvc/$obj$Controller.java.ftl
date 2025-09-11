<#import '/$/modelbase.ftl' as modelbase>
<#import '/$/modelbase4java.ftl' as modelbase4java>
<#if license??>
${java.license(license)}
</#if>
package <#if namespace??>${namespace}.</#if>${app.name}.mvc;

import java.util.List;
import java.util.ArrayList;
import java.util.Map;
import java.util.HashMap;
import java.math.BigDecimal;
import java.io.Serializable;
import java.sql.Date;
import java.sql.Timestamp;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.*;
import org.springframework.transaction.annotation.*;
import org.springframework.stereotype.*;
import org.springframework.web.bind.annotation.*;
import org.springframework.http.MediaType;

import <#if namespace??>${namespace}.</#if>${app.name}.poco.*;
import <#if namespace??>${namespace}.</#if>${app.name}.orm.assembler.*;
import <#if namespace??>${namespace}.</#if>${app.name}.dto.payload.*;
import <#if namespace??>${namespace}.</#if>${app.name}.service.*;

<#assign typename = java.nameType(obj.name)>
<#assign varname = java.nameVariable(obj.name)>
<#assign idAttrs = modelbase.get_id_attributes(obj)>
/**
 * 【${modelbase.get_object_label(obj)}】控制器。
 *
 * @author <a href="mailto:guo.guo.gan@gmail.com">Christian Gann</a>
 *
 * @since ${version}
 */
@RestController("<#if namespace??>${namespace}.</#if>${app.name}.mvc.${typename}Controller") 
@RequestMapping("/${app.name}")
public class ${typename}Controller extends BaseController {
  
  private static final Logger TRACER = LoggerFactory.getLogger(${typename}Controller.class);
  
  @Autowired
  @Qualifier("<#if namespace??>${namespace}.</#if>${app.name}.service.${typename}Service") 
  private ${typename}Service ${varname}Service;
  
  @PostMapping(value = "/${obj.name}/batch", produces = MediaType.APPLICATION_JSON_VALUE + ";charset=utf-8")
  public RestResult save${inflector.pluralize(java.nameType(obj.name))}(@RequestBody List<${typename}Query> queries) {
    try {
      ${varname}Service.save${inflector.pluralize(java.nameType(obj.name))}(queries);
      return new RestResult();
    } catch (Throwable cause) {
      TRACER.error(cause.getMessage(), cause);
      return error(cause);
    }
  }
  
  @PostMapping(value = "/${obj.name}/save", produces = MediaType.APPLICATION_JSON_VALUE + ";charset=utf-8")
  public RestResult save${java.nameType(obj.name)}(@RequestBody ${typename}Query query) {
    try {
      ${typename}Query data = ${varname}Service.save${java.nameType(obj.name)}(query);
      return new RestResult(data.toMap());
    } catch (Throwable cause) {
      TRACER.error(cause.getMessage(), cause);
      return error(cause);
    }
  }
  
  @PatchMapping(value = "/${obj.name}/modify", produces = MediaType.APPLICATION_JSON_VALUE + ";charset=utf-8")
  public RestResult modify${java.nameType(obj.name)}(@RequestBody ${typename}Query query) {
    try {
      ${typename}Query data = ${varname}Service.modify${java.nameType(obj.name)}(query);
      return new RestResult(data.toMap());
    } catch (Throwable cause) {
      TRACER.error(cause.getMessage(), cause);
      return error(cause);
    }
  }
  
  @GetMapping(value = "/${obj.name}/read", produces = MediaType.APPLICATION_JSON_VALUE + ";charset=utf-8")
  public RestResult read${java.nameType(obj.name)}(${typename}Query query) {
    try {
      ${typename}Query data = ${varname}Service.read${java.nameType(obj.name)}(query);
      return new RestResult(data.toMap());
    } catch (Throwable cause) {
      TRACER.error(cause.getMessage(), cause);
      return error(cause);
    }
  }
  
  @PostMapping(value = "/${obj.name}/aggregate", produces = MediaType.APPLICATION_JSON_VALUE + ";charset=utf-8")
  public RestResult aggregate${java.nameType(obj.name)}(${typename}Query query) {
    try {
      Pagination<${typename}Query> page = ${varname}Service.aggregate${java.nameType(obj.name)}(query);
      RestResult retVal = new RestResult();
      retVal.setTotal(page.getTotal());
      List<Map<String,Object>> rows = new ArrayList<>();
      for (${typename}Query item : page.getData()) {
        rows.add(item.toMap());
      }
      retVal.setData(rows);
      return retVal;
    } catch (Throwable cause) {
      TRACER.error(cause.getMessage(), cause);
      return error(cause);
    }
  }
  
  @PostMapping(value = "/${obj.name}/find", produces = MediaType.APPLICATION_JSON_VALUE + ";charset=utf-8")
  public RestResult find${java.nameType(inflector.pluralize(obj.name))}(@RequestBody ${typename}Query query) {
    try {
      Pagination<${typename}Query> page = ${varname}Service.find${java.nameType(inflector.pluralize(obj.name))}(query);
      RestResult retVal = new RestResult();
      retVal.setTotal(page.getTotal());
      List<Map<String,Object>> rows = new ArrayList<>();
      for (${typename}Query item : page.getData()) {
        rows.add(item.toMap());
      }
      retVal.setData(rows);
      return retVal;
    } catch (Throwable cause) {
      TRACER.error(cause.getMessage(), cause);
      return error(cause);
    }
  }
  
  @DeleteMapping(value = "/${obj.name}/delete", produces = MediaType.APPLICATION_JSON_VALUE + ";charset=utf-8")
  public RestResult delete${java.nameType(obj.name)}(@RequestBody ${typename}Query query) {
    try {
      ${varname}Service.delete${java.nameType(obj.name)}(query);
      return new RestResult();
    } catch (Throwable cause) {
      TRACER.error(cause.getMessage(), cause);
      return error(cause);
    }
  }
<#list obj.attributes as attr>
  <#if !attr.type.collection><#continue></#if>
  <#assign singular = attr.getLabelledOptions("name")["singular"]!attr.type.componentType.name>
  <#assign collObj = model.findObjectByName(attr.type.componentType.name)>
  <#assign collObjIdAttrs = modelbase.get_id_attributes(collObj)>
  <#assign collObjIdAttrs = modelbase.get_id_attributes(collObj)>
  <#assign collTargetAttr = attr.directRelationship.targetAttribute>
  <#assign one2many = false>
  <#list collObj.attributes as collObjAttr>
    <#if collObjAttr.type.name == obj.name>
      <#assign one2many = true>
      <#break>
    </#if>
  </#list>
  <#if one2many == false>
    <#assign collObj = model.findObjectByName(attr.getLabelledOptions("conjunction")["name"])>
    <#assign collObjIdAttrs = modelbase.get_id_attributes(collObj)>
  </#if>
  
  @PostMapping(value = "/${obj.name}/${singular}/add", produces = MediaType.APPLICATION_JSON_VALUE + ";charset=utf-8")  
  public RestResult add${java.nameType(singular)}(@RequestBody ${java.nameType(collObj.name)}Query query) {
    try {
      ${java.nameType(collObj.name)}Query res = ${varname}Service.add${java.nameType(singular)}(query);
      return new RestResult(res.toMap());
    } catch (Throwable cause) {
      return error(cause);
    }
  }
   
  @DeleteMapping(value = "/${obj.name}/${singular}/remove", produces = MediaType.APPLICATION_JSON_VALUE + ";charset=utf-8")  
  public RestResult remove${java.nameType(singular)}(@RequestBody ${java.nameType(collObj.name)}Query query) {
    try {
      ${java.nameType(collObj.name)}Query res = ${varname}Service.remove${java.nameType(singular)}(query);
      return new RestResult(res.toMap());
    } catch (Throwable cause) {
      TRACER.error(cause.getMessage(), cause);
      return error(cause);
    }
  }
  
  @DeleteMapping(value = "/${obj.name}/${singular}/clear", produces = MediaType.APPLICATION_JSON_VALUE + ";charset=utf-8")  
  public RestResult clear${java.nameType(inflector.pluralize(singular))}(@RequestBody ${java.nameType(obj.name)}Query query) {
    try {
      ${varname}Service.clear${java.nameType(attr.name)}(query);
      return new RestResult();
    } catch (Throwable cause) {
      TRACER.error(cause.getMessage(), cause);
      return error(cause);
    }
  }

  @GetMapping(value = "/${obj.name}/${singular}/get", produces = MediaType.APPLICATION_JSON_VALUE + ";charset=utf-8")  
  public RestResult get${java.nameType(inflector.pluralize(singular))}(${java.nameType(obj.name)}Query query) {
    try {
      List<${java.nameType(collObj.name)}Query> data = ${varname}Service.get${java.nameType(attr.name)}(query);
      List<Map<String,Object>> rows = new ArrayList<>();
      for (${java.nameType(collObj.name)}Query item : data) {
        rows.add(item.toMap());
      }
      return new RestResult(rows);
    } catch (Throwable cause) {
      TRACER.error(cause.getMessage(), cause);
      return error(cause);
    }
  }
</#list>  
  
}
