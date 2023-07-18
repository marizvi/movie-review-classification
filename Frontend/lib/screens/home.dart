import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/foundation.dart';
import 'package:lottie/lottie.dart';
import 'package:nlp_app/utils/helper.dart';
import 'package:nlp_app/utils/services.dart';
import 'package:nlp_app/widgets/description_dialog.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int score = -1;
  bool loading = false;
  String value = '';
  Map<int, String> emojiMap = {
    -1: "assets/emoji/load1.gif",
    0: "assets/emoji/triumph.gif",
    1: "assets/emoji/sad.gif",
    2: "assets/emoji/slightly_happy.gif",
    3: "assets/emoji/smile_big_eyes.gif",
    4: "assets/emoji/star_struck.gif",
  };
  Map<int, String> emojiMapLottie = {
    -1: "assets/emoji/welcome_bot.json",
    0: "assets/emoji/triumph.json",
    1: "assets/emoji/sad.json",
    2: "assets/emoji/slightly_happy.json",
    3: "assets/emoji/smile_big_eyes.json",
    4: "assets/emoji/star_struck.json",
  };
  Map<int, String> emojiMapPng = {
    -1: "assets/emoji/load1.gif",
    0: "assets/emoji/triumph.png",
    1: "assets/emoji/sad.png",
    2: "assets/emoji/slightly_happy.png",
    3: "assets/emoji/smile_big_eyes.png",
    4: "assets/emoji/star_struck.png",
  };
  Future<void> requestBackend() async {
    // final debouncer = Debouncer(milliseconds: 1000);
    EasyDebounce.debounce('my-tag', Duration(milliseconds: 800), () async {
      if (value.isNotEmpty) {
        try {
          setState(() {
            loading = true;
          });
          score = await fetchScore(text: value);
          setState(() {
            loading = false;
          });
        } catch (e) {
          score = -1;
          value = '';
          print(e);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("${e.toString()}"),
            ),
          );
          setState(() {
            loading = false;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isWebMobile = kIsWeb &&
        (defaultTargetPlatform == TargetPlatform.iOS ||
            defaultTargetPlatform == TargetPlatform.android);
    double containerWidth = MediaQuery.of(context).size.width * 0.8 > 600
        ? 600
        : MediaQuery.of(context).size.width * 0.8;
    String caption = getRandomCaption(score);
    String sentimentTitle = sentimentTile(score);
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color.fromARGB(255, 3, 63, 154), Colors.black],
              begin: Alignment.bottomRight,
              end: Alignment.topLeft,
            ),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
              toolbarHeight: 80,
              backgroundColor: Colors.transparent,
              centerTitle: true,
              flexibleSpace: GlassContainer(
                blur: 4,
                shape: BoxShape.rectangle,
                color: Colors.white.withOpacity(0.1),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withOpacity(0.2),
                    Colors.transparent,
                  ],
                ),
                shadowStrength: 5,
                shadowColor: Colors.white.withOpacity(0.24),
              ),
              title: Column(
                children: [
                  FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Text(
                      'FlickFeels',
                      style: GoogleFonts.nunito(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 26.0,
                      ),
                    ),
                  ),
                  FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Text(
                      'Interpreting the Emotional Pulse of the Big Screen',
                      style: GoogleFonts.nunito(
                        color: Colors.grey.shade300,
                        fontSize: 14.0,
                      ),
                    ),
                  ),
                ],
              ),
              elevation: 0),
          body: Container(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 130),
                GlassContainer(
                  blur: 4,
                  shadowColor:
                      Color.fromARGB(255, 255, 255, 255).withOpacity(0.8),
                  shadowStrength: 2,
                  width: containerWidth,
                  color: Colors.white.withOpacity(0.05),
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.centerRight,
                        child: IconButton(
                          icon: Icon(Icons.info_outline),
                          color: Colors.white,
                          onPressed: () {
                            // show alert box
                            showDialog(
                                context: context,
                                builder: (context) =>
                                    DescriptionDialogWidget());
                          },
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        child: TextField(
                          style: GoogleFonts.nunito(
                            color: Colors.white,
                            fontSize: 16.0,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Write at least 2-3 words review.',
                            hintStyle: GoogleFonts.nunito(
                              color: Colors.grey.shade300,
                              fontSize: 16.0,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: Colors.white,
                                width: 0.5,
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: Colors.white,
                                width: 0.5,
                              ),
                            ),
                          ),
                          onChanged: (val) {
                            // if number of words is less than 2 return
                            // remember space is not a word
                            if (countWords(val) < 2) {
                              value = val;
                              score = -1;
                              setState(() {});
                            } else {
                              value = val;
                              requestBackend();
                            }
                          },
                          maxLines: 2,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      if (loading)
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 10),
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        ),
                      if (!loading)
                        Column(
                          children: [
                            if (!isWebMobile)
                              Lottie.asset(
                                emojiMapLottie[score]!,
                                height: score == -1 ? 150 : 100,
                              ),
                            if (isWebMobile)
                              Image.asset(
                                emojiMap[score]!,
                                height: 100,
                                color: score == -1 ? Colors.white : null,
                              ),
                            if (score >= 0 && score <= 4 && caption.isNotEmpty)
                              Container(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 4,
                                    horizontal: 12,
                                  ),
                                  child: Column(
                                    children: [
                                      sentimentScore(score: score),
                                      sentimentTitleContainer(
                                          title: sentimentTitle),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      captionContainer(caption: caption),
                                    ],
                                  )),
                          ],
                        ),
                      SizedBox(
                        height: 15,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget sentimentScore({required int score}) {
    return FittedBox(
      fit: BoxFit.fitWidth,
      child: Text(
        score.toString(),
        textAlign: TextAlign.center,
        style: GoogleFonts.nunito(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 20.0,
        ),
      ),
    );
  }

  Widget sentimentTitleContainer({required String title}) {
    return Text(
      title,
      textAlign: TextAlign.center,
      style: GoogleFonts.nunito(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 16.0,
      ),
    );
  }

  Widget captionContainer({required String caption}) {
    return Text(
      caption,
      textAlign: TextAlign.center,
      style: GoogleFonts.nunito(
        color: Colors.white,
        fontSize: 14.0,
        fontStyle: FontStyle.italic,
      ),
    );
  }
}
