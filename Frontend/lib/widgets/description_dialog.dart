import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:google_fonts/google_fonts.dart';

class DescriptionDialogWidget extends StatelessWidget {
  const DescriptionDialogWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
      child: AlertDialog(
        backgroundColor: Colors.white.withOpacity(0.1),
        title: Text(
          'About',
          style: GoogleFonts.nunito(
            color: Colors.white,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'FlickFeels is a sentiment analysis app that uses Natural Language Processing to interpret the emotional pulse of the big screen. It uses a pre-trained model to predict the sentiment of a movie review. The model is trained on the IMDB dataset and it provides sentiment analysis ranging from 0 to 4.',
          style: GoogleFonts.nunito(
            color: Colors.white,
            fontSize: 16.0,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              'Close',
              style: GoogleFonts.nunito(
                color: Colors.white,
                fontSize: 16.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
