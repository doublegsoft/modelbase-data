<#import "/$/modelbase.ftl" as modelbase>
<#import "/$/modelbase4dart.ftl" as modelbase4dart>
<#if license??>
${dart.license(license)}
</#if>
<#assign obj = browsable>
<#assign idAttrs = modelbase.get_id_attributes(obj)>
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '/common/format.dart';
import '/design/all.dart';
import '/design/pull_to_refresh.dart';
import '/model/dto.dart';
import '/provider/${obj.name}_provider.dart';
import '/sdk/sdk.dart';
import '/page/route.dart';

import '${obj.name}_card.dart';

class ${dart.nameType(obj.name)}Coll extends StatefulWidget {
  
  ${dart.nameType(obj.name)}Query? criteria;
  
  ${dart.nameType(obj.name)}Coll({
    super.key,
    this.criteria,
  }) {
    criteria = criteria ?? ${dart.nameType(obj.name)}Query();
  }
  
  @override
  State<StatefulWidget> createState() => ${dart.nameType(obj.name)}CollState();

}

class ${dart.nameType(obj.name)}CollState extends State<${dart.nameType(obj.name)}Coll> {

  final ScrollController _scrollController = new ScrollController();

  late ${dart.nameType(obj.name)}Provider _${dart.nameVariable(obj.name)}Provider;

  @override
  void initState() {
    super.initState();
    _${dart.nameVariable(obj.name)}Provider = context.read<${dart.nameType(obj.name)}Provider>();
    _scrollController.addListener(_scrollListener);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_${dart.nameVariable(obj.name)}Provider.listed${dart.nameType(inflector.pluralize(obj.name))}.length == 0) {
        // 意味着重未加载过，需要加载一次数据
        _refresh();
      }
    });
  }
  
  @override
  void didUpdateWidget(covariant ${dart.nameType(obj.name)}Coll oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.criteria != widget.criteria) {
      // 查新条件发生变化，才需要刷新
      _refresh();
    }
  }
  
  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${modelbase.get_object_label(obj)}'),
      ),
      body: Column(
        children: [
          SizedBox(height: padding),
          Container(
            padding: EdgeInsets.symmetric(horizontal: padding),
            height: 42,
            child: TextField(
              style: TextStyle(fontSize: 14),
              readOnly: true,
              decoration: InputDecoration(
                hintText: '搜索关键字',
                hintStyle: TextStyle(fontSize: 14),
                prefixIcon: Icon(Icons.search),
                contentPadding: EdgeInsets.symmetric(horizontal: padding),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(padding),
                ),
              ),
              onTap: () async {
                await goto${dart.nameType(obj.name)}Search(context,
                  criteria: widget.criteria,
                );
              },
            ),
          ),
          SizedBox(height: padding),
          Expanded(
            child: _buildCollFor${dart.nameType(obj.name)}(),
          ),
        ],
      ),
    );
  }
  
  Widget _buildCollFor${dart.nameType(obj.name)}() {
    return Consumer<${dart.nameType(obj.name)}Provider>(
      builder: (BuildContext context, ${dart.nameType(obj.name)}Provider provider, Widget? child) {
        if (provider.state == DataState.loading) {
          // TODO: 显示加载更多的动画效果
          // return Center(child: Loading(size: 96,),);
        } else if (provider.state == DataState.error) {
          return ErrorState();
        }
        if (provider.listed${dart.nameType(inflector.pluralize(obj.name))}.length == 0) {
          return EmptyState();
        }
        return PullToRefresh(
          body: ListView(
            controller: _scrollController,
            padding: EdgeInsets.only(left: padding, right: padding,),
            children: provider.listed${dart.nameType(inflector.pluralize(obj.name))}.map((${dart.nameVariable(obj.name)}) {
              return GestureDetector(
                onTap: () => goto${dart.nameType(obj.name)}Detail(context,
<#list idAttrs as idAttr>
                  ${modelbase.get_attribute_sql_name(idAttr)}: ${dart.nameVariable(obj.name)}.${modelbase.get_attribute_sql_name(idAttr)}!,
</#list>                                 
                ),
                child: ${dart.nameType(obj.name)}Card(
                  ${dart.nameVariable(obj.name)}: ${dart.nameVariable(obj.name)},
                ),
              );
            }).toList(),
          ),
          onRefresh: () async {
            await Future.delayed(Duration(milliseconds: 600));
            await _refresh();
          },
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
    return ret;
  }
  
  ///
  /// 加载更多
  ///
  void _scrollListener() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent &&
        _scrollController.position.atEdge) {
      _${dart.nameVariable(obj.name)}Provider.fetch${dart.nameType(inflector.pluralize(obj.name))}(
        query: _assembleQuery(),
      );
    }
  }
}