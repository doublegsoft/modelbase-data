<#import "/$/modelbase.ftl" as modelbase>
<#import "/$/modelbase4java.ftl" as modelbase4java>
<#if license??>
${java.license(license)}
</#if>
package ${namespace}.${app.name}.dto.payload;

import java.util.List;
import java.util.Map;
import java.util.ArrayList;
import java.util.Collections;

/*!
** 
*/
public class QueryHandler {
  
  protected String handler;
  
  protected AbstractQuery query;
  
  protected List<AbstractQuery> queries;
  
  protected String resultName;
  
  protected String sourceField;
  
  protected String targetField;

  protected List<String> sourceFields;
  
  protected List<String> targetFields;
  
  public String getHandler() {
    return this.handler;
  }
  
  public void setHandler(String handler) {
    this.handler = handler;
  }
  
  
  public AbstractQuery getQuery() {
    return query;
  }
  
  public void setQuery(AbstractQuery query) {
    this.query = query;
  }
  
  public List<AbstractQuery> getQueries() {
    return queries;
  }
  
  public void setQueries(List<AbstractQuery> queries) {
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

  public List<String> getSourceFields() {
    if (this.sourceFields == null) {
      return Collections.emptyList();
    } 
    return this.sourceFields;
  }
  
  public void setSourceFields(List<String> sourceFields) {
    this.sourceFields = sourceFields;
  }
  
  public List<String> getTargetFields() {
    if (this.targetFields == null) {
      return Collections.emptyList();
    } 
    return this.targetFields;
  }
  
  public void setTargetFields(List<String> targetFields) {
    this.targetFields = targetFields;
  }
  
}