<#import "/$/modelbase.ftl" as modelbase>
<#import "/$/modelbase4dart.ftl" as modelbase4dart>
<#if license??>
${dart.license(license)}
</#if>
import 'package:flutter/material.dart';
import '/design/buttons.dart';
import 'verified_by_otp.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  ForgotPasswordState createState() => ForgotPasswordState();
}

class ForgotPasswordState extends State<ForgotPassword> {
  String? _selectedOption;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_outlined, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '忘记密码',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Select which contact details should we use to reset your password',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 40),
                  Center(
                    child: SizedBox(
                      height: 200,
                      child: Image.asset(
                        'asset/image/page/clothe3.png', // Add your lock icon to assets
                        // color: Colors.purple[700],
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  _buildOptionCard(
                    icon: Icons.message,
                    title: '通过短信发送验证码',
                    subtitle: '(808) 555-0111',
                    isSelected: _selectedOption == 'sms',
                    onTap: () => setState(() => _selectedOption = 'sms'),
                  ),
                  const SizedBox(height: 16),
                  _buildOptionCard(
                    icon: Icons.mail_outline,
                    title: '通过邮件发送验证码',
                    subtitle: 'tim.jennings@example.com',
                    isSelected: _selectedOption == 'email',
                    onTap: () => setState(() => _selectedOption = 'email'),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              left: 20,
              child: RoundedButton(
                width: MediaQuery.of(context).size.width - 40,
                height: 56,
                backgroundColor: Colors.purple[700],
                text: '发送验证码',
                onPressed: _selectedOption != null ? () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => VerifiedByOTP(phoneNumber: '88889999')),);
                } : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? Colors.purple[700]! : Colors.grey[300]!,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isSelected ? Colors.purple[700] : Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: isSelected ? Colors.white : Colors.grey,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
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