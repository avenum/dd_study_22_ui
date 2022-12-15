import 'dart:io';
import 'dart:math';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CamWidget extends StatefulWidget {
  final Function(File) onFile;
  const CamWidget({
    Key? key,
    required this.onFile,
  }) : super(key: key);

  @override
  State<CamWidget> createState() => CamWidgetState();
}

class CamWidgetState extends State<CamWidget> {
  CameraController? controller;

  @override
  void initState() {
    super.initState();
    asyncInit();
  }

  asyncInit() async {
    var cameras = await availableCameras();
    controller = CameraController(cameras[0], ResolutionPreset.high);
    await controller!.initialize();
    if (!mounted) {
      return;
    }
    setState(() {});
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!(controller?.value.isInitialized ?? false)) {
      return const Center(
          child: Text(
        "Camera initialize",
        style: TextStyle(color: Colors.white),
      ));
    }

    var camera = controller!.value;

    return LayoutBuilder(
      builder: (context, constraints) {
        var scale = (min(constraints.maxWidth, constraints.maxHeight) /
                max(constraints.maxWidth, constraints.maxHeight)) *
            camera.aspectRatio;

        if (scale < 1) scale = 1 / scale;

        return Stack(
          children: [
            Transform.scale(
              scale: scale,
              child: Center(
                child: CameraPreview(
                  controller!,
                ),
              ),
            ),
            Container(
              alignment: Alignment.bottomCenter,
              padding: const EdgeInsets.only(bottom: 10),
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 2),
                      color: Colors.grey[400]!.withAlpha(150),
                      borderRadius: BorderRadius.circular(30)),
                  width: 60,
                  height: 60,
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    icon: Icon(Icons.camera),
                    color: Colors.white,
                    iconSize: 54,
                    onPressed: () async {
                      var file = await controller!.takePicture();
                      widget.onFile(File(file.path));
                    },
                  ),
                )
              ]),
            )
          ],
        );
      },
    );
  }
}
