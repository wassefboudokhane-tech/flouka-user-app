import 'package:flouka/core/config/app_color.dart';
import 'package:flouka/core/config/app_spacing.dart';
import 'package:flouka/core/config/app_styles.dart';
import 'package:flouka/core/helper_function/api.dart';
import 'package:flouka/features/auth/presentation/providers/auth_provider.dart';
import 'package:flouka/features/language/presentation/provider/language_provider.dart';
import 'package:flouka/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// The page the home banner opens: ask to become a creator.
class BecomeCreatorPage extends StatefulWidget {
  const BecomeCreatorPage({super.key});

  @override
  State<BecomeCreatorPage> createState() => _BecomeCreatorPageState();
}

class _BecomeCreatorPageState extends State<BecomeCreatorPage> {
  final _handle = TextEditingController();
  final _name = TextEditingController();
  String _message = '';
  bool _sending = false;

  @override
  void dispose() {
    _handle.dispose();
    _name.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    if (!AuthProvider.isLogin()) {
      context.read<AuthProvider>().goToLoginView(replace: false);
      return;
    }
    final handle = _handle.text.trim().toLowerCase().replaceFirst(RegExp(r'^@'), '');
    final name = _name.text.trim();
    if (!RegExp(r'^[a-z0-9_.-]{2,40}$').hasMatch(handle) || name.isEmpty) {
      setState(() => _message = LanguageProvider.translate('home', 'become_intro'));
      return;
    }
    setState(() {
      _sending = true;
      _message = '';
    });
    final result = await sl<ApiHandel>().post('user/apply_as_creator', {
      'handle': handle,
      'name': name,
    });
    if (!mounted) return;
    setState(() {
      _sending = false;
      _message = result.fold(
        (l) => l.message ?? LanguageProvider.translate('error', 'error'),
        (_) => LanguageProvider.translate('home', 'become_sent'),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.canvasColor,
      appBar: AppBar(
        backgroundColor: AppColor.canvasColor,
        foregroundColor: AppColor.inkColor,
        elevation: 0,
        title: Text(
          LanguageProvider.translate('home', 'become_creator'),
          style: TextStyleClass.normalStyle(color: AppColor.inkColor),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.pageGutter),
        children: [
          Text(
            LanguageProvider.translate('home', 'share_claim'),
            style: TextStyleClass.semiHeadStyle(color: AppColor.inkColor).copyWith(
              fontWeight: FontWeight.w300,
              fontSize: 28,
              height: 1.15,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            LanguageProvider.translate('home', 'become_intro'),
            style: TextStyleClass.smallStyle(color: AppColor.mutedColor).copyWith(height: 1.45),
          ),
          const SizedBox(height: 22),
          TextField(
            controller: _handle,
            decoration: _field(LanguageProvider.translate('home', 'become_handle')),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _name,
            decoration: _field(LanguageProvider.translate('home', 'become_name')),
          ),
          const SizedBox(height: 18),
          FilledButton(
            onPressed: _sending ? null : _send,
            style: FilledButton.styleFrom(
              backgroundColor: AppColor.deepColor,
              foregroundColor: Colors.white,
              shape: const RoundedRectangleBorder(),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            child: Text(LanguageProvider.translate('home', 'become_creator')),
          ),
          if (_message.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(_message, style: TextStyleClass.smallStyle(color: AppColor.inkColor)),
          ],
        ],
      ),
    );
  }

  InputDecoration _field(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyleClass.smallStyle(color: AppColor.mutedColor),
      enabledBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(color: Color(0xFFEAEAEE)),
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(color: Color(0xFF1A1A1A)),
      ),
    );
  }
}
