<#import "/$/modelbase.ftl" as modelbase>
<#import "/$/modelbase4dart.ftl" as modelbase4dart>
<#if license??>
${dart.license(license)}
</#if>
<#assign obj = purchasable>
<#assign idAttrs = modelbase.get_id_attributes(obj)>
<#assign levelledAttrs = modelbase.level_object_attributes(obj)>
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

class ${dart.nameType(obj.name)}Purchase extends StatefulWidget {
<#list idAttrs as idAttr>

  final ${modelbase4dart.type_attribute_primitive(idAttr)} ${modelbase.get_attribute_sql_name(idAttr)};
</#list>

  const ${dart.nameType(obj.name)}Purchase({
    Key? key,
<#list idAttrs as idAttr>
    required this.${modelbase.get_attribute_sql_name(idAttr)},
</#list>        
  }) : super(key: key);

  @override
  State<${dart.nameType(obj.name)}Purchase> createState() => ${dart.nameType(obj.name)}PurchaseState();
}

class ${dart.nameType(obj.name)}PurchaseState extends State<${dart.nameType(obj.name)}Purchase> {
  int quantity = 1;
  int selectedPaymentMethod = 2; // Default to WeChat Pay

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('百变怪TCG卡牌'),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_horiz),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Location Bar
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Row(
              children: const [
                Icon(Icons.location_on, color: Colors.black54),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '甘果 菜园坝平安街168号江湾国际花都...',
                    style: TextStyle(fontSize: 14),
                  ),
                ),
                Icon(Icons.chevron_right, color: Colors.black54),
              ],
            ),
          ),

          // Product Details
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Image
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Cover(
                      url: '',
                      height: 120,
                      width: 120,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                
                // Product Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '摩托蜥 精灵球闪 105/127',
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '¥7.96',
                            style: TextStyle(
                              fontSize: 18,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          // Quantity Selector
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove),
                                onPressed: quantity > 1
                                    ? () => setState(() => quantity--)
                                    : null,
                              ),
                              Text('$quantity'),
                              IconButton(
                                icon: const Icon(Icons.add),
                                onPressed: () => setState(() => quantity++),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Bundle Product Section
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: const DecorationImage(
                      image: AssetImage('assets/bundle_image.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('藕饼cp挂件哪吒2魔童闯海'),
                      Text(
                        '藕饼cp-三条装',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: const [
                    Text(
                      '¥6.50',
                      style: TextStyle(color: Colors.red),
                    ),
                    Text(
                      '¥7.80',
                      style: TextStyle(
                        decoration: TextDecoration.lineThrough,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Payment Methods
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildPaymentOption(0, '支付宝', Icons.account_balance_wallet),
                _buildPaymentOption(1, '微信支付', Icons.chat_bubble),
                _buildPaymentOption(2, '找朋友帮忙付', Icons.people),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepOrange,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            child: const Text(
              '立即支付 ¥7.96',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentOption(int index, String title, IconData icon) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: Radio<int>(
        value: index,
        groupValue: selectedPaymentMethod,
        onChanged: (int? value) {
          setState(() {
            selectedPaymentMethod = value!;
          });
        },
      ),
    );
  }
}