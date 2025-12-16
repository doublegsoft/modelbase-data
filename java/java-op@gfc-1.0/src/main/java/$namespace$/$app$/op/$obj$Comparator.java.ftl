<#import '/$/modelbase.ftl' as modelbase>
<#import '/$/modelbase4java.ftl' as modelbase4java>
<#if license??>
${java.license(license)}
</#if>
package ${namespace}.${app.name}.op;

public class ${java.nameType(obj.name)}Comparator { 

  /**
   * Compares two instances of ${java.nameType(obj.name)} and returns the list of changes.
   *
   * @param oldObj The persisted object (database state)
   * @param newObj The editing object (current state)
   * @return List of differences
   */
  public List<ChangeItem> compare${java.nameType(obj.name)}(${java.nameType(obj.name)} oldObj, ${java.nameType(obj.name)} newObj) {
    List<ChangeItem> changes = new ArrayList<>();
    
    if (oldObj == null || newObj == null) {
        return changes;
    }

<#list obj.attributes as attr>
  <#if attr.isLabelled("audit_ignore")><#continue></#if>
    // Check Field: ${attr.text!attr.name}
    {
      ${modelbase4java.type_attribute(attr)} oldVal = oldObj.get${attr.name?cap_first}();
      ${modelbase4java.type_attribute(attr)} newVal = newObj.get${attr.name?cap_first}();

      boolean isChanged = false;
      
  <#if attr.type.name == "BigDecimal">
      if (oldVal != null && newVal != null) {
        if (oldVal.compareTo(newVal) != 0) {
          isChanged = true;
        }
      } else if (oldVal != newVal) {
        isChanged = true;
      }
  <#else>
      if (!java.util.Objects.equals(oldVal, newVal)) {
        isChanged = true;
      }
  </#if>

      if (isChanged) {
        ChangeItem item = new ChangeItem();
        item.setField("${attr.name}");
        item.setFieldText("${attr.text!attr.name}");
        <#if attr.isLabelled("sensitive")>
        item.setOldValue("******");
        item.setNewValue("******");
        <#else>
        item.setOldValue(oldVal == null ? "" : String.valueOf(oldVal));
        item.setNewValue(newVal == null ? "" : String.valueOf(newVal));
        </#if>
          
        changes.add(item);
      }
    }
</#list>

    return changes;
  }

}