import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/app_colors.dart';
import '../../utils/app_routes.dart';
import '../../utils/app_text_styles.dart';
import '../../utils/context_colors.dart';
import '../../utils/prefs_keys.dart';

class _OnboardingPage {
  const _OnboardingPage({
    required this.image,
    required this.icon,
    required this.title,
    required this.highlight,
    required this.subtitle,
    required this.color,
  });

  /// Illustration asset. Falls back to [icon] if the file is missing, so the
  /// screen still looks finished before any artwork is added.
  final String image;
  final IconData icon;

  /// Split title — [highlight] renders in the page's accent colour.
  final String title;
  final String highlight;

  final String subtitle;
  final Color color;
}

const List<_OnboardingPage> _pages = <_OnboardingPage>[
  _OnboardingPage(
    image: 'assets/images/onboarding/find.png',
    icon: Icons.search_rounded,
    title: 'Find the ',
    highlight: 'right doctor',
    subtitle:
    'Search by specialty and by the day you are free. You only see doctors '
        'who actually sit that day.',
    color: AppColors.primary,
  ),
  _OnboardingPage(
    image: 'assets/images/onboarding/book.png',
    icon: Icons.confirmation_number_outlined,
    title: 'Book ',
    highlight: 'without calling',
    subtitle:
    'Your serial number and estimated arrival time are confirmed instantly, '
        'so you know exactly when to reach the chamber.',
    color: AppColors.accent,
  ),
  _OnboardingPage(
    image: 'assets/images/onboarding/prices.png',
    icon: Icons.receipt_long_outlined,
    title: 'Know the ',
    highlight: 'cost first',
    subtitle:
    'Compare diagnostic test and medicine prices from nearby centres before '
        'you leave home.',
    color: AppColors.warning,
  ),
];

/// Shown only on first launch — a SharedPreferences flag makes sure of that.
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _index = 0;

  bool get _isLastPage => _index == _pages.length - 1;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _finish() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(PrefsKeys.seenOnboarding, true);

    if (!mounted) return;
    Navigator.pushReplacementNamed(context, AppRoutes.welcome);
  }

  void _next() {
    if (_isLastPage) {
      _finish();
    } else {
      _controller.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOutCubic,
      );
    }
  }

  void _back() {
    _controller.previousPage(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final _OnboardingPage page = _pages[_index];

    return Scaffold(
      body: Stack(
        children: <Widget>[
          // Soft colour wash behind the content, tinted to the current page.
          // It shifts as you swipe, which ties the three screens together
          // without needing three different backgrounds.
          Positioned(
            top: -110,
            right: -90,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 450),
              width: 320,
              height: 320,
              decoration: BoxDecoration(
                color: page.color.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            top: 160,
            left: -120,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 450),
              width: 240,
              height: 240,
              decoration: BoxDecoration(
                color: page.color.withValues(alpha: 0.07),
                shape: BoxShape.circle,
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 12, 0),
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.medical_services_rounded,
                          size: 20, color: context.cPrimary),
                      const SizedBox(width: 7),
                      Text(
                        'MediBook',
                        style: AppTextStyles.heading3.copyWith(
                          color: context.cTextPrimary,
                          fontSize: 16,
                        ),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: _finish,
                        child: Text(
                          'Skip',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: context.cTextSecondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: PageView.builder(
                    controller: _controller,
                    itemCount: _pages.length,
                    onPageChanged: (int i) => setState(() => _index = i),
                    itemBuilder: (BuildContext context, int i) {
                      final _OnboardingPage p = _pages[i];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 28),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            _IllustrationCard(page: p),
                            const SizedBox(height: 44),
                            RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                style: AppTextStyles.heading1.copyWith(
                                  color: context.cTextPrimary,
                                  fontSize: 27,
                                  height: 1.25,
                                ),
                                children: <TextSpan>[
                                  TextSpan(text: p.title),
                                  TextSpan(
                                    text: p.highlight,
                                    style: TextStyle(color: p.color),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 14),
                            Text(
                              p.subtitle,
                              textAlign: TextAlign.center,
                              style: AppTextStyles.body.copyWith(
                                color: context.cTextSecondary,
                                height: 1.6,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(28, 12, 28, 28),
                  child: Row(
                    children: <Widget>[
                      // Dots sit beside the button rather than above it — it
                      // reads as one control strip instead of two stacked rows.
                      Row(
                        children: List<Widget>.generate(
                          _pages.length,
                              (int i) => AnimatedContainer(
                            duration: const Duration(milliseconds: 280),
                            curve: Curves.easeOut,
                            margin: const EdgeInsets.only(right: 6),
                            height: 8,
                            width: i == _index ? 26 : 8,
                            decoration: BoxDecoration(
                              color: i == _index ? page.color : context.cBorder,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ),
                      const Spacer(),
                      if (_index > 0)
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: _CircleButton(
                            icon: Icons.arrow_back_rounded,
                            onTap: _back,
                          ),
                        ),
                      _NextButton(
                        label: _isLastPage ? 'Get Started' : 'Next',
                        color: page.color,
                        onTap: _next,
                      ),
                    ],
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

/// The illustration sits on a white rounded card with a colour-tinted shadow.
///
/// unDraw's PNG exports carry a white background, so rather than fighting it
/// the card makes that white deliberate — and the tinted shadow lifts it off
/// the page.
class _IllustrationCard extends StatelessWidget {
  const _IllustrationCard({required this.page});

  final _OnboardingPage page;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(26),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: page.color.withValues(alpha: 0.22),
            blurRadius: 34,
            spreadRadius: -6,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: SizedBox(
        height: 190,
        width: double.infinity,
        child: Image.asset(
          page.image,
          fit: BoxFit.contain,
          errorBuilder: (_, _, _) =>
              Icon(page.icon, size: 86, color: page.color),
        ),
      ),
    );
  }
}

class _NextButton extends StatelessWidget {
  const _NextButton({
    required this.label,
    required this.color,
    required this.onTap,
  });

  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 280),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 15),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(30),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: color.withValues(alpha: 0.35),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              label,
              style: AppTextStyles.button.copyWith(color: Colors.white),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.arrow_forward_rounded,
                size: 19, color: Colors.white),
          ],
        ),
      ),
    );
  }
}

class _CircleButton extends StatelessWidget {
  const _CircleButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: context.cSurface,
          shape: BoxShape.circle,
          border: Border.all(color: context.cBorder),
        ),
        child: Icon(icon, size: 20, color: context.cTextSecondary),
      ),
    );
  }
}