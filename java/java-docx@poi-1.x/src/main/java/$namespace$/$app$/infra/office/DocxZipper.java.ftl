package $namespace$.${java.nameNamespace(app.name)}.infra.office;

import java.io.IOException;
import java.nio.file.*;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

public class DocxZipper {

  public static void zipFolderToDocx(Path sourceFolderPath, Path outputDocxPath) throws IOException {
    if (outputDocxPath.getParent() != null) {
      Files.createDirectories(outputDocxPath.getParent());
    }

    try (ZipOutputStream zos = new ZipOutputStream(Files.newOutputStream(outputDocxPath))) {
      Files.walk(sourceFolderPath)
        .filter(path -> !Files.isDirectory(path))
        .filter(path -> !isHiddenOrSystemFile(path))
        .forEach(path -> {
          Path relativePath = sourceFolderPath.relativize(path);
          String zipEntryName = relativePath.toString().replace('\\', '/');

          ZipEntry zipEntry = new ZipEntry(zipEntryName);
          try {
            zos.putNextEntry(zipEntry);
            Files.copy(path, zos);
            zos.closeEntry();
          } catch (IOException e) {
            throw new RuntimeException("Failed to zip file: " + path, e);
          }
        });
    }
  }

  private static boolean isHiddenOrSystemFile(Path path) {
    String fileName = path.getFileName().toString();
    return fileName.startsWith(".") || 
           fileName.equalsIgnoreCase("Thumbs.db") || 
           fileName.equalsIgnoreCase("__MACOSX");
  }

  public static void main(String[] args) {
    Path sourceDir = Paths.get("path/to/unpacked_docx_folder");
    Path targetDocx = Paths.get("path/to/output.docx");

    try {
      zipFolderToDocx(sourceDir, targetDocx);
      System.out.println("DOCX file created successfully at: " + targetDocx.toAbsolutePath());
    } catch (IOException e) {
      e.printStackTrace();
    }
  }
}