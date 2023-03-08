import 'package:flutter/material.dart';
import 'package:librino/core/constants/colors.dart';
import 'package:librino/core/constants/sizes.dart';
import 'package:librino/data/models/user.dart';

class HomeAppBar extends StatelessWidget {
  final User user;
  final double conclusionPercentage;

  const HomeAppBar({
    super.key,
    required this.user,
    required this.conclusionPercentage,
  });

  @override
  Widget build(BuildContext context) {
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
                      '${conclusionPercentage.floor()}% de conclusão',
                      style: TextStyle(
                        color: LibrinoColors.subtitleLightGray,
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                      ),
                    ),
                    const Icon(
                      Icons.check_circle_outline_outlined,
                      color: LibrinoColors.subtitleLightGray,
                      size: 13,
                    ),
                  ],
                ),
              ),
              Material(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(50),
                child: Tooltip(
                  message: 'Perfil',
                  child: InkWell(
                    onTap: () => Scaffold.of(context).openEndDrawer(),
                    borderRadius: BorderRadius.circular(50),
                    child: Ink.image(
                      image: AssetImage('assets/images/user.png'),
                      width: 40,
                      height: 40,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: Sizes.defaultScreenTopMargin),
            child: Text(
              'Olá ${user.name},',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ),
          Text(
            'Continue aprendendo!',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
        ],
      ),
    );
  }
}
