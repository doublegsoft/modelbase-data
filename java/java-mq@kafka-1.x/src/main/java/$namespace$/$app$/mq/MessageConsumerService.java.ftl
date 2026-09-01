<#import '/$/modelbase.ftl' as modelbase>
<#import '/$/modelbase4java.ftl' as modelbase4java>
<#if license??>
${java.license(license)}
</#if>
<#assign msgObjs = model.objects?filter(obj -> obj.isLabelled("message"))>
package <#if namespace??>${namespace}.</#if>${java.nameNamespace(app.name)}.mq;

import java.time.Duration;
import java.util.Collections;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import jakarta.annotation.*;
import jakarta.inject.*;
import org.apache.kafka.clients.consumer.Consumer;
import org.apache.kafka.clients.consumer.ConsumerRecord;
import org.apache.kafka.clients.consumer.ConsumerRecords;

import ${namespace}.${java.nameNamespace(app.name)}.dto.payload.*;

@Named
public class MessageConsumerService implements Runnable {

  private static final Logger TRACER = LoggerFactory.getLogger(MessageConsumerService.class);

  @Resource
  private Consumer<String, Object> consumer;

  @Override
  public void run() {
    consumer.subscribe(Collections.singletonList("multi-topic"));
    try {
      while (!Thread.currentThread().isInterrupted()) {
        ConsumerRecords<String, Object> records = consumer.poll(Duration.ofMillis(100));
        for (ConsumerRecord<String, Object> record : records) {
          Object message = record.value();
<#list msgObjs as obj>
  <#if obj?index == 0>
          if (message instanceof ${java.nameType(obj.name)}Query) {
            ${java.nameType(obj.name)}Query ${java.nameVariable(obj.name)} = (${java.nameType(obj.name)}Query) message;
          } 
  <#else>
          else if (message instanceof ${java.nameType(obj.name)}Query) {
            ${java.nameType(obj.name)}Query ${java.nameVariable(obj.name)} = (${java.nameType(obj.name)}Query) message;
          }
  </#if>
</#list>
        }
      }
    } finally {
      consumer.close();
    }
  }
}