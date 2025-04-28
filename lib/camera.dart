import 'package:Eco/appSizes.dart';
import 'package:Eco/permission.dart';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CameraPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  late CameraController _controller;
  Future<void>? _initializeControllerFuture; // ✅ заменили late на nullable
  bool _isFlashOn = false;

  @override
  void initState() {
    super.initState();
    _initializeCameraFlow(); // ✅ единая последовательная инициализация
  }

  Future<void> _initializeCameraFlow() async {
    await _initializeApp();
    await _initCamera();
    if (mounted) setState(() {}); // ✅ вызываем setState после инициализации
  }

  Future<void> _initializeApp() async {
    await AppPermission.checkAndRequestCameraPermission();
  }

  Future<void> _initCamera() async {
    final cameras = await availableCameras();
    final camera = cameras.first;

    _controller = CameraController(
      camera,
      ResolutionPreset.high,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleFlash() async {
    _isFlashOn = !_isFlashOn;
    await _controller.setFlashMode(
        _isFlashOn ? FlashMode.torch : FlashMode.off);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _initializeControllerFuture == null
          ? const Center(child: CircularProgressIndicator()) // ✅ безопасная проверка
          : FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Stack(
              fit: StackFit.expand,
              children: [
                CameraPreview(_controller),
                // Верхняя панель
                Positioned(
                  top: 0,
                  child: Container(
                    width: AppSizes.width,
                    height: AppSizes.height * 0.2,
                    decoration:
                    const BoxDecoration(color: Color(0xFF131010)),
                    padding: EdgeInsets.symmetric(
                      vertical: AppSizes.height * 0.07,
                      horizontal: AppSizes.width * 0.02,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: AppSizes.width * 0.08,
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ),
                ),
                // Нижняя панель
                Positioned(
                  bottom: 0,
                  child: Container(
                    width: AppSizes.width,
                    height: AppSizes.height * 0.3,
                    decoration:
                    const BoxDecoration(color: Color(0xFF131010)),
                    child: Column(
                      children: [
                        SizedBox(height: AppSizes.height * 0.11),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: AppSizes.width * 0.15),
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(width: AppSizes.width * 0.1),
                              GestureDetector(
                                onTap: () async {
                                  try {
                                    await _initializeControllerFuture;
                                    final image =
                                    await _controller.takePicture();
                                    print('📸 Фото сделано: ${image.path}');
                                    Navigator.pop(context, image.path);
                                  } catch (e) {
                                    print('Ошибка при съёмке: $e');
                                  }
                                },
                                child: Container(
                                  width: AppSizes.width * 0.2,
                                  height: AppSizes.width * 0.2,
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: Colors.grey, width: 4),
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.flash_on,
                                  color: _isFlashOn
                                      ? Colors.green
                                      : Colors.grey,
                                  size: AppSizes.width * 0.08,
                                ),
                                onPressed: _toggleFlash,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
