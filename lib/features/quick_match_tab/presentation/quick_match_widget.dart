import 'package:flutter/material.dart';
import 'package:vertex_app/features/quick_match_tab/model/quick_match_model.dart';

class QuickMatchWidget extends StatelessWidget {
  final QuickMatchModel quickMatch;

  const QuickMatchWidget({
    super.key,
    required this.quickMatch,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    // final screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 10, 30, 0),
      child: Container(
        decoration: BoxDecoration(
            color: const Color(0xFF0A1B31),
            border: Border.all(color: Colors.white.withOpacity(0.15), width: 1),
            borderRadius: const BorderRadius.all(Radius.circular(10))),
        constraints: BoxConstraints(minHeight: screenHeight * 0.2),
        // height: screenHeight * 0.25,
        // width: screenWidth*0.01,

        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Container(
                    margin: const EdgeInsets.all(10),
                    child: ClipOval(
                      child: Image.asset(
                        quickMatch.imageLink,
                        width: 45,
                        height: 45,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.error,
                              size: 45, color: Colors.red);
                        },
                        // fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        quickMatch.name,
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 15),
                      ),
                      Text(quickMatch.college,
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 12))
                    ],
                  )
                ],
              ),
              const SizedBox(
                height: 7,
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    quickMatch.description,
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 15),
                  )),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: quickMatch.tags
                            .map<Widget>((tag) => _tagWidget(text: tag))
                            .toList(),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 17,
              ),
              // const Spacer(),
              Padding(
                padding: const EdgeInsets.only(bottom: 5.0, left: 7, right: 7),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          // color: Colors.red.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(22),
                          border: Border.all(
                              color: Colors.red.withOpacity(0.5), width: 0.5)),
                      child: CircleAvatar(
                        backgroundColor: Colors.red.withOpacity(0.15),
                        radius: 22,
                        child: const Icon(Icons.close, color: Colors.red),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          // color: Colors.green.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(22),
                          border: Border.all(
                              color: Colors.green.withOpacity(0.5),
                              width: 0.5)),
                      child: CircleAvatar(
                        backgroundColor: Colors.green.withOpacity(
                            0.15), // cant do nothing, this is the only fix
                        radius: 22,
                        child: const Icon(Icons.done, color: Colors.green),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        // You can use quickMatch fields here to display data
      ),
    );
  }
}

class _tagWidget extends StatelessWidget {
  final String text;

  const _tagWidget({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 1),
      decoration: BoxDecoration(
        color: const Color.fromARGB(193, 66, 66, 66),
        borderRadius: BorderRadius.circular(7),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
