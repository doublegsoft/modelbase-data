java-dao@gfc-1.0
================

## 说明

DAO层的接口，与Query耦合。

定义了接口如下：

### {entity}

实体对象的数据操作，包括插入（insert）、更新（update）、部分更新（updatePartial）、删除（delete）、查询（select）、计数（selectCountOf）、去重查询（selectDistinctOf）。

### {value}

值体对象的数据操作。

### {meta} = {entity} + [value]

元型扩展对象的数据操作。比如，在不改变某些实体对象表结构的情况下，在meta表上扩展实体对象的其他需要存储的属性。

### {pivot} = {entity} + [value]

转换扩展对象的数据操作。比如，医疗报告中的检验报告，一个报告主体，对应若干检验指标项的明细。

### {extension} = {entity}

直接扩展对象的数据操作。比如，

## 版本 

1.0