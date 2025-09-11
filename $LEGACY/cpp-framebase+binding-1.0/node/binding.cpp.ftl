<#import '/$/modelbase.ftl' as modelbase>
<#if license??>
${cpp.license(license)}
</#if>
#include <napi.h>

using namespace Napi;

String Hello(const CallbackInfo& info) 
{
  return String::New(info.Env(), "world");
}

void Init(Env env, Object exports, Object module) 
{
  exports.Set("${app.name}", Function::New(env, Hello));
}
NODE_API_MODULE(addon, Init)