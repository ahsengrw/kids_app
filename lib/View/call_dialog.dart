import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import '../SharedContent/call_button.dart';
import '../SharedContent/constants.dart';

class CallDialog extends StatefulWidget {
  final String assets;
  final Color bgColor;
  final VoidCallback popCall;
  CallDialog({Key? key, required this.assets, required this.bgColor, required this.popCall}) : super(key: key);

  @override
  State<CallDialog> createState() => _CallDialogState();
}

class _CallDialogState extends State<CallDialog> {




  @override
  Widget build(BuildContext context) {
    return  Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      backgroundColor: lightGreen,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 286,
            margin: EdgeInsets.symmetric(vertical: 21, horizontal: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: widget.bgColor,
            ),
            child: Center(
              child: Image.asset(
                widget.assets,
                // width: MediaQuery.of(context).size.width * 0.5,
                // height: MediaQuery.of(context).size.width * 0.5,
                fit: BoxFit.cover,
              ),

            ),
          ),
          SizedBox(
            height: 31,
          ),
          CallButton(
            onTap: widget.popCall,
          ),
        ],
      ),
    );
  }
}
