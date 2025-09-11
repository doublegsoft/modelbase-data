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
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import '/common/format.dart';
import '/design/all.dart';
import '/model/dto.dart';
import '/provider/${obj.name}_provider.dart';
import '/sdk/sdk.dart';

import '${obj.name}_tile.dart';

class ${dart.nameType(obj.name)}List extends StatefulWidget {
  
  ${dart.nameType(obj.name)}Query? query;
  
  ${dart.nameType(obj.name)}List({
    super.key,
    this.query,
  }) {
    this.query ??= ${dart.nameType(obj.name)}Query();
  }
  
  @override
  State<StatefulWidget> createState() => ${dart.nameType(obj.name)}ListState();

}

class ${dart.nameType(obj.name)}ListState extends State<${dart.nameType(obj.name)}List> {

  late ${dart.nameType(obj.name)}Provider _${dart.nameVariable(obj.name)}Provider;

  CalendarFormat _calendarFormat = CalendarFormat.week;

  late DateTime _selectedDay;

  late DateTime _focusedDay;

  @override
  void initState() {
    super.initState();
    _${dart.nameVariable(obj.name)}Provider = context.read<${dart.nameType(obj.name)}Provider>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_${dart.nameVariable(obj.name)}Provider.listed${dart.nameType(inflector.pluralize(obj.name))}.length == 0) {
        // 意味着重未加载过，需要加载一次数据
        _refresh();
      }
    });
    setState(() {
      _selectedDay = widget.query!.${modelbase.get_attribute_sql_name(attrStart)}??DateTime.now();
      _focusedDay = widget.query!.${modelbase.get_attribute_sql_name(attrStart)}??DateTime.now();
    });
  }
  
  @override
  void didUpdateWidget(covariant ${dart.nameType(obj.name)}List oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.query != widget.query) {
      // 查新条件发生变化，才需要刷新
      _refresh();
    }
  }
  
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(yearAndMonth4Chinese(_focusedDay),),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                if (_calendarFormat == CalendarFormat.week) {
                  _calendarFormat = CalendarFormat.month;
                } else {
                  _calendarFormat = CalendarFormat.week;
                }
              });
            },
            icon: Icon(_calendarFormat == CalendarFormat.week ? Icons.calendar_view_month : Icons.view_week),
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: 4,),
          _buildWeekCalendar(),
          SizedBox(height: 8,),
          Expanded(
            child: PullToRefresh(
              body: _buildListFor${dart.nameType(obj.name)}(),
              onRefresh: () async {
                await Future.delayed(Duration(milliseconds: 600));
                await _refresh();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeekCalendar() {
    return TableCalendar(
      locale: 'zh_CN',
      headerVisible: false,
      firstDay: DateTime(1900, 1, 1),
      lastDay: DateTime(2099, 12, 31),
      calendarFormat: _calendarFormat,
      focusedDay: _focusedDay,
      calendarStyle: CalendarStyle(
        cellPadding: EdgeInsets.all(0),
        cellMargin: EdgeInsets.all(0),
      ),
      daysOfWeekHeight: 24,
      rowHeight: 32,
      selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
      onFormatChanged: null,
      onPageChanged: (DateTime date) {
        setState(() {
          _focusedDay = date;
        });
      },
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          _selectedDay = selectedDay;
          _focusedDay = selectedDay;
        });
        _refresh();
      },
    );
  }

  Widget _buildListFor${dart.nameType(obj.name)}() {
    return Consumer<${dart.nameType(obj.name)}Provider>(
      builder: (BuildContext context, ${dart.nameType(obj.name)}Provider provider, Widget? child) {
        if (provider.state == DataState.loading) {
          return Center(child: Loading(size: 96,),);
        } else if (provider.state == DataState.error) {
          return ErrorState();
        }
        if (provider.listed${dart.nameType(inflector.pluralize(obj.name))}.length == 0) {
          return EmptyState();
        }
        return ListView(
          padding: EdgeInsets.all(20),
          children: provider.listed${dart.nameType(inflector.pluralize(obj.name))}.map((${dart.nameVariable(obj.name)}) {
            return ${dart.nameType(obj.name)}Tile(
              ${dart.nameVariable(obj.name)}: ${dart.nameVariable(obj.name)},
            );
          }).toList(),
        );
      },
    );
  }
  
  ///
  /// 刷新页面数据
  ///
  Future<void> _refresh() async {
    await _${dart.nameVariable(obj.name)}Provider.fetch${dart.nameType(inflector.pluralize(obj.name))}(
      query: _assembleQuery(),
      reload: true,
    );
  }
  
  ///
  /// 加载更多数据
  ///
  Future<void> _reload() async {
    await _${dart.nameVariable(obj.name)}Provider.fetch${dart.nameType(inflector.pluralize(obj.name))}(
      query: _assembleQuery(),
    );
  }
  
  ///
  /// 从页面状态变量中封装查询条件
  ///
  ${dart.nameType(obj.name)}Query _assembleQuery() {
    ${dart.nameType(obj.name)}Query ret = new ${dart.nameType(obj.name)}Query();
<#if attrStart??>
    DateTime ${modelbase.get_attribute_sql_name(attrStart)}0 = DateTime(_selectedDay.year, _selectedDay.month, _selectedDay.day, 0, 0, 0);
    DateTime ${modelbase.get_attribute_sql_name(attrStart)}1 = DateTime(_selectedDay.year, _selectedDay.month, _selectedDay.day, 23, 59, 59);
    ret.${modelbase.get_attribute_sql_name(attrStart)}0 = ${modelbase.get_attribute_sql_name(attrStart)}0;
    ret.${modelbase.get_attribute_sql_name(attrStart)}1 = ${modelbase.get_attribute_sql_name(attrStart)}1;
</#if>    
    return ret;
  }
}