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
  
  late ${dart.nameType(obj.name)}Provider _${dart.nameVariable(obj.name)}Provider;
  
  int selectedColorIndex = 0;
  final List<Color> availableColors = [
    Colors.pink[100]!,
    Colors.grey,
    Colors.pink[50]!,
    Colors.purple[50]!,
    Colors.teal[100]!,
    Colors.grey[300]!,
  ];

  @override
  void initState() {
    super.initState();
    _${dart.nameVariable(obj.name)}Provider = context.read<${dart.nameType(obj.name)}Provider>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _${dart.nameVariable(obj.name)}Provider.fetch${dart.nameType(obj.name)}(
<#list idAttrs as idAttr>
        ${modelbase.get_attribute_sql_name(idAttr)}: widget.${modelbase.get_attribute_sql_name(idAttr)},
</#list>         
      );
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.transparent,
      body: Consumer<${dart.nameType(obj.name)}Provider>(
        builder: (BuildContext context, ${dart.nameType(obj.name)}Provider value, Widget? child) {
          return Stack(
            children: [
              CustomScrollView(
                slivers: [
                  SliverAppBar(
                    expandedHeight: 270,
                    floating: false,
                    pinned: true,
                    elevation: 0,
                    backgroundColor: Colors.transparent,
                    flexibleSpace: FlexibleSpaceBar(
                      centerTitle: true,                   
                      background: Cover(
<#if (levelledAttrs["image"]?size > 0)>                      
                        url: value.editing${dart.nameType(obj.name)}?.${modelbase.get_attribute_sql_name(levelledAttrs["image"][0])}??'',
<#else>           
                        url: 'https://gitee.com/christiangann/tatabase-image/raw/main/1024/0006.png',             
</#if>                        
                        height: 270,
                      ),
                    ),
                    leading: CloseIconButton(color: Colors.black,),
                    actions: [
                      IconButton(
                        icon: const Icon(Icons.ios_share, color: Colors.black),
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                            ),
                            builder: (BuildContext context) {
                              return ShareSheet();
                            },
                          );
                        },
                      ),
                    ],
                  ),
                  SliverToBoxAdapter(
                    child: Transform.translate(
                      offset: Offset(0, 0),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                ),
                              ),
                              padding: EdgeInsets.all(16),
                              child: Column(
                                children: [
                                  Headline1(
<#if (levelledAttrs["primary"]?size > 0)>  
                                    text: value.editing${dart.nameType(obj.name)}?.${modelbase.get_attribute_sql_name(levelledAttrs["primary"][0])}??'',
<#else>
                                    text: '这里是标题',
</#if>
                                    lines: 3,
                                  ),
                                  const SizedBox(height: 16),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                                    // Color Selection
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: List.generate(
                            availableColors.length,
                                (index) => GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedColorIndex = index;
                                });
                              },
                              child: Container(
                                margin: EdgeInsets.only(right: 8),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: selectedColorIndex == index
                                        ? Colors.orange
                                        : Colors.transparent,
                                    width: 2,
                                  ),
                                ),
                                child: Cover(
                                  url: '',
                                  width: 60,
                                  height: 60,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Price Section
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children: [
                          Text(
                            '¥18.9',
                            style: TextStyle(
                              color: Colors.orange,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 8),
                          Text(
                            '¥21.9',
                            style: TextStyle(
                              decoration: TextDecoration.lineThrough,
                              color: Colors.grey,
                            ),
                          ),
                          Spacer(),
                          Text(
                            '已售 1万+',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Discount Tags
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.pink[50],
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text('消费券'),
                          ),
                          SizedBox(width: 8),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.pink[50],
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text('商品券满19减3'),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Product Title
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        '无绳跳绳垫加厚隔音减震垫家用专业慢跑垫静音圆形地垫防滑瑜伽垫',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: SizedBox(height: 88,),
                  )
                ],
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: padding),
                  child: Row(
                    children: [
                      SizedBox(width: padding / 2),
                      Column(
                        children: [
                          Icon(Icons.store, color: Colors.grey),
                          Text('店铺', style: TextStyle(fontSize: 12)),
                        ],
                      ),
                      SizedBox(width: padding / 2),
                      Column(
                        children: [
                          Icon(Icons.support_agent, color: Colors.grey),
                          Text('客服', style: TextStyle(fontSize: 12)),
                        ],
                      ),
                      SizedBox(width: padding / 2),
                      Column(
                        children: [
                          Icon(Icons.favorite_border, color: Colors.grey),
                          Text('收藏', style: TextStyle(fontSize: 12)),
                        ],
                      ),
                      SizedBox(width: padding / 2),
                      Expanded(
                        child: Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () => gotoPersonalCart(context),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.amber,
                                ),
                                child: Text('加入购物车'),
                              ),
                            ),
                            SizedBox(width: padding / 2),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () => goto${dart.nameType(obj.name)}Purchase(context,
<#list idAttrs as idAttr>
                                  ${modelbase.get_attribute_sql_name(idAttr)}: widget.${modelbase.get_attribute_sql_name(idAttr)},
</#list> 
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.orange,
                                ),
                                child: Text('领券购买'),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: padding / 2),
                    ],
                  ),
                ),
              ),
            ],
          );
        }
      ),
    );
  }
}