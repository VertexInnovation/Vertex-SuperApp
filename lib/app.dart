import 'package:flutter/material.dart';
import 'package:vertex_app/colors.dart';
import 'package:vertex_app/main.dart';

class VertexApp extends StatelessWidget {
  const VertexApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vertex SuperApp',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Use our custom color palette
        colorScheme: const ColorScheme(
          brightness: Brightness.light,
          primary: VertexColors.deepSapphire,
          onPrimary: Colors.white,
          secondary: VertexColors.ceruleanBlue,
          onSecondary: Colors.white,
          tertiary: VertexColors.oceanMist,
          onTertiary: Colors.black87,
          error: Colors.redAccent,
          onError: Colors.white,
          surface: Colors.white,
          onSurface: Colors.black87,
        ),

        // Customize specific component themes
        appBarTheme: const AppBarTheme(
          backgroundColor: VertexColors.honeyedAmber,
          foregroundColor: VertexColors.deepSapphire,
          elevation: 0,
        ),

        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: VertexColors.ceruleanBlue,
          foregroundColor: Colors.white,
        ),

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: VertexColors.ceruleanBlue,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          ),
        ),

        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: VertexColors.deepSapphire,
          ),
        ),

        inputDecorationTheme: InputDecorationTheme(
          fillColor: Colors.grey.shade50,
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: VertexColors.ceruleanBlue,
              width: 2,
            ),
          ),
        ),

        useMaterial3: true,
        fontFamily: 'Poppins',
      ),
      home: const AuthHandler(),
    );
  }
}
