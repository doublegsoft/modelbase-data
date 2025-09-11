<#if license??>
${java.license(license)}
</#if>
package ${namespace}.${app.name};

public final class Exceptions {
  
  public static final int IAM = 100;
  
  public static final int AAM = 110;
  
  public static final int WFM = 120;
  
  public static final int DMM = 130;
  
  public static final int EXT = 900;
<#list model.objects as obj>
  
  public static final int ${obj.name?upper_case} = 1${(obj?index+1)?string?left_pad(2 "0")};
</#list>
  
  public static final int OK = 200;
  
  public static final int CREATED = 201;
  
  public static final int ACCEPTED = 202;
  
  public static final int UNAUTHORIZED = 401;
  
  public static final int NOT_FOUND = 404;
  
  public static final int CONFLICT = 409;
  
  public static final int GONE = 410;
  
  public static final int CONTENT_TOO_LARGE = 413;
  
  public static final int TOO_MANY_REQUESTS = 429;
  
  public static final int UNAVAILABLE_FOR_LEGAL_REASONS = 451;
  
  public static int buildCode(int module, int obj, int status) {
    return module * 1000 * 1000 + obj * 1000 + status;
  }
  
  public void throwServiceException(int module, int obj, int status) {
    throw new ServiceException(buildCode(module, obj, status), null); 
  }
  
  public String translate(int errorCode) {
    return null;
  }

}