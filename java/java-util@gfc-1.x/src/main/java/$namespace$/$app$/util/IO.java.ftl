<#import '/$/modelbase.ftl' as modelbase>
<#import "/$/modelbase4java.ftl" as modelbase4java>
<#if license??>
${java.license(license)}
</#if>
package ${namespace}.${app.name}.util;

import java.io.*;
import java.nio.charset.StandardCharsets;
import java.nio.file.*;
import java.util.ArrayList;
import java.util.List;

/**
 * IO 工具类，提供文件读写、流处理、目录操作等常用静态方法。
 * 所有方法均为 null 安全、异常简洁。
 */
public class IO {

  // ------------------ 读取文件 ------------------

  /**
   * 读取文件全部内容为字符串（UTF-8）
   */
  public static String readFile(String path) {
    if (path == null || path.trim().isEmpty()) {
      return "";
    }
    try {
      return Files.readString(Paths.get(path), StandardCharsets.UTF_8);
    } catch (IOException e) {
      throw new UncheckedIOException("Failed to read file: " + path, e);
    }
  }

  /**
   * 读取文件所有行
   */
  public static List<String> readLines(String path) {
    if (path == null || path.trim().isEmpty()) {
      return new ArrayList<>();
    }
    try {
      return Files.readAllLines(Paths.get(path), StandardCharsets.UTF_8);
    } catch (IOException e) {
      throw new UncheckedIOException("Failed to read lines from: " + path, e);
    }
  }

  // ------------------ 写入文件 ------------------

  /**
   * 写入字符串到文件（覆盖模式，UTF-8）
   */
  public static void writeFile(String path, String content) {
    if (path == null || path.trim().isEmpty()) {
      return;
    }
    try {
      Files.writeString(Paths.get(path), content == null ? "" : content, StandardCharsets.UTF_8);
    } catch (IOException e) {
      throw new UncheckedIOException("Failed to write file: " + path, e);
    }
  }

  /**
   * 追加写入字符串到文件（UTF-8）
   */
  public static void appendFile(String path, String content) {
    if (path == null || path.trim().isEmpty() || content == null) {
      return;
    }
    try {
      Files.writeString(Paths.get(path), content, StandardCharsets.UTF_8,
                        StandardOpenOption.APPEND, StandardOpenOption.CREATE);
    } catch (IOException e) {
      throw new UncheckedIOException("Failed to append to file: " + path, e);
    }
  }

  // ------------------ 目录操作 ------------------

  /**
   * 创建目录（包括多级目录）
   */
  public static void createDirectories(String path) {
    if (path == null || path.trim().isEmpty()) {
      return;
    }
    try {
      Files.createDirectories(Paths.get(path));
    } catch (IOException e) {
      throw new UncheckedIOException("Failed to create directories: " + path, e);
    }
  }

  /**
   * 判断路径是否存在
   */
  public static boolean exists(String path) {
    if (path == null || path.trim().isEmpty()) {
      return false;
    }
    return Files.exists(Paths.get(path));
  }

  /**
   * 判断是否为目录
   */
  public static boolean isDirectory(String path) {
    if (path == null || path.trim().isEmpty()) {
      return false;
    }
    return Files.isDirectory(Paths.get(path));
  }

  // ------------------ 流处理 ------------------

  /**
   * 将 InputStream 读取为字符串（UTF-8）
   */
  public static String readStream(InputStream is) {
    if (is == null) {
      return "";
    }
    try (BufferedReader reader = new BufferedReader(new InputStreamReader(is, StandardCharsets.UTF_8))) {
      StringBuilder sb = new StringBuilder();
      String line;
      while ((line = reader.readLine()) != null) {
        sb.append(line).append("\n");
      }
      return sb.toString();
    } catch (IOException e) {
      throw new UncheckedIOException("Failed to read stream", e);
    }
  }

  /**
   * 将字符串写入 OutputStream（UTF-8）
   */
  public static void writeStream(OutputStream os, String content) {
    if (os == null || content == null) {
      return;
    }
    try {
      os.write(content.getBytes(StandardCharsets.UTF_8));
      os.flush();
    } catch (IOException e) {
      throw new UncheckedIOException("Failed to write stream", e);
    }
  }

  // ------------------ 其他常用 ------------------

  /**
   * 删除文件或目录（递归删除目录）
   */
  public static void delete(String path) {
    if (path == null || path.trim().isEmpty()) {
      return;
    }
    Path p = Paths.get(path);
    try {
      if (Files.isDirectory(p)) {
        Files.walk(p)
          .sorted((a, b) -> -a.compareTo(b))  // 逆序删除，先删子文件
          .forEach(file -> {
            try {
              Files.delete(file);
            } catch (IOException e) {
              throw new UncheckedIOException(e);
            }
          });
      } else {
        Files.deleteIfExists(p);
      }
    } catch (IOException e) {
      throw new UncheckedIOException("Failed to delete: " + path, e);
    }
  }

  /**
   * 获取文件大小（字节）
   */
  public static long fileSize(String path) {
    if (path == null || path.trim().isEmpty()) {
      return 0;
    }
    try {
      return Files.size(Paths.get(path));
    } catch (IOException e) {
      return 0;
    }
  }
}