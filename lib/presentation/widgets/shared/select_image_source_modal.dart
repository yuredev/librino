import 'package:flutter/material.dart';
import 'package:librino/core/constants/colors.dart';
import 'package:librino/presentation/widgets/shared/modal_top_bar_widget.dart';

class SelectImageSourceModal extends StatelessWidget {
  const SelectImageSourceModal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.45,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 12),
              child: ModalTopBarWidget(),
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(18, 16, 18, 16),
            child: Text(
              'Adicionar foto',
              style: TextStyle(
                color: LibrinoColors.main,
                fontSize: 19,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.camera_alt),
            title: Text(
              'Tirar foto',
              style: TextStyle(
                fontSize: 15,
              ),
            ),
            horizontalTitleGap: 0,
            onTap: () => Navigator.pop(context, false),
          ),
          ListTile(
            horizontalTitleGap: 0,
            leading: Icon(Icons.image),
            title: Text(
              'Adicionar da galeria',
              style: TextStyle(
                fontSize: 15,
              ),
            ),
            onTap: () => Navigator.pop(context, true),
          ),
        ],
      ),
    );
  }
}

