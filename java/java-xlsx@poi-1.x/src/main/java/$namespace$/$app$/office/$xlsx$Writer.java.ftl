import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import java.io.FileOutputStream;
import java.io.IOException;

public class ExcelWriterExample {
  public static void main(String[] args) {
    // 创建工作簿
    try (Workbook workbook = new XSSFWorkbook()) {
      Sheet sheet = workbook.createSheet("Employee Data");

      // 创建表头
      Row headerRow = sheet.createRow(0);
      String[] columns = {"ID", "Name", "Department"};
      for (int i = 0; i < columns.length; i++) {
        Cell cell = headerRow.createCell(i);
        cell.setCellValue(columns[i]);
      }

      // 写入数据
      Row dataRow = sheet.createRow(1);
      dataRow.createCell(0).setCellValue(101);
      dataRow.createCell(1).setCellValue("Alice Smith");
      dataRow.createCell(2).setCellValue("Engineering");

      // 自动调整列宽
      for (int i = 0; i < columns.length; i++) {
        sheet.autoSizeColumn(i);
      }

      // 保存到文件
      try (FileOutputStream fileOut = new FileOutputStream("employees.xlsx")) {
        workbook.write(fileOut);
        System.out.println("Excel file created successfully.");
      }
    } catch (IOException e) {
      System.err.println("An error occurred: " + e.getMessage());
    }
  }
}