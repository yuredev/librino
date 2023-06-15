import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:librino/core/constants/colors.dart';
import 'package:librino/presentation/utils/presentation_utils.dart';
import 'package:librino/presentation/widgets/shared/librino_scaffold.dart';
import 'package:librino/presentation/widgets/shared/shimmer_widget.dart';

class CameraPage extends StatefulWidget {
  final CameraDescription camera;

  const CameraPage(this.camera, {Key? key}) : super(key: key);

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  late final CameraController cameraController;

  @override
  void initState() {
    super.initState();
    inicializarCamera();
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  void onRecordBtnPress() async {
    final foto = await cameraController.takePicture();
    if (context.mounted) Navigator.pop(context, foto);
  }

  void inicializarCamera() async {
    cameraController = CameraController(widget.camera, ResolutionPreset.high);
    try {
      await cameraController.initialize();
      if (!mounted) {
        return;
      }
      setState(() {});
    } catch (e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            PresentationUtils.showSnackBar(
              context,
              'Você deve permitir o uso da câmera ao Librino',
              isErrorMessage: true,
            );
            Navigator.pop(context);
            break;
          default:
            print(e);
            PresentationUtils.showSnackBar(
              context,
              'Erro desconhecido ao abrir a câmera',
              isErrorMessage: true,
            );
            Navigator.pop(context);
            break;
        }
      }
    }
  }

  Widget buildCameraWidget() {
    final camera = cameraController.value;
    final size = MediaQuery.of(context).size;
    var scale = size.aspectRatio * camera.aspectRatio;
    if (scale < 1) scale = 1 / scale;
    return Transform.scale(
      scale: scale,
      child: Center(
        child: CameraPreview(
          cameraController,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LibrinoScaffold(
      statusBarColor: !cameraController.value.isInitialized
          ? LibrinoColors.statusBarGray
          : Colors.black,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (!cameraController.value.isInitialized)
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // const AppBarPequenaWidget(
                  //   titulo: 'Capturar foto',
                  //   cor: Cores.turquesaPrincipal,
                  //   corTitulo: Colors.white,
                  // ),
                  AppBar(
                    title: Text('Capturar foto'),
                  ),
                  Column(
                    children: [
                      ShimmerWidget(
                        child: Icon(
                          Icons.camera_alt,
                          size: MediaQuery.of(context).size.width * 0.45,
                          color: Colors.black,
                        ),
                      ),
                      const Text(
                        'Abrindo câmera, aguarde...',
                        style: TextStyle(color: Colors.black54),
                      )
                    ],
                  ),
                  SizedBox(),
                ],
              ),
            )
          else
            Expanded(
              child: Stack(
                children: [
                  buildCameraWidget(),
                  Positioned(
                    left: 14,
                    top: 14,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(50),
                        onTap: () => Navigator.pop(context),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                                size: 25.5,
                              ),
                              Container(
                                margin: const EdgeInsets.only(
                                  top: 2.5,
                                  left: 4.5,
                                  right: 4.5,
                                ),
                                child: const Text(
                                  'Voltar',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      color: Colors.black.withOpacity(0.125),
                      child: IconButton(
                        enableFeedback: true,
                        onPressed: onRecordBtnPress,
                        icon: Icon(Icons.camera),
                        color: Colors.white,
                        iconSize: 58,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
