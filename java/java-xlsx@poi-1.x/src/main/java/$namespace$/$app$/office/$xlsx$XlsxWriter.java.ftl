<#import '/$/modelbase.ftl' as modelbase>
<#import "/$/modelbase4java.ftl" as modelbase4java>
<#if license??>
${java.license(license)}
</#if>
<#assign obj = xlsx>
package ${namespace}.${java.nameNamespace(app.name)}.office;

import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.*;

import java.io.*;
import java.util.*;

import ${namespace}.${java.nameNamespace(app.name)}.util.*;
import ${namespace}.${java.nameNamespace(app.name)}.dto.payload.*;

public class ${java.nameType(obj.name)}XlsxWriter {

  public byte[] write${java.nameType(modelbase.get_object_plural(obj))}ToXlsx(String sheetName, List<${java.nameType(obj.name)}Query> data) throws IOException {
    try (Workbook workbook = new XSSFWorkbook()) {
      Sheet sheet = workbook.createSheet(sheetName);

      Row headerRow = sheet.createRow(0);
      String[] headers = {"用户ID", "用户名", "电子邮箱"};
      for (int i = 0; i < headers.length; i++) {
        Cell cell = headerRow.createCell(i);
        cell.setCellValue(headers[i]);
      }

      int rowNum = 1;
      <#--  for (User user : users) {
        Row row = sheet.createRow(rowNum++);
        
        Cell cell0 = row.createCell(0);
        cell0.setCellValue(user.getId());

        // 写入用户名 (字符串)
        Cell cell1 = row.createCell(1);
        cell1.setCellValue(user.getName());

        // 写入电子邮箱 (字符串)
        Cell cell2 = row.createCell(2);
        cell2.setCellValue(user.getEmail());
      }  -->
      for (int i = 0; i < headers.length; i++) {
        sheet.autoSizeColumn(i);
      }
    }
    return null;
  }

}