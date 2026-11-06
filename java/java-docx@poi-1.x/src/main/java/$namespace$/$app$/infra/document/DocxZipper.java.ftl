package ${namespace}.${java.nameNamespace(app.name)}.infra.document;

import java.io.*;
import java.nio.file.*;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

public class DocxZipper {

  /**
   * 将解压出来的文件夹内容压缩为标准 .docx 文件
   *
   * @param sourceDirPath 解压目录的路径（该目录下应直接包含 [Content_Types].xml 和 word/ 等）
   * @param targetDocxPath 输出的 .docx 文件路径
   * @throws IOException IO异常
   */
  public static void zipDirToDocx(Path sourceDirPath, Path targetDocxPath) throws IOException {
    if (!Files.isDirectory(sourceDirPath)) {
      throw new IllegalArgumentException("源路径必须是一个目录: " + sourceDirPath);
    }

    if (targetDocxPath.getParent() != null) {
      Files.createDirectories(targetDocxPath.getParent());
    }

    try (ZipOutputStream zos = new ZipOutputStream(Files.newOutputStream(targetDocxPath))) {
      Files.walk(sourceDirPath)
        .filter(path -> !path.equals(sourceDirPath))
        .filter(path -> !path.getFileName().toString().equals(".DS_Store"))
        .filter(path -> !path.getFileName().toString().startsWith("._"))
        .forEach(path -> {
          try {
            String entryName = sourceDirPath.relativize(path).toString().replace('\\', '/');
            if (Files.isDirectory(path)) {
              zos.putNextEntry(new ZipEntry(entryName + "/"));
              zos.closeEntry();
            } else {
              zos.putNextEntry(new ZipEntry(entryName));
              Files.copy(path, zos);
              zos.closeEntry();
            }
          } catch (IOException e) {
            throw new UncheckedIOException(e);
          }
        });
    }
  }

  /**
   * 将解压出来的文件夹内容直接压缩为二进制 byte[]
   *
   * @param sourceDirPath 解压目录的路径
   * @return docx 文件的二进制字节流
   * @throws IOException IO异常
   */
  public static byte[] zipDirToBytes(Path sourceDirPath) throws IOException {
    try (ByteArrayOutputStream baos = new ByteArrayOutputStream();
         ZipOutputStream zos = new ZipOutputStream(baos)) {
      Files.walk(sourceDirPath)
        .filter(path -> !path.equals(sourceDirPath))
        .filter(path -> !path.getFileName().toString().equals(".DS_Store"))
        .filter(path -> !path.getFileName().toString().startsWith("._"))
        .forEach(path -> {
          try {
            String entryName = sourceDirPath.relativize(path).toString().replace('\\', '/');
            if (Files.isDirectory(path)) {
              zos.putNextEntry(new ZipEntry(entryName + "/"));
              zos.closeEntry();
            } else {
              zos.putNextEntry(new ZipEntry(entryName));
              Files.copy(path, zos);
              zos.closeEntry();
            }
          } catch (IOException e) {
            throw new UncheckedIOException(e);
          }
        });
      zos.finish();
      return baos.toByteArray();
    }
  }

  public static void zipDirToDocx(File sourceDir, File targetDocxFile) throws IOException {
    zipDirToDocx(sourceDir.toPath(), targetDocxFile.toPath());
  }
}