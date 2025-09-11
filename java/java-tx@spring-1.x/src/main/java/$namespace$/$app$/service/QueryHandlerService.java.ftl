<#import '/$/modelbase.ftl' as modelbase>
<#if license??>
${java.license(license)}
</#if>
package <#if namespace??>${namespace}.</#if>${app.name}.service;

import <#if namespace??>${namespace}.</#if>${app.name}.dto.assembler.QueryHandlerAssembler;
import <#if namespace??>${namespace}.</#if>${app.name}.dto.payload.*;
import <#if namespace??>${namespace}.</#if>${app.name}.util.Inflector;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.stereotype.Component;
import org.springframework.beans.factory.annotation.*;
import org.springframework.transaction.annotation.*;
import org.springframework.stereotype.*;

import java.lang.reflect.Method;
import java.util.List;
import java.util.ArrayList;
import java.util.Map;
import java.util.HashMap;

@Component
public class QueryHandlerService {

  @Autowired
  private ApplicationContext applicationContext;

  public <T> T getBean(Class<T> klass) {
    return applicationContext.getBean(klass);
  }

  public ApplicationContext getApplicationContext() {
    return applicationContext;
  }
  
  @Transactional(rollbackFor = Throwable.class)
  public void transact(AbstractQuery query) throws ServiceException {
    List<QueryHandler> queryHandlers = query.getQueryHandlers();
    for (QueryHandler queryHandler : queryHandlers) {
      String handler = queryHandler.getHandler();
      if (handler.startsWith("||")) {
        String sourceField = queryHandler.getSourceField();
        String targetField = queryHandler.getTargetField();
        String[] strs = handler.substring(2).split("/");
        String methodName = strs[1] + QueryHandlerAssembler.toPascalCase(strs[0]);
        String getSourceMethodName = null;
        Method getSourceMethod = null;
        try {
          if (sourceField != null && targetField != null) {
            getSourceMethodName = "get" + sourceField.substring(0,1).toUpperCase() + sourceField.substring(1);
            getSourceMethod = query.getClass().getMethod(getSourceMethodName);
          }
          String objname = QueryHandlerAssembler.toPascalCase(strs[0]);
          Class serviceClass = Class.forName("<#if namespace??>${namespace}.</#if>${app.name}.service." + objname + "Service");
          Class queryClass = Class.forName("<#if namespace??>${namespace}.</#if>${app.name}.dto.payload." + objname + "Query");
          Class assemblerClass = Class.forName("<#if namespace??>${namespace}.</#if>${app.name}.dto.assembler." + objname + "QueryAssembler");
          Method assemblerMethod = assemblerClass.getMethod("assemble"+ objname + "Query", Map.class);
          Method serviceMethod = serviceClass.getMethod(methodName, queryClass);
          Method serviceBatchMethod = serviceClass.getMethod(Inflector.getInstance().pluralize(methodName), List.class);
          Object bean = getBean(serviceClass);
          if (queryHandler.getQueries() != null && queryHandler.getQueries().size() > 0) {
            List ps = new ArrayList();
            for (Map<String,Object> q : queryHandler.getQueries()) {
              if (sourceField != null && targetField != null) {
                Object v = getSourceMethod.invoke(query);
                q.put(targetField, v);
              }
              ps.add(assemblerMethod.invoke(null, q));
            }
            serviceBatchMethod.invoke(bean, ps);
          } else {
            serviceMethod.invoke(bean, assemblerMethod.invoke(null, queryHandler.getQuery()));
          }
        } catch (Throwable cause) {
          throw new ServiceException(500, cause);
        }
      }
    }
  }
  
  public void conjunct(List results, AbstractQuery query) {

  }
  
