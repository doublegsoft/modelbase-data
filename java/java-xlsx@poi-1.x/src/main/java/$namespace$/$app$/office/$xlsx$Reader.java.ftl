<#import '/$/modelbase.ftl' as modelbase>
<#import '/$/modelbase4java.ftl' as modelbase4java>
<#if license??>
${java.license(license)}
</#if>
<#assign typeDef = objectConstructor("com.doublegsoft.jcommons.metacode.TypeDefinition", obj, model)>
<#assign rootObj = typeDef.definition>
<#assign flow = typeDef.flow>
<#assign idAttrs = typeDef.getIdentifiableAttributes()>
<#assign existings = {}>
package <#if namespace??>${namespace}.</#if>${app.name}.service.impl;

import org.apache.poi.ss.usermodel.*;
import java.io.File;
import java.io.IOException;

public class ExcelReaderExample {

  public List<${java.nameType(rootObj.name)}Query> parse(InputStream input) throws IOException {
    List<${java.nameType(rootObj.name)}Query> retVal = new ArrayList<>();
    try (Workbook workbook = WorkbookFactory.create(new File("employees.xlsx"))) {
      Sheet sheet = workbook.getSheetAt(0);

      // 遍历行和列
      for (Row row : sheet) {
        ${java.nameType(rootObj.name)}Query item = new ${java.nameType(rootObj.name)}Query();
        for (Cell cell : row) {
          switch (cell.getCellType()) {
            case STRING:
              System.out.print(cell.getStringCellValue() + "\t");
              break;
            case NUMERIC:
              if (DateUtil.isCellDateFormatted(cell)) {
                System.out.print(cell.getDateCellValue() + "\t");
              } else {
                System.out.print(cell.getNumericCellValue() + "\t");
              }
              break;
            case BOOLEAN:
              System.out.print(cell.getBooleanCellValue() + "\t");
              break;
            default:
              System.out.print("[Blank/Formula/Error]\t");
          }
        }
        System.out.println();
      }
    } catch (IOException e) {
      System.err.println("An error occurred: " + e.getMessage());
    }
    return retVal;
  }

  public static void main(String[] args) {
    try (Workbook workbook = WorkbookFactory.create(new File("employees.xlsx"))) {
      Sheet sheet = workbook.getSheetAt(0);

      // 遍历行和列
      for (Row row : sheet) {
        for (Cell cell : row) {
          switch (cell.getCellType()) {
            case STRING:
              System.out.print(cell.getStringCellValue() + "\t");
              break;
            case NUMERIC:
              if (DateUtil.isCellDateFormatted(cell)) {
                System.out.print(cell.getDateCellValue() + "\t");
              } else {
                System.out.print(cell.getNumericCellValue() + "\t");
              }
              break;
            case BOOLEAN:
              System.out.print(cell.getBooleanCellValue() + "\t");
              break;
            default:
              System.out.print("[Blank/Formula/Error]\t");
          }
        }
        System.out.println();
      }
    } catch (IOException e) {
      System.err.println("An error occurred: " + e.getMessage());
    }
  }
}