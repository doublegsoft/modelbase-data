<#import '/$/modelbase.ftl' as modelbase>
<#import '/$/modelbase4java.ftl' as modelbase4java>
<#if license??>
${java.license(license)}
</#if>
package <#if namespace??>${namespace}.</#if>${java.nameNamespace(app.name)}.mq;

import com.fasterxml.jackson.databind.ObjectMapper;
import org.apache.kafka.common.header.Headers;
import org.apache.kafka.common.serialization.Serializer;
import java.util.Map;

public class HeaderJsonSerializer implements Serializer<Object> {
  private final ObjectMapper objectMapper = new ObjectMapper();

  @Override
  public void configure(Map<String, ?> configs, boolean isKey) {}

  @Override
  public byte[] serialize(String topic, Object data) {
    return serialize(topic, null, data);
  }

  @Override
  public byte[] serialize(String topic, Headers headers, Object data) {
    if (data == null) {
      return null;
    }
    try {
      if (headers != null) {
        // Record the fully qualified class name in the headers
        headers.add("action_type", data.getClass().getName().getBytes());
      }
      return objectMapper.writeValueAsBytes(data);
    } catch (Exception e) {
      throw new RuntimeException("Error serializing JSON message", e);
    }
  }

  @Override
  public void close() {}
}