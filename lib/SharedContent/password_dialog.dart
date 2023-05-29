import 'package:flutter/material.dart';
import 'package:kids_app/SharedContent/constants.dart';
import 'package:kids_app/SharedContent/container_button.dart';

class PasscodeDialog extends StatefulWidget {
  final VoidCallback onEnter;
  const PasscodeDialog({required this.onEnter});

  @override
  _PasscodeDialogState createState() => _PasscodeDialogState();
}

class _PasscodeDialogState extends State<PasscodeDialog> {
  String otp = '';

  void _addNumberToOtp(String number) {
    if (otp.length < 4) {
      setState(() {
        otp += number;
      });
    }
  }

  void _removeNumberFromOtp() {
    if (otp.length > 0) {
      setState(() {
        otp = otp.substring(0, otp.length - 1);
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: redishOrange,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Stack(children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 31,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.0),
                child: Text(
                  'Please enter your year of birth',
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.height * 0.03,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildOtpBox(otp.length > 0 ? otp[0] : ''),
                  _buildOtpBox(otp.length > 1 ? otp[1] : ''),
                  _buildOtpBox(otp.length > 2 ? otp[2] : ''),
                  _buildOtpBox(otp.length > 3 ? otp[3] : ''),
                ],
              ),
              SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildNumberButton('1'),
                  _buildNumberButton('2'),
                  _buildNumberButton('3'),
                  _buildNumberButton('4'),
                  _buildNumberButton('5'),
                ],
              ),
              SizedBox(height: 8.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildNumberButton('6'),
                  _buildNumberButton('7'),
                  _buildNumberButton('8'),
                  _buildNumberButton('9'),
                  _buildNumberButton('0'),
                ],
              ),
              SizedBox(height: 8.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [],
              ),
              SizedBox(height: 8.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Spacer(),
                  ContainerButton(
                    onTap: (){
                      int currentYear = DateTime.now().year;
                      int age = currentYear - int.parse(otp);
                      if (age >= 18) {
                        widget.onEnter();
                      } else {
                        Navigator.pop(context);
                        showToast(context, 'You are under age');
                      }

                    },
                    title: 'Enter',
                    width: 150,
                    height: 46,
                    color: yellowish,
                    borderRadius: 10,
                    fontSize: 20,
                  ),
                  Spacer(),
                  IconButton(
                    icon: Icon(Icons.backspace),
                    onPressed: _removeNumberFromOtp,
                  ),
                ],
              ),
              SizedBox(
                height: 21,
              ),
            ],
          ),
        ),
        Positioned(
          top: 7,
          right: 7,
          child: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Image.asset(
              'assets/cross.png',
              width: 30,
              height: 30,
            ),
          ),
        ),
      ]),
    );
  }

  Widget _buildOtpBox(String number) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.12,
      height: MediaQuery.of(context).size.width * 0.17,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0), color: Colors.white),
      child: Center(
        child: Text(
          number,
          style: TextStyle(
            fontSize: 32.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildNumberButton(String number) {
    return InkWell(
      onTap: () {
        _addNumberToOtp(number);
      },
      child: CircleAvatar(
        backgroundColor: lightBrown,
        radius: MediaQuery.of(context).size.height * 0.03,
        child: Text(
          number,
          style: customStyle.copyWith(
            fontWeight: FontWeight.w900,
            color: Colors.white,
            fontSize: 20,
          ),
        ),
      ),
    );
  }
}
