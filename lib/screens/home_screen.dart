import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vertex_app/Colors.dart';
import 'package:vertex_app/components/homechatcard.dart';
import 'package:vertex_app/components/homegigcard.dart';
import 'package:vertex_app/components/homementorcard.dart';
import 'package:vertex_app/components/homenotificationcard.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        color: VertexColors.background,
      ),
      child: SafeArea(
        child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Home",
                  style: GoogleFonts.poppins(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 40,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Hello, Alex",
                          style: GoogleFonts.roboto(
                              fontSize: 26,
                              color: Colors.white,
                              fontWeight: FontWeight.w500),
                        ),
                        Text(
                          "Monday, May 25",
                          style: GoogleFonts.roboto(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w500),
                        )
                      ],
                    ),
                    Row(children: [
                      IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.search),
                          style: IconButton.styleFrom(
                              backgroundColor: VertexColors.button1background),
                          color: Colors.white),
                      IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.notifications_none_rounded),
                          style: IconButton.styleFrom(
                              backgroundColor: VertexColors.button1background),
                          color: Colors.white),
                      IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.messenger_outline_rounded),
                          style: IconButton.styleFrom(
                              backgroundColor: VertexColors.button1background),
                          color: Colors.white),
                    ])
                  ],
                ),
                const SizedBox(
                  height: 50,
                ),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      gradient: const LinearGradient(
                        colors: [
                          VertexColors.background,
                          Color.fromRGBO(12, 37, 106, 1)
                        ],
                      )),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color.fromRGBO(60, 62, 56, 1)),
                          child: const Padding(
                            padding: EdgeInsets.all(12.0),
                            child: Icon(
                              Icons.auto_awesome_rounded,
                              color: Colors.amber,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "VYNC AI Assistant",
                                style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                "Get personalized recommendations and career guidance",
                                softWrap: true,
                                style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Recent Gigs",
                      style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600),
                    ),
                    Text(
                      "See All",
                      style: GoogleFonts.poppins(
                          color: Colors.amber,
                          fontSize: 14,
                          fontWeight: FontWeight.w600),
                    )
                  ],
                ),
                const SizedBox(
                  height: 24,
                ),
                const SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Homegigcard(
                        title: "UI Design for Student App",
                        description:
                            "Looking for a UI designer to create mockups for a student project app, focusing on clean design and user-friendly interfaces",
                        time: '2',
                        open: true,
                        price: 200,
                        skills: [
                          "UI/UX Design",
                          "Mobile Development",
                          "Web Development"
                        ],
                        name: 'Ganesh G',
                      ),
                      Homegigcard(
                        title: "UI Design for Student App",
                        description:
                            "Looking for a UI designer to create mockups for a student project app, focusing on clean design and user-friendly interfaces",
                        time: '2',
                        open: true,
                        price: 200,
                        skills: [
                          "UI/UX Design",
                          "Mobile Development",
                          "Web Development"
                        ],
                        name: 'Ganesh G',
                      ),
                      Homegigcard(
                        title: "UI Design for Student App",
                        description:
                            "Looking for a UI designer to create mockups for a student project app, focusing on clean design and user-friendly interfaces",
                        time: '2',
                        open: true,
                        price: 200,
                        skills: [
                          "UI/UX Design",
                          "Mobile Development",
                          "Web Development"
                        ],
                        name: 'Ganesh G',
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Top Mentors",
                      style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600),
                    ),
                    Text(
                      "See All",
                      style: GoogleFonts.poppins(
                          color: Colors.amber,
                          fontSize: 14,
                          fontWeight: FontWeight.w600),
                    )
                  ],
                ),
                const SizedBox(
                  height: 24,
                ),
                const SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      // "Abhinav Sunil",
// "Senior UX Researcher at Google",
// "10+ years of experience in UX research and design. Passionate about mentoring the next generation",

                      Homementorcard(
                        name: 'Abinav Sunil',
                        job: 'Senior UX Researcher at Google',
                        rating: 5.0,
                        description:
                            '10+ years of experience in UX research and design. Passionate about mentoring the next generation',
                        skills: [
                          "UI/UX Design",
                          "Web Development",
                          "Mobile Development"
                        ],
                        available: 'Weekends',
                        verified: true,
                      ),
                      Homementorcard(
                        name: 'Abinav Sunil',
                        job: 'Senior UX Researcher at Google',
                        rating: 5.0,
                        description:
                            '10+ years of experience in UX research and design. Passionate about mentoring the next generation',
                        skills: [
                          "UI/UX Design",
                          "Web Development",
                          "Mobile Development"
                        ],
                        available: 'Weekends',
                        verified: true,
                      ),
                      Homementorcard(
                        name: 'Abinav Sunil',
                        job: 'Senior UX Researcher at Google',
                        rating: 5.0,
                        description:
                            '10+ years of experience in UX research and design. Passionate about mentoring the next generation',
                        skills: [
                          "UI/UX Design",
                          "Web Development",
                          "Mobile Development"
                        ],
                        available: 'Weekends',
                        verified: true,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Recent Chats",
                      style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600),
                    ),
                    Text(
                      "See All",
                      style: GoogleFonts.poppins(
                          color: Colors.amber,
                          fontSize: 14,
                          fontWeight: FontWeight.w600),
                    )
                  ],
                ),
                const SizedBox(
                  height: 24,
                ),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      color: VertexColors.button1background),
                  child: Column(
                    children: [Homechatcard(), Homechatcard()],
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Notifications",
                      style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600),
                    ),
                    Text(
                      "See All",
                      style: GoogleFonts.poppins(
                          color: Colors.amber,
                          fontSize: 14,
                          fontWeight: FontWeight.w600),
                    )
                  ],
                ),
                const SizedBox(
                  height: 24,
                ),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      color: VertexColors.button1background),
                  child: Column(
                    children: [
                      Homenotificationcard(),
                      Homenotificationcard(),
                    ],
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
