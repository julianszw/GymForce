import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gym_force/config/providers/user_registration_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class RegisterDniScreen extends ConsumerStatefulWidget {
  const RegisterDniScreen({super.key});

  @override
  RegisterDniScreenState createState() => RegisterDniScreenState();
}

class RegisterDniScreenState extends ConsumerState<RegisterDniScreen> {
  CameraController? _cameraController;
  File? _image;
  final picker = ImagePicker();
  bool _isCameraInitialized = false;
  bool _isFrontCamera = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera([bool isFrontCamera = false]) async {
    final cameras = await availableCameras();
    CameraDescription camera;
    if (isFrontCamera) {
      camera = cameras.firstWhere(
          (camera) => camera.lensDirection == CameraLensDirection.front);
    } else {
      camera = cameras.firstWhere(
          (camera) => camera.lensDirection == CameraLensDirection.back);
    }

    _cameraController = CameraController(
      camera,
      ResolutionPreset.high,
    );

    await _cameraController!.initialize();

    if (mounted) {
      setState(() {
        _isCameraInitialized = true;
        _image = null;
      });
    }
  }

  void _switchCamera() {
    _isFrontCamera = !_isFrontCamera;
    _initializeCamera(_isFrontCamera);
  }

  Future<void> _takePhoto() async {
    if (_cameraController != null && _cameraController!.value.isInitialized) {
      try {
        final image = await _cameraController!.takePicture();
        setState(() {
          _image = File(image.path);
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Error al intentar tomar la foto'),
        ));
      }
    }
  }

  Future<void> _selectFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  void _goToNextScreen() {
    if (_image != null) {
      final userRegistrationNotifier =
          ref.read(userRegistrationProvider.notifier);
      userRegistrationNotifier.updateDniPhotoPath(_image!);
      context.push('/register_selfie');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Por favor, selecciona o toma una foto de tu DNI.')),
      );
    }
  }

  void _retakePhoto() {
    setState(() {
      _image = null;
      _isCameraInitialized = false;
    });
    _initializeCamera(_isFrontCamera);
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Sacale foto a tu dni',
              style: TextStyle(color: Colors.white, fontSize: 36),
            ),
          ),
          Expanded(
            child: _isCameraInitialized && _image == null
                ? Center(
                    child: AspectRatio(
                      aspectRatio: 3 / 4,
                      child: ClipRRect(
                        child: Stack(
                          children: [
                            Align(
                                child: CameraPreview(
                              _cameraController!,
                            )),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    IconButton(
                                      icon: Icon(
                                        _isFrontCamera
                                            ? Icons.camera_rear
                                            : Icons.camera_front,
                                        color: Colors.white,
                                        size: 30,
                                      ),
                                      onPressed: _switchCamera,
                                    ),
                                    GestureDetector(
                                      onTap: _takePhoto,
                                      child: Container(
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                        ),
                                        padding: const EdgeInsets.all(20),
                                        child: const Icon(Icons.camera_alt,
                                            size: 30, color: Colors.black),
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.photo_library,
                                          color: Colors.white, size: 30),
                                      onPressed: _selectFromGallery,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : _image != null
                    ? Image.file(
                        _image!,
                        width: 295,
                      )
                    : Center(
                        child: CircularProgressIndicator(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: 150,
                child: ElevatedButton(
                  onPressed: _image != null ? _retakePhoto : null,
                  child: const Text(
                    'Volver a sacar',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(
                width: 150,
                child: ElevatedButton(
                  onPressed: _image != null ? _goToNextScreen : null,
                  child: const Text(
                    'Siguiente',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
