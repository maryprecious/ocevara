import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class VideoGuidesScreen extends StatelessWidget {
  const VideoGuidesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F3950),
        title: Text(
          'Video Guides',
          style: GoogleFonts.playfairDisplay(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _videoTile('How to log a sustainable catch', '3:45'),
          _videoTile('Identifying protected species', '5:12'),
          _videoTile('Using the map & zones', '4:20'),
          _videoTile('Best handling and release techniques', '6:05'),
        ],
      ),
    );
  }

  Widget _videoTile(String title, String duration) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 8),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 90,
            height: 60,
            color: Colors.grey.shade200,
            child: const Icon(Icons.play_arrow, size: 28),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: GoogleFonts.lato(
                fontWeight: FontWeight.bold,
                color: const Color(0xFF0F3950),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(duration, style: GoogleFonts.lato(color: Colors.grey)),
        ],
      ),
    );
  }
}
