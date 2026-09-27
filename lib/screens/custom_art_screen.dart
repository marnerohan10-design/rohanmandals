import 'package:flutter/material.dart';
import 'package:rohanmandalas/theme/app_theme.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomArtScreen extends StatefulWidget {
  const CustomArtScreen({super.key});

  @override
  State<CustomArtScreen> createState() => _CustomArtScreenState();
}

class _CustomArtScreenState extends State<CustomArtScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fields = <String, TextEditingController>{};
  bool _submitted = false;

  static const _fieldLabels = [
    'Name',
    'Email',
    'Phone',
    'Preferred Size',
    'Preferred Color Palette',
    'Theme',
    'Occasion',
    'Budget',
    'Deadline',
    'Reference Image URL',
  ];

  @override
  void initState() {
    super.initState();
    for (final label in _fieldLabels) {
      _fields[label] = TextEditingController();
    }
    _fields['Additional Requirements'] = TextEditingController();
  }

  @override
  void dispose() {
    for (final controller in _fields.values) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _submitRequest() async {
    if (!_formKey.currentState!.validate()) return;

    final details = _fields.entries
        .map((entry) => '${entry.key}: ${entry.value.text.trim()}')
        .join('\n');
    final uri = Uri(
      scheme: 'mailto',
      path: 'marnerohan10@gmail.com',
      queryParameters: {
        'subject':
            'Custom Mandala Request from ${_fields['Name']!.text.trim()}',
        'body': details,
      },
    );

    final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!mounted) return;
    if (launched) {
      setState(() => _submitted = true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No email app is available on this device.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 980),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(28),
              child:
                  _submitted
                      ? _SuccessState(onReset: _reset)
                      : _buildForm(context),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Expanded(child: _SectionIntro()),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppTheme.parchment,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(Icons.auto_awesome, color: AppTheme.plum),
              ),
            ],
          ),
          const SizedBox(height: 26),
          LayoutBuilder(
            builder: (context, constraints) {
              final columns = constraints.maxWidth >= 700 ? 2 : 1;
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _fieldLabels.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: columns,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 14,
                  mainAxisExtent: 66,
                ),
                itemBuilder: (context, index) {
                  final label = _fieldLabels[index];
                  return TextFormField(
                    controller: _fields[label],
                    keyboardType:
                        label == 'Email'
                            ? TextInputType.emailAddress
                            : TextInputType.text,
                    decoration: InputDecoration(labelText: label),
                    validator:
                        label == 'Reference Image URL' ? null : _required,
                  );
                },
              );
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _fields['Additional Requirements'],
            maxLines: 5,
            decoration: const InputDecoration(
              labelText: 'Additional Requirements',
              hintText:
                  'Share the story, mood, symbols, or details you want included.',
              alignLabelWithHint: true,
            ),
            validator: _required,
          ),
          const SizedBox(height: 22),
          FilledButton.icon(
            onPressed: _submitRequest,
            icon: const Icon(Icons.send_outlined),
            label: const Text('Send commission request'),
          ),
        ],
      ),
    );
  }

  void _reset() {
    for (final controller in _fields.values) {
      controller.clear();
    }
    setState(() => _submitted = false);
  }

  String? _required(String? value) =>
      value == null || value.trim().isEmpty ? 'Required' : null;
}

class _SectionIntro extends StatelessWidget {
  const _SectionIntro();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Your story. Your Mandala.',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 10),
        Text(
          'Share your vision and the complete brief will open as an email addressed to Rohan.',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.5),
        ),
      ],
    );
  }
}

class _SuccessState extends StatelessWidget {
  final VoidCallback onReset;

  const _SuccessState({required this.onReset});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 20),
      child: Column(
        children: [
          const Icon(
            Icons.mark_email_read_outlined,
            color: AppTheme.rust,
            size: 70,
          ),
          const SizedBox(height: 18),
          Text(
            'Your request is ready.',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 12),
          const Text(
            'Your email app has been opened with the full commission brief. Review it and press send.',
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
