<#import '/$/modelbase.ftl' as modelbase>
<#assign attrId = modelbase.get_id_attributes(entity)[0]>

def unique(ApplicationContext spring, ObjectMap params) {
  String _data_source = params.get("_data_source") == null ? "" : params.get("_data_source")
  CommonService commonService = spring.getBean("commonService" + _data_source)
  SqlParams sqlParams = new SqlParams()

  String entityPersistenceName = ${java.nameType(entity.name)}.getPersistenceName()
  List<String> fields = params.get("_unique_fields")
  List<String> values = params.get("_unique_values")
  for (int i = 0; i < fields.size(); i++) {
    sqlParams.set(fields.get(i), values.get(i))
  }
  if (sqlParams.isEmpty()) {
    throw new IllegalArgumentException("唯一性校验没有传入任何参数，请联系管理员！")
  }
  ObjectMap found = commonService.single(entityPersistenceName + ".unique", sqlParams)
  return found
}

ApplicationContext spring = binding.getVariable("spring")
ObjectMap params = binding.getVariable("params")
try {
  ObjectMap found = unique(spring, params)
  if (found != null) {
    return new JsonData().error("已经存在满足唯一性检验值的数据！");
  }
} catch (Throwable cause) {
  commonDataAccess.rollback()
  return new JsonData().error(cause.getMessage())
} 

return new JsonData()