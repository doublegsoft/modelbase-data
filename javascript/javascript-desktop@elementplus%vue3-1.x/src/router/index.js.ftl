<#import '/$/modelbase.ftl' as modelbase>
<#import '/$/modelbase4js.ftl' as modelbase4js>
<#if license??>
${js.license(license)}
</#if>
import { createRouter, createWebHistory } from 'vue-router';
import Home from '@/page/home.vue';
<#list model.objects as obj>
  <#if obj.isLabelled("browsable")>
import ${js.nameType(obj.name)}Coll from '@/page/${modelbase.get_object_module(obj)}/${obj.name?replace("_","-")}/coll.vue';
  <#elseif obj.isLabelled("listable")>
import ${js.nameType(obj.name)}List from '@/page/${modelbase.get_object_module(obj)}/${obj.name?replace("_","-")}/list.vue';  
  </#if>
  <#if obj.isLabelled("detailable")>
import ${js.nameType(obj.name)}Detail from '@/page/${modelbase.get_object_module(obj)}/${obj.name?replace("_","-")}/detail.vue';    
  </#if>
</#list>

const routes = [{
<#list model.objects as obj>
  <#if !obj.isLabelled("manageable")><#continue></#if>
  <#if obj.isLabelled("browsable")>
path: '/${modelbase4js.get_object_page_path(obj)}/coll',
  name: '${obj.name?replace("_","-")}-coll',
  component: ${js.nameType(obj.name)}Coll,
  meta: { breadcrumb: {text: '${modelbase.get_object_label(obj)}'}, keepAlive: true,}, 
},{  
  <#elseif obj.isLabelled("listable")>
  path: '/${modelbase4js.get_object_page_path(obj)}/list',
  name: '${obj.name?replace("_","-")}-list',
  component: ${js.nameType(obj.name)}List,  
  meta: { breadcrumb: {text: '${modelbase.get_object_label(obj)}'}, keepAlive: true,}, 
},{  
  </#if>
  <#if obj.isLabelled("detailable")>  
  path: '/${modelbase4js.get_object_page_path(obj)}/detail',
  name: '${obj.name?replace("_","-")}-detail',
  component: ${js.nameType(obj.name)}Detail, 
  meta: { breadcrumb: {text: '${modelbase.get_object_label(obj)}详情'}, }, 
},{ 
  </#if>
</#list>  
  path: '/',
  name: 'home',
  component: Home,
  meta: { breadcrumb: {text: '首页'}, keepAlive: true,},
}];

const router = createRouter({
  history: createWebHistory(),
  routes
});

const breadcrumbs = [];

router.beforeEach((to, from, next) => {
  if (to.path == '/') breadcrumbs.splice(0, breadcrumbs.length);
<#list model.objects as obj>
  <#if !obj.isLabelled("manageable")><#continue></#if>
  else if (to.path == '/${modelbase4js.get_object_page_path(obj)}/coll') breadcrumbs.splice(0, breadcrumbs.length);
  else if (to.path == '/${modelbase4js.get_object_page_path(obj)}/list') breadcrumbs.splice(0, breadcrumbs.length);
</#list>  
  breadcrumbs.push({
    ...to.meta.breadcrumb,
    path: to.path,
  });
  next();
});

router.getBreadcrumbs = () => {
  return breadcrumbs;
};

<#list model.objects as obj>
  <#if obj.isLabelled("detailable")>
    <#assign idAttrs = modelbase.get_id_attributes(obj)>
    
router.goto${js.nameType(obj.name)}Detail = (${modelbase.get_attribute_sql_name(idAttrs[0])}) => {
  router.push({path: '/${modelbase4js.get_object_page_path(obj)}/detail', params: {
  },});
};  
  </#if>
</#list>

export default router;