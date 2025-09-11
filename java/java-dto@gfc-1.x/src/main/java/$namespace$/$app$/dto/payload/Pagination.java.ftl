<#import "/$/modelbase.ftl" as modelbase>
<#import "/$/modelbase4java.ftl" as modelbase4java>
<#if license??>
${java.license(license)}
</#if>
package ${namespace}.${app.name}.dto.payload;

import java.util.ArrayList;
import java.util.List;

/**
 * It's the paged result object.
 *
 * @author <a href="mailto:guo.guo.gan@gmail.com">Christian Gann</a>
 *
 * @since 1.0
 */
public class Pagination<T> {

  /**
   * the total number.
   */
  private long total;

  /**
   * the data for the current page.
   */
  private final List<T> data = new ArrayList<>();

  /**
   * Gets the total number.
   * 
   * @return the total number
   */
  public long getTotal() {
    return total;
  }

  /**
   * Sets the total number.
   * 
   * @param total
   *            the total number
   */
  public void setTotal(long total) {
    this.total = total;
  }

  /**
   * Gets the data for the current page.
   * 
   * @return the data
   */
  public List<T> getData() {
    return data;
  }

}