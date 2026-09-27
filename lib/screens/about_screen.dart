import 'package:flutter/material.dart';
import 'package:rohanmandalas/theme/app_theme.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final timeline = [
      'Beginning',
      'Learning',
      'Experimenting',
      'Creating',
      'Sharing',
      'Rohan\'s Mandala',
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Behind Every Line Is a Story.', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 42)),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Who is Rohan?', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 12),
                    const Text('Rohan is a contemporary artist and maker who creates Mandalas from the rhythm of everyday life. His work blends symmetry, intention, and emotion into tactile pieces that bring calm into a room.'),
                    const SizedBox(height: 18),
                    const Text('How Rohan started creating Mandalas', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 8),
                    const Text('What began as a quiet personal practice gradually became a language of expression, used to reflect stillness, gratitude, and creative renewal.'),
                    const SizedBox(height: 18),
                    const Text('Inspiration', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 8),
                    const Text('Nature, sacred geometry, travel, spiritual rituals, family memories, and the marks of the hand all shape each Mandala.'),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Image.network(
                  'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=800&q=80',
                  width: 380,
                  height: 480,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
          const SizedBox(height: 28),
          const Text('Artistic Process', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700)),
          const SizedBox(height: 10),
          const Text('Each work starts with a concept, then moves through careful sketching, geometric alignment, embellishment, and finishing. Every layer tells a story of patience, control, and emotion.'),
          const SizedBox(height: 18),
          const Text('Philosophy', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700)),
          const SizedBox(height: 10),
          const Text('Rohan believes every circle holds a memory, and every line creates a path back to balance. His Mandalas are invitations to pause, breathe, and reconnect with your inner rhythm.'),
          const SizedBox(height: 18),
          const Text('Future Vision', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700)),
          const SizedBox(height: 10),
          const Text('The mission is to share Mandalas with homes, healing spaces, and communities that seek beauty, meaning, and mindful living across the world.'),
          const SizedBox(height: 30),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Journey', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700)),
                const SizedBox(height: 18),
                Wrap(
                  spacing: 18,
                  runSpacing: 14,
                  children: timeline.map((step) => Chip(
                    label: Text(step),
                    backgroundColor: AppTheme.parchment,
                    labelStyle: const TextStyle(color: AppTheme.plum, fontWeight: FontWeight.w600),
                  )).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
