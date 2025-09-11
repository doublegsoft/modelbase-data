<#import "/$/modelbase.ftl" as modelbase>
<#import "/$/modelbase4dart.ftl" as modelbase4dart>
<#if license??>
${dart.license(license)}
</#if>
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/rendering/sliver.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '/common/format.dart';
import '/design/all.dart';
import '/model/dto.dart';
import '/sdk/sdk.dart';
import '/page/route.dart';

class Order {
  final String name;
  final String date;
  final String time;
  final String status;
  final double price;
  final int items;
  final String imageUrl;

  Order({
    required this.name,
    required this.date,
    required this.time,
    required this.status,
    required this.price,
    required this.items,
    required this.imageUrl,
  });
}

class PersonalCart extends StatefulWidget {
  
  PersonalCart({Key? key}) : super(key: key);

  @override
  State<PersonalCart> createState() => PersonalCartState();
}

class PersonalCartState extends State<PersonalCart> {
  String selectedFilter = 'Cancelled';
  final List<String> filters = ['Active', 'Completed', 'Cancelled'];
  
  final List<Order> orders = [
    Order(
      name: 'Sushi Wave',
      date: '02 Nov',
      time: '04:00 pm',
      status: 'Order cancelled',
      price: 103.00,
      items: 3,
      imageUrl: 'assets/sushi.jpg',
    ),
    Order(
      name: 'Fruit and Berry Tea',
      date: '12 Oct',
      time: '03:15 pm',
      status: 'Order cancelled',
      price: 15.00,
      items: 2,
      imageUrl: 'assets/tea.jpg',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFD700),
      appBar: AppBar(
        title: const Text('我的购物车'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: padding),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  children: [
                    // Filter tabs
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: filters.map((filter) => _buildFilterChip(filter)).toList(),
                      ),
                    ),

                    // Orders list
                    Expanded(
                      child: ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemCount: orders.length,
                        separatorBuilder: (context, index) => const Divider(),
                        itemBuilder: (context, index) => _buildOrderCard(orders[index], index),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String filter) {
    bool isSelected = selectedFilter == filter;
    return GestureDetector(
      onTap: () => setState(() => selectedFilter = filter),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected 
            ? (filter == 'Cancelled' ? Colors.red : Colors.orange)
            : Colors.pink[50],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          filter,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildOrderCard(Order order, int index) {
    return Slidable(
      key: Key(order.name),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (context) => () {},
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
          ),
        ],
      ),
      startActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (context) => () {},
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            icon: Icons.check,
            label: 'Complete',
          ),
        ],
      ),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 4,
            ),
          ],
        ),
        child: Row(
          children: [
            // Order image
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Cover(
                url: order.imageUrl,
                width: 80,
                height: 80,
              ),
            ),
            const SizedBox(width: 12),

            // Order details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    order.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${r"${"}order.date}, ${r"${"}order.time}',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.cancel_outlined, size: 16, color: Colors.red[300]),
                      const SizedBox(width: 4),
                      Text(
                        order.status,
                        style: TextStyle(
                          color: Colors.red[300],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '\$${r"${"}order.price.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${r"${"}order.items} items',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
