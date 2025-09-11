import 'package:flutter/material.dart';
import '/design/buttons.dart';
import '/design/input_field.dart';
import '/sdk/options.dart';
import '/design/styles.dart' as styles;

class ProfileBaseEdit extends StatefulWidget {
  final Map<String, dynamic>? initialUserData; // 用于预填充用户信息

  const ProfileBaseEdit({Key? key, this.initialUserData}) : super(key: key);

  @override
  _ProfileBaseEditState createState() => _ProfileBaseEditState();
}

class _ProfileBaseEditState extends State<ProfileBaseEdit> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('编辑用户信息', style: TextStyle(color: Colors.black,)),
        leading: IconButton(onPressed: () {
          Navigator.of(context).pop();
        }, icon: Icon(Icons.arrow_back_ios_new_outlined, color: Colors.black,)),
        elevation: 0,
        backgroundColor: Color(0xffebf0f0),
        actions: [],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              height: styles.screenHeight,
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(10),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    InputField(label: '姓名', nullable: false, length: 10,),
                    SizedBox(height: 10,),
                    InputField(label: '身份证号', length: 18, nullable: false,),
                    SizedBox(height: 10,),
                    InputField(label: '出生日期', type: InputFieldType.date, nullable: false,),
                    SizedBox(height: 10,),
                    InputField(label: '性别', type: InputFieldType.select, options: [
                      Option(text: '男孩', value: 'M'), Option(text: '女孩', value: 'F'),
                    ],),
                    SizedBox(height: 10,),
                    InputField(label: '闹钟时间', type: InputFieldType.time,),
                    SizedBox(height: 10,),
                    InputField(label: '热量', type: InputFieldType.ruler, unit: 'kcal', min: 60, max: 200,),
                    SizedBox(height: 60,),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: styles.padding * 2,
              child: Container(
                margin: EdgeInsets.only(bottom: 20),
                child: RoundedButton(
                  width: styles.screenWidth - styles.padding * 4,
                  text: '保存',
                  onPressed: () {},
                ),
              ),
            ),
          ]
        ),
      ),
    );
  }
}