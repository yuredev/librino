import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:librino/core/constants/colors.dart';
import 'package:librino/core/constants/mappings.dart';
import 'package:librino/core/constants/sizes.dart';
import 'package:librino/data/models/class/class.dart';
import 'package:librino/data/models/user/librino_user.dart';
import 'package:librino/logic/cubits/auth/auth_cubit.dart';
import 'package:librino/logic/cubits/user/load_progress/load_user_progress_cubit.dart';
import 'package:librino/logic/cubits/user/load_progress/load_user_progress_state.dart';
import 'package:librino/presentation/widgets/profile/user_progress_item_of_list.dart';
import 'package:librino/presentation/widgets/shared/illustration_widget.dart';
import 'package:librino/presentation/widgets/shared/librino_scaffold.dart';
import 'package:librino/presentation/widgets/shared/progress_bar_widget.dart';
import 'package:librino/presentation/widgets/shared/refreshable_scrollview_widget.dart';

class ProfileScreen extends StatefulWidget {
  final LibrinoUser user;
  final Class? clazz;

  const ProfileScreen({
    super.key,
    required this.user,
    this.clazz,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final LoadUserProgressCubit loadProgressCubit = context.read();

  @override
  void initState() {
    super.initState();
    final signedUser = context.read<AuthCubit>().signedUser!;
    if (signedUser.isInstructor) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        loadProgressCubit.load(widget.user);
      });
    }
  }

  List<Widget> buildBackgroundIcons() {
    return [
      Positioned(
        top: 65,
        left: 62,
        child: Icon(
          Icons.sign_language_outlined,
          color: Colors.black.withOpacity(0.05),
        ),
      ),
      Positioned(
        top: 12,
        left: 12,
        child: Icon(
          Icons.star_border,
          size: 31,
          color: Colors.black.withOpacity(0.05),
        ),
      ),
      Positioned(
        top: 5,
        right: 20,
        child: Icon(
          Icons.volunteer_activism_outlined,
          color: Colors.black.withOpacity(0.05),
          size: 22,
        ),
      ),
      Positioned(
        top: 50,
        right: 25,
        child: Icon(
          Icons.sign_language_outlined,
          color: Colors.black.withOpacity(0.05),
        ),
      ),
      Positioned(
        top: 55,
        right: 125,
        child: Icon(
          Icons.tag_faces_sharp,
          color: Colors.black.withOpacity(0.05),
        ),
      ),
      Positioned(
        top: 15,
        right: 78,
        child: Icon(
          Icons.front_hand_outlined,
          color: Colors.black.withOpacity(0.05),
        ),
      ),
      Positioned(
        bottom: 20,
        left: 13,
        child: Icon(
          Icons.pan_tool_outlined,
          color: Colors.black.withOpacity(0.05),
        ),
      ),
      Positioned(
        top: 25,
        left: 180,
        child: Icon(
          Icons.sign_language_outlined,
          color: Colors.black.withOpacity(0.05),
        ),
      ),
      Positioned(
        top: 10,
        left: 81,
        child: Icon(
          Icons.waving_hand_outlined,
          color: Colors.black.withOpacity(0.05),
        ),
      ),
      Positioned(
        bottom: 33,
        right: 81,
        child: Icon(
          Icons.waving_hand_outlined,
          color: Colors.black.withOpacity(0.05),
        ),
      ),
      Positioned(
        bottom: 10,
        right: 13,
        child: Icon(
          Icons.thumbs_up_down_outlined,
          color: Colors.black.withOpacity(0.05),
        ),
      ),
      Positioned(
        bottom: 58,
        left: 110,
        child: Icon(
          Icons.swipe_outlined,
          color: Colors.black.withOpacity(0.05),
        ),
      ),
      Positioned(
        top: 0,
        left: 140,
        child: Icon(
          Icons.thumb_up_alt_outlined,
          color: Colors.black.withOpacity(0.05),
        ),
      ),
      Positioned(
        top: 0,
        right: 135,
        child: Icon(
          Icons.sign_language_outlined,
          color: Colors.black.withOpacity(0.05),
        ),
      ),
      Positioned(
        bottom: 10,
        left: 90,
        child: Icon(
          Icons.sentiment_satisfied,
          color: Colors.black.withOpacity(0.05),
        ),
      ),
    ];
  }

  Widget buildField(String label, String value, {bool buildDivider = true}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(bottom: value.isEmpty ? 0 : 6),
            child: Text(
              label,
              style: TextStyle(
                color: LibrinoColors.textLightBlack,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: buildDivider ? 12 : 0),
            child: Text(
              value,
              style: TextStyle(
                color: LibrinoColors.subtitleDarkGray,
              ),
            ),
          ),
          if (buildDivider) Divider(height: 0, thickness: 1),
        ],
      ),
    );
  }

  Widget buildUserProgress() {
    return BlocBuilder<LoadUserProgressCubit, LoadUserProgressState>(
      builder: (context, state) {
        if (state is UserProgressLoadedState && state.progressList.isNotEmpty) {
          var list = state.progressList;
          if (widget.clazz != null) {
            final modulesOfClass = list
                .where((p) => p.module.classId == widget.clazz!.id)
                .toList();
            final others =
                list.where((p) => !modulesOfClass.contains(p)).toList();
            list = [
              ...modulesOfClass
                ..sort((a, b) => a.module.index - b.module.index),
              ...others..sort((a, b) => a.module.index - b.module.index),
            ];
          }
          return ExpansionTile(
            initiallyExpanded: true,
            tilePadding: EdgeInsets.zero,
            childrenPadding: EdgeInsets.zero,
            title: const Text(
              'Progresso',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: LibrinoColors.textLightBlack,
              ),
            ),
            children: list
                .where((element) => element.module.lessons!.isNotEmpty)
                .map(
                  (e) => Container(
                    margin: const EdgeInsets.only(top: 32),
                    child: UserProgressItemOfList(
                      title: e.module.title,
                      totalLessons: e.module.lessons!.length,
                      finishedLessons: e.lessonsCompletedCount,
                    ),
                  ),
                )
                .toList(),
          );
        }
        if (state is LoadingUserProgressState) {
          return ExpansionTile(
            initiallyExpanded: true,
            tilePadding: EdgeInsets.zero,
            childrenPadding: EdgeInsets.zero,
            title: const Text(
              'Progresso',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: LibrinoColors.textLightBlack,
              ),
            ),
            children: List.generate(
              4,
              (index) => Container(
                margin: const EdgeInsets.only(top: 32),
                child: UserProgressItemOfList(isLoading: true),
              ),
            ),
          );
        }
        if (state is LoadUserProgressErrorState) {
          return Container(
            margin: const EdgeInsets.only(top: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildField('Progresso:', '', buildDivider: false),
                IllustrationWidget(
                  illustrationName: 'error.json',
                  title:
                      'Erro ao carregar o progresso deste usuário no Librino',
                  imageWidth: MediaQuery.of(context).size.width * 0.58,
                  isAnimation: true,
                ),
              ],
            ),
          );
        }
        return SizedBox();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final imageSize = screenSize.width * 0.4;
    return LibrinoScaffold(
      statusBarColor: LibrinoColors.mainDeeper,
      body: RefreshableScrollViewWidget(
        onRefresh: () => loadProgressCubit.load(widget.user),
        child: Column(
          children: [
            AppBar(
              bottomOpacity: 0,
              elevation: 0,
              title: Text(
                'Perfil',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),
              backgroundColor: LibrinoColors.mainDeeper,
              centerTitle: true,
            ),
            Container(
              margin: EdgeInsets.only(bottom: imageSize / 2 + 18),
              child: Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: [
                  Container(
                    height: screenSize.height * 0.16,
                    color: LibrinoColors.mainDeeper,
                  ),
                  ...buildBackgroundIcons(),
                  Positioned(
                    bottom: 0 - (imageSize / 2),
                    child: Material(
                      elevation: 2,
                      borderRadius: BorderRadius.circular(100),
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: LibrinoColors.backgroundGray, width: 3),
                            borderRadius: BorderRadius.circular(100)),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: widget.user.photoURL == null
                              ? Image.asset(
                                  'assets/images/user2.png',
                                  width: imageSize,
                                  height: imageSize,
                                  fit: BoxFit.fill,
                                )
                              : Image.network(
                                  widget.user.photoURL!,
                                  width: imageSize,
                                  height: imageSize,
                                  fit: BoxFit.fill,
                                ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(),
              child: Text(
                widget.user.completeName,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: Sizes.defaultScreenHorizontalMargin * 1.2,
                vertical: Sizes.defaultScreenTopMargin,
              ),
              child: Column(
                children: [
                  buildField('Email', widget.user.email),
                  buildField('Capacidade auditiva',
                      audityAbilityToString[widget.user.auditoryAbility]!),
                  buildField(
                    'Gênero',
                    genderIdentityToString[widget.user.genderIdentity]!,
                  ),
                  buildUserProgress(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
