import 'package:flutter/material.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Contact', style: TextStyle(fontSize: 40, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 18),
                  const TextField(decoration: InputDecoration(labelText: 'Name')),
                  const SizedBox(height: 16),
                  const TextField(decoration: InputDecoration(labelText: 'Email')),
                  const SizedBox(height: 16),
                  const TextField(decoration: InputDecoration(labelText: 'Subject')),
                  const SizedBox(height: 16),
                  const TextField(decoration: InputDecoration(labelText: 'Message'), maxLines: 5),
                  const SizedBox(height: 20),
                  FilledButton(onPressed: () {}, child: const Text('Send Message')),
                ],
              ),
            ),
          ),
          const SizedBox(width: 24),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Get in touch', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 14),
                  const ListTile(leading: Icon(Icons.email_outlined), title: Text('hello@rohansmandala.com')),
                  const ListTile(leading: Icon(Icons.phone_outlined), title: Text('+91 98765 43210')),
                  const ListTile(leading: Icon(Icons.camera_alt_outlined), title: Text('@rohansmandala')),
                  const ListTile(leading: Icon(Icons.location_on_outlined), title: Text('Bengaluru, India')),
                  const SizedBox(height: 20),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: Image.network(
                      'https://images.unsplash.com/photo-1524661135-423995f22d0b?auto=format&fit=crop&w=900&q=80',
                      height: 220,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
