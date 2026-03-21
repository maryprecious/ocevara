import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum ContactInfoType { responseTime, email, phone }

class ContactDetailScreen extends StatelessWidget {
  final ContactInfoType infoType;

  const ContactDetailScreen({super.key, required this.infoType});

  @override
  Widget build(BuildContext context) {
    String title;
    Widget body;

    switch (infoType) {
      case ContactInfoType.responseTime:
        title = 'Response Time';
        body = Text(
          'Our team aims to respond within 2 hours during business hours (Mon–Fri, 8AM–6PM). For urgent safety issues, call us immediately.',
          style: GoogleFonts.lato(color: Colors.grey.shade800),
        );
        break;
      case ContactInfoType.email:
        title = 'Email Support';
        body = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'support@ocevara.org',
              style: GoogleFonts.lato(
                fontWeight: FontWeight.bold,
                color: const Color(0xFF0F3950),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Available 24/7 for general enquiries. Expect a reply within 24 hours outside business hours.',
              style: GoogleFonts.lato(color: Colors.grey.shade800),
            ),
          ],
        );
        break;
      case ContactInfoType.phone:
        title = 'Phone Support';
        body = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '+234 800 ocevara',
              style: GoogleFonts.lato(
                fontWeight: FontWeight.bold,
                color: const Color(0xFF0F3950),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Phone support is available Mon–Fri, 8AM–6PM. For emergencies, use your local emergency services first.',
              style: GoogleFonts.lato(color: Colors.grey.shade800),
            ),
          ],
        );
        break;
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F3950),
        title: Text(
          title,
          style: GoogleFonts.playfairDisplay(color: Colors.white),
        ),
      ),
      body: Padding(padding: const EdgeInsets.all(20), child: body),
    );
  }
}
