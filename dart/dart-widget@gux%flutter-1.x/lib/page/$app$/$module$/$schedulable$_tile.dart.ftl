<#import "/$/modelbase.ftl" as modelbase>
<#import "/$/modelbase4dart.ftl" as modelbase4dart>
<#if license??>
${dart.license(license)}
</#if>
<#assign obj = schedulable>
<#assign idAttrs = modelbase.get_id_attributes(obj)>
<#if model.findAttributeByNames(obj.name, obj.getLabelledOptions("schedulable")["start"]!'NOTSET')??>
  <#assign attrStart = model.findAttributeByNames(obj.name, obj.getLabelledOptions("schedulable")["start"])>
</#if>
<#if model.findAttributeByNames(obj.name, obj.getLabelledOptions("schedulable")["end"]!'NOTSET')??>
  <#assign attrEnd = model.findAttributeByNames(obj.name, obj.getLabelledOptions("schedulable")["end"])>
</#if>
<#if model.findAttributeByNames(obj.name, obj.getLabelledOptions("schedulable")["title"]!'NOTSET')??>
  <#assign attrTitle = model.findAttributeByNames(obj.name, obj.getLabelledOptions("schedulable")["title"])>
</#if>
<#if model.findAttributeByNames(obj.name, obj.getLabelledOptions("schedulable")["location"]!'NOTSET')??>
  <#assign attrLocation = model.findAttributeByNames(obj.name, obj.getLabelledOptions("schedulable")["location"])>
</#if>
<#if model.findAttributeByNames(obj.name, obj.getLabelledOptions("schedulable")["description"]!'NOTSET')??>
  <#assign attrDescr = model.findAttributeByNames(obj.name, obj.getLabelledOptions("schedulable")["description"])>
</#if>
import 'dart:core';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

import '/design/all.dart';
import '/model/dto.dart';

class ${dart.nameType(obj.name)}Tile extends StatelessWidget {

  final ${dart.nameType(obj.name)}Query ${dart.nameVariable(obj.name)};

  ScheduleTile({
    required this.${dart.nameVariable(obj.name)},
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 55,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SizedBox(height: 18,),
              Text(DateFormat('HH:mm').format(schedule.startTime!), style: TextStyle(color: Colors.black, fontSize: 16)),
              Text('min', style: TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          ),
        ),
        SizedBox(width: 10),
        Column(
          children: [
            Container(
              width: 4,
              height: 28,
              color: Colors.grey,
            ),
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey,)
              ),
            ),
            Container(
              width: 4,
              height: 72,
              color: Colors.grey,
            ),
          ],
        ),
        SizedBox(width: 10),
        Expanded(
          child: Container(
            margin: EdgeInsets.only(top: 12,),
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: Colors.grey.shade900,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(<#if attrTitle??>${dart.nameVariable(obj.name)}.${modelbase.get_attribute_sql_name(attrTitle)}!<#else>''</#if>,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Spacer(),
                    PopupMenuButton(
                      color: Colors.white,
                      position: PopupMenuPosition.under,
                      iconSize: 16,
                      icon: Icon(Icons.more_horiz_outlined, color: colorTextInverse,),
                      itemBuilder: (context) => [
                        PopupMenuItem(child: Text('Option 1'), value: '1'),
                        PopupMenuItem(child: Text('Option 2'), value: '2'),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
<#if attrLocation??>                  
                    Icon(Icons.location_on_outlined, color: Colors.grey, size: 16,),
                    SizedBox(width: 4),
                    Text(this.${dart.nameVariable(obj.name)}.${modelbase.get_attribute_sql_name(attrLocation)}!,
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
</#if>                    
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}