<#import '/$/modelbase.ftl' as modelbase>
<#import "/$/modelbase4java.ftl" as modelbase4java>
<#if license??>
${java.license(license)}
</#if>
<#macro print_reference_assemble attr objname attrname indent>
  <#local refObj = model.findObjectByName(attr.type.name)>
  <#local idAttrs = modelbase.get_id_attributes(refObj)>
${""?left_pad(indent)}${java.nameType(refObj.name)} ${java.nameVariable(refObj.name)} = new ${java.nameType(refObj.name)}();
${""?left_pad(indent)}${objname}.set${java.nameType(attr.name)}(${java.nameVariable(refObj.name)});  
  <#if idAttrs[0].type.custom>
<@print_reference_assemble attr=idAttrs[0] objname=java.nameVariable(refObj.name) attrname=attrname indent=indent />  
  <#else>
${""?left_pad(indent)}${java.nameVariable(refObj.name)}.set${java.nameType(idAttrs[0].name)}(${attrname});  
  </#if>
</#macro>
package <#if namespace??>${namespace}.</#if>${app.name}.dto.assembler;

import java.util.List;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Map;
import java.util.HashMap;
import java.math.BigDecimal;
import java.io.Serializable;
import java.sql.Date;
import java.sql.Timestamp;
import java.lang.reflect.Method;

import <#if namespace??>${namespace}.</#if>${app.name}.dto.payload.*;

/**
 * 查询处理器实体各层对象的装配器。
 *
 * @author <a href="mailto:guo.guo.gan@gmail.com">Christian Gann</a>
 *
 * @since ${version}
 */
public final class QueryHandlerAssembler {

  /**
   * 从数据库存储的数据对象中装配查询处理器实体实体对象。
   *
   * @param handler
   *        处理方法的逻辑标识
   *
   * @param params
   *        数据库返回的行列对象
   *
   * @return 装配后的查询处理器实体实体对象
   */
  public static QueryHandler assembleQueryHandler(String handler, Map<String,Object> params) {
    QueryHandler retVal = new QueryHandler();
    retVal.setHandler(handler);
    String[] strs = handler.split("/");
    String objname = strs[strs.length - 2];
    AbstractQuery query = null;
    try {
      Class<?> clazz = Class.forName("<#if namespace??>${namespace}.</#if>${app.name}.dto.assembler." + toPascalCase(objname) + "QueryAssembler");
      Method method = clazz.getMethod("assemble" + toPascalCase(objname) + "Query", Map.class);
      query = (AbstractQuery) method.invoke(null, params);
    } catch (Exception ex) {
      throw new IllegalArgumentException(ex);
    }
    for (String key : params.keySet()) {
      if (key.startsWith("||")) {
        QueryHandler handlerObj = assembleQueryHandler(key, (Map<String,Object>)params.get(key));
        query.getQueryHandlers().add(handlerObj);
      } else if (key.startsWith("//")) {
        QueryHandler handlerObj = assembleQueryHandler(key, (Map<String,Object>)params.get(key));
        query.getQueryHandlers().add(handlerObj);
      } else if (key.startsWith("<<")) {
        QueryHandler handlerObj = assembleQueryHandler(key, (Map<String,Object>)params.get(key));
        query.getQueryHandlers().add(handlerObj);
      } else {
        // nothing to do
      }
    }
    retVal.setQuery(query.toMap());
    return retVal;
  }
  
  public static List<QueryHandler> assembleQueryHandlers(String handler, Map<String,Object> params) {
    List<QueryHandler> retVal = new ArrayList<>();
    String[] strs = handler.split("/");
    String objname = strs[strs.length - 2];
    List<AbstractQuery> queries = null;
    try {
      Class<?> clazz = Class.forName("<#if namespace??>${namespace}.</#if>${app.name}.dto.assembler." + toPascalCase(objname) + "QueryAssembler");
      Method method = clazz.getMethod("assemble" + toPascalCase(objname) + "Queries", Map.class);
      queries = (List<AbstractQuery>) method.invoke(null, params);
    } catch (Exception ex) {
      throw new IllegalArgumentException(ex);
    }
    if (queries != null) {
      for (AbstractQuery query : queries) {
        QueryHandler handlerObj = new QueryHandler();
        handlerObj.setQuery(query.toMap());
        handlerObj.setHandler(handler);
        retVal.add(handlerObj);
      }
    }
    return retVal;
  }
  
  public static List<QueryHandler> extractQueryHandlers(Map<String,Object> params) {
    List<QueryHandler> retVal = new ArrayList<>();
    List<Map<String,Object>> queryHandlers = (List<Map<String,Object>>) params.get("queryHandlers");
    if (queryHandlers == null) {
      return retVal;
    }
    for (Map<String,Object> row : queryHandlers) {
      QueryHandler qh = new QueryHandler();
      qh.setHandler((String)row.get("handler"));
      qh.setSourceField((String)row.get("sourceField"));
      qh.setTargetField((String)row.get("targetField"));
      qh.setResultName((String)row.get("resultName"));
      qh.setQuery((Map<String,Object>)row.get("query"));
      qh.setQueries((List<Map<String,Object>>)row.get("queries"));
      retVal.add(qh);
    }
    return retVal;
  }
  
  public static String toPascalCase(String input) {
    if (input == null || input.isEmpty()) {
      return input;
    }
    String[] words = input.split("_");
    StringBuilder pascalCaseBuilder = new StringBuilder();

    for (String word : words) {
      if (word.isEmpty()) {
        continue;
      }
      // Capitalize the first letter and append the rest of the word
      pascalCaseBuilder.append(Character.toUpperCase(word.charAt(0)))
                       .append(word.substring(1).toLowerCase());
    }

    return pascalCaseBuilder.toString();
  }
  
  private QueryHandlerAssembler() {}
}
