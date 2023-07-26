// import 'package:flutter/material.dart';
// import 'package:flutter_cache_manager/flutter_cache_manager.dart';
//
// class AnimatedGif extends StatefulWidget {
//   final String assetName;
//   final double height;
//   final double width;
//   final int frameDuration; // Duration for each frame in milliseconds
//
//   const AnimatedGif({
//     required this.assetName,
//     required this.height,
//     required this.width,
//     required this.frameDuration,
//   });
//
//   @override
//   _AnimatedGifState createState() => _AnimatedGifState();
// }
//
// class _AnimatedGifState extends State<AnimatedGif> {
//   num currentFrame = 0;
//
//   @override
//   void initState() {
//     super.initState();
//     startAnimation();
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//   }
//
//   void startAnimation() {
//     Future.delayed(Duration(milliseconds: widget.frameDuration), () {
//       setState(() {
//         currentFrame = (currentFrame + 1) %   totalFrames; // Increment frame index
//         startAnimation(); // Recursive call for next frame
//       });
//     });
//   }
//
//   dynamic get totalFrames async {
//     final file = await DefaultCacheManager().getSingleFile(widget.assetName);
//     final byteData = await file.readAsBytes();
//     final decoder = GifDecoder();
//     decoder.startDecoding(byteData);
//     final frames = decoder.frameCount;
//     decoder.clear();
//     return frames;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Image.asset(
//       widget.assetName,
//       height: widget.height,
//       width: widget.width,
//       frameBuilder: (context, child, frame, isSync) {
//         if (isSync) return child;
//
//         return AnimatedOpacity(
//           opacity: currentFrame == frame ? 1.0 : 0.0,
//           duration: Duration(milliseconds: widget.frameDuration),
//           child: child,
//         );
//       },
//     );
//   }
// }
