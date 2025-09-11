<#import "/$/modelbase.ftl" as modelbase>
<#import "/$/modelbase4dart.ftl" as modelbase4dart>
<#if license??>
${dart.license(license)}
</#if>
import 'package:flutter/material.dart';
import '/page/route.dart';
import '/sdk/options.dart';
import '/design/all.dart';

import '/page/common/privacy_policy.dart';
import 'profile_base_edit.dart';

class ProfileSettings extends StatefulWidget {

  const ProfileSettings({Key? key}) : super(key: key);

  @override
  State<ProfileSettings> createState() => ProfileSettingsState();
}

class ProfileSettingsState extends State<ProfileSettings> {

  bool _notificationsEnabled = true;
  String _themeMode = 'light';

  String _language = 'ZH';
  String _localAvatar = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              elevation: 0,
              floating: false,
              pinned: true,
              backgroundColor: Color(0xffebf0f0),
              actions: [
                const Icon(Icons.notifications_none, size: 28, color: Colors.black,),
                SizedBox(width: 16,),
                const Icon(Icons.history, size: 28, color: Colors.black,),
                SizedBox(width: 16,),
                const Icon(Icons.more_vert, size: 28, color: Colors.black,),
              ],
            ),
            SliverToBoxAdapter(
              child: Container(
                width: screenWidth,
                height: 210,
                child: Stack(
                  children: [
                    Container(
                      height: 100,
                      width: screenWidth,
                      child: CustomPaint(
                        painter: ArcBorderPainter(arcHeight: 30),
                      ),
                    ),
                    Positioned(
                      top: 20,
                      width: screenWidth,
                      child: Column(
                        children: [
                          Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              Avatar(size: 96, url: _localAvatar),
                              GestureDetector(
                                onTap: () {
                                  pickImage(context,
                                    didPick: (file) {
                                      setState(() {
                                        _localAvatar = file.path;
                                      });
                                    }
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.edit, size: 20),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          const Text('元某某',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 20,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'youremail@domain.com | +01 234 567 89',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ];
        },
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 5,
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          _buildSettingsTile(
                            icon: Icons.edit_note,
                            title: '基本信息',
                            onTap: () => gotoProfileBaseEdit(context),
                          ),
                          ListTile(
                            leading: Icon(Icons.notifications_none, color: Colors.black87),
                            title: Text('消息提醒'),
                            trailing: IconSwitch(
                              value: _notificationsEnabled,
                              onChanged: (value) => setState(() => _notificationsEnabled = value),
                              activeColor: Colors.blue,
                              activeIconData: Icons.notifications_active_outlined,
                              inactiveIconData: Icons.notifications_off_outlined,
                            ),
                          ),
                          _buildSettingsTile(
                            icon: Icons.translate,
                            title: '语言',
                            trailing: Text(getTextOfLanguage(_language),
                              style: TextStyle(color: Colors.blue.shade400),
                            ),
                            onTap: () {
                              _pickLanguage();
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 5,
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          _buildSettingsTile(
                            icon: Icons.security,
                            title: 'Security',
                            onTap: () {},
                          ),
                          ListTile(
                            leading: Icon(Icons.palette_outlined, color: Colors.black87),
                            title: Text('主题'),
                            trailing: ThemeSwitch(
                              value: _themeMode == 'dark',
                              onChanged: (value) => setState(() => _themeMode = value ? 'dark' : 'light'),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 5,
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          _buildSettingsTile(
                            icon: Icons.help_outline,
                            title: '帮助与支持',
                            onTap: () {},
                          ),
                          _buildSettingsTile(
                            icon: Icons.chat_bubble_outline,
                            title: '联系我们',
                            onTap: () {},
                          ),
                          _buildSettingsTile(
                            icon: Icons.lock_outline,
                            title: '隐私协议',
                            onTap: () => Navigator.push(context,
                                MaterialPageRoute(builder: (_) => PrivacyPolicy()),),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 5,
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          _buildSettingsTile(
                            icon: Icons.person_off_outlined,
                            textColor: colorError,
                            title: '注销账号',
                            onTap: () {},
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    RoundedButton(
                      text: '退出登录',
                      backgroundColor: colorWarning,
                      foregroundColor: colorTextInverse,
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    Widget? trailing,
    Color? textColor = Colors.black87,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: textColor),
      title: Text(title, style: TextStyle(color: textColor,)),
      trailing: trailing ?? const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  void _pickLanguage() {
    pickItem(context,
      height: 350,
      options: arrayOfLanguage,
      initial: _language,
      didPick: (val) {
        setState(() {
          _language = val;
        });
      }
    );
  }
}

class ArcBorderPainter extends CustomPainter {
  final double arcHeight;

  ArcBorderPainter({this.arcHeight = 20});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Color(0xffebf0f0)
      ..style = PaintingStyle.fill
      ..strokeWidth = 2;

    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width, 0);

    path.lineTo(size.width, arcHeight);
    path.arcToPoint(
      Offset(0, arcHeight),
      radius: Radius.circular(size.width),
      clockwise: true,
    );

    path.lineTo(0, arcHeight);
    path.lineTo(0, 0);
    path.close();
    canvas.drawPath(path, paint);

  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}