// import 'dart:async';
//
// void main() {
//   final cancelToken = CancelToken();
//   performAsyncOperation(cancelToken);
//
//   //bool isCancelled = true;
//
//   int age = 10;
//
//   //if(isCancelled){
//   //  cancelToken.cancel();
//   // }
//
//   if(age <= 18){
//     cancelToken.cancel();
//   }
//
// }
//
// Future<void> performAsyncOperation(CancelToken cancelToken) async {
//   final completer = Completer<void>();
//
//   // Simulate a long-running task
//   Timer(Duration(seconds: 5), () {
//     if (!completer.isCompleted) {
//       completer.complete();
//       print('Async operation completed');
//     }
//   });
//
//   cancelToken.onCancel(() {
//     if (!completer.isCompleted) {
//       completer.completeError('Async operation canceled');
//     }
//   });
//
//   try {
//     await completer.future;
//   } catch (e) {
//     print(e);
//   }
// }
//
class MyCancelToken {
  Function? _onCancelCallback;

  void cancel() {
    _onCancelCallback?.call();
  }

  void onCancel(Function callback) {
    _onCancelCallback = callback;
  }
}
//
//
//
// // onTap: () async {
// // if (_buttonEnabled) {
// // setState(() {
// // _buttonEnabled = false;
// // whileTrue = true;
// // selectedAsset =
// // gifAssetsHearing[index];
// // backgroundAsset = bgs[index];
// // selectedIndex = index;
// // });
// // while (whileTrue) {
// // await stop();
// // stopSound();
// // setState(() {
// // selectedAsset =
// // gifAssetsHearing[selectedIndex!];
// // });
// //
// // await record();
// // await Future.delayed(
// // Duration(seconds: 5));
// // await stop();
// // setState(() {
// // _buttonEnabled = true;
// // selectedAsset =
// // gifAssetsTalking[selectedIndex!];
// // });
// //
// // playSoundFile(pathToAudio!.path);
// // await Future.delayed(
// // Duration(seconds: 5));
// // }
// // } else {
// // showToast(context, 'button disabled');
// // }
// // },


// Future record(MyCancelToken cancelToken) async {
//   if (!whileTrue) return;
//   final completer = Completer<void>();
//   print('recording start....................');
//   if (!isRecorderReady) return;
//   await recorder
//       .startRecorder(
//     toFile: 'audio',
//     bitRate: 128000,
//     sampleRate: 44100,
//   )
//       .then((value) {
//     if (!completer.isCompleted) {
//       completer.complete();
//       print('Async operation completed');
//     }
//   });
//
//   cancelToken.onCancel(() {
//     if (!completer.isCompleted) {
//       completer.completeError('Async operation canceled');
//     }
//   });
//
//   try {
//     await completer.future;
//   } catch (e) {
//     print(e);
//   }
// }

// onTap: () async {
// cancelTokenList.add(MyCancelToken());
// print('cancel: ${cancel}');
// if(cancel != 0){
// cancelTokenList[index-1].cancel();
// }
// print('index $index');
// cancel = index;
// print('cancel2 : $cancel');
//
// if (_buttonEnabled) {
// setState(() {
// _buttonEnabled = false;
// whileTrue = true;
// selectedAsset =
// gifAssetsHearing[index];
// backgroundAsset = bgs[index];
// selectedIndex = index;
// });
// while (whileTrue) {
// await stop();
// stopSound();
// setState(() {
// selectedAsset = gifAssetsHearing[
// selectedIndex!];
// });
//
// await record(cancelTokenList[index]);
//
// await Future.delayed(
// Duration(seconds: 5));
// await stop();
// setState(() {
// _buttonEnabled = true;
// selectedAsset = gifAssetsTalking[
// selectedIndex!];
// });
//
// playSoundFile(pathToAudio!.path);
// await Future.delayed(
// Duration(seconds: 5));
// }
// //cancelTokenList[index].cancel();
// } else {
// showToast(context, 'button disabled');
// }
// },


// Padding(
//   padding: const EdgeInsets.symmetric(horizontal: 21.0),
//   child: GridView.count(
//     crossAxisCount: 3,
//     childAspectRatio: (1.2 / 0.9),
//     shrinkWrap: true,
//     mainAxisSpacing: 7,
//     crossAxisSpacing: 7,
//     children: List.generate(12, (index) {
//       String label;
//       double containerWidth;
//       double containerHeight;
//       switch (index) {
//         case 9:
//           label = '*';
//           containerWidth = 34;
//           containerHeight = 34;
//           break;
//         case 10:
//           label = '0';
//           containerWidth = 89;
//           containerHeight = 89;
//           break;
//         case 11:
//           label = '#';
//           containerWidth = 34;
//           containerHeight = 34;
//           break;
//         default:
//           label = (index + 1).toString();
//           containerWidth = 89;
//           containerHeight = 89;
//       }
//       return  Bounce(
//
//         duration: Duration(milliseconds: 100),
//         onTap: (){
//           _onButtonPress(label);
//         },
//         child: index == 9 || index == 11
//             ? Container(
//           width: containerWidth,
//           height: containerHeight,
//           decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               color: Colors.white,
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black26,
//                   spreadRadius: 3,
//                   blurRadius: 15,
//                   offset: Offset(0, 3),
//                 ),
//               ]),
//           child: Center(
//             child: Text(
//               index == 9 ? '*' : '#',
//               style: customStyle.copyWith(
//                 fontWeight: FontWeight.w800,
//                 fontSize: 34,
//                 color: redishOrange,
//               ),
//             ),
//           ),
//         )
//             : Container(
//           decoration: BoxDecoration(
//               color: Colors.white,
//               shape: BoxShape.circle,
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black26,
//                   spreadRadius: 3,
//                   blurRadius: 15,
//                   offset: Offset(0, 3),
//                 ),
//               ]),
//           width: containerWidth,
//           height: containerHeight,
//           child: Center(
//               child: Text(
//                 label,
//                 style: customStyle.copyWith(
//                   fontWeight: FontWeight.w900,
//                   fontSize: 50,
//                   color: redishOrange,
//                 ),
//               )),
//         ),
//       );
//     }),
//   ),
// ),