import 'package:flutter/material.dart';
import 'package:scrumlab_flutter_tindercard/scrumlab_flutter_tindercard.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'package:vertex_app/features/quick_match_tab/model/quick_match_model.dart';
import 'package:vertex_app/features/quick_match_tab/presentation/quick_match_widget.dart';

class QuickMatchTab extends StatefulWidget {
  const QuickMatchTab({super.key});

  @override
  State<QuickMatchTab> createState() => _QuickMatchTabState();
}

class _QuickMatchTabState extends State<QuickMatchTab> {
  late List<QuickMatchModel> quickMatchListValue;
  late CardController controller;
  bool isDeckEmpty = false;
  @override
  void initState() {
    super.initState();
    controller = CardController();
    quickMatchListValue = quickMatchList;
  }

  @override
  Widget build(BuildContext context) {
    // quickMatchListValue = quickMatchList;
    return Scaffold(
        backgroundColor: const Color(0xFF011332),
        appBar: AppBar(
          title: const Text(
            "QuickMatch Connect",
            style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
          ),
          backgroundColor: const Color(0xFF011332),
          automaticallyImplyLeading: false,
        ),
        body: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.width * 0.2,
            ),
            if (isDeckEmpty)
              Column(
                children: [
                  Container(
                    margin: const EdgeInsets.all(10),
                    height: MediaQuery.of(context).size.width * 0.2,
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: Colors.white.withOpacity(0.3), width: 2),
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      "No more matches!",
                      style: TextStyle(color: Colors.white, fontSize: 24),
                    ),
                  ),
                ],
              )
            else
              Expanded(
                // <--- ADD THIS WRAPPER
                child: TinderSwapCard(
                  swipeUp: false,
                  swipeDown: false,
                  orientation: AmassOrientation.bottom,
                  totalNum: quickMatchListValue.length,
                  stackNum: 2,
                  swipeEdge: 4.0,
                  maxWidth: MediaQuery.of(context).size.width * 0.95,
                  maxHeight: MediaQuery.of(context).size.height * 0.6,
                  minWidth: MediaQuery.of(context).size.width * 0.85,
                  minHeight: MediaQuery.of(context).size.height * 0.5,
                  cardBuilder: (context, index) => Align(
                    alignment: Alignment.topCenter,
                    child: QuickMatchWidget(
                      quickMatch: quickMatchListValue[index],
                    ),
                  ),
                  cardController: controller,
                  swipeCompleteCallback:
                      (CardSwipeOrientation orientation, int index) {
                    if (orientation == CardSwipeOrientation.left) {
                      lightLeftBorderRed(context);
                    } else if (orientation == CardSwipeOrientation.right) {
                      lightRightBorderGreen(context);
                      // add to the array if needed
                    }
                    if (index == quickMatchListValue.length - 1) {
                      setState(() {
                        isDeckEmpty = true;
                      });
                    }
                  },
                ),
              ),
            // const Spacer(),
            Padding(
              padding:
                  const EdgeInsets.only(bottom: 8.0, left: 70.0, right: 70.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 110,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 255, 255, 255)
                            .withOpacity(0.15),
                      ),
                      onPressed: () {},
                      child: const Text(
                        "Pass",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 110,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 255, 255, 255)
                            .withOpacity(0.15),
                      ),
                      onPressed: () {},
                      child: const Text(
                        "Connect",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}

void lightRightBorderGreen(BuildContext context) async {
  final overlay = Overlay.of(context);
  final overlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      top: 0,
      right: 0,
      bottom: 0,
      width: 10,
      child: IgnorePointer(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          color: Colors.green.withOpacity(0.7),
        ),
      ),
    ),
  );

  overlay.insert(overlayEntry);
  await Future.delayed(const Duration(milliseconds: 500));
  overlayEntry.remove();
}

void lightLeftBorderRed(BuildContext context) async {
  final overlay = Overlay.of(context);
  final overlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      top: 0,
      left: 0,
      bottom: 0,
      width: 10,
      child: IgnorePointer(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          color: Colors.red.withOpacity(0.7),
        ),
      ),
    ),
  );

  overlay.insert(overlayEntry);
  await Future.delayed(const Duration(milliseconds: 500));
  overlayEntry.remove();
}