  public void hierarchize(List results, AbstractQuery query) throws ServiceException {
    List<QueryHandler> queryHandlers = query.getQueryHandlers();
    for (QueryHandler queryHandler : queryHandlers) {
      String handler = queryHandler.getHandler();
      if (handler.startsWith("//")) {
        String[] strs = handler.substring(2).split("/");
        String objname = QueryHandlerAssembler.toPascalCase(strs[0]);
        String sourceField = queryHandler.getSourceField();
        String targetField = queryHandler.getTargetField();
        String resultName = queryHandler.getResultName();
        String methodName = strs[1] + QueryHandlerAssembler.toPascalCase(strs[0]);
        methodName = Inflector.getInstance().pluralize(methodName);
        String addMethodName = "add" + targetField.substring(0,1).toUpperCase() + targetField.substring(1);
        String getSourceMethodName = "get" + sourceField.substring(0,1).toUpperCase() + sourceField.substring(1);
        String getTargetMethodName = "get" + targetField.substring(0,1).toUpperCase() + targetField.substring(1);
        try {
          Class serviceClass = Class.forName("<#if namespace??>${namespace}.</#if>${app.name}.service." + objname + "Service");
          Class queryClass = Class.forName("<#if namespace??>${namespace}.</#if>${app.name}.dto.payload." + objname + "Query");
          Class assemblerClass = Class.forName("<#if namespace??>${namespace}.</#if>${app.name}.dto.assembler." + objname + "QueryAssembler");
          Method serviceMethod = serviceClass.getMethod(methodName, queryClass);
          Method assemblerMethod = assemblerClass.getMethod("assemble"+ objname + "Query", Map.class);
          Method addMethod = queryClass.getMethod(addMethodName, Long.class);
          Method getSourceMethod = query.getClass().getMethod(getSourceMethodName);
          Method getTargetMethod = queryClass.getMethod(getTargetMethodName);
          AbstractQuery q = (AbstractQuery) assemblerMethod.invoke(null, queryHandler.getQuery());
          q.setLimit(-1);
          for (Object row : results) {
            Object val = getSourceMethod.invoke(row);
            addMethod.invoke(q, val);
          }
          Object bean = getBean(serviceClass);
          Pagination page = (Pagination)serviceMethod.invoke(bean, q);
          for (Object res : results) {
            for (Object row : page.getData()) { 
              Object s1 = getSourceMethod.invoke(res);
              Object t1 = getTargetMethod.invoke(row);
              if (s1 != null && t1 != null && s1.equals(t1)) {
                ((AbstractQuery)res).addResult(resultName, row);
              }
            }
          }
        } catch (Throwable cause) {
          throw new ServiceException(500, cause);
        }
      }
    }
  }
  
  public void hierarchize(AbstractQuery result, AbstractQuery query) throws ServiceException {
    List<QueryHandler> queryHandlers = query.getQueryHandlers();
    for (QueryHandler queryHandler : queryHandlers) {
      String handler = queryHandler.getHandler();
      if (handler.startsWith("//")) {
        String[] strs = handler.substring(2).split("/");
        String objname = QueryHandlerAssembler.toPascalCase(strs[0]);
        String sourceField = queryHandler.getSourceField();
        String targetField = queryHandler.getTargetField();
        String resultName = queryHandler.getResultName();
        String methodName = strs[1] + QueryHandlerAssembler.toPascalCase(strs[0]);
        methodName = Inflector.getInstance().pluralize(methodName);
        String addMethodName = "add" + targetField.substring(0,1).toUpperCase() + targetField.substring(1);
        String getSourceMethodName = "get" + sourceField.substring(0,1).toUpperCase() + sourceField.substring(1);
        String getTargetMethodName = "get" + targetField.substring(0,1).toUpperCase() + targetField.substring(1);
        try {
          Class serviceClass = Class.forName("biz.doublegsoft.smbiz.service." + objname + "Service");
          Class queryClass = Class.forName("biz.doublegsoft.smbiz.dto.payload." + objname + "Query");
          Class assemblerClass = Class.forName("biz.doublegsoft.smbiz.dto.assembler." + objname + "QueryAssembler");
          Method serviceMethod = serviceClass.getMethod(methodName, queryClass);
          Method assemblerMethod = assemblerClass.getMethod("assemble"+ objname + "Query", Map.class);
          Method addMethod = queryClass.getMethod(addMethodName, Long.class);
          Method getSourceMethod = query.getClass().getMethod(getSourceMethodName);
          Method getTargetMethod = queryClass.getMethod(getTargetMethodName);
          AbstractQuery q = (AbstractQuery) assemblerMethod.invoke(null, queryHandler.getQuery());
          q.setLimit(-1);
          Object val = getSourceMethod.invoke(result);
          addMethod.invoke(q, val);
          Object bean = getBean(serviceClass);
          Pagination page = (Pagination)serviceMethod.invoke(bean, q);
          for (Object row : page.getData()) {
            Object s1 = getSourceMethod.invoke(result);
            Object t1 = getTargetMethod.invoke(row);
            if (s1 != null && t1 != null && s1.equals(t1)) {
              result.addResult(resultName, row);
            }
          }
        } catch (Throwable cause) {
          throw new ServiceException(500, cause);
        }
      }
    }
  }

}
