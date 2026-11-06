<#import '/$/modelbase.ftl' as modelbase>
<#import "/$/modelbase4java.ftl" as modelbase4java>
<#if license??>
${java.license(license)}
</#if>
<#assign obj = xlsx>
<#assign className = java.nameType(obj.name) + "XlsxWriter">
<#assign queryClass = java.nameType(obj.name) + "Query">
<#assign pluralMethod = java.nameType(modelbase.get_object_plural(obj))>
package ${namespace}.${java.nameNamespace(app.name)}.support.document;

import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.util.List;

import ${namespace}.${java.nameNamespace(app.name)}.dto.payload.${queryClass};

/**
 * ${obj.name} Excel 导出组件
 */
public class ${className} {

  /**
   * 将 ${obj.name} 数据列表导出为 Excel 二进制字节数组
   *
   * @param sheetName 工作表名称，为 null 时默认为 "Sheet1"
   * @param data      待导出的数据集合
   * @return Excel 文件的二进制字节流 (byte[])
   * @throws IOException IO 操作异常
   */
  public byte[] write${pluralMethod}ToXlsx(String sheetName, List<${queryClass}> data) throws IOException {
    try (Workbook workbook = new XSSFWorkbook();
         ByteArrayOutputStream out = new ByteArrayOutputStream()) {

      Sheet sheet = workbook.createSheet(sheetName != null && !sheetName.trim().isEmpty() ? sheetName : "Sheet1");

      // 1. 初始化常用样式
      CellStyle headerStyle = workbook.createCellStyle();
      Font headerFont = workbook.createFont();
      headerFont.setBold(true);
      headerStyle.setFont(headerFont);

      // 日期格式化样式 (yyyy-MM-dd HH:mm:ss)
      CellStyle dateCellStyle = workbook.createCellStyle();
      CreationHelper createHelper = workbook.getCreationHelper();
      dateCellStyle.setDataFormat(createHelper.createDataFormat().getFormat("yyyy-MM-dd HH:mm:ss"));

      // 2. 动态生成表头行
      Row headerRow = sheet.createRow(0);
      int cellIndex = 0;
<#list obj.attributes as attr>
  <#if attr.type.collection || attr.type.custom><#continue></#if>
  <#if attr.constraint.domainType.name?starts_with("strings") || attr.constraint.domainType.name?starts_with("{")><#continue></#if>
      Cell headerCell${attr_index} = headerRow.createCell(cellIndex++);
        <#-- 优先取字段注释或标签，如果没有则回退为字段名 -->
  <#if attr.comment?? && attr.comment?has_content>
      headerCell${attr_index}.setCellValue("${attr.comment}");
  <#elseif attr.label?? && attr.label?has_content>
      headerCell${attr_index}.setCellValue("${attr.label}");
  <#else>
      headerCell${attr_index}.setCellValue("${modelbase.get_attribute_sql_name(attr)}");
  </#if>
      headerCell${attr_index}.setCellStyle(headerStyle);
</#list>

      // 3. 动态写入数据行
      int rowIdx = 1;
      Cell cell = null;
      if (data != null && !data.isEmpty()) {
        for (${queryClass} item : data) {
          if (item == null) {
            continue;
          }
          Row row = sheet.createRow(rowIdx++);
          cellIndex = 0;
<#list obj.attributes as attr>
  <#if attr.type.collection || attr.type.custom><#continue></#if>
  <#if attr.constraint.domainType.name?starts_with("strings") || attr.constraint.domainType.name?starts_with("{")><#continue></#if>
  <#assign attrType = modelbase4java.type_attribute_primitive(attr)?lower_case>
  <#assign getter = modelbase4java.name_getter(attr)>
          // 列 ${attr_index}: ${attr.name}
          cell = row.createCell(cellIndex++);
          if (item.${getter}() != null) {
  <#if attrType?contains("int") || attrType?contains("long") || attrType?contains("short") || attrType?contains("double") || attrType?contains("float") || attrType?contains("decimal") || attrType?contains("number")>
            cell.setCellValue(((Number) item.${getter}()).longValue());
  <#elseif attrType?contains("bool")>
            cell.setCellValue(item.${getter}());
  <#elseif attrType?contains("date") || attrType?contains("time")>
            cell.setCellValue(item.${getter}());
            cell.setCellStyle(dateCellStyle);
  <#else>
            cell.setCellValue(String.valueOf(item.${getter}()));
  </#if>
          } else {
            cell.setCellValue("");
          }
</#list>
        }
      }

      // 4. 自适应列宽
<#list obj.attributes as attr>
      sheet.autoSizeColumn(${attr_index});
</#list>

      // 5. 写入内存流并返回
      workbook.write(out);
      return out.toByteArray();
    }
  }
}