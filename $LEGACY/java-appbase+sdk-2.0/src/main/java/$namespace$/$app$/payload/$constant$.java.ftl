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

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.annotation.JSONField;

<#list imports as imp>
import ${imp}.payload.*;
</#list>

<#assign idAttrs = modelbase.get_id_attributes(constant)>
<#assign constantId = idAttrs[0]>
<#assign label = modelbase.get_object_label(constant)>
/**
 * ${label}数据载体封装。
 *
 * @author <a href="mailto:guo.guo.gan@gmail.com">Christian Gann</a>
 *
 * @since 1.0.0
 */
@XmlRootElement
public class ${java.nameType(constant.name)} implements Serializable {

  private static final long serialVersionUID = -1L;

<#list constant.attributes as attr>
	<#if modelbase.is_attribute_system(attr)><#continue></#if>
  /**
   * ${modelbase.get_attribute_label(attr)}.
   */
  <#assign defaultValue = modelbase.get_attribute_default_value(attr)>
  <#if attr.name == 'id' || attr.name == 'name' || attr.name == 'type' || attr.name == 'code' || attr.name == 'text'>
  @JSONField(name="${modelbase.get_attribute_sql_name(attr)}")
  </#if>
  private <#if attr.type.collection || attr.type.name == 'json'>final </#if>${modelbase.type_attribute(attr)} ${java.nameVariable(attr.name)}<#if defaultValue != ''> = ${defaultValue}</#if>;

</#list>
<#assign implicitReferences = modelbase.get_object_implicit_references(constant)>
<#list implicitReferences as implicitReferenceName, implicitReference>
	<#if implicitReferenceName == 'modifier'><#continue></#if>
	/**
   * ${modelbase.get_attribute_label(implicitReference['id'])}.
   */
  private Object ${java.nameVariable(implicitReferenceName)};

</#list>
<#list constant.attributes as attr>
	<#if modelbase.is_attribute_system(attr)><#continue></#if>
	<#if attr.type.custom>
	@XmlElement(name="${java.nameVariable(attr.name)}")
	<#else>
	@XmlElement(name="${modelbase.get_attribute_sql_name(attr)}")
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
	@XmlElement(name="${java.nameVariable(implicitReferenceName)}")
  public Object get${java.nameType(implicitReferenceName)}() {
    return ${java.nameVariable(implicitReferenceName)};
  }

  public void set${java.nameType(implicitReferenceName)}(Object ${java.nameVariable(implicitReferenceName)}) {
    this.${java.nameVariable(implicitReferenceName)} = ${java.nameVariable(implicitReferenceName)};
  }

</#list>
  
  public String toXML() throws JAXBException {
  	JAXBContext context = JAXBContext.newInstance(${java.nameType(constant.name)}.class);  
  
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
