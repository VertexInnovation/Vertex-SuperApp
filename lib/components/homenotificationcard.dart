import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Homenotificationcard extends StatelessWidget {
  Homenotificationcard({super.key});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(18.0),
          child: Container(
            child: Row(
              children: [
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                      color: Colors.brown[800], shape: BoxShape.circle),
                  child: Icon(
                    Icons.notifications_none_rounded,
                    color: Colors.amber,
                  ),
                ),
                SizedBox(
                  width: 18,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Your gig Ul Design for Student App has a new applicant",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(
                            color: Colors.white, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                        "2 hours ago",
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(
                            color: Colors.white, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.notifications_active,
                  color: Colors.amber,
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
