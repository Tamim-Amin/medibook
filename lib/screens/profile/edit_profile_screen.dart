import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../models/app_user.dart';
import '../../providers/auth_provider.dart';
import '../../utils/app_text_styles.dart';
import '../../utils/app_theme.dart';
import '../../utils/context_colors.dart';
import '../../utils/validators.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/avatar_image.dart';
import '../../widgets/primary_button.dart';

/// Lets the logged-in user update their name, phone and age.
///
/// Email is deliberately read-only: [AuthProvider.updateProfile] matches the
/// stored account by email, so changing it here would orphan the record.
class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _age = TextEditingController();

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final AppUser? user = context.read<AuthProvider>().currentUser;
    _name.text = user?.name ?? '';
    _phone.text = user?.phone ?? '';
    _age.text = user?.age?.toString() ?? '';
  }

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _age.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    final AuthProvider auth = context.read<AuthProvider>();
    final AppUser? current = auth.currentUser;
    if (current == null) return;

    setState(() => _isSaving = true);

    final AppUser updated = current.copyWith(
      name: _name.text.trim(),
      phone: _phone.text.trim(),
      age: _age.text.trim().isEmpty ? null : int.parse(_age.text.trim()),
    );

    await auth.updateProfile(updated);

    if (!mounted) return;
    setState(() => _isSaving = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile updated')),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final AppUser? user = context.watch<AuthProvider>().currentUser;

    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Edit Profile')),
        body: Center(
          child: Text(
            'You need to be logged in to edit your profile.',
            style: AppTextStyles.body.copyWith(color: context.cTextSecondary),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Center(
                  child: AvatarImage(
                    initials: user.initials,
                    size: 88,
                    radius: 26,
                  ),
                ),
                const SizedBox(height: 28),
                AppTextField(
                  label: 'Full Name',
                  hint: 'e.g. Tamim Amin',
                  controller: _name,
                  prefixIcon: Icons.person_outline,
                  textInputAction: TextInputAction.next,
                  validator: Validators.name,
                ),
                AppTextField(
                  label: 'Phone Number',
                  hint: '01712345678',
                  controller: _phone,
                  prefixIcon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                  maxLength: 11,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  textInputAction: TextInputAction.next,
                  validator: Validators.phone,
                ),
                AppTextField(
                  label: 'Age (optional)',
                  hint: 'Used to pre-fill your booking forms',
                  controller: _age,
                  prefixIcon: Icons.cake_outlined,
                  keyboardType: TextInputType.number,
                  maxLength: 3,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  textInputAction: TextInputAction.done,
                  validator: (String? v) =>
                      (v == null || v.trim().isEmpty) ? null : Validators.age(v),
                ),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: context.cSurface,
                    borderRadius: BorderRadius.circular(AppTheme.radius),
                    border: Border.all(color: context.cBorder),
                  ),
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.mail_outline,
                          size: 19, color: context.cTextSecondary),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              user.email,
                              style: AppTextStyles.bodySmall
                                  .copyWith(color: context.cTextPrimary),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Email cannot be changed',
                              style: AppTextStyles.caption
                                  .copyWith(color: context.cTextSecondary),
                            ),
                          ],
                        ),
                      ),
                      Icon(Icons.lock_outline,
                          size: 17, color: context.cTextSecondary),
                    ],
                  ),
                ),
                const SizedBox(height: 26),
                PrimaryButton(
                  label: 'Save Changes',
                  icon: Icons.check_rounded,
                  isLoading: _isSaving,
                  onPressed: _save,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
