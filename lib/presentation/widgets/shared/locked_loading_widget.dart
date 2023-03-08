import 'package:flutter/material.dart';

class LockedLoadingWidget extends StatelessWidget {
  final String text;

  const LockedLoadingWidget({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Material(
        color: Colors.transparent,
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(child: CircularProgressIndicator()),
                  if (text.isNotEmpty)
                    Container(
                      margin: const EdgeInsets.only(top: 18),
                      width: MediaQuery.of(context).size.width * .65,
                      child: Text(
                        text,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
