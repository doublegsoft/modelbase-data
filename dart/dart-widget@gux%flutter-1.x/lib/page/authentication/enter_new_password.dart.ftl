<#import "/$/modelbase.ftl" as modelbase>
<#import "/$/modelbase4dart.ftl" as modelbase4dart>
<#if license??>
${dart.license(license)}
</#if>
import 'package:flutter/material.dart';
import '/design/buttons.dart';
import '/page/common/success_page.dart';

class EnterNewPassword extends StatefulWidget {
  const EnterNewPassword({Key? key}) : super(key: key);

  @override
  EnterNewPasswordState createState() => EnterNewPasswordState();
}

class EnterNewPasswordState extends State<EnterNewPassword> {
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  final FocusNode _focusPassword = FocusNode();

  final FocusNode _focusConfirmed = FocusNode();

  bool get _isFormValid {
    return _passwordController.text.length >= 8 &&
        _passwordController.text == _confirmPasswordController.text;
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Widget _buildPasswordField({
    required String label,
    required FocusNode focusNode,
    required TextEditingController controller,
    required bool obscureText,
    required VoidCallback onToggleVisibility,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        obscureText: obscureText,
        style: const TextStyle(fontSize: 16),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          border: InputBorder.none,
          suffixIcon: IconButton(
            icon: Icon(
              obscureText ? Icons.visibility_off : Icons.visibility,
              color: Colors.grey[600],
            ),
            onPressed: onToggleVisibility,
          ),
        ),
        onChanged: (_) => setState(() {}),
      ),
    );
  }

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
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: SafeArea(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '输入新密码',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Please enter new password',
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
                            'asset/image/page/clothe3.png',
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                      _buildPasswordField(
                        label: '新密码',
                        focusNode: _focusPassword,
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        onToggleVisibility: () {
                          setState(() => _obscurePassword = !_obscurePassword);
                        },
                      ),
                      _buildPasswordField(
                        label: '再输一次新密码',
                        focusNode: _focusConfirmed,
                        controller: _confirmPasswordController,
                        obscureText: _obscureConfirmPassword,
                        onToggleVisibility: () {
                          setState(() => _obscureConfirmPassword = !_obscureConfirmPassword);
                        },
                      ),
                      SizedBox(height: 60),
                    ],
                  ),
                ),
              ),
              if (!_focusPassword.hasFocus && !_focusConfirmed.hasFocus) Positioned(
                bottom: 0,
                left: 20,
                child: RoundedButton(
                  width: MediaQuery.of(context).size.width - 40,
                  height: 56,
                  text: '确认修改',
                  onPressed: _isFormValid ? () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => SuccessPage(),),
                    );
                  } : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}