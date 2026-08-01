<#import '/$/modelbase.ftl' as modelbase>
<#import '/$/modelbase4java.ftl' as modelbase4java>
<#if license??>
${java.license(license)}
</#if>
<#assign obj = composite>
package <#if namespace??>${namespace}.</#if>${app.name}.dao;

import java.util.List;
import java.util.ArrayList;
import java.util.Map;
import java.util.HashMap;
import java.math.BigDecimal;
import java.io.Serializable;
import java.sql.Date;
import java.sql.Timestamp;

import org.apache.ibatis.session.RowBounds;
import org.apache.ibatis.annotations.*;

import <#if namespace??>${namespace}.</#if>${app.name}.poco.*;
import <#if namespace??>${namespace}.</#if>${app.name}.dto.payload.*;

/**
 * 【${modelbase.get_object_label(composite)}】合成对象的装配器。
 *
 * @since ${version}
 */
@Mapper 
public interface ${java.nameType(composite.name)}DataAccess {
  
  List<${java.nameType(composite.name)}Query> select${java.nameType(composite.name)}Query(${java.nameType(composite.name)}Query query, RowBounds rowBounds);
  
}
