import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:librino/core/constants/colors.dart';
import 'package:librino/logic/cubits/auth/auth_cubit.dart';
import 'package:librino/logic/cubits/auth/auth_state.dart';
import 'package:librino/presentation/widgets/shared/gray_bar_widget.dart';
import 'package:librino/presentation/widgets/shared/inkwell_widget.dart';
import 'package:librino/presentation/widgets/shared/progress_bar_widget.dart';
import 'package:librino/presentation/widgets/shared/shimmer_widget.dart';

class ModuleGridItemWidget extends StatelessWidget {
  final void Function()? onPress;
  final String? title;
  final String? subtitle;
  final double? conclusionPercentage;
  final String? imageUrl;
  final bool isLoading;

  const ModuleGridItemWidget({
    super.key,
    this.onPress,
    this.title,
    this.subtitle,
    this.conclusionPercentage,
    this.imageUrl,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    const spacing = 8.0;
    final content = InkWellWidget(
      onTap: onPress,
      borderRadius: 20,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            final user = (state as LoggedInState).user;
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LayoutBuilder(
                  builder: (context, constraints) => Container(
                    margin: const EdgeInsets.only(bottom: spacing),
                    child: isLoading
                        ? const GrayBarWidget(height: 45, width: 45)
                        : imageUrl == null
                            ? Image.asset(
                                'assets/images/generic-module.png',
                                width: constraints.maxWidth * 0.55,
                                height: constraints.maxWidth * 0.55,
                                fit: BoxFit.contain,
                              )
                            : Image.network(
                                imageUrl!,
                                width: constraints.maxWidth * 0.55,
                                height: constraints.maxWidth * 0.55,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) {
                                  return Image.asset(
                                    'assets/images/generic-module.png',
                                    width: constraints.maxWidth * 0.55,
                                    height: constraints.maxWidth * 0.55,
                                    fit: BoxFit.contain,
                                  );
                                },
                                // loadingBuilder:
                                //     (context, child, loadingProgress) {
                                //   return ShimmerWidget(
                                //     child: GrayBarWidget(
                                //       width: constraints.maxWidth * 0.55,
                                //       height: constraints.maxWidth * 0.55,
                                //     ),
                                //   );
                                // },
                              ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: spacing - 5),
                  child: isLoading
                      ? const GrayBarWidget(height: 12, width: 90)
                      : Text(
                          title!,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12.5,
                          ),
                        ),
                ),
                if (!isLoading && subtitle != null)
                  Container(
                    margin: const EdgeInsets.only(bottom: spacing - 5),
                    child: Text(
                      subtitle!,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 11.5,
                        color: LibrinoColors.subtitleGray,
                      ),
                    ),
                  ),
                if (!user.isInstructor)
                  Container(
                    margin: const EdgeInsets.only(bottom: spacing),
                    child: isLoading
                        ? const GrayBarWidget(height: 12, width: 90)
                        : Text(
                            'Você completou ${conclusionPercentage!.floor()}%',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 10,
                              color: LibrinoColors.subtitleGray,
                            ),
                          ),
                  ),
                if (!user.isInstructor)
                  isLoading
                      ? GrayBarWidget(height: 14, width: double.infinity)
                      : ProgressBarWidget(
                          color: LibrinoColors.main,
                          height: 12,
                          progression: conclusionPercentage!,
                        )
              ],
            );
          },
        ),
      ),
    );
    return Container(
      decoration: BoxDecoration(
        color: LibrinoColors.backgroundWhite,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.03),
            spreadRadius: 1.25,
            blurRadius: 15,
          ),
        ],
      ),
      child: isLoading ? ShimmerWidget(child: content) : content,
    );
  }
}
