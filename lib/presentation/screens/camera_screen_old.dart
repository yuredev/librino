// // ignore_for_file: use_build_context_synchronously

// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
// import 'package:librino/core/bindings.dart';
// import 'package:librino/core/constants/colors.dart';
// import 'package:librino/presentation/utils/presentation_utils.dart';
// import 'package:librino/presentation/widgets/shared/inkwell_widget.dart';
// import 'package:librino/presentation/widgets/shared/librino_scaffold.dart';
// import 'package:librino/presentation/widgets/shared/shimmer_widget.dart';

// class CameraScreenOld extends StatefulWidget {
//   final bool isVideo;
//   final bool startInFrontal;

//   const CameraScreenOld({
//     Key? key,
//     this.startInFrontal = false,
//     this.isVideo = false,
//   }) : super(key: key);

//   @override
//   State<CameraScreenOld> createState() => _CameraScreenOldState();
// }

// class _CameraScreenOldState extends State<CameraScreenOld> {
//   late CameraController cameraController;
//   final FlutterFFmpeg ffmpeg = Bindings.get();
//   var isRecording = false;
//   late final Future future;
//   late final List<CameraDescription> cameras;

//   @override
//   void initState() {
//     super.initState();
//     future = initAll();
//   }

//   Future<void> initAll() async {
//     cameras = await getAvailableCameras();
//     await initCamera(widget.startInFrontal
//         ? CameraLensDirection.front
//         : CameraLensDirection.back);
//   }

//   Future<List<CameraDescription>> getAvailableCameras() async {
//     return availableCameras();
//   }

//   void onRecordBtnPress() async {
//     setState(() => isRecording = !isRecording);
//     if (isRecording) {
//       await cameraController.startVideoRecording();
//     } else {
//       final video = await cameraController.stopVideoRecording();
//       final fixedVideoPath = '${video.path}_fixed.mp4';
//       // TODO: criar um Utils????
//       cameraController.pausePreview();
//       PresentationUtils.showLockedLoading(context, text: 'Salvando vídeo...');
//       await ffmpeg.execute(
//         "-y -i ${video.path} -filter:v \"hflip\" $fixedVideoPath",
//       );
//       Navigator.pop(context);
//       if (context.mounted) Navigator.pop(context, XFile(fixedVideoPath));
//     }
//     // final foto = await cameraController.takePicture();
//   }

//   void onTakePicturePress() async {
//     final file = await cameraController.takePicture();
//     Navigator.pop(context, file);
//   }

//   Future<void> initCamera(CameraLensDirection direction) async {
//     cameraController = CameraController(
//       cameras.firstWhere(
//         (element) => element.lensDirection == direction,
//       ),
//       ResolutionPreset.veryHigh,
//     );
//     try {
//       await cameraController.initialize();
//       if (!mounted) return;
//       setState(() {});
//     } catch (e) {
//       if (e is CameraException) {
//         switch (e.code) {
//           case 'CameraAccessDenied':
//             PresentationUtils.showSnackBar(
//               context,
//               'Você deve permitir o uso da câmera ao Librino',
//               isErrorMessage: true,
//             );
//             Navigator.pop(context);
//             break;
//           default:
//             print(e);
//             PresentationUtils.showSnackBar(
//               context,
//               'Erro desconhecido ao abrir a câmera',
//               isErrorMessage: true,
//             );
//             Navigator.pop(context);
//             break;
//         }
//       }
//     }
//   }

//   Widget buildCameraPreview() {
//     // final camera = cameraController.value;
//     // final size = MediaQuery.of(context).size;
//     // var scale = size.aspectRatio * camera.aspectRatio;
//     // if (scale < 1) scale = 1 / scale;

//     final size = MediaQuery.of(context).size.width;

//     // return Container(
//     //   color: Colors.black,
//     //   alignment: Alignment.center,
//     //   child: SizedBox(
//     //     width: size,
//     //     height: size,
//     //     child: ClipRRect(
//     //       child: OverflowBox(
//     //         child: FittedBox(
//     //           fit: BoxFit.fitWidth,
//     //           child: SizedBox(
//     //             width: size,
//     //             height: size / cameraController.value.aspectRatio,
//     //             child: CameraPreview(cameraController),
//     //           ),
//     //         ),
//     //       ),
//     //     ),
//     //   ),
//     // );
//     // return AspectRatio(
//     //   aspectRatio: 1,
//     //   child: ClipRect(
//     //     child: Transform.scale(
//     //       scale: 1 / cameraController.value.aspectRatio,
//     //       child: Center(
//     //         child: AspectRatio(
//     //           aspectRatio: cameraController.value.aspectRatio,
//     //           child: CameraPreview(cameraController),
//     //         ),
//     //       ),
//     //     ),
//     //   ),
//     // );
//     return AspectRatio(
//       aspectRatio: 1,
//       child: ClipRect(
//         child: Transform.scale(
//           scale: cameraController.value.aspectRatio,
//           child: Center(
//             child: CameraPreview(cameraController),
//           ),
//         ),
//       ),
//     );
//   }

