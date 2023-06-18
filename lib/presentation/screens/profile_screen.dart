import 'package:flutter/material.dart';
import 'package:librino/core/constants/colors.dart';
import 'package:librino/core/constants/mappings.dart';
import 'package:librino/core/constants/sizes.dart';
import 'package:librino/data/models/user/librino_user.dart';
import 'package:librino/presentation/widgets/shared/librino_scaffold.dart';

class ProfileScreen extends StatelessWidget {
  final LibrinoUser user;

  const ProfileScreen({
    super.key,
    required this.user,
  });

  List<Widget> buildBackgroundIcons() {
    return [
      Positioned(
        top: 65,
        left: 35,
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
        top: 12,
        right: 12,
        child: Icon(
          Icons.tag_faces_sharp,
          color: Colors.black.withOpacity(0.05),
        ),
      ),
      Positioned(
        top: 60,
        right: 35,
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
          Icons.handshake_outlined,
          color: Colors.black.withOpacity(0.05),
        ),
      ),
      Positioned(
        bottom: 20,
        left: 13,
        child: Icon(
          Icons.mobile_friendly_sharp,
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
        bottom: 15,
        right: 13,
        child: Icon(
          Icons.tips_and_updates_outlined,
          color: Colors.black.withOpacity(0.05),
        ),
      ),
      Positioned(
        bottom: 70,
        left: 100,
        child: Icon(
          Icons.smart_display_outlined,
          color: Colors.black.withOpacity(0.05),
        ),
      ),
    ];
  }

  Widget buildField(String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 6),
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
            margin: const EdgeInsets.only(bottom: 12),
            child: Text(
              value,
              style: TextStyle(
                color: LibrinoColors.subtitleDarkGray,
              ),
            ),
          ),
          Divider(height: 0, thickness: 1),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final imageSize = screenSize.width * 0.4;
    return LibrinoScaffold(
      statusBarColor: LibrinoColors.mainDeeper,
      body: SingleChildScrollView(
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
                          child: user.photoURL == null
                              ? Image.asset(
                                  'assets/images/user2.png',
                                  width: imageSize,
                                  height: imageSize,
                                  fit: BoxFit.fill,
                                )
                              : Image.network(
                                  user.photoURL!,
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
                user.completeName,
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
                  buildField('Email', user.email),
                  buildField('Capacidade auditiva',
                      audityAbilityToString[user.auditoryAbility]!),
                  buildField(
                      'Gênero', genderIdentityToString[user.genderIdentity]!),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
