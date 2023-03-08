import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:librino/core/constants/colors.dart';
import 'package:librino/presentation/widgets/shared/button_widget.dart';
import 'package:librino/presentation/widgets/shared/info_dialog_widget.dart';
import 'package:librino/presentation/widgets/shared/locked_loading_widget.dart';
import 'package:librino/presentation/widgets/shared/yes_not_dialog_widget.dart';

abstract class VisualAlerts {
  static void showSnackBar(
    BuildContext context,
    String message, {
    bool isErrorMessage = false,
    bool shouldCloseCurrent = true,
  }) {
    const maxChars = 150;
    if (message.length > maxChars) {
      message = message.substring(0, maxChars - 1);
      message += '...';
    }
    if (shouldCloseCurrent) ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      duration: Duration(seconds: 3),
      backgroundColor: isErrorMessage ? Colors.red : null,
    ));
  }

  static void showLockedLoading(BuildContext context, {required String text}) {
    showDialog(
      context: context,
      builder: (ctx) {
        return LockedLoadingWidget(text: text);
      },
    );
  }

  static Future<bool?> showConfirmActionDialog(
    BuildContext context, {
    required String title,
    required String description,
    String confirmTitle = 'Confirmar',
    Color confirmColor = LibrinoColors.lightBlue,
  }) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Column(
            children: [
              Icon(
                Icons.error,
                color: LibrinoColors.alertYellow,
                size: 78,
              ),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Text(
              description,
              textAlign: TextAlign.center,
            ),
          ),
          titlePadding: EdgeInsets.symmetric(vertical: 18),
          actionsPadding: const EdgeInsets.symmetric(vertical: 18),
          actionsAlignment: MainAxisAlignment.center,
          actions: <Widget>[
            ButtonWidget(
              title: 'Cancelar',
              color: LibrinoColors.buttonGray,
              textColor: Colors.white,
              height: 46,
              fontSize: 16,
              borderRadius: 5,
              onPress: () => Navigator.pop(context, false),
            ),
            ButtonWidget(
              title: confirmTitle,
              color: confirmColor,
              textColor: Colors.white,
              height: 46,
              fontSize: 16,
              borderRadius: 5,
              onPress: () => Navigator.pop(context, true),
            ),
          ],
        );
      },
    );
  }

  static Future<bool?> showYesNotDialog(
    BuildContext context, {
    required String title,
    required String description,
    String? confirmText,
    String? cancelText,
    void Function()? onConfirm,
    String? confirmTitle,
    String? cancelTitle,
    Color? confirmColor = Colors.black,
    Color? cancelColor = Colors.black,
    Color? titleColor = Colors.black,
    bool isDismissable = true,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: isDismissable, // user must tap button!
      builder: (BuildContext context) {
        return YesNotDialogWidget(
          context: context,
          title: title,
          description: description,
          cancelColor: cancelColor,
          confirmColor: confirmColor,
          onConfirm: onConfirm,
          titleColor: titleColor,
        );
      },
    );
  }

  static Future<void> showInfoDialog(
    BuildContext context, {
    required String text,
    required String imageName,
  }) async {
    await showDialog(
      context: context,
      builder: (ctx) => InfoDialogWidget(
        imageName: imageName,
        text: text,
      ),
    );
  }

  static void showToast(String texto) async {
    await Fluttertoast.cancel();
    Fluttertoast.showToast(
        msg: texto,
        backgroundColor: LibrinoColors.toastGray,
        fontSize: 12,
        toastLength: Toast.LENGTH_SHORT,
      );
  }
}
