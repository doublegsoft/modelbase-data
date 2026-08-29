<#assign libname = app.name>
<#if libname?starts_with("lib")>
  <#assign libname = libname?substring(3)>
</#if>
[package]
name = "${libname}"
version = "1.0.0" 

[lib]
name = "${libname}"
path = "src/poco/lib.rs"    
crate-type = ["staticlib"]
bench = false