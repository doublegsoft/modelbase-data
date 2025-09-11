import java.util.List
import java.util.ArrayList
import java.util.Map
import org.springframework.context.ApplicationContext
import ${namespace}.${java.nameNamespace(app.name)}.model.repository.${java.nameType(entity.name)}Repository
import net.doublegsoft.appbase.JsonData
import net.doublegsoft.appbase.ObjectMap
import net.doublegsoft.appbase.SqlParams
import org.springframework.context.ApplicationContext
import net.doublegsoft.appbase.service.CommonService
import org.apache.logging.log4j.util.Strings

List<ObjectMap> calculate(ApplicationContext spring, ObjectMap params) {
  String _data_source = params.get("_data_source") == null ? "" : params.get("_data_source")
  CommonService commonService = spring.getBean("commonService" + _data_source)
  SqlParams sqlParams = new SqlParams()
  List<ObjectMap> numerics = params.get("_numerics")
  for (ObjectMap numeric : numerics) {
    SqlParams innerSqlParams = new SqlParams(numeric);
    String persistenceName = numeric.get("_persistence_name");
    String operator = numeric.get("_operator")
    String sqlId = numeric.get("_sql_id")
    sqlParams.set("_other_select", operator + "(" + persistenceName + ")")
    ObjectMap found = commonService.single(sqlId, innerSqlParams);
  }
}

List<ObjectMap> handle(ApplicationContext spring, ObjectMap params) {
  return aggregate(spring, params);
}

ApplicationContext spring = binding.getVariable("spring")
ObjectMap params = binding.getVariable("params")



List<ObjectMap> data = calculate(spring, params)

JsonData retVal = new JsonData()
retVal.set('data', data)
return retVal
