import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class CameraProvider extends ChangeNotifier {
  CameraController? cameraController ;
  bool isCameraInitialized = false;

  Future<void> initCamera() async {
    final cameras = await availableCameras();
    final frontCamera = cameras.firstWhere(
          (camera) => camera.lensDirection == CameraLensDirection.front,
      orElse: () => cameras.first,
    );
    final size = Size(300, 300);
    cameraController = CameraController(
      frontCamera,
      ResolutionPreset.max,
    );
    await cameraController!.initialize();
    isCameraInitialized = true;
    notifyListeners(); // Notify listeners after camera initialization
  }
}
