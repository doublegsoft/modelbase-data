<#import '/$/modelbase.ftl' as modelbase>
<#import '/$/modelbase4java.ftl' as modelbase4java>
<#if license??>
${java.license(license)}
</#if>
package <#if namespace??>${namespace}.</#if>${java.nameNamespace(app.name)}.mq;

import com.fasterxml.jackson.databind.ObjectMapper;
import org.apache.kafka.common.header.Header;
import org.apache.kafka.common.header.Headers;
import org.apache.kafka.common.serialization.Deserializer;
import java.util.Map;

public class HeaderJsonDeserializer implements Deserializer<Object> {
  private final ObjectMapper objectMapper = new ObjectMapper();

  @Override
  public void configure(Map<String, ?> configs, boolean isKey) {}

  @Override
  public Object deserialize(String topic, byte[] data) {
    throw new UnsupportedOperationException("Header-based deserialization requires headers.");
  }

  @Override
  public Object deserialize(String topic, Headers headers, byte[] data) {
    if (data == null) {
      return null;
    }
    try {
      Header typeHeader = headers.lastHeader("action_type");
      if (typeHeader == null) {
        throw new RuntimeException("Missing 'action_type' header for deserialization");
      }
      String className = new String(typeHeader.value());
      Class<?> targetClass = Class.forName(className);
      return objectMapper.readValue(data, targetClass);
    } catch (Exception e) {
      throw new RuntimeException("Error deserializing JSON message", e);
    }
  }

  @Override
  public void close() {}
}