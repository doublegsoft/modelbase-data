<#import '/$/modelbase.ftl' as modelbase>
<#import '/$/modelbase4java.ftl' as modelbase4java>
<#if license??>
${java.license(license)}
</#if>
package <#if namespace??>${namespace}.</#if>${java.nameNamespace(app.name)}.mq;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import jakarta.annotation.*;
import jakarta.inject.*;
import org.apache.kafka.clients.producer.Producer;
import org.apache.kafka.clients.producer.ProducerRecord;

import ${namespace}.${java.nameNamespace(app.name)}.dto.payload.*;

@Named
public class MessageProducerService {

  private static final Logger TRACER = LoggerFactory.getLogger(MessageProducerService.class);

  @Resource
  private Producer<String, Object> producer;

  public void sendMessage(String topic, String key, Object value) {
    ProducerRecord<String, Object> record = new ProducerRecord<>(topic, key, value);
    producer.send(record, (metadata, exception) -> {
      if (exception != null) {
        TRACER.error("Failed to send message to topic {} with key {}: {}", topic, key, exception.getMessage(), exception);
      }
    });
  }
}