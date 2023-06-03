import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:librino/core/constants/colors.dart';
import 'package:librino/core/constants/sizes.dart';

class SearchBarWidget extends StatefulWidget {
  final String? hint;
  final void Function(String)? onChange;
  final TextEditingController? controller;
  final void Function()? onSendButtonPress;
  final Color? sendButtonColor;
  final String? Function(String?)? validator;
  final void Function(String)? onSubmit;
  final GlobalKey<FormState>? formKey;
  final List<TextInputFormatter>? masks;
  final bool isUppercaseKeybord;
  final Color borderClor;
  final double height;

  const SearchBarWidget({
    Key? key,
    this.controller,
    this.formKey,
    this.isUppercaseKeybord = false,
    this.onChange,
    this.height = 44,
    this.hint,
    this.borderClor = LibrinoColors.backgroundWhite,
    this.onSendButtonPress,
    this.validator,
    this.onSubmit,
    this.sendButtonColor,
    this.masks,
  }) : super(key: key);

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  @override
  Widget build(BuildContext context) {
    const borderWidth = .9;
    return Form(
      key: widget.formKey,
      child: TextFormField(
        textInputAction: TextInputAction.search,
        onFieldSubmitted: widget.onSubmit,
        validator: widget.validator,
        controller: widget.controller,
        onChanged: widget.onChange,
        autocorrect: false,
        inputFormatters: widget.masks,
        textCapitalization: widget.isUppercaseKeybord
            ? TextCapitalization.sentences
            : TextCapitalization.none,
        style: const TextStyle(
          color: LibrinoColors.textLightBlack,
          fontSize: 14,
        ),
        enableSuggestions: false,
        decoration: InputDecoration(
          errorMaxLines: 2,
          prefixIconConstraints: BoxConstraints(),
          prefixIcon: SizedBox(width: 16),
          contentPadding: EdgeInsets.zero,
          border: OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(Sizes.defaultInputBorderRadius),
            borderSide: BorderSide(
              width: borderWidth,
              color: Colors.grey,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: LibrinoColors.borderGray,
              width: borderWidth,
            ),
            borderRadius:
                BorderRadius.circular(Sizes.defaultInputBorderRadius),
          ),
          disabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: LibrinoColors.borderGray,
              width: borderWidth,
            ),
            borderRadius:
                BorderRadius.circular(Sizes.defaultInputBorderRadius),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: LibrinoColors.main,
              width: borderWidth,
            ),
            borderRadius:
                BorderRadius.circular(Sizes.defaultInputBorderRadius),
          ),
          fillColor: LibrinoColors.backgroundWhite,
          filled: true,
          // label: widget.hint == null ? null : Text(widget.hint!),
          hintText: widget.hint,
          labelStyle: TextStyle(
            color: LibrinoColors.grayPlaceholder,
          ),
          suffixIcon: widget.onSendButtonPress != null
              ? IconButton(
                  padding: const EdgeInsets.all(0),
                  alignment: Alignment.centerRight,
                  onPressed: () {
                    if (widget.formKey == null ||
                        widget.formKey != null &&
                            widget.formKey!.currentState!.validate()) {
                      widget.onSendButtonPress!();
                    }
                  },
                  icon: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: widget.sendButtonColor ?? const Color(0xffd8d8d8),
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(7),
                        bottomRight: Radius.circular(7),
                      ),
                    ),
                    child: const Icon(
                      Icons.send_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                )
              : null,
        ),
      ),
    );
  }
}
