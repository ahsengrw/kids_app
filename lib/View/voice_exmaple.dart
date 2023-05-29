// import 'dart:async';
// import 'dart:convert';
// import 'dart:io';
// import 'dart:math';
// import 'package:audioplayers/audioplayers.dart' as audio;
// import 'package:fluently/App/Authentication/Controller/auth_services.dart';
// import 'package:fluently/App/Chat/Controller/open_ai_apis.dart';
// import 'package:fluently/App/Chat/Provider/chat.dart';
// import 'package:fluently/App/Home/Widgets/custom_dialogue.dart';
// import 'package:fluently/App/Home/Widgets/explore_button.dart';
// import 'package:fluently/App/Memberships/plans_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_sound/flutter_sound.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:intl/date_symbol_data_local.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:path/path.dart' as path;
// import 'package:provider/provider.dart';
// import '../../Memberships/Controller/database_controller.dart';
// import '../Widgets/ai_type_bar.dart';
// import '../Widgets/bubbles.dart';
// class ChatScreen extends StatefulWidget {
//   final String characterName;
//   final String introduction;
//   final List contents;
//   const ChatScreen({Key? key, required this.characterName, required this.contents,required this.introduction}) : super(key: key);
//
//   @override
//   State<ChatScreen> createState() => _ChatScreenState();
// }
//
// class _ChatScreenState extends State<ChatScreen> {
//   int messagesCount= 0;
//   audio.AudioPlayer audioPlayer = audio.AudioPlayer();
//   bool isRecording=false;
//   double spreadCount = 0;
//   bool increment=true;
//   bool decrement=false;
//   Timer? activeTimer;
//   late FlutterSoundRecorder _recordingSession;
//   String? pathToAudio;
//   int? seconds;
//   StreamSubscription? _recorderSubscription;
//
//   Future<void> startRecording() async {
//     try{
//       Directory directory = Directory(path.dirname(pathToAudio!));
//       if (!directory.existsSync()) {
//         directory.createSync();
//       }
//       _recordingSession.openRecorder();
//       await _recordingSession.startRecorder(
//         toFile: pathToAudio,
//         codec: Codec.pcm16WAV,
//       );
//       _recorderSubscription = _recordingSession.onProgress!.listen((e) {
//         var date = DateTime.fromMillisecondsSinceEpoch(e.duration.inMilliseconds,
//             isUtc: true);
//         setState(() {
//           seconds = date.second;
//         });
//       });
//     }
//     catch(e){
//       print(e.toString());
//     }
//   }
//
//   Future<String?> stopRecording() async {
//     _recorderSubscription!.cancel();
//     return await _recordingSession.stopRecorder();
//   }
//
//
//   void initializer() async {
//     await [
//       Permission.microphone,
//       Permission.storage,
//       Permission.manageExternalStorage,
//     ].request();
//     var statusMicroPhone = await Permission.microphone.status;
//     var statusStorage = await Permission.storage.status;
//     var statusExternalStorage = await Permission.manageExternalStorage.status;
//     if (statusMicroPhone.isDenied || statusStorage.isDenied || statusExternalStorage.isDenied) {
//       await [
//         Permission.microphone,
//         Permission.storage,
//         Permission.manageExternalStorage,
//       ].request();
//     }
//     _recordingSession = FlutterSoundRecorder();
//     await _recordingSession.openRecorder();
//     await _recordingSession.setSubscriptionDuration(Duration(milliseconds: 10));
//     await initializeDateFormatting();
//   }
//
//
//
//   introduction()async{
//     Provider.of<Chat>(context,listen: false).updatePrompt(widget.contents, widget.characterName);
//     final response = await OpenAiApi().textToSpeech(text:widget.introduction);
//     _playAudioFromBase64(response);
//   }
//
//   Future<void> _playAudioFromBase64(var response) async {
//     final audioBytes = base64Decode(response);
//     await audioPlayer.play(audioBytes);
//   }
//
//
//   @override
//   void initState() {
//     super.initState();
//     introduction();
//     initializer();
//
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//     audioPlayer.dispose();
//     _recorderSubscription!.cancel();
//     _recordingSession.stopRecorder();
//   }
//
//   static const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz';
//   Random _rnd = Random();
//
//   String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
//       length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
//
//
//   Future<bool> checkPermission() async {
//     if (!await Permission.microphone.isGranted) {
//       PermissionStatus status = await Permission.microphone.request();
//       if (status != PermissionStatus.granted) {
//         return false;
//       }
//     }
//     return true;
//   }
//
//   double averageScore = 0.0;
//
//   // Future<void> convertWavToMp3(String wavFilePath, String mp3FilePath) async {
//   //   final AudioPlayer audioPlayer = AudioPlayer();
//   //   final Directory tempDir = await getTemporaryDirectory();
//   //   final String tempFilePath = '${tempDir.path}/temp.mp3';
//   //
//   //   final File wavFile = File(wavFilePath);
//   //   await audioPlayer.setUrl(wavFile.path); // pass the file path of the WAV file
//   //   await audioPlayer.play(wavFile.path); // play the WAV file
//   //
//   //   await Future.delayed(const Duration(seconds: 1));
//   //
//   //   await audioPlayer.pause();
//   //   await audioPlayer.setUrl(tempFilePath);
//   //
//   //   await Future.delayed(const Duration(seconds: 1));
//   //
//   //   await audioPlayer.stop();
//   //
//   //   await audioPlayer.setReleaseMode(ReleaseMode.STOP);
//   //   await audioPlayer.dispose();
//   //
//   //   await File(tempFilePath).copy(mp3FilePath);
//   // }
//
//   // ///
//
//   // Stopwatch stopwatch = new Stopwatch();
//   // final _formKey = GlobalKey<FormState>();
//   // SpeechToText _speechToText = SpeechToText();
//   // bool _speechEnabled = false;
//   // String _lastWords = '';
//   // bool isKeyboard = false;
//   // String? text;
//   // TextEditingController controller = TextEditingController();
//   // FlutterTts flutterTts = FlutterTts();
//   // final filter = ProfanityFilter();
//   //
//   // Future _speak2(String userInput) async {
//   //   List voices = await flutterTts.getVoices;
//   //   // print(voices.length);
//   //   // for (var item in voices) {
//   //   //   print(item);
//   //   // }
//   //   await flutterTts.setVoice({"name": "en-us-x-sfg-local", "locale": "en-US"});
//   //   await flutterTts.speak(userInput);
//   //   // if (result == 1) setState(() => ttsState = TtsState.playing);
//   // }
//   //
//   // @override
//   // void initState() {
//   //   super.initState();
//   //   checkPermission();
//   //   _initSpeech();
//   // }
//   //
//   // /// This has to happen only once per app
//   // void _initSpeech() async {
//   //   _speechEnabled = await _speechToText.initialize();
//   //   setState(() {});
//   // }
//   //
//   // /// Each time to start a speech recognition session
//   // _startListening() async {
//   //   await _speechToText.listen(onResult: _onSpeechResult);
//   //   setState(() {});
//   // }
//   //
//   // /// Manually stop the active speech recognition session
//   // /// Note that there are also timeouts that each platform enforces
//   // /// and the SpeechToText plugin supports setting timeouts on the
//   // /// listen method.
//   // void _stopListening() async {
//   //   await _speechToText.stop();
//   //   setState(() {});
//   // }
//   //
//   // /// This is the callback that the SpeechToText plugin calls when
//   // /// the platform returns recognized words.
//   // void _onSpeechResult(SpeechRecognitionResult result) async {
//   //   setState(() {
//   //     _lastWords = result.recognizedWords;
//   //   });
//   //   if (_lastWords != '' && _speechToText.isNotListening) {
//   //     print('doSomething() executed in ${stopwatch.elapsed.inSeconds}');
//   //     stopwatch.stop();
//   //     int messageCount = await DatabaseServices().getMessageCount();
//   //     if (messageCount <= 0) {
//   //       Fluttertoast.showToast(
//   //           msg: "Your free messages for today is finished",
//   //           toastLength: Toast.LENGTH_SHORT,
//   //           gravity: ToastGravity.CENTER,
//   //           timeInSecForIosWeb: 1,
//   //           backgroundColor: Colors.red,
//   //           textColor: Colors.white,
//   //           fontSize: 16.0);
//   //     } else {
//   //       Map messageModel = {
//   //         'Message': _lastWords,
//   //         'My Message Check': true,
//   //         'Words Count': _lastWords.split(' ').length,
//   //         'Speak Timing': stopwatch.elapsed.inSeconds,
//   //         'Average': _lastWords.split(' ').length / stopwatch.elapsed.inSeconds,
//   //       };
//   //       Provider.of<ChatProvider>(context, listen: false)
//   //           .addModelToAiAssistantList(messageModel);
//   //       Provider.of<ChatProvider>(context, listen: false)
//   //           .updateAssistantPromptForUser(_lastWords);
//   //       String? dataFromOpenAi = await OpenAiApi()
//   //           .getAnswerFromAiForAiAssistant(
//   //               Provider.of<ChatProvider>(context, listen: false)
//   //                   .assistantPrompt);
//   //       Map messageModelFromAi = {
//   //         'Message': dataFromOpenAi ?? '',
//   //         'My Message Check': false,
//   //         'Words Count': dataFromOpenAi!.split(' ').length,
//   //       };
//   //       Provider.of<ChatProvider>(context, listen: false)
//   //           .updateAssistantPromptForAi(dataFromOpenAi);
//   //       Provider.of<ChatProvider>(context, listen: false)
//   //           .addModelToAiAssistantList(messageModelFromAi);
//   //       _speak2(dataFromOpenAi != ''
//   //           ? dataFromOpenAi
//   //           : 'I do not understand what you said');
//   //       DatabaseServices().incrementMessageCount();
//   //     }
//   //     _lastWords = '';
//   //   }
//   // }
//   //
//   // @override
//   // void dispose() {
//   //   flutterTts.stop();
//   //   super.dispose();
//   // }
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<Chat>(
//       builder: (context, messages, child) {
//         List reversedMessages = [];
//         reversedMessages =messages.getMessages(widget.characterName).reversed.toList();
//         return Scaffold(
//           appBar: AppBar(
//             backgroundColor: Colors.white,
//             foregroundColor: Colors.black,
//             title: Text(
//               'fluently',
//               style: GoogleFonts.pacifico(),
//             ),
//             elevation: 0.0,
//             actions: [
//               InkWell(
//                 onTap: () {},
//                 child: Padding(
//                   padding: const EdgeInsets.all(2.0),
//                   child: Icon(
//                     Icons.home,
//                     size: 26,
//                   ),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(right: 20),
//                 child: Icon(
//                   Icons.menu,
//                   size: 26,
//                 ),
//               ),
//             ],
//           ),
//           body: Padding(
//             padding: const EdgeInsets.only(left: 20,right: 20,bottom: 20),
//             child: Column(
//               children: [
//                 AiTypeBar(
//                   finishChatSession: () {
//                     int totalMessages = 0;
//                     double totalOfAllMessagesAverage = 0.0;
//                     for (var message in reversedMessages) {
//                       if (message['role']=='user') {
//                         print('average is ${message['Average']}');
//                         totalMessages++;
//                         totalOfAllMessagesAverage =
//                             totalOfAllMessagesAverage + message['Average'];
//
//                       }
//                     }
//                     print(totalMessages);
//                     print(totalOfAllMessagesAverage);
//                     // averageScore = totalOfAllMessagesAverage / totalMessages;
//                     averageScore = totalOfAllMessagesAverage;
//                     // showDialog(
//                     //     context: context,
//                     //     builder: (BuildContext context) {
//                     //       return Dialog(
//                     //         shape: RoundedRectangleBorder(
//                     //             borderRadius: BorderRadius.circular(
//                     //                 20.0)), //this right here
//                     //         child: Container(
//                     //           height: 200,
//                     //           width: 200,
//                     //           child: Padding(
//                     //             padding: EdgeInsets.symmetric(
//                     //                 horizontal: 30, vertical: 30),
//                     //             child: Column(
//                     //               mainAxisAlignment: MainAxisAlignment.center,
//                     //               crossAxisAlignment: CrossAxisAlignment.center,
//                     //               children: [
//                     //                 Text(
//                     //                   'Reports',
//                     //                   style: TextStyle(
//                     //                       fontWeight: FontWeight.bold,
//                     //                       fontSize: 16),
//                     //                   textAlign: TextAlign.center,
//                     //                 ),
//                     //                 SizedBox(height: 20),
//                     //                 Text(
//                     //                   'Your Fluently Score for this session is ${averageScore}',
//                     //                   style: TextStyle(
//                     //                       fontSize: 12,
//                     //                       fontWeight: FontWeight.w600),
//                     //                   textAlign: TextAlign.center,
//                     //                 ),
//                     //                 Spacer(),
//                     //                 Align(
//                     //                   alignment: Alignment.center,
//                     //                   child: InkWell(
//                     //                     onTap: () async {
//                     //                       DatabaseServices()
//                     //                           .storeScoreOfASession(
//                     //                               widget.chatType,
//                     //                               averageScore.toString());
//                     //                       DatabaseServices()
//                     //                           .storeMessagesOFASession(
//                     //                               data.teacherMessages,
//                     //                               widget.chatType);
//                     //                       Navigator.pop(context);
//                     //                     },
//                     //                     child: Container(
//                     //                       height: 40,
//                     //                       width: 150,
//                     //                       decoration: BoxDecoration(
//                     //                         color: Colors.red,
//                     //                         borderRadius:
//                     //                             BorderRadius.circular(10),
//                     //                       ),
//                     //                       alignment: Alignment.center,
//                     //                       child: Text(
//                     //                         'Exit',
//                     //                         style: TextStyle(
//                     //                             fontWeight: FontWeight.bold,
//                     //                             color: Colors.white,
//                     //                             fontSize: 17),
//                     //                       ),
//                     //                     ),
//                     //                   ),
//                     //                 )
//                     //               ],
//                     //             ),
//                     //           ),
//                     //         ),
//                     //       );
//                     //     });
//
//                     CustomDialogue(context, 'assets/random.json', 'Conversation Finished', 'Well done! Practice makes perfect. Here is your fluency score for the conversations',  'Save & Close',
//                             (){
//                           ///save convo
//                           DatabaseServices()
//                               .storeScoreOfASession(
//                             widget.characterName,
//                             averageScore.toString(),
//                           );
//                           Navigator.pop(context);
//                           Navigator.pop(context);
//                         },averageScore,true);
//                   },
//                 ),
//                 SizedBox(height: 15),
//                 Expanded(
//                   child: ListView.builder(
//                     reverse: true,
//                     itemCount:reversedMessages.length,
//                     itemBuilder: (BuildContext context, int index) {
//                       if(index==reversedMessages.length-1){
//                         return SizedBox();
//                       }
//                       else  if (reversedMessages[index]['role']=='user') {
//                         return SenderBubble(
//                             text: reversedMessages[index]['content']);
//                       } else {
//                         return ReceiverBubbles(
//                             text: reversedMessages[index]['content']);
//                       }
//                     },
//                   ),
//                 ),
//                 // Padding(
//                 //   padding:
//                 //       isKeyboard ? EdgeInsets.all(5.0) : EdgeInsets.all(10.0),
//                 //   child: Column(
//                 //     children: [
//                 //       isKeyboard
//                 //           ? SizedBox()
//                 //           : Text(
//                 //               _speechToText.isListening
//                 //                   ? '$_lastWords'
//                 //                   : _speechEnabled
//                 //                       ? 'Tap the microphone to start listening...'
//                 //                       : 'Speech not available',
//                 //             ),
//                 //       isKeyboard ? SizedBox() : SizedBox(height: 10),
//                 //       isKeyboard
//                 //           ? Row(
//                 //               children: [
//                 //                 InkWell(
//                 //                   onTap: () {
//                 //                     setState(() {
//                 //                       isKeyboard = false;
//                 //                     });
//                 //                   },
//                 //                   child: Image.asset(
//                 //                     'assets/keyboard.png',
//                 //                     height: 25,
//                 //                   ),
//                 //                 ),
//                 //                 SizedBox(width: 10),
//                 //                 Expanded(
//                 //                   child: Form(
//                 //                     key: _formKey,
//                 //                     child: TextFormField(
//                 //                       decoration: InputDecoration(
//                 //                           hintText: 'Type Something'),
//                 //                       validator: (value) => value!.isEmpty
//                 //                           ? 'type something'
//                 //                           : null,
//                 //                       controller: controller,
//                 //                       onChanged: (val) {
//                 //                         text = val;
//                 //                       },
//                 //                     ),
//                 //                   ),
//                 //                 ),
//                 //                 SizedBox(width: 10),
//                 //                 IconButton(
//                 //                   onPressed: () async {
//                 //                     if (_formKey.currentState!.validate()) {
//                 //                       int messageCount =
//                 //                           await DatabaseServices()
//                 //                               .getMessageCount();
//                 //                       if (messageCount <= 0) {
//                 //                         Fluttertoast.showToast(
//                 //                             msg:
//                 //                                 "Your free messages for today is finished",
//                 //                             toastLength: Toast.LENGTH_SHORT,
//                 //                             gravity: ToastGravity.CENTER,
//                 //                             timeInSecForIosWeb: 1,
//                 //                             backgroundColor: Colors.red,
//                 //                             textColor: Colors.white,
//                 //                             fontSize: 16.0);
//                 //                       } else {
//                 //                         bool isBadWord =
//                 //                             filter.hasProfanity(text!);
//                 //                         if (isBadWord) {
//                 //                           Fluttertoast.showToast(
//                 //                               msg:
//                 //                                   "Please don\'t user bad words",
//                 //                               toastLength: Toast.LENGTH_SHORT,
//                 //                               gravity: ToastGravity.CENTER,
//                 //                               timeInSecForIosWeb: 1,
//                 //                               backgroundColor: Colors.red,
//                 //                               textColor: Colors.white,
//                 //                               fontSize: 16.0);
//                 //                         } else {
//                 //                           List<String> words = text!.split(' ');
//                 //                           DatabaseServices().updateVocabulary(words);
//                 //                           Map messageModel = {
//                 //                             'Message': text,
//                 //                             'My Message Check': true,
//                 //                           };
//                 //                           Provider.of<ChatProvider>(context,
//                 //                                   listen: false)
//                 //                               .addModelToAiAssistantList(
//                 //                                   messageModel);
//                 //                           Provider.of<ChatProvider>(context,
//                 //                                   listen: false)
//                 //                               .updateAssistantPromptForUser(
//                 //                                   text!);
//                 //                           controller.clear();
//                 //                           String? dataFromOpenAi =
//                 //                               await OpenAiApi()
//                 //                                   .getAnswerFromAiForAiAssistant(
//                 //                                       Provider.of<ChatProvider>(
//                 //                                               context,
//                 //                                               listen: false)
//                 //                                           .assistantPrompt);
//                 //                           Map messageModelFromAi = {
//                 //                             'Message': dataFromOpenAi ?? '',
//                 //                             'My Message Check': false,
//                 //                           };
//                 //                           Provider.of<ChatProvider>(context,
//                 //                                   listen: false)
//                 //                               .updateAssistantPromptForAi(
//                 //                                   dataFromOpenAi!);
//                 //                           Provider.of<ChatProvider>(context,
//                 //                                   listen: false)
//                 //                               .addModelToAiAssistantList(
//                 //                                   messageModelFromAi);
//                 //                           _speak2(dataFromOpenAi != ''
//                 //                               ? dataFromOpenAi
//                 //                               : 'I do not understand what you said');
//                 //                           DatabaseServices()
//                 //                               .incrementMessageCount();
//                 //                           // if (widget.chatType == 'Teacher') {
//                 //                           // MessageModel model = MessageModel(
//                 //                           //     text: text!,
//                 //                           //     myMessageCheck: true);
//                 //                           // // data.addModelToTeacherList(model);
//                 //                           // controller.clear();
//                 //                           // data.updatePromptForUser(text!);
//                 //                           // String? dataFromOpenAi =
//                 //                           //     await OpenAiApi()
//                 //                           //         .getAnswerFromAiForTeacher(
//                 //                           //             data.prompt);
//                 //                           // MessageModel modelFromOpenAi =
//                 //                           //     MessageModel(
//                 //                           //         text: dataFromOpenAi == ''
//                 //                           //             ? 'I do not understand, what you said'
//                 //                           //             : dataFromOpenAi!,
//                 //                           //         myMessageCheck: false);
//                 //                           // // data.addModelToTeacherList(
//                 //                           // //     modelFromOpenAi);
//                 //                           // _speak2(dataFromOpenAi != ''
//                 //                           //     ? dataFromOpenAi!
//                 //                           //     : 'I do not understand what you said');
//                 //                           // data.updatePromptForAi(
//                 //                           //     dataFromOpenAi!);
//                 //                           // data.resetPrompt();
//                 //                           // DatabaseServices()
//                 //                           //     .incrementMessageCount();
//                 //                           // } else if (widget.chatType ==
//                 //                           //     'Friend') {
//                 //                           //   MessageModel model = MessageModel(
//                 //                           //       text: text!,
//                 //                           //       myMessageCheck: true);
//                 //                           //   data.addModelToAiFriendList(model);
//                 //                           //   controller.clear();
//                 //                           //   data.updateFriendPromptForUser(
//                 //                           //       text!);
//                 //                           //   MessageService()
//                 //                           //       .storeMessageInSenderDatabase(
//                 //                           //           text!,
//                 //                           //           AuthServices().getUid(),
//                 //                           //           'Friend',
//                 //                           //           true);
//                 //                           //   String? dataFromOpenAi =
//                 //                           //       await OpenAiApi()
//                 //                           //           .getAnswerFromAiForFriend(
//                 //                           //               data.prompt);
//                 //                           //   MessageModel modelFromOpenAi =
//                 //                           //       MessageModel(
//                 //                           //           text: dataFromOpenAi == ''
//                 //                           //               ? 'I do not understand, what you said'
//                 //                           //               : dataFromOpenAi!,
//                 //                           //           myMessageCheck: false);
//                 //                           //   data.addModelToAiFriendList(
//                 //                           //       modelFromOpenAi);
//                 //                           //   MessageService()
//                 //                           //       .storeMessageInSenderDatabase(
//                 //                           //           dataFromOpenAi == ''
//                 //                           //               ? 'I do not understand, what you said'
//                 //                           //               : dataFromOpenAi!,
//                 //                           //           AuthServices().getUid(),
//                 //                           //           'Friend',
//                 //                           //           false);
//                 //                           //   _speak2(dataFromOpenAi != ''
//                 //                           //       ? dataFromOpenAi!
//                 //                           //       : 'I do not understand what you said');
//                 //                           //   data.updateFriendPromptForAi(
//                 //                           //       dataFromOpenAi!);
//                 //                           //   data.resetFriendPrompt();
//                 //                           //   DatabaseServices()
//                 //                           //       .incrementMessageCount();
//                 //                           // } else if (widget.chatType ==
//                 //                           //     'Study Notes') {
//                 //                           //   MessageModel model = MessageModel(
//                 //                           //       text: text!,
//                 //                           //       myMessageCheck: true);
//                 //                           //   data.addModelToAiNotesList(model);
//                 //                           //   MessageService()
//                 //                           //       .storeMessageInSenderDatabase(
//                 //                           //           text!,
//                 //                           //           AuthServices().getUid(),
//                 //                           //           'Study Notes',
//                 //                           //           true);
//                 //                           //   controller.clear();
//                 //                           //   data.updateNotesPromptForUser(
//                 //                           //       text!);
//                 //                           //   String? dataFromOpenAi =
//                 //                           //       await OpenAiApi()
//                 //                           //           .getAnswerFromAiForAiNotes(
//                 //                           //               data.notesPrompt);
//                 //                           //   MessageModel modelFromOpenAi =
//                 //                           //       MessageModel(
//                 //                           //           text: dataFromOpenAi == ''
//                 //                           //               ? 'I do not understand, what you said'
//                 //                           //               : dataFromOpenAi!,
//                 //                           //           myMessageCheck: false);
//                 //                           //   data.addModelToAiNotesList(
//                 //                           //       modelFromOpenAi);
//                 //                           //   MessageService()
//                 //                           //       .storeMessageInSenderDatabase(
//                 //                           //           dataFromOpenAi == ''
//                 //                           //               ? 'I do not understand, what you said'
//                 //                           //               : dataFromOpenAi!,
//                 //                           //           AuthServices().getUid(),
//                 //                           //           'Study Notes',
//                 //                           //           false);
//                 //                           //   _speak2(dataFromOpenAi != ''
//                 //                           //       ? dataFromOpenAi!
//                 //                           //       : 'I do not understand what you said');
//                 //                           //   data.updateNotesPromptForAi(
//                 //                           //       dataFromOpenAi!);
//                 //                           //   data.resetNotesPrompt();
//                 //                           //   DatabaseServices()
//                 //                           //       .incrementMessageCount();
//                 //                           // } else {
//                 //                           //   MessageModel model = MessageModel(
//                 //                           //       text: text!,
//                 //                           //       myMessageCheck: true);
//                 //                           //   data.addModelToAiAssistantList(
//                 //                           //       model);
//                 //                           //   MessageService()
//                 //                           //       .storeMessageInSenderDatabase(
//                 //                           //           text!,
//                 //                           //           AuthServices().getUid(),
//                 //                           //           'Assistant',
//                 //                           //           true);
//                 //                           //   controller.clear();
//                 //                           //   data.updateAssistantPromptForUser(
//                 //                           //       text!);
//                 //                           //   String? dataFromOpenAi =
//                 //                           //       await OpenAiApi()
//                 //                           //           .getAnswerFromAiForAiAssistant(
//                 //                           //               data.assistantPrompt);
//                 //                           //   MessageModel modelFromOpenAi =
//                 //                           //       MessageModel(
//                 //                           //           text: dataFromOpenAi == ''
//                 //                           //               ? 'I do not understand, what you said'
//                 //                           //               : dataFromOpenAi!,
//                 //                           //           myMessageCheck: false);
//                 //                           //   MessageService()
//                 //                           //       .storeMessageInSenderDatabase(
//                 //                           //           dataFromOpenAi == ''
//                 //                           //               ? 'I do not understand, what you said'
//                 //                           //               : dataFromOpenAi!,
//                 //                           //           AuthServices().getUid(),
//                 //                           //           'Assistant',
//                 //                           //           false);
//                 //                           //   data.addModelToAiAssistantList(
//                 //                           //       modelFromOpenAi);
//                 //                           //   _speak2(dataFromOpenAi != ''
//                 //                           //       ? dataFromOpenAi!
//                 //                           //       : 'I do not understand what you said');
//                 //                           //   data.updateAssistantPromptForAi(
//                 //                           //       dataFromOpenAi!);
//                 //                           //   data.resetAssistantPrompt();
//                 //                           //   DatabaseServices()
//                 //                           //       .incrementMessageCount();
//                 //                           // }
//                 //
//                 //                         }
//                 //                       }
//                 //                     }
//                 //                   },
//                 //                   icon: Icon(
//                 //                     Icons.send,
//                 //                     color: Colors.black,
//                 //                     size: 20,
//                 //                   ),
//                 //                 )
//                 //               ],
//                 //             )
//                 //           : Row(
//                 //               mainAxisAlignment: MainAxisAlignment.center,
//                 //               children: [
//                 //                 InkWell(
//                 //                   onTap: () async {
//                 //                     if (_speechToText.isNotListening) {
//                 //                       stopwatch.start();
//                 //                       await _startListening();
//                 //                     } else {
//                 //                       _stopListening();
//                 //                     }
//                 //                   },
//                 //                   child: Container(
//                 //                     height: 44,
//                 //                     width: 44,
//                 //                     alignment: Alignment.center,
//                 //                     padding:
//                 //                         EdgeInsets.symmetric(horizontal: 10),
//                 //                     child: Icon(
//                 //                       _speechToText.isNotListening
//                 //                           ? Icons.mic_off
//                 //                           : Icons.mic,
//                 //                       size: 25,
//                 //                       color: Colors.black.withOpacity(0.65),
//                 //                     ),
//                 //                     decoration: BoxDecoration(
//                 //                         color: Color(0xffF0F0F0),
//                 //                         shape: BoxShape.circle),
//                 //                   ),
//                 //                 ),
//                 //                 SizedBox(width: 7),
//                 //                 InkWell(
//                 //                   onTap: () {
//                 //                     setState(() {
//                 //                       isKeyboard = true;
//                 //                     });
//                 //                   },
//                 //                   child: Container(
//                 //                     height: 40,
//                 //                     width: 60,
//                 //                     padding: EdgeInsets.symmetric(
//                 //                         horizontal: 5, vertical: 2),
//                 //                     child: Image.asset('assets/keyboard.png'),
//                 //                     decoration: BoxDecoration(
//                 //                         color: Color(0xffF0F0F0),
//                 //                         borderRadius: BorderRadius.circular(5)),
//                 //                   ),
//                 //                 ),
//                 //               ],
//                 //             ),
//                 //     ],
//                 //   ),
//                 // ),
//                 messagesCount<=10? InkWell(
//                   onTap: () async {
//                     setState(() {
//                       isRecording=!isRecording;
//                     });
//                     if(isRecording){
//                       activeTimer =  Timer.periodic(Duration(milliseconds: 50), (timer) {
//                         setState(() {
//                           if(increment){
//                             spreadCount=spreadCount+1;
//                             if(spreadCount==20){
//                               increment=false;
//                               decrement=true;
//                             }
//                           }
//                           else if(decrement){
//                             spreadCount=spreadCount-1;
//                             if(spreadCount==0){
//                               decrement=false;
//                               increment=true;
//                             }
//                           }
//                         });
//                       });
//                       audioPlayer.pause();
//                       Directory? appDocDir =
//                       Platform.isAndroid ? await getExternalStorageDirectory() : await getApplicationDocumentsDirectory();
//                       setState(() {
//                         String pathHeader = getRandomString(5);
//                         pathToAudio = '${appDocDir!.path}/$pathHeader.wav';
//                         startRecording();
//                       });
//
//                     }
//                     else{
//                       activeTimer!.cancel();
//                       spreadCount=0;
//                       increment=true;
//                       decrement=false;
//                       _recorderSubscription!.cancel();
//                       await _recordingSession.stopRecorder();
//                       var googleCloudTTSResponse= await OpenAiApi().googleSpeechToText(filePath: pathToAudio!);
//                       print('voice note duration $seconds');
//                       messages.updateMessages(
//                           {
//                             "role": "user",
//                             "content": googleCloudTTSResponse['results'][0]['alternatives'][0]['transcript'],
//                             'Average':googleCloudTTSResponse['results'][0]['alternatives'][0]['transcript'].split(' ').length/seconds
//                           },
//                           widget.characterName
//                       );
//                       messagesCount++;
//                       List<String> words = googleCloudTTSResponse['results'][0]['alternatives'][0]['transcript'].split(' ');
//                       DatabaseServices().updateVocabulary(words);
//                       DatabaseServices().updateVocabularyWithTime(words);
//                       if(messagesCount>=10){
//                         CustomDialogue(context, 'assets/timeended.png', 'Limit Reached', 'Upgrade to our premium subscription plan for longer conversations and the best experience! With our free plan, you\'re limited to 10 messages per day. Upgrade now for uninterrupted conversations!',  'Get subscription', (){
//                           Navigator.pop(context);
//                           Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
//                             return PlansScreen(profileCheck: true);
//                           }));
//                         },null,false);
//                         final response = await OpenAiApi().textToSpeech(text:'Thank you for talking with me,your conversation has been ended, come back tomorrow');
//                         _playAudioFromBase64(response);
//                         setState(() {
//                         });
//                         AuthServices().updateChatSession();
//                       }
//                       else{
//                         var gptResponse =await OpenAiApi().openAiCall(userId: AuthServices().getUid(), messages: messages.travelGuideMessages);
//                         messages.updateMessages(gptResponse['choices'][0]['message'],widget.characterName);
//                         final response = await OpenAiApi().textToSpeech(text:gptResponse['choices'][0]['message']['content']);
//                         _playAudioFromBase64(response);
//                       }
//                     }
//                   },
//                   child: Container(
//                     height: 44,
//                     width: 44,
//                     alignment: Alignment.center,
//                     padding:
//                     EdgeInsets.symmetric(horizontal: 10),
//                     child: Icon(
//                       isRecording
//                           ?Icons.mic: Icons.mic_off,
//                       size: 25,
//                       color: Colors.black.withOpacity(0.65),
//                     ),
//                     decoration: BoxDecoration(
//                         color: Color(0xffF0F0F0),
//                         shape: BoxShape.circle,
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.grey.withOpacity(0.3),
//                             blurRadius: spreadCount,
//                             spreadRadius: spreadCount,
//                             offset: Offset(0,0),
//                           )
//                         ]
//                     ),
//                   ),
//                 ):SizedBox(),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }