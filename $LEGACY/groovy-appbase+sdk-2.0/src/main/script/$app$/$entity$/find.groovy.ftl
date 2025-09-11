<#import '/$/modelbase.ftl' as modelbase>
<#assign querybase = statics['io.doublegsoft.querybase.Querybase']>
import java.util.List
import java.util.ArrayList
import java.util.Map
import java.io.File

import org.springframework.context.ApplicationContext

import net.doublegsoft.appbase.JsonData
import net.doublegsoft.appbase.SqlParams
import net.doublegsoft.appbase.ObjectMap
import net.doublegsoft.appbase.Pagination
import net.doublegsoft.appbase.service.CommonService
import net.doublegsoft.appbase.service.RepositoryService
import net.doublegsoft.appbase.service.GroovyService
import net.doublegsoft.appbase.util.Strings
import net.doublegsoft.appbase.util.Datasets

ApplicationContext spring = binding.getVariable("spring")
ObjectMap params = binding.getVariable("params")

CommonService commonService = spring.getBean("commonService")


def retVal = new JsonData()
retVal.set("data", data)
return retVal