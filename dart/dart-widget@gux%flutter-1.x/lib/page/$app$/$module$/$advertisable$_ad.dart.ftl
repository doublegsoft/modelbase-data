<#import "/$/modelbase.ftl" as modelbase>
<#import "/$/modelbase4dart.ftl" as modelbase4dart>
<#if license??>
${dart.license(license)}
</#if>
<#assign obj = advertisable>
<#assign idAttrs = modelbase.get_id_attributes(obj)>
<#assign levelledAttrs = modelbase.level_object_attributes(obj)>
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '/common/safe.dart';
import '/model/dto.dart';
import '/design/all.dart';
import '/page/route.dart';

class ${dart.nameType(obj.name)}Ad extends StatelessWidget {

  final ${dart.nameType(obj.name)}Query ${dart.nameVariable(obj.name)};
  
  final double width;

  ${dart.nameType(obj.name)}Ad({
    super.key,
    required this.${dart.nameVariable(obj.name)},
    this.width = double.infinity,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      margin: EdgeInsets.symmetric(horizontal: width == double.infinity ? 0 : padding),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
<#if (levelledAttrs["image"]?size > 0)>           
        image: DecorationImage(
          image: NetworkImage(${dart.nameVariable(obj.name)}.${modelbase.get_attribute_sql_name(levelledAttrs["image"][0])}??''),
          fit: BoxFit.cover, 
        ),
      ),
</#if>      
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Spacer(),
          Headline3(
            color: colorTextInverse,
<#if levelledAttrs["primary"]?size == 1>  
            text: ${modelbase4dart.get_attribute_display_string(dart.nameVariable(obj.name), levelledAttrs["primary"][0])},
<#else>
            text: '',
</#if>                      
          ),
          Headline5(
            color: colorTextInverse,
<#if levelledAttrs["secondary"]?size == 1> 
            text: ${modelbase4dart.get_attribute_display_string(dart.nameVariable(obj.name), levelledAttrs["secondary"][0])},
<#else>
            text: '',
</#if>                      
          ),
        ],
      ),
    );
  }
  
  
}