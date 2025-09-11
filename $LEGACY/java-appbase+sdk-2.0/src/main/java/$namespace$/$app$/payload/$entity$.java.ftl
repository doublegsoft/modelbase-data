<#import '/$/modelbase.ftl' as modelbase>
<#if license??>
${java.license(license)}
</#if>
package <#if namespace??>${namespace}.</#if>${app.name}.payload;

import java.sql.Date;
import java.sql.Timestamp;
import java.util.List;
import java.util.ArrayList;
import java.util.Map;
import java.util.HashMap;
import java.math.BigDecimal;
import java.io.StringWriter;
import java.io.Serializable;
import java.io.InputStream;

import javax.xml.bind.JAXBContext;  
import javax.xml.bind.Marshaller;  
import javax.xml.bind.JAXBException;  
import javax.xml.bind.annotation.XmlElement;  
import javax.xml.bind.annotation.XmlRootElement;
import javax.xml.bind.annotation.XmlAnyElement;
import javax.xml.bind.annotation.adapters.XmlJavaTypeAdapter;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.annotation.JSONField;

import <#if namespace??>${namespace}.</#if>${app.name}.XmlDateAdapter;

<#list imports as imp>
import ${imp}.payload.*;
</#list>

<#assign idAttrs = modelbase.get_id_attributes(entity)>
<#assign entityId = idAttrs[0]>
<#assign label = modelbase.get_object_label(entity)>
/**
 * ${label}数据载体封装。
 *
 * @author <a href="mailto:guo.guo.gan@gmail.com">Christian Gann</a>
 *
 * @since 1.0.0
 */
@XmlRootElement
public class ${java.nameType(entity.name)} implements Serializable {

  private static final long serialVersionUID = -1L;
  
<#assign duplicated = {}>
<#list entity.attributes as attr>
	<#if attr.constraint.identifiable || modelbase.is_attribute_system(attr)><#continue></#if>
  /**
   * ${modelbase.get_attribute_label(attr)}.
   */
  <#assign defaultValue = modelbase.get_attribute_default_value(attr)>
  <#if attr.name == 'id' || attr.name == 'name' || attr.name == 'type' || attr.name == 'code' || attr.name == 'text'>
  @JSONField(name="${modelbase.get_attribute_sql_name(attr)}")
  </#if>
  <#if attr.type.collection>
		<#assign refObj = model.findObjectByName(attr.type.componentType.name)>
  	<#assign duplicated = duplicated + {refObj.name: refObj}>
  </#if>
  private <#if attr.type.collection || attr.type.name == 'json'>final </#if>${modelbase.type_attribute(attr)} ${java.nameVariable(attr.name)}<#if defaultValue != ''> = ${defaultValue}</#if>;

</#list>
<#-- 反向关联 -->
<#list model.objects as obj>
	<#if !obj.persistenceName?? || obj.isLabelled('conjunction')><#continue></#if>
	<#list obj.attributes as attr>
		<#if attr.type.name == entity.name>
			<#--
			<#list entity.attributes as attrThis>
				<#if attrThis.type.collection && attrThis.type.componentType.name == obj.name>
					<#assign duplicated = duplicated + {obj.name: obj}>
					<#break>
				</#if>
			</#list>
			-->
			<#if !duplicated[obj.name]??>
				<#assign duplicated = duplicated + {obj.name: obj}>
	/**
	 * ${modelbase.get_object_label(obj)}.
	 */
	private final List<${java.nameType(obj.name)}> ${java.nameVariable(modelbase.get_object_plural(obj))} = new ArrayList<>();
	
			</#if>
		</#if>
	</#list>
</#list>
<#assign implicitReferences = modelbase.get_object_implicit_references(entity)>
<#list implicitReferences as implicitReferenceName, implicitReference>
	<#if implicitReferenceName == 'modifier'><#continue></#if>
	/**
   * ${modelbase.get_attribute_label(implicitReference['id'])}.
   */
  private Object ${java.nameVariable(implicitReferenceName)};

</#list>

<#assign duplicated = {}>
<#list entity.attributes as attr>
	<#if attr.constraint.identifiable || modelbase.is_attribute_system(attr)><#continue></#if>
	<#if attr.type.custom>
	@XmlElement(name="${java.nameVariable(attr.name)}")
	<#else>
	@XmlElement(name="${modelbase.get_attribute_sql_name(attr)}")
	</#if>
	<#if attr.type.name == 'date' || attr.type.name == 'datetime'>
	@XmlJavaTypeAdapter(XmlDateAdapter.class)
	</#if>
	<#if attr.type.collection>
		<#assign refObj = model.findObjectByName(attr.type.componentType.name)>
  	<#assign duplicated = duplicated + {refObj.name: refObj}>
  </#if>
  public ${modelbase.type_attribute(attr)} get${java.nameType(attr.name)}() {
    return ${java.nameVariable(attr.name)};
  }

  <#if !attr.type.collection && attr.type.name != 'json'>
  public void set${java.nameType(attr.name)}(${modelbase.type_attribute(attr)} ${java.nameVariable(attr.name)}) {
    this.${java.nameVariable(attr.name)} = ${java.nameVariable(attr.name)};
  }

  </#if>
</#list>
<#list implicitReferences as implicitReferenceName, implicitReference>
	<#if implicitReferenceName == 'modifier'><#continue></#if>
	@XmlAnyElement(lax=true)
  public Object get${java.nameType(implicitReferenceName)}() {
    return ${java.nameVariable(implicitReferenceName)};
  }

  public void set${java.nameType(implicitReferenceName)}(Object ${java.nameVariable(implicitReferenceName)}) {
    this.${java.nameVariable(implicitReferenceName)} = ${java.nameVariable(implicitReferenceName)};
  }

</#list>
<#-- 反向关联 -->
<#list model.objects as obj>
	<#if !obj.persistenceName?? || obj.isLabelled('conjunction')><#continue></#if>
	<#list obj.attributes as attr>
		<#if attr.type.name == entity.name>
			<#--
			<#list entity.attributes as attrThis>
				<#if attrThis.type.collection && attrThis.type.componentType.name == obj.name>
					<#assign duplicated = duplicated + {obj.name: obj}>
					<#break>
				</#if>
			</#list>
			-->
			<#if !duplicated[obj.name]??>
				<#assign duplicated = duplicated + {obj.name: obj}>
	@XmlElement(name="${java.nameVariable(modelbase.get_object_plural(obj))}")
	public List<${java.nameType(obj.name)}> get${java.nameType(modelbase.get_object_plural(obj))}() {
		return ${java.nameVariable(modelbase.get_object_plural(obj))};
	}
	
			</#if>
		</#if>
	</#list>
</#list>
  
  public String toXML() throws JAXBException {
  	List<Class> classes = new ArrayList<>();
  	classes.add(${java.nameType(entity.name)}.class);
<#list implicitReferences as implicitReferenceName, implicitReference>
	<#if implicitReferenceName == 'modifier'><#continue></#if>
		if (${java.nameVariable(implicitReferenceName)} != null) {
			classes.add(${java.nameVariable(implicitReferenceName)}.getClass());
		}
</#list> 
  	JAXBContext context = JAXBContext.newInstance(classes.toArray(new Class[classes.size()]));  
  
    Marshaller marshaller = context.createMarshaller();  
    marshaller.setProperty(Marshaller.JAXB_FORMATTED_OUTPUT, true);  
    
    StringWriter sw = new StringWriter();
    marshaller.marshal(this, sw);  
    return sw.toString();
  }
  
  public String toJSON() {
  	return JSON.toJSONString(this);
  }
}
