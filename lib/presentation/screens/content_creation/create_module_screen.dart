import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:librino/core/bindings.dart';
import 'package:librino/core/constants/colors.dart';
import 'package:librino/core/constants/sizes.dart';
import 'package:librino/core/routes.dart';
import 'package:librino/data/models/class/class.dart';
import 'package:librino/data/models/module/module.dart';
import 'package:librino/logic/cubits/module/actions/module_actions_cubit.dart';
import 'package:librino/logic/cubits/module/actions/module_actions_state.dart';
import 'package:librino/logic/validators/create_module_validator.dart';
import 'package:librino/presentation/widgets/shared/button_widget.dart';
import 'package:librino/presentation/widgets/shared/dotted_button.dart';
import 'package:librino/presentation/widgets/shared/select_image_source_modal.dart';

class CreateModuleScreen extends StatefulWidget {
  final Class clazz;

  const CreateModuleScreen({
    super.key,
    required this.clazz,
  });

  @override
  State<CreateModuleScreen> createState() => _CreateModuleScreenState();
}

class _CreateModuleScreenState extends State<CreateModuleScreen> {
  late final ModuleActionsCubit moduleActionsCubit = context.read();
  final nameCtrl = TextEditingController();
  final descriptionCtrl = TextEditingController();
  final indexCtrl = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final picker = Bindings.get<ImagePicker>();
  XFile? attachedImage;

  void attachImage() async {
    // TODO: criar tela pra selecionar uma imagem prédefinida pro usuário não precisar anexar do seu celular
    final getFromGallery = await showModalBottomSheet<bool>(
      context: context,
      builder: (context) => SelectImageSourceModal(),
    );
    if (getFromGallery == null) return;
    final image = await picker.pickImage(
      source: getFromGallery ? ImageSource.gallery : ImageSource.camera,
    );
    setState(() => attachedImage = image);
  }

  void submit(BuildContext context) {
    if (formKey.currentState!.validate()) {
      moduleActionsCubit.create(
        Module(
          title: nameCtrl.text,
          description: descriptionCtrl.text,
          index: int.parse(indexCtrl.text),
          classId: widget.clazz.id!,
        ),
        attachedImage,
      );
    }
  }

  void onModuleActionsListen(BuildContext context, ModuleActionsState state) {
    if (state is ModuleCreatedState) {
      Navigator.pushNamed(
        context,
        Routes.addLessonsToModule,
        arguments: {
          'module': state.module,
        }
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final inputBorder = OutlineInputBorder(
      borderSide: BorderSide(
        color: LibrinoColors.grayInputBorder,
      ),
      borderRadius: BorderRadius.circular(Sizes.defaultInputBorderRadius),
    );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: LibrinoColors.deepBlue,
        centerTitle: true,
        title: const Text(
          'Cadastrar Módulo',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Container(
        constraints: BoxConstraints.expand(),
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            Sizes.defaultScreenHorizontalMargin,
            Sizes.defaultScreenTopMargin - 10,
            Sizes.defaultScreenHorizontalMargin,
            Sizes.defaultScreenBottomMargin,
          ),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // TODO: colocar botão de anexar imagem como o primeiro campo no visual do app
                // Talvez deixar ele quadrado seria uma opção...
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: TextFormField(
                    controller: nameCtrl,
                    validator: CreateModuleValidator.validateName,
                    autocorrect: false,
                    style: TextStyle(fontSize: 15),
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: LibrinoColors.backgroundWhite,
                      prefixIcon: const Icon(
                        Icons.draw_outlined,
                        size: 22,
                      ),
                      contentPadding: const EdgeInsets.only(left: 22),
                      label: const Text('*Nome do módulo'),
                      enabledBorder: inputBorder,
                      disabledBorder: inputBorder,
                      focusedBorder: inputBorder,
                      border: inputBorder,
                      labelStyle: TextStyle(
                        color: LibrinoColors.grayPlaceholder,
                      ),
                      isDense: true,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: TextFormField(
                    controller: indexCtrl,
                    validator: CreateModuleValidator.validateIndex,
                    autocorrect: false,
                    style: TextStyle(fontSize: 15),
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.numberWithOptions(signed: true),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: LibrinoColors.backgroundWhite,
                      prefixIcon: const Icon(
                        Icons.filter_1,
                        size: 22,
                      ),
                      contentPadding: const EdgeInsets.only(left: 22),
                      label: const Text('*Ordem do módulo na turma'),
                      enabledBorder: inputBorder,
                      disabledBorder: inputBorder,
                      focusedBorder: inputBorder,
                      border: inputBorder,
                      labelStyle: TextStyle(
                        color: LibrinoColors.grayPlaceholder,
                      ),
                      isDense: true,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: TextFormField(
                    controller: descriptionCtrl,
                    validator: CreateModuleValidator.validateDescription,
                    autocorrect: false,
                    style: TextStyle(fontSize: 15),
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.name,
                    maxLines: 3,
                    maxLength: 300,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: LibrinoColors.backgroundWhite,
                      prefixIcon: const Icon(
                        Icons.description_outlined,
                        size: 22,
                      ),
                      contentPadding:
                          const EdgeInsets.only(left: 22, top: 12, bottom: 12),
                      label: const Text('*Descrição'),
                      enabledBorder: inputBorder,
                      disabledBorder: inputBorder,
                      focusedBorder: inputBorder,
                      border: inputBorder,
                      labelStyle: TextStyle(
                        color: LibrinoColors.grayPlaceholder,
                      ),
                      isDense: true,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Tooltip(
                    message: 'Adicionar imagem ilustrativa para o módulo',
                    // TODO: adicionar preview da imagem?
                    child: DottedButton(
                      borderColor: attachedImage == null
                          ? LibrinoColors.iconGrayDarker
                          : LibrinoColors.main,
                      title: attachedImage == null
                          ? 'Imagem Ilustrativa'
                          : 'Imagem anexada',
                      titleColor: attachedImage == null
                          ? LibrinoColors.grayPlaceholder
                          : LibrinoColors.main,
                      icon: Container(
                        margin: const EdgeInsets.only(right: 4),
                        child: Icon(
                          attachedImage == null ? Icons.photo : Icons.done,
                          color: attachedImage == null
                              ? LibrinoColors.iconGrayDarker
                              : LibrinoColors.main,
                        ),
                      ),
                      onPress: attachImage,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 46),
                  child: BlocConsumer<ModuleActionsCubit, ModuleActionsState>(
                    listener: onModuleActionsListen,
                    builder: (context, state) => ButtonWidget(
                      title: 'Continuar',
                      width: double.infinity,
                      height: Sizes.defaultButtonHeight,
                      onPress: () => submit(context),
                      isLoading: state is CreatingModuleState,
                      loadingText: 'Submetendo...',
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
