import 'dart:io';

import 'package:camera/camera.dart';
import 'package:deepleaf/pages/scans_page.dart';
import 'package:deepleaf/widgets/base_widget.dart';
import 'package:deepleaf/widgets/scan_button.dart';
import 'package:deepleaf/state/home_page_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:image_picker/image_picker.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Allows interaction with the Camera API
  late CameraController controller;

  // Camera is ready
  bool ready = false;

  @override
  void initState() {
    // Run on startup
    super.initState();
    initCamera();
  }

  // Initialise the camera
  void initCamera() async {
    // Get cameras
    List<CameraDescription> cameras = await availableCameras();

    // Initialise and update state
    controller = CameraController(cameras[0], ResolutionPreset.max);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {
        ready = true;
      });
    });
  }

  @override
  void dispose() {
    // Dispose of Camera controller on teardown
    controller.dispose();
    super.dispose();
  }

  // Slide up panel controller and contents
  final PanelController _panelController = PanelController();
  late Widget _panelContents;

  // Predict image
  void scanImage(
      CameraController controller, HomePageState state, double vpW) async {
    // Take photo
    XFile photo = await controller.takePicture();

    // Calls home_page_state.dart function
    await state.scanImage(photo, vpW);
    _panelController.show();
    _panelController.open();
  }

  // Select image from camera roll / gallery
  void selectImage(HomePageState state, double vpW) async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      await state.scanImage(image, vpW);
      _panelController.show();
      _panelController.open();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get height and width of screen
    double vpW = MediaQuery.of(context).size.width;
    double vpH = MediaQuery.of(context).size.height;

    // If camera is not ready, show text
    if (!ready || !controller.value.isInitialized) {
      return Scaffold(
        body: Container(
          child: Center(
            child: Text("Loading camera"),
          ),
        ),
      );
    } else {
      return PageView(children: [
        BaseWidget<HomePageState>(
            state: Provider.of<HomePageState>(context),
            onStateReady: (state) {
              state.init();
            },
            builder: (context, state, child) {
              if (!state.scanning && !state.finishedScanning) {
                // Camera is ready to scan
                return Scaffold(
                    body: Container(
                        width: vpW,
                        height: vpH,
                        child: Stack(
                          children: [
                            Container(
                                width: vpW,
                                height: vpH,
                                child: CameraPreview(controller)),
                            Positioned(
                              top: 0.0,
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                height: 200,
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                      Colors.black.withOpacity(0.66),
                                      Colors.black.withOpacity(0)
                                    ])),
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Scan a plant',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 30,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        'Keep the whole plant in view',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 22),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 50,
                              child: Container(
                                width: vpW,
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Container(
                                      height: 50,
                                      width: 50,
                                      color: Colors.transparent,
                                    ),
                                    GestureDetector(
                                        onTap: () async {
                                          scanImage(controller, state, vpW);
                                        },
                                        child: ScanButton()),
                                    GestureDetector(
                                      onTap: () {
                                        selectImage(state, vpW);
                                      },
                                      child: Container(
                                        height: 50,
                                        width: 50,
                                        decoration: BoxDecoration(
                                            color:
                                                Colors.black.withOpacity(0.5),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(100))),
                                        child: Center(
                                          child: Icon(
                                            Icons.image_outlined,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        )));
              } else {
                // Scanning, or prediction returned
                return SlidingUpPanel(
                    backdropEnabled: true,
                    backdropOpacity: 0.8,
                    padding: EdgeInsets.all(0.0),
                    margin: EdgeInsets.all(0.0),
                    header: Container(),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        topRight: Radius.circular(20.0)),
                    minHeight: 0.0,
                    maxHeight: vpH * 0.8,
                    controller: _panelController,
                    onPanelClosed: () {
                      state.reset();
                      _panelController.hide();
                    },
                    panelBuilder: (c) {
                      if (!state.scanning && state.finishedScanning) {
                        return state.panelContents;
                      } else {
                        return Center(child: CircularProgressIndicator());
                      }
                    },
                    body: Scaffold(
                      body: Stack(
                        children: [
                          Container(
                            width: vpW,
                            height: vpH,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: FileImage(
                                        File(state.scannedImagePath)))),
                          ),
                          Positioned(
                            top: 0.0,
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 200,
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                    Colors.black.withOpacity(0.66),
                                    Colors.black.withOpacity(0)
                                  ])),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Scanning...',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        state.reset();
                                      },
                                      child: Container(
                                        color: Colors.transparent,
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 30, vertical: 16),
                                          child: Text(
                                            "Cancel",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ));
              }
            }),
        // Second page
        ScansPage()
      ]);
    }
  }
}
