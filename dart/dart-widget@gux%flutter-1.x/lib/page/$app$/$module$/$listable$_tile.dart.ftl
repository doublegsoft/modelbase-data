<#import "/$/modelbase.ftl" as modelbase>
<#import "/$/modelbase4dart.ftl" as modelbase4dart>
<#if license??>
${dart.license(license)}
</#if>
<#assign obj = listable>
<#assign idAttrs = modelbase.get_id_attributes(obj)>
<#assign levelledAttrs = modelbase.level_object_attributes(obj)>
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '/common/safe.dart';
import '/model/dto.dart';
import '/design/all.dart';

class ${dart.nameType(obj.name)}Tile extends StatelessWidget {

  final ${dart.nameType(obj.name)}Query ${dart.nameVariable(obj.name)};

  ${dart.nameType(obj.name)}Tile({
    super.key,
    required this.${dart.nameVariable(obj.name)},
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      padding: EdgeInsets.all(padding),
      margin: EdgeInsets.only(bottom: padding,),
      decoration: BoxDecoration(
        color: colorSurface,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [       
          ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            child: Cover(
<#if levelledAttrs["image"]?size == 1>            
              url: ${dart.nameVariable(obj.name)}.${modelbase.get_attribute_sql_name(levelledAttrs["image"][0])}??'', 
<#else>
              url: 'NOT SET IMAGE ATTR',
</#if>              
            ),
          ),
          SizedBox(width: padding,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: padding / 2,),
              Row(
                children: [
                  SizedBox(
                    width: screenWidth / 3,
                    child: Headline5(
<#if levelledAttrs["primary"]?size == 1>  
                      text: ${modelbase4dart.get_attribute_display_string(dart.nameVariable(obj.name), levelledAttrs["primary"][0])},
<#else>
                      text: '',
</#if>                      
                    ),
                  ),
                  const SizedBox(width: 5),
                  const Icon(
                    Icons.verified,
                    color: Colors.red,
                    size: 16,
                  ),
                ],
              ),
              SizedBox(height: padding / 2,),
              Headline6(
<#if levelledAttrs["secondary"]?size == 1> 
                text: ${modelbase4dart.get_attribute_display_string(dart.nameVariable(obj.name), levelledAttrs["secondary"][0])},
<#else>
                text: '',
</#if>                      
              ),
              SizedBox(height: padding / 2,),
<#if levelledAttrs["tertiary"]?size == 1>  
              Description(
                content: ${modelbase4dart.get_attribute_display_string(dart.nameVariable(obj.name), levelledAttrs["tertiary"][0])},
              ),
</#if>
            ],
          ),
        ],
      ),
    );
  }
}