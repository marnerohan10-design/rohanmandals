import 'package:flutter/material.dart';
import 'package:rohanmandalas/theme/app_theme.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    if (!_formKey.currentState!.validate()) return;

    final uri = Uri(
      scheme: 'mailto',
      path: 'marnerohan10@gmail.com',
      queryParameters: {
        'subject': _subjectController.text.trim(),
        'body':
            'Name: ${_nameController.text.trim()}\n'
            'Email: ${_emailController.text.trim()}\n\n'
            '${_messageController.text.trim()}',
      },
    );

    final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          launched
              ? 'Your email draft is ready to send.'
              : 'No email app is available on this device.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 820;
        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Flex(
            direction: isWide ? Axis.horizontal : Axis.vertical,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 3, child: _buildForm(context)),
              SizedBox(width: isWide ? 24 : 0, height: isWide ? 0 : 24),
              Expanded(flex: 2, child: _buildDetails(context)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildForm(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Let’s make something meaningful.',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 10),
              Text(
                'Tell Rohan what you are imagining and your email app will prepare the request.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 26),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Your name'),
                validator: _required,
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(labelText: 'Email address'),
                validator: _emailValidator,
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _subjectController,
                decoration: const InputDecoration(labelText: 'Subject'),
                validator: _required,
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _messageController,
                maxLines: 6,
                decoration: const InputDecoration(
                  labelText: 'Message',
                  alignLabelWithHint: true,
                ),
                validator: _required,
              ),
              const SizedBox(height: 20),
              FilledButton.icon(
                onPressed: _sendMessage,
                icon: const Icon(Icons.mail_outline),
                label: const Text('Prepare email'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetails(BuildContext context) {
    return Card(
      color: AppTheme.plum,
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.auto_awesome, color: AppTheme.gold, size: 30),
            const SizedBox(height: 22),
            Text(
              'A calm space for good ideas.',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(color: Colors.white),
            ),
            const SizedBox(height: 14),
            Text(
              'Custom commissions, original art, collaborations, and thoughtful gifts are welcome.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.white70,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 28),
            const _ContactDetail(
              icon: Icons.email_outlined,
              label: 'Email',
              value: 'marnerohan10@gmail.com',
            ),
            const _ContactDetail(
              icon: Icons.location_on_outlined,
              label: 'Studio',
              value: 'Bengaluru, India',
            ),
            const _ContactDetail(
              icon: Icons.camera_alt_outlined,
              label: 'Instagram',
              value: '@rohansmandala',
            ),
          ],
        ),
      ),
    );
  }

  String? _required(String? value) =>
      value == null || value.trim().isEmpty ? 'Required' : null;

  String? _emailValidator(String? value) {
    if (_required(value) != null) return 'Required';
    return value!.contains('@') ? null : 'Enter a valid email';
  }
}

class _ContactDetail extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _ContactDetail({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppTheme.gold, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(color: Colors.white60, fontSize: 12),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
