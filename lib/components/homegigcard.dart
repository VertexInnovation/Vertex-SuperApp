import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vertex_app/colors.dart';

class Homegigcard extends StatelessWidget {
  const Homegigcard(
      {super.key,
      required this.title,
      required this.description,
      required this.time,
      required this.open,
      required this.price,
      required this.skills,
      required this.name});
  final String title;
  final String description;
  final String time;
  final bool open;
  final double price;
  final List<String> skills;
  final String name;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 14.0),
      child: Container(
        width: 300,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: VertexColors.button1background),
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      title,
                      softWrap: true,
                      overflow: TextOverflow.visible,
                      style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 18),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: open ? Colors.teal[900] : Colors.red[700],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 4),
                      child: Text(
                        open ? "Open" : "Closed",
                        style: GoogleFonts.poppins(
                            color: open
                                ? Colors.lightGreenAccent
                                : Colors.red[300]),
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                description,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 14),
              ),
              const SizedBox(
                height: 12,
              ),
              Row(
                children: [
                  const Icon(
                    Icons.attach_money_rounded,
                    color: Colors.amber,
                  ),
                  Text(
                    "₹$price",
                    style: GoogleFonts.poppins(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  const Icon(
                    Icons.access_time_rounded,
                    color: Colors.amber,
                  ),
                  Text(
                    "$time  weeks",
                    style: GoogleFonts.poppins(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(
                height: 14,
              ),
              Wrap(
                runSpacing: 2,
                spacing: 2,
                children: [
                  for (String skill in skills)
                    Chip(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: const BorderSide(color: Colors.blueGrey)),
                      label: Text(
                        skill,
                        style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 10),
                      ),
                      backgroundColor: Colors.blueGrey[800],
                    ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Container(
                    height: 40,
                    width: 40,
                    decoration: const BoxDecoration(
                      color: Colors.amber,
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image:
                            AssetImage("assets/images/sample_mike_image.png"),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 18,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Posted by",
                        style: GoogleFonts.poppins(color: Colors.white),
                      ),
                      Text(
                        name,
                        style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w500),
                      )
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
// "UI Design for Student App",
// "Looking for a UI designer to create mockups for a student project app, focusing on clean design and user-friendly interfaces"
