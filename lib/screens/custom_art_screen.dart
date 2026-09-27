import 'package:flutter/material.dart';

class CustomArtScreen extends StatefulWidget {
  const CustomArtScreen({super.key});

  @override
  State<CustomArtScreen> createState() => _CustomArtScreenState();
}

class _CustomArtScreenState extends State<CustomArtScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _submitted = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 900),
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
          ),
          child: _submitted
              ? _SuccessState(
                  onReset: () => setState(() => _submitted = false),
                )
              : Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Your Story. Your Mandala.',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 42),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Share your vision and I will create a one-of-a-kind custom Mandala tailored to your story, space, and spiritual energy.',
                        style: TextStyle(fontSize: 17, height: 1.7),
                      ),
                      const SizedBox(height: 26),
                      GridView.count(
                        shrinkWrap: true,
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 5,
                        children: const [
                          CustomField(label: 'Name'),
                          CustomField(label: 'Email'),
                          CustomField(label: 'Phone'),
                          CustomField(label: 'Preferred Size'),
                          CustomField(label: 'Preferred Color Palette'),
                          CustomField(label: 'Theme'),
                          CustomField(label: 'Occasion'),
                          CustomField(label: 'Budget'),
                          CustomField(label: 'Deadline'),
                          CustomField(label: 'Upload Reference Image'),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Additional Requirements',
                        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      const TextField(
                        maxLines: 5,
                        decoration: InputDecoration(
                          hintText: 'Tell me about your story, ideas, colors, or other details...',
                        ),
                      ),
                      const SizedBox(height: 20),
                      FilledButton(
                        onPressed: () => setState(() => _submitted = true),
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFF3B1F2B),
                          minimumSize: const Size.fromHeight(54),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text('Submit Custom Request'),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}

class CustomField extends StatelessWidget {
  final String label;

  const CustomField({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
      ),
    );
  }
}

class _SuccessState extends StatelessWidget {
  final VoidCallback onReset;

  const _SuccessState({required this.onReset});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const Icon(Icons.check_circle, color: Color(0xFFC9A227), size: 72),
          const SizedBox(height: 18),
          Text(
            'Custom request submitted successfully.',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 12),
          const Text(
            'Thank you for sharing your story. Rohan will review your request and contact you soon with a personalized proposal.',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 22),
          TextButton.icon(
            onPressed: onReset,
            icon: const Icon(Icons.refresh),
            label: const Text('Submit another request'),
          ),
        ],
      ),
    );
  }
}
