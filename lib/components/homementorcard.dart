import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vertex_app/colors.dart';

class Homementorcard extends StatelessWidget {
  const Homementorcard(
      {super.key,
      required this.name,
      required this.job,
      required this.rating,
      required this.description,
      required this.skills,
      required this.available,
      required this.verified});
  final String name;
  final String job;
  final double rating;
  final String description;
  final List<String> skills;
  final String available;
  final bool verified;

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
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.amber, width: 2),
                        shape: BoxShape.circle,
                        image: const DecorationImage(
                            image: AssetImage(
                          "assets/images/sample_mike_image.png",
                        ))),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Text(
                            name,
                            style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Icon(
                            Icons.verified_rounded,
                            color: Colors.amber,
                            size: verified ? 24 : 0,
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Text(
                        job,
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 14),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 18,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            "$rating",
                            style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontWeight: FontWeight.w600),
                          )
                        ],
                      )
                    ],
                  ))
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                description,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                maxLines: 3,
                style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 14),
              ),
              const SizedBox(
                height: 8,
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
                height: 14,
              ),
              Row(
                children: [
                  const Icon(
                    Icons.access_time_outlined,
                    color: Colors.white,
                    size: 18,
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  Text(
                    "Available : $available",
                    style: GoogleFonts.poppins(color: Colors.white),
                  )
                ],
              ),
              const SizedBox(
                height: 14,
              ),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14)),
                          side: const BorderSide(color: Colors.amber)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24),
                        child: Text(
                          "Message",
                          style: GoogleFonts.poppins(color: Colors.amber),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14)),
                          backgroundColor: Colors.amber,
                          side: const BorderSide(color: Colors.amber)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        child: Text(
                          "Book Session",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                              color: Colors.black, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
