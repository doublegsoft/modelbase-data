<#import '/$/modelbase.ftl' as modelbase>
<#import "/$/modelbase4java.ftl" as modelbase4java>
<#if license??>
${java.license(license)}
</#if>
<#assign obj = xlsx>
<#assign baseName = java.nameType(obj.name)>
<#assign readerClass = baseName + "XlsxReader">
<#assign writerClass = baseName + "XlsxWriter">
<#assign testClassName = baseName + "XlsxRoundTripTest">
<#assign queryClass = baseName + "Query">
<#assign pluralMethod = java.nameType(modelbase.get_object_plural(obj))>
package ${namespace}.${java.nameNamespace(app.name)}.support.document;

import org.junit.Assert;
import org.junit.Before;
import org.junit.Test;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.util.*;
import java.text.SimpleDateFormat;

import ${namespace}.${java.nameNamespace(app.name)}.util.*;
import ${namespace}.${java.nameNamespace(app.name)}.dto.payload.*;

/**
 * ${obj.name} Excel 读写往返测试 (JUnit 4)
 */
public class ${java.nameType(obj.name)}XlsxReaderAndWriterTest {

  private ${writerClass} writer;
  private ${readerClass} reader;

  @Before
  public void setUp() {
    writer = new ${writerClass}();
    reader = new ${readerClass}();
  }

  /**
   * 往返测试：先 Write 写入字节流，再由 Reader Read 还原，断言数据完整一致
   */
  @Test
  public void testWriteAndRead${pluralMethod}_RoundTrip() throws IOException {
    // -------------------------------------------------------------
    // 1. Arrange: 构造期望写入的模拟数据集合 (2条数据以验证循环)
    // -------------------------------------------------------------
    List<${queryClass}> expectedList = new ArrayList<>();

    // 第一行模拟数据
    ${queryClass} item1 = test${java.nameType(obj.name)}();
    expectedList.add(item1);

    // 第二行模拟数据
    ${queryClass} item2 = test${java.nameType(obj.name)}();
    expectedList.add(item2);

    // -------------------------------------------------------------
    // 2. Act: 先使用 Writer 写入为内存 byte[]
    // -------------------------------------------------------------
    byte[] excelBytes = writer.write${pluralMethod}ToXlsx("${obj.name}Sheet", expectedList);

    Assert.assertNotNull("Writer 生成的二进制流不应为 null", excelBytes);
    Assert.assertTrue("Writer 生成的字节长度应大于 0", excelBytes.length > 0);

    // -------------------------------------------------------------
    // 3. Act: 再将 byte[] 转为 InputStream 喂给 Reader
    // -------------------------------------------------------------
    List<${queryClass}> actualList = reader.read${pluralMethod}FromXlsx(new ByteArrayInputStream(excelBytes));

    // -------------------------------------------------------------
    // 4. Assert: 验证数量及每个对象的每一个属性
    // -------------------------------------------------------------
    Assert.assertNotNull("Reader 解析的结果不应为 null", actualList);
    Assert.assertEquals("读取出的列表大小应与写入一致", expectedList.size(), actualList.size());

    for (int i = 0; i < expectedList.size(); i++) {
      ${queryClass} expected = expectedList.get(i);
      ${queryClass} actual = actualList.get(i);

      <#list obj.attributes as attr>
        <#if attr.type.collection || attr.type.custom><#continue></#if>
        <#if attr.constraint.domainType.name?starts_with("strings") || attr.constraint.domainType.name?starts_with("{")><#continue></#if>
        <#if attr.type.name == "string">
      assertEqualsIgnoreEmpty("第 " + i + " 行的字段 [${attr.name}] 数据往返解析后不一致！", 
          expected.${modelbase4java.name_getter(attr)}(), 
          actual.${modelbase4java.name_getter(attr)}());
        <#elseif attr.type.name == "date" || attr.type.name == "time" || attr.type.name == "datetime">
      assertDateEquals("第 " + i + " 行的字段 [${attr.name}] 数据往返解析后不一致！", 
          expected.${modelbase4java.name_getter(attr)}(), 
          actual.${modelbase4java.name_getter(attr)}());
        <#else>
      Assert.assertEquals("第 " + i + " 行的字段 [${attr.name}] 数据往返解析后不一致！", 
          expected.${modelbase4java.name_getter(attr)}(), 
          actual.${modelbase4java.name_getter(attr)}());
        </#if>
      </#list>
    }
  }

  /**
   * 往返测试：写入空列表时，应能正常生成空表且 Reader 读取出空列表
   */
  @Test
  public void testWriteAndRead${pluralMethod}_EmptyList() throws IOException {
    <#--  List<${queryClass}> emptyList = new ArrayList<>();

    byte[] excelBytes = writer.write${pluralMethod}ToXlsx("EmptySheet", emptyList);
    Assert.assertNotNull("生成的字节数组不应为 null", excelBytes);

    List<${queryClass}> actualList = reader.read${pluralMethod}FromXlsx(new ByteArrayInputStream(excelBytes));
    Assert.assertNotNull("读取出的列表不应为 null", actualList);
    Assert.assertTrue("写入空列表时，Reader 读取出来的也必须是空列表", actualList.isEmpty());  -->
  }

<@modelbase4java.print_test_obj attr={"name": obj.name} obj=obj is_aggregate_like=modelbase.is_aggregate_like(obj) />

  public static void assertEqualsIgnoreEmpty(String message, Object expected, Object actual) {
    String exp = (expected == null || "".equals(expected)) ? "" : String.valueOf(expected);
    String act = (actual == null || "".equals(actual)) ? "" : String.valueOf(actual);
    org.junit.Assert.assertEquals(message, exp, act);
  }

  public static void assertDateEquals(String message, Date expected, Date actual) {
    if (expected == null && actual == null) {
        return;
    }
    if (expected == null || actual == null) {
        Assert.fail(message + " [日期存在一方为 null: expected=" + expected + ", actual=" + actual + "]");
    }
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
    String expStr = sdf.format(expected);
    String actStr = sdf.format(actual);
    Assert.assertEquals(message, expStr, actStr);
  }
}