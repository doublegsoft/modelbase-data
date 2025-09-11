<#import "/$/modelbase.ftl" as modelbase>
<#import "/$/modelbase4dart.ftl" as modelbase4dart>
<#if license??>
${dart.license(license)}
</#if>
import 'dart:async';
import 'package:flutter/material.dart';
import '/design/buttons.dart';

import 'enter_new_password.dart';

class VerifiedByOTP extends StatefulWidget {
  final String phoneNumber;

  const VerifiedByOTP({
    Key? key,
    required this.phoneNumber,
  }) : super(key: key);

  @override
  VerifiedByOTPState createState() => VerifiedByOTPState();
}

class VerifiedByOTPState extends State<VerifiedByOTP> {
  final int otpLength = 4;
  final List<TextEditingController> controllers = [];
  final List<FocusNode> focusNodes = [];
  Timer? _resendTimer;
  int _timeLeft = 52;

  @override
  void initState() {
    super.initState();
    // Initialize controllers and focus nodes
    for (int i = 0; i < otpLength; i++) {
      controllers.add(TextEditingController());
      focusNodes.add(FocusNode());
    }
    _startResendTimer();
  }

  void _startResendTimer() {
    _resendTimer?.cancel();
    setState(() => _timeLeft = 52);
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft > 0) {
        setState(() => _timeLeft--);
      } else {
        timer.cancel();
      }
    });
  }

  String get _formattedTime {
    int minutes = _timeLeft ~/ 60;
    int seconds = _timeLeft % 60;
    return '${r"${"}minutes.toString().padLeft(2, '0')}:${r"${"}seconds.toString().padLeft(2, '0')}s';
  }

  void _onCodeDigitChanged(int index, String value) {
    if (value.length == 1 && index < otpLength - 1) {
      focusNodes[index + 1].requestFocus();
    }
  }

  bool get _isCodeComplete {
    return controllers.every((controller) => controller.text.length == 1);
  }

  @override
  void dispose() {
    for (var controller in controllers) {
      controller.dispose();
    }
    for (var focus in focusNodes) {
      focus.dispose();
    }
    _resendTimer?.cancel();
    super.dispose();
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
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '输入验证码',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'OTP code has been sent to ${r"${"}widget.phoneNumber}',
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: List.generate(
                      otpLength,
                          (index) => SizedBox(
                        width: 72,
                        height: 108,
                        child: TextField(
                          controller: controllers[index],
                          focusNode: focusNodes[index],
                          keyboardType: TextInputType.number,
                          maxLength: 1,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                          decoration: InputDecoration(
                            counterText: '',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: Colors.purple[700]!,
                                width: 2,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: Colors.grey[300]!,
                                width: 2,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: Colors.purple[700]!,
                                width: 2,
                              ),
                            ),
                          ),
                          onChanged: (value) => _onCodeDigitChanged(index, value),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Center(
                    child: TextButton(
                      onPressed: _timeLeft == 0 ? _startResendTimer : null,
                      child: RichText(
                        text: TextSpan(
                          text: 'Resend code ',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 16,
                          ),
                          children: [
                            TextSpan(
                              text: _formattedTime,
                              style: TextStyle(
                                color: Colors.purple[700],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              left: 20,
              child: RoundedButton(
                width: MediaQuery.of(context).size.width - 40,
                height: 56,
                text: '验证',
                onPressed: _isCodeComplete ? () {
                  String code = controllers.map((controller) => controller.text).join();
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => EnterNewPassword()),);
                } : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}