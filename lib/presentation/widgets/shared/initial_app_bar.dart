import 'package:flutter/material.dart';
import 'package:librino/core/constants/colors.dart';
import 'package:librino/core/constants/sizes.dart';
import 'package:librino/core/enums/enums.dart';
import 'package:librino/data/models/user/librino_user.dart';
import 'package:librino/presentation/widgets/shared/inkwell_widget.dart';

class InitialAppBar extends StatelessWidget {
  final LibrinoUser user;
  final double? conclusionPercentage;
  final bool compact;
  final String firstLineText;
  final String? secondLineText;
  final double? firstLineTextSize;
  final Widget? bottomWidget;

  const InitialAppBar({
    super.key,
    required this.user,
    this.bottomWidget,
    required this.firstLineText,
    this.firstLineTextSize,
    this.secondLineText,
    this.compact = false,
    required this.conclusionPercentage,
  });

  @override
  Widget build(BuildContext context) {
    final messageWidget = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          firstLineText,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: firstLineTextSize ?? (compact ? 13 : 15),
          ),
        ),
        if (secondLineText != null && secondLineText!.isNotEmpty)
          Text(
            secondLineText!,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: compact ? 18 : 22,
            ),
          ),
      ],
    );
    return Container(
      padding: EdgeInsets.fromLTRB(
        Sizes.defaultScreenHorizontalMargin + 2,
        Sizes.defaultScreenTopMargin,
        Sizes.defaultScreenHorizontalMargin + 2,
        26,
      ),
      decoration: BoxDecoration(
        color: LibrinoColors.backgroundWhite,
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(40),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.03),
            // color: Colors.grey.withOpacity(1.0),
            spreadRadius: 1.25,
            blurRadius: 15,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (compact)
                messageWidget
              else
                Container(
                  constraints: const BoxConstraints(
                    minWidth: 160,
                  ),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: LibrinoColors.lightBorderGray,
                      width: 1.2,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        user.profileType == ProfileType.studant
                            ? 'Perfil estudante'
                            : 'Perfil instrutor',
                        style: TextStyle(
                          color: LibrinoColors.subtitleLightGray,
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                        ),
                      ),
                      Icon(
                        user.profileType == ProfileType.studant
                            ? Icons.local_library_outlined
                            : Icons.school_outlined,
                        color: LibrinoColors.subtitleLightGray,
                        size: 18,
                      ),
                    ],
                  ),
                ),
              Material(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(50),
                child: Tooltip(
                  message: 'Perfil',
                  child: InkWellWidget(
                    onTap: () => Scaffold.of(context).openEndDrawer(),
                    borderRadius: 50,
                    child: Container(
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: user.photoURL == null
                          ? Ink(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage('assets/images/user2.png'),
                                  fit: BoxFit.cover,
                                ),
                                borderRadius: BorderRadius.circular(50),
                              ),
                              width: 40,
                              height: 40,
                            )
                          : Ink(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(user.photoURL!),
                                  fit: BoxFit.cover,
                                ),
                                borderRadius: BorderRadius.circular(50),
                              ),
                              width: 40,
                              height: 40,
                            ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (!compact)
            Container(
              margin: const EdgeInsets.only(top: Sizes.defaultScreenTopMargin),
              child: messageWidget,
            ),
          if (bottomWidget != null) bottomWidget!,
        ],
      ),
    );
  }
}
