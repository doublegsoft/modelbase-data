<#assign obj = detailable>
<#assign idAttrs = modelbase.get_id_attributes(obj)>
<#assign levelledAttrs = modelbase.level_object_attributes(obj)>
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/rendering/sliver.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import '/common/format.dart';
import '/design/all.dart';
import '/model/dto.dart';
import '/provider/${obj.name}_provider.dart';
import '/sdk/sdk.dart';
import '/page/route.dart';

class ${dart.nameType(obj.name)}Detail extends StatefulWidget {
<#list idAttrs as idAttr>

  final ${modelbase4dart.type_attribute_primitive(idAttr)} ${modelbase.get_attribute_sql_name(idAttr)};
</#list>

  ${dart.nameType(obj.name)}Detail({
    Key? key,
<#list idAttrs as idAttr>
    required this.${modelbase.get_attribute_sql_name(idAttr)},
</#list>    
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() =>  ${dart.nameType(obj.name)}DetailState();

}

class  ${dart.nameType(obj.name)}DetailState extends State< ${dart.nameType(obj.name)}Detail> {

  @override
  Widget build(BuildContext context) {
    return Container();
  }  
}