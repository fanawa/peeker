import 'package:flutter/material.dart';

class TelErrorDialog {
  static Future<void> show(
    BuildContext context, {
    String? message,
    VoidCallback? onTapOk,
  }) {
    return showDialog<void>(
      useRootNavigator: true,
      context: context,
      barrierColor: Colors.black.withOpacity(0.5),
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 10),
          titlePadding: EdgeInsets.zero,
          contentPadding: EdgeInsets.zero,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          content: Container(
            width: MediaQuery.of(context).size.width >
                    MediaQuery.of(context).size.height
                ? MediaQuery.of(context).size.width * 0.45
                : MediaQuery.of(context).size.width * 0.4,
            constraints: const BoxConstraints(minHeight: 130),
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) =>
                  ListView(
                shrinkWrap: true,
                children: <Widget>[
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          message!,
                          textScaler: const TextScaler.linear(1),
                          style: const TextStyle(fontSize: 15),
                        ),
                        const SizedBox(height: 20),
                        FilledButton(
                          onPressed: onTapOk,
                          style: FilledButton.styleFrom(
                            minimumSize: const Size(100, 40),
                          ),
                          child: const Text(
                            'OK',
                            textScaler: TextScaler.linear(1),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