//   void switchCamera() async {
//     final newDirection =
//         cameraController.description.lensDirection == CameraLensDirection.front
//             ? CameraLensDirection.back
//             : CameraLensDirection.front;
//     // cameraController.setDescription(
//     //     cameras.firstWhere((element) => element.lensDirection == newDirection));
//     await initCamera(newDirection);
//   }

//   Widget buildLoading() {
//     return Expanded(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           AppBar(
//             title: Text(
//               widget.isVideo ? 'Gravar vídeo' : 'Capturar foto',
//             ),
//           ),
//           Column(
//             children: [
//               ShimmerWidget(
//                 child: Icon(
//                   Icons.camera_alt,
//                   size: MediaQuery.of(context).size.width * 0.45,
//                   color: Colors.white.withOpacity(0.15),
//                 ),
//               ),
//               const Text(
//                 'Abrindo câmera, aguarde...',
//                 style: TextStyle(color: Colors.white),
//               )
//             ],
//           ),
//           SizedBox(),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return LibrinoScaffold(
//       backgroundColor: Colors.black,
//       statusBarColor: Colors.black,
//       body: FutureBuilder(
//         future: future,
//         builder: (context, snapshot) => Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             if (snapshot.connectionState != ConnectionState.done)
//               buildLoading()
//             else
//               Column(
//                 children: [
//                   Container(
//                     color: Colors.black.withOpacity(0.5),
//                     alignment: Alignment.topLeft,
//                     padding: EdgeInsets.symmetric(vertical: 6),
//                     child: Row(
//                       children: [
//                         InkWellWidget(
//                           onTap: () => Navigator.pop(context),
//                           child: Padding(
//                             padding: const EdgeInsets.symmetric(
//                               horizontal: 12,
//                               vertical: 4,
//                             ),
//                             child: Row(
//                               children: [
//                                 const Icon(
//                                   Icons.arrow_back,
//                                   color: Colors.white,
//                                   size: 25.5,
//                                 ),
//                                 Container(
//                                   margin: const EdgeInsets.only(
//                                     top: 2.5,
//                                     left: 4.5,
//                                     right: 4.5,
//                                   ),
//                                   child: const Text(
//                                     'Voltar',
//                                     style: TextStyle(
//                                       fontSize: 14,
//                                       color: Colors.white,
//                                     ),
//                                   ),
//                                 )
//                               ],
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   buildCameraPreview(),
//                   Container(
//                     height: 75,
//                     color: Colors.black.withOpacity(0.2),
//                     width: MediaQuery.of(context).size.width,
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         SizedBox(
//                           width: MediaQuery.of(context).size.width * 0.33,
//                         ),
//                         Expanded(
//                           child: widget.isVideo
//                               ? IconButton(
//                                   enableFeedback: true,
//                                   onPressed: onRecordBtnPress,
//                                   icon: Stack(
//                                     alignment: Alignment.center,
//                                     children: [
//                                       Icon(
//                                         Icons.circle,
//                                         color: isRecording ? Colors.red : null,
//                                       ),
//                                       Icon(
//                                         isRecording
//                                             ? Icons.square
//                                             : Icons.circle,
//                                         color: isRecording
//                                             ? Colors.white
//                                             : Colors.red,
//                                         size: 25,
//                                       ),
//                                     ],
//                                   ),
//                                   color: Colors.white,
//                                   iconSize: 58,
//                                 )
//                               : IconButton(
//                                   enableFeedback: true,
//                                   onPressed: onRecordBtnPress,
//                                   icon: const Icon(Icons.camera),
//                                   color: Colors.white,
//                                   iconSize: 58,
//                                 ),
//                         ),
//                         SizedBox(
//                           width: MediaQuery.of(context).size.width * 0.33,
//                           child: IconButton(
//                             enableFeedback: true,
//                             onPressed: switchCamera,
//                             icon: Icon(
//                               Icons.cameraswitch_outlined,
//                             ),
//                             color: Colors.white,
//                             iconSize: 30,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }
