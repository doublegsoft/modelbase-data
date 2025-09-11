<#import "/$/modelbase.ftl" as modelbase>
<#import "/$/modelbase4java.ftl" as modelbase4java>
<#if license??>
${java.license(license)}
</#if>
package ${namespace}.${app.name}.dto.payload;

import java.util.Map;
import java.util.HashMap;
import java.util.List;
import java.util.ArrayList;

/*!
** 查询DTO基类。
*/
public abstract class AbstractQuery {

  protected int start = 0;
  
  protected int limit = -1;
  
  protected final List<String> orderByList = new ArrayList<>();
  
  protected final List<String> groupByList = new ArrayList<>();
  
  protected final List<String> columnList = new ArrayList<>();
  
  protected final List<QueryHandler> queryHandlers = new ArrayList<>();
  
  protected final List<AbstractQuery> queries = new ArrayList<>();
  
  protected final Map<String,Object> results = new HashMap<>();
  
  public List<QueryHandler> getQueryHandlers() {
    return queryHandlers;
  }
  
  public List<AbstractQuery> getQueries() {
    return queries;
  }
  
  public List<String> getOrderByList() {
    return orderByList;
  }
  
  public List<String> getGroupByList() {
    return groupByList;
  }
  
  public List<String> getColumnList() {
    return columnList;
  }
  
  public int getStart() {
    return start;
  }
  
  public void setStart(int start) {
    this.start = start;
  }
  
  public int getLimit() {
    return limit;
  }
  
  public void setLimit(int limit) {
    this.limit = limit;
  }
  
  public void addResult(String name, Object val) {
    List arr = (List) results.get(name);
    if (arr == null) {
      arr = new ArrayList();
      results.put(name, arr);
    }
    arr.add(val);
  }
  
  public abstract Map<String,Object> toMap();
}