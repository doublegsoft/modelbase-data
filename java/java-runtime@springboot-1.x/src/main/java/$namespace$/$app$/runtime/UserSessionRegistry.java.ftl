<#import '/$/modelbase.ftl' as modelbase>
<#import "/$/modelbase4java.ftl" as modelbase4java>
<#if license??>
${java.license(license)}
</#if>
package ${namespace}.${app.name}.runtime;

import jakarta.servlet.http.HttpSession;
import jakarta.enterprise.context.ApplicationScoped;
import javax.inject.Named;

import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

@Named
@ApplicationScoped
public class UserSessionRegistry {

  private final Map<Long, HttpSession> userSessions = new ConcurrentHashMap<>();

  public void register(Long userId, HttpSession session) {
    userSessions.put(userId, session);
  }

  public HttpSession getSession(Long userId) {
    return userSessions.get(userId);
  }

  public void remove(Long userId) {
    userSessions.remove(userId);
  }
}
