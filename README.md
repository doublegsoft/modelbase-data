java-dao@gfc-1.0
================

## 说明

DAO层的接口，与Query耦合。

定义了接口如下：

### {entity}

实体对象的数据操作，包括：

* 保存（save）
  
  先判断标识属性是否有值，无值就生成一个，同时在有值的情况下也要判断是否已存在，如果已存在则更新，否则插入。注意，更新为部分更新，也就是值为空的属性不被更新。

* 读取（read）

  通过对象标识属性获取唯一对象的数据。

* 获取（get）

  通过对象非标识属性获取唯一对象的数据，如果存在多个，只返回第一个。

* 查找（find）
  
  通过任意对象属性查找对象的数据，返回所有匹配的对象。
  
* 插入（insert）
* 更新（update）
* 部分更新（updatePartial）
* 删除（delete）
* 查询（select）
* 计数（selectCountOf）
* 去重查询（selectDistinctOf）

### {entity + [value]}

实体对象的数据操作，在这个实体对象中包含了一个（或多个）类型为值域对象数组的属性。

* 插入（insert）
* 更新（update）
* 部分更新（updatePartial）
* 删除（delete）
* 查询（select）
* 计数（selectCountOf）
* 去重查询（selectDistinctOf）

### {entity + [conjunction]}

实体对象的数据操作，在这个实体对象中包含了一个（或多个）类型为连接对象数组的属性。

* 插入（insert）
* 更新（update）
* 部分更新（updatePartial）
* 删除（delete）
* 查询（select）
* 计数（selectCountOf）
* 去重查询（selectDistinctOf）

### [entity]

### {value}

值体对象的数据操作。

### [value]

### {meta} = {entity} + [value]

元型扩展对象的数据操作。比如，在不改变某些实体对象表结构的情况下，在meta表上扩展实体对象的其他需要存储的属性。

### {pivot} = {entity} + [value]

转换扩展对象的数据操作。比如，医疗报告中的检验报告，一个报告主体，对应若干检验指标项的明细。

### {extension} = {entity}

直接扩展对象的数据操作。比如，

## 版本 

1.0