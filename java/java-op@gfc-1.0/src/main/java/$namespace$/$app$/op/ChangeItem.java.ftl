<#import '/$/modelbase.ftl' as modelbase>
<#import '/$/modelbase4java.ftl' as modelbase4java>
<#if license??>
${java.license(license)}
</#if>
package ${namespace}.${app.name}.op;

import java.io.Serializable;

public class ChangeItem implements Serializable {

  private static final long serialVersionUID = 1L;

  /**
   * Logic name (e.g., "mobilePhone")
   */
  private String field;

  /**
   * Display name (e.g., "Mobile Number")
   */
  private String fieldText;

  /**
   * Previous value
   */
  private String oldValue;

  /**
   * Current value
   */
  private String newValue;

  public ChangeItem() {
  }

  public ChangeItem(String field, String fieldText, String oldValue, String newValue) {
    this.field = field;
    this.fieldText = fieldText;
    this.oldValue = oldValue;
    this.newValue = newValue;
  }

  public String getField() {
    return field;
  }

  public void setField(String field) {
    this.field = field;
  }

  public String getFieldText() {
    return fieldText;
  }

  public void setFieldText(String fieldText) {
    this.fieldText = fieldText;
  }

  public String getOldValue() {
    return oldValue;
  }

  public void setOldValue(String oldValue) {
    this.oldValue = oldValue;
  }

  public String getNewValue() {
    return newValue;
  }

  public void setNewValue(String newValue) {
    this.newValue = newValue;
  }

  @Override
  public String toString() {
    return "ChangeItem{" +
      "field='" + field + '\'' +
      ", fieldText='" + fieldText + '\'' +
      ", oldValue='" + oldValue + '\'' +
      ", newValue='" + newValue + '\'' +
      '}';
  }
}