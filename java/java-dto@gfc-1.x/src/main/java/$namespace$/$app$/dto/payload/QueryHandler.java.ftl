<#import "/$/modelbase.ftl" as modelbase>
<#import "/$/modelbase4java.ftl" as modelbase4java>
<#if license??>
${java.license(license)}
</#if>
package ${namespace}.${app.name}.dto.payload;

import java.util.List;
import java.util.Map;
import java.util.ArrayList;

/*!
** 
*/
public class QueryHandler {
  
  protected String handler;
  
  protected Map<String,Object> query;
  
  protected List<Map<String,Object>> queries;
  
  protected String resultName;
  
  protected String sourceField;
  
  protected String targetField;
  
  public String getHandler() {
    return this.handler;
  }
  
  public void setHandler(String handler) {
    this.handler = handler;
  }
  
  
  public Map<String,Object> getQuery() {
    return query;
  }
  
  public void setQuery(Map<String,Object> query) {
    this.query = query;
  }
  
  public List<Map<String,Object>> getQueries() {
    return queries;
  }
  
  public void setQueries(List<Map<String,Object>> queries) {
    this.queries = queries;
  }
  
  public String getResultName() {
    return this.resultName;
  }
  
  public void setResultName(String resultName) {
    this.resultName = resultName;
  }
  
  public String getSourceField() {
    return this.sourceField;
  }
  
  public void setSourceField(String sourceField) {
    this.sourceField = sourceField;
  }
  
  public String getTargetField() {
    return this.targetField;
  }
  
  public void setTargetField(String targetField) {
    this.targetField = targetField;
  }
  
}