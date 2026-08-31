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

public class ${java.nameType(obj.name)}XlsxReader {
  
  public List<${java.nameType(obj.name)}Query> read${java.nameType(modelbase.get_object_plural(obj))}FromXlsx(File file) throws IOException {
    return read${java.nameType(modelbase.get_object_plural(obj))}FromXlsx(new FileInputStream(file));
  }

  public List<${java.nameType(obj.name)}Query> read${java.nameType(modelbase.get_object_plural(obj))}FromXlsx(String filePath) throws IOException {
    return read${java.nameType(modelbase.get_object_plural(obj))}FromXlsx(new FileInputStream(filePath));
  }

  public List<${java.nameType(obj.name)}Query> read${java.nameType(modelbase.get_object_plural(obj))}FromXlsx(InputStream input) throws IOException {
    List<${java.nameType(obj.name)}Query> retVal = new ArrayList<>();
    Workbook workbook = WorkbookFactory.create(input);
    Sheet sheet = workbook.getSheetAt(0);
    for (int r = 0; r <= sheet.getLastRowNum(); r++) {
      Row row = sheet.getRow(r);
      if (row == null) continue;
      int cellIndex = 0;
      Cell cell;
      Object value;
      if (r > 0) {
        ${java.nameType(obj.name)}Query ${java.nameVariable(obj.name)} = new ${java.nameType(obj.name)}Query();
        <#list obj.attributes as attr>
          <#assign attrTypeName = modelbase4java.type_attribute_primitive(attr)>  
        cell = row.getCell(cellIndex);
        value = getCellValue(cell);
        ${java.nameVariable(obj.name)}.${modelbase4java.name_setter(attr)}(Safe.safe(value, ${attrTypeName}.class));
        </#list>
      
        retVal.add(${java.nameVariable(obj.name)});
      }
    }
    return retVal;
  }

  public static Object getCellValue(Cell cell) {
    if (cell == null) {
      return null;
    }

    switch (cell.getCellType()) {
      case STRING:
        return cell.getStringCellValue();
      case NUMERIC:
        if (DateUtil.isCellDateFormatted(cell)) {
          return cell.getDateCellValue();
        }
        return cell.getNumericCellValue();
      case BOOLEAN:
        return cell.getBooleanCellValue();
      case FORMULA:
        return getFormulaResultValue(cell);
      case BLANK:
        return null;
      case ERROR:
        return cell.getErrorCellValue();
      default:
        return null;
    }
  }

  private static Object getFormulaResultValue(Cell cell) {
    switch (cell.getCachedFormulaResultType()) {
      case STRING:
        return cell.getStringCellValue();
      case NUMERIC:
        if (DateUtil.isCellDateFormatted(cell)) {
          return cell.getDateCellValue();
        }
        return cell.getNumericCellValue();
      case BOOLEAN:
        return cell.getBooleanCellValue();
      case ERROR:
        return cell.getErrorCellValue();
      default:
        return null;
    }
  }

}