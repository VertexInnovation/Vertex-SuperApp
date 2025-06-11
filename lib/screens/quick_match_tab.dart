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
  // final int _counter = 0;
  late CardController controller;
   bool isDeckEmpty = false;
  @override
  void initState() {
    super.initState();
    controller = CardController(); // Initialize it here
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
        body: Center(
            child: isDeckEmpty
            ? const Text(
                'No more cards!',
                style: TextStyle(color: Colors.white, fontSize: 20),
              )
            : TinderSwapCard(
                orientation: AmassOrientation.bottom,
                totalNum: quickMatchListValue.length,
                stackNum: 2,
                swipeEdge: 4,
                cardBuilder: (context, index) {
                  return QuickMatchWidget(quickMatch: quickMatchListValue[index]);
                },
                cardController: controller,
                swipeUpdateCallback: (DragUpdateDetails details, Alignment align) {
                  // Optional: you can add left/right swipe animations
                },
                swipeCompleteCallback: (CardSwipeOrientation orientation, int index) {
                  if (index == quickMatchListValue.length - 1) {
                    setState(() {
                      isDeckEmpty = true;
                    });
                  }
                },
              ),)); //QuickMatchWidget(quickMatch: quickMatchListValue[_counter])
  }
}
