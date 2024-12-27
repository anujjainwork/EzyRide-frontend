import 'package:ezyride_frontend/common/websocket_connections/websocket_provider.dart';
import 'package:ezyride_frontend/common/widgets/custom_text.dart';
import 'package:flutter/material.dart';

Widget generateOtpButton(
      {required double screenHeight,
      required double screenWidth,
      required String text,
      required VoidCallback? onPressed,
      required bool isEnabled,
      required double textsize,
      required Color boxcolor,
      required Color borderColor,
      required Color textColor,
      required double height,
      required double width,
      required WebSocketProvider wbprovider}) {
    return Opacity(
      opacity: !(wbprovider.isFull) ? 1.0 : 0.2,
      child: InkWell(
        onTap: !(wbprovider.isFull) ? onPressed : null,
        child: Container(
          height: height,
          width: width,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: boxcolor,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: borderColor, width: 1),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: CustomText(
            text: text,
            fontSize: textsize,
            textAlign: TextAlign.center,
            color: textColor,
          ),
        ),
      ),
    );
  }