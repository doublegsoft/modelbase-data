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
 * ${label}集合数据载体封装。
 *
 * @author <a href="mailto:guo.guo.gan@gmail.com">Christian Gann</a>
 *
 * @since 1.0.0
 */
@XmlRootElement(name="${java.nameVariable(modelbase.get_object_plural(entity))}")
public class ${java.nameType(entity.name)}List implements Serializable {

  private static final long serialVersionUID = -1L;

  private final List<${java.nameType(entity.name)}> ${java.nameVariable(modelbase.get_object_plural(entity))} = new ArrayList<>();

	@XmlElement(name="${java.nameVariable(entity.name)}")
  public List<${java.nameType(entity.name)}> get${java.nameType(modelbase.get_object_plural(entity))}() {
    return ${java.nameVariable(modelbase.get_object_plural(entity))};
  }
  
  public String toXML() throws JAXBException {
  	JAXBContext context = JAXBContext.newInstance(${java.nameType(entity.name)}List.class);  
  
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
