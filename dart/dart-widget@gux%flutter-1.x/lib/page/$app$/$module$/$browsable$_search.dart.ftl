<#import "/$/modelbase.ftl" as modelbase>
<#import "/$/modelbase4dart.ftl" as modelbase4dart>
<#if license??>
${dart.license(license)}
</#if>
<#assign obj = browsable>
<#assign idAttrs = modelbase.get_id_attributes(obj)>
import 'package:flutter/material.dart';
import '/model/dto.dart';
import '/design/pickers.dart';

class ${dart.nameType(obj.name)}Search extends StatefulWidget {

  ${dart.nameType(obj.name)}Query? criteria;

  ${dart.nameType(obj.name)}Search({
    super.key,
    this.criteria,
  }) {
    criteria = criteria ?? ${dart.nameType(obj.name)}Query();
  }

  @override
  State<${dart.nameType(obj.name)}Search> createState() => ${dart.nameType(obj.name)}SearchState();
}

class ${dart.nameType(obj.name)}SearchState extends State<${dart.nameType(obj.name)}Search> {

  bool repeatDaily = false;
  
  String selectedDuration = '30 min';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('查询条件'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     const Text('查询条件',
              //       style: TextStyle(
              //         color: Colors.white,
              //         fontSize: 24,
              //         fontWeight: FontWeight.bold,
              //       ),
              //     ),
              //     IconButton(
              //       icon: const Icon(Icons.edit, color: Colors.white),
              //       onPressed: () {},
              //     ),
              //   ],
              // ),
              const SizedBox(height: 24),
              const Text(
                '开始和结束时间？',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[900],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: _buildDateField(),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Icon(Icons.arrow_forward, color: Colors.grey),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[900],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: _buildDateField(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text(
                'Timing of Session',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[900],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: _buildTimeField(),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Icon(Icons.arrow_forward, color: Colors.grey),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[900],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: _buildTimeField(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text(
                'Duration',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _DurationButton(
                    text: '30 min',
                    isSelected: selectedDuration == '30 min',
                    onTap: () => setState(() => selectedDuration = '30 min'),
                  ),
                  const SizedBox(width: 8),
                  _DurationButton(
                    text: '60 min',
                    isSelected: selectedDuration == '60 min',
                    onTap: () => setState(() => selectedDuration = '60 min'),
                  ),
                  const SizedBox(width: 8),
                  _DurationButton(
                    text: 'All Day',
                    isSelected: selectedDuration == 'All Day',
                    onTap: () => setState(() => selectedDuration = 'All Day'),
                  ),
                  const SizedBox(width: 8),
                  _DurationButton(
                    text: 'Custom',
                    isSelected: selectedDuration == 'Custom',
                    onTap: () => setState(() => selectedDuration = 'Custom'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Icon(Icons.access_time, color: Colors.grey[600], size: 20),
                  const SizedBox(width: 8),
                  const Text(
                    '10 minutes before',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Icon(Icons.repeat, color: Colors.grey[600], size: 20),
                  const SizedBox(width: 8),
                  const Text(
                    'Repetition',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Repeat Everyday at Same time',
                    style: TextStyle(color: Colors.white),
                  ),
                  Switch(
                    value: repeatDaily,
                    onChanged: (value) => setState(() => repeatDaily = value),
                    activeColor: Colors.green[300],
                  ),
                ],
              ),
              const Spacer(),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Colors.grey[900],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {},
                      child: const Text(
                        '← Back',
                        style: TextStyle(color: Colors.green),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextButton(
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Colors.green[300],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {},
                      child: const Text(
                        'Next',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateField() {
    return GestureDetector(
      child: Row(
        children: [
          const Text(
            'YYYY-MM-DD',
            style: TextStyle(color: Colors.grey),
          ),
          Spacer(),
          Icon(Icons.calendar_today, color: Colors.grey[600], size: 16),
        ],
      ),
      onTap: () {
        _pickDate(context);
      },
    );
  }

  Widget _buildTimeField() {
    return GestureDetector(
      child: Row(
        children: [
          const Text(
            'HH:MM',
            style: TextStyle(color: Colors.grey),
          ),
          Spacer(),
          Icon(Icons.access_time, color: Colors.grey[600], size: 18),
        ],
      ),
      onTap: () {
        _pickTime(context);
      },
    );
  }

  void _pickDate(BuildContext context) {
    pickDate(context);
  }

  void _pickTime(BuildContext context) {
    pickTime(context);
  }
}

class _DurationButton extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  const _DurationButton({
    required this.text,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? Colors.green[300] : Colors.grey[900],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? Colors.black : Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}