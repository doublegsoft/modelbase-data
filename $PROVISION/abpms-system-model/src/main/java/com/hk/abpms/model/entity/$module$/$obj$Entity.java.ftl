<#import "/$/modelbase.ftl" as modelbase>
<#import "/$/modelbase4java.ftl" as modelbase4java>
package com.hk.abpms.model.entity.${java.nameVariable(modelbase.get_object_module(obj))};

import com.baomidou.mybatisplus.annotation.FieldStrategy;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import com.hk.abpms.model.entity.BaseEntity;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.List;
import java.util.Map;
import java.util.Date;
import java.util.HashMap;
import java.util.ArrayList;


/**
 * 【${modelbase.get_object_label(obj)}】与库表映射类型。
 */
@TableName("${obj.persistenceName}")
@Data
public class ${java.nameType(obj.name)}Entity implements Serializable {

    private static final long serialVersionUID = -1L;
<#list obj.attributes as attr>

    /**
     * 【${modelbase.get_attribute_label(attr)}】
     */
    private ${modelbase4java.type_attribute_primitive(attr)} ${modelbase.get_attribute_sql_name(attr)};
</#list>    
}
