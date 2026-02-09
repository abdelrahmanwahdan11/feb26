import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

const String geminiApiKey = 'AIzaSyAO5VBHhruRHCVcRcSX2cWTW1wJ8utZGGs';
const String searchApiKey = 'AIzaSyA0-dxnZUucBiuwe6eDooqEFGTWGYMlgdo';
const String searchCx = '0349de8d5b2744bd5';

void main() {
  runApp(const NeonSheetApp());
}

class NeonSheetApp extends StatefulWidget {
  const NeonSheetApp({super.key});

  @override
  State<NeonSheetApp> createState() => _NeonSheetAppState();
}

class _NeonSheetAppState extends State<NeonSheetApp> {
  Locale _locale = const Locale('ar');

  void _toggleLocale() {
    setState(() {
      _locale = _locale.languageCode == 'ar' ? const Locale('en') : const Locale('ar');
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: _locale,
      theme: ThemeData(
        brightness: Brightness.dark,
        textTheme: GoogleFonts.cairoTextTheme(Theme.of(context).textTheme),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xff9f67ff),
          secondary: Color(0xff44d9ff),
          surface: Color(0xff14142a),
        ),
        scaffoldBackgroundColor: const Color(0xff0b0b16),
      ),
      home: HomeShell(
        locale: _locale,
        onToggleLocale: _toggleLocale,
      ),
    );
  }
}

class HomeShell extends StatefulWidget {
  const HomeShell({super.key, required this.locale, required this.onToggleLocale});

  final Locale locale;
  final VoidCallback onToggleLocale;

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  final ValueNotifier<bool> _loading = ValueNotifier<bool>(false);
  AppSection _section = AppSection.splash;
  int _onboardingIndex = 0;

  void _showLoading(bool value) {
    _loading.value = value;
  }

  void _goToSection(AppSection section) {
    setState(() {
      _section = section;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          child: _buildSection(context),
        ),
        ValueListenableBuilder<bool>(
          valueListenable: _loading,
          builder: (context, isLoading, _) {
            return AnimatedOpacity(
              opacity: isLoading ? 1 : 0,
              duration: const Duration(milliseconds: 300),
              child: IgnorePointer(
                ignoring: !isLoading,
                child: Container(
                  color: Colors.black.withOpacity(0.7),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(
                          width: 120,
                          height: 120,
                          child: CircularProgressIndicator(strokeWidth: 6),
                        ),
                        const SizedBox(height: 16),
                        Text(AppStrings.of(widget.locale).loading),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildSection(BuildContext context) {
    switch (_section) {
      case AppSection.splash:
        return SplashScreen(
          locale: widget.locale,
          onStart: () => _goToSection(AppSection.onboarding),
          onToggleLocale: widget.onToggleLocale,
          onLogin: () => _goToSection(AppSection.auth),
        );
      case AppSection.onboarding:
        return OnboardingScreen(
          locale: widget.locale,
          index: _onboardingIndex,
          onToggleLocale: widget.onToggleLocale,
          onSkip: () => _goToSection(AppSection.auth),
          onNext: () {
            setState(() {
              if (_onboardingIndex < 2) {
                _onboardingIndex += 1;
              } else {
                _section = AppSection.auth;
              }
            });
          },
        );
      case AppSection.auth:
        return AuthScreen(
          locale: widget.locale,
          onToggleLocale: widget.onToggleLocale,
          onEnter: () async {
            _showLoading(true);
            await Future<void>.delayed(const Duration(milliseconds: 1200));
            _showLoading(false);
            _goToSection(AppSection.dashboard);
          },
        );
      case AppSection.dashboard:
        return DashboardScreen(
          locale: widget.locale,
          onToggleLocale: widget.onToggleLocale,
          onShowLoading: _showLoading,
        );
    }
  }
}

enum AppSection { splash, onboarding, auth, dashboard }

class AppStrings {
  const AppStrings(this.locale);

  final Locale locale;

  static AppStrings of(Locale locale) => AppStrings(locale);

  bool get isArabic => locale.languageCode == 'ar';

  String get brandTitle => isArabic ? 'نيون شيت للذكاء الاصطناعي' : 'Neon Sheet AI';
  String get brandTagline => isArabic
      ? 'مساحة عمل تشبه إكسل ومدعومة بذكاء Gemini'
      : 'Excel-like workspace powered by Gemini';
  String get toggleLanguage => isArabic ? 'English' : 'عربي';
  String get splashTitle => isArabic ? 'مرحبا بك في نيون شيت' : 'Welcome to Neon Sheet';
  String get splashDesc => isArabic
      ? 'تجربة ثنائية اللغة مليئة بالحركة لملفات إكسل مع Gemini.'
      : 'A bilingual animated Excel universe with Gemini.';
  String get start => isArabic ? 'ابدأ' : 'Start';
  String get login => isArabic ? 'تسجيل الدخول' : 'Login';
  String get onboardingTitle1 => isArabic ? 'سحر فوري' : 'Instant Magic';
  String get onboardingDesc1 => isArabic
      ? 'حمّل ملفات إكسل ودع Gemini يلخص ويعدل ويصور.'
      : 'Load Excel files and let Gemini summarize and visualize.';
  String get onboardingTitle2 => isArabic ? 'تقارير ذكية' : 'AI Reports';
  String get onboardingDesc2 => isArabic
      ? 'اطلب تحليلات ولوحات مؤشرات وتوقعات.'
      : 'Ask for dashboards, analytics, and forecasts.';
  String get onboardingTitle3 => isArabic ? 'تجربة ثنائية' : 'Bilingual Flow';
  String get onboardingDesc3 => isArabic
      ? 'بدّل بين اللغتين بسهولة.'
      : 'Switch between Arabic and English instantly.';
  String get skip => isArabic ? 'تخطي' : 'Skip';
  String get next => isArabic ? 'التالي' : 'Next';
  String get authTitle => isArabic ? 'ابدأ رحلتك' : 'Start your journey';
  String get loginTab => isArabic ? 'دخول' : 'Login';
  String get signupTab => isArabic ? 'حساب جديد' : 'Sign up';
  String get guestTab => isArabic ? 'ضيف' : 'Guest';
  String get email => isArabic ? 'البريد الإلكتروني' : 'Email';
  String get password => isArabic ? 'كلمة المرور' : 'Password';
  String get fullName => isArabic ? 'الاسم الكامل' : 'Full name';
  String get enter => isArabic ? 'دخول' : 'Enter';
  String get enterGuest => isArabic ? 'الدخول كضيف' : 'Enter as guest';
  String get workspace => isArabic ? 'المساحة' : 'Workspace';
  String get aiCenter => isArabic ? 'مركز الذكاء' : 'AI Center';
  String get reports => isArabic ? 'التقارير' : 'Reports';
  String get search => isArabic ? 'البحث' : 'Search';
  String get settings => isArabic ? 'الإعدادات' : 'Settings';
  String get loading => isArabic ? 'جارٍ تحميل مساحتك...' : 'Loading your workspace...';
  String get runWithGemini => isArabic ? 'تشغيل مع Gemini' : 'Run with Gemini';
  String get generate => isArabic ? 'إنشاء' : 'Generate';
  String get apply => isArabic ? 'تطبيق مع Gemini' : 'Apply with Gemini';
  String get searchHint => isArabic ? 'ابحث عبر محركك المخصص' : 'Search using your custom engine';
  String get openSearch => isArabic ? 'فتح البحث' : 'Open search';
  String get fileSupport => isArabic
      ? 'يدعم XLS/XLSX/CSV ويستعد للربط الخلفي.'
      : 'Supports XLS/XLSX/CSV; backend wiring pending.';
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({
    super.key,
    required this.locale,
    required this.onStart,
    required this.onToggleLocale,
    required this.onLogin,
  });

  final Locale locale;
  final VoidCallback onStart;
  final VoidCallback onToggleLocale;
  final VoidCallback onLogin;

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(locale);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      AnimatedRotation(
                        turns: 1,
                        duration: const Duration(seconds: 12),
                        curve: Curves.easeInOut,
                        child: Container(
                          width: 54,
                          height: 54,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            gradient: const LinearGradient(
                              colors: [Color(0xff9f67ff), Color(0xff44d9ff)],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xff9f67ff).withOpacity(0.4),
                                blurRadius: 20,
                              )
                            ],
                          ),
                          child: const Icon(Icons.grid_3x3, color: Colors.white),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(strings.brandTitle, style: Theme.of(context).textTheme.titleLarge),
                          Text(strings.brandTagline, style: Theme.of(context).textTheme.bodySmall),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      TextButton(
                        onPressed: onToggleLocale,
                        child: Text(strings.toggleLanguage),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: onLogin,
                        child: Text(strings.login),
                      ),
                    ],
                  )
                ],
              ),
              const Spacer(),
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.8, end: 1),
                duration: const Duration(seconds: 2),
                curve: Curves.easeInOut,
                builder: (context, value, child) {
                  return Transform.scale(
                    scale: value,
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [Color(0xff9f67ff), Color(0x0044d9ff)],
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
              Text(strings.splashTitle, style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 12),
              Text(strings.splashDesc, textAlign: TextAlign.center),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: onStart,
                child: Text(strings.start),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({
    super.key,
    required this.locale,
    required this.index,
    required this.onSkip,
    required this.onNext,
    required this.onToggleLocale,
  });

  final Locale locale;
  final int index;
  final VoidCallback onSkip;
  final VoidCallback onNext;
  final VoidCallback onToggleLocale;

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(locale);
    final pages = [
      _OnboardingData(strings.onboardingTitle1, strings.onboardingDesc1, Icons.auto_awesome),
      _OnboardingData(strings.onboardingTitle2, strings.onboardingDesc2, Icons.query_stats),
      _OnboardingData(strings.onboardingTitle3, strings.onboardingDesc3, Icons.language),
    ];

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                  onPressed: onToggleLocale,
                  child: Text(strings.toggleLanguage),
                ),
              ),
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 400),
                  child: _OnboardingCard(data: pages[index], key: ValueKey(index)),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(onPressed: onSkip, child: Text(strings.skip)),
                  Row(
                    children: List.generate(
                      pages.length,
                      (dotIndex) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: dotIndex == index ? 24 : 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: dotIndex == index ? const Color(0xff44d9ff) : Colors.white24,
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                    ),
                  ),
                  ElevatedButton(onPressed: onNext, child: Text(strings.next)),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _OnboardingData {
  const _OnboardingData(this.title, this.description, this.icon);

  final String title;
  final String description;
  final IconData icon;
}

class _OnboardingCard extends StatelessWidget {
  const _OnboardingCard({super.key, required this.data});

  final _OnboardingData data;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: const Color(0xff1a1c32),
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              color: const Color(0xff44d9ff).withOpacity(0.2),
              blurRadius: 30,
              offset: const Offset(0, 20),
            )
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedRotation(
              turns: 1,
              duration: const Duration(seconds: 8),
              child: Icon(data.icon, size: 64, color: const Color(0xff44d9ff)),
            ),
            const SizedBox(height: 16),
            Text(data.title, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 12),
            Text(data.description, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key, required this.locale, required this.onToggleLocale, required this.onEnter});

  final Locale locale;
  final VoidCallback onToggleLocale;
  final FutureOr<void> Function() onEnter;

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> with SingleTickerProviderStateMixin {
  int _tabIndex = 0;
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(widget.locale);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                  onPressed: widget.onToggleLocale,
                  child: Text(strings.toggleLanguage),
                ),
              ),
              const SizedBox(height: 16),
              Text(strings.authTitle, style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 24),
              ToggleButtons(
                isSelected: [
                  _tabIndex == 0,
                  _tabIndex == 1,
                  _tabIndex == 2,
                ],
                onPressed: (index) {
                  setState(() {
                    _tabIndex = index;
                  });
                },
                borderRadius: BorderRadius.circular(20),
                children: [
                  Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: Text(strings.loginTab)),
                  Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: Text(strings.signupTab)),
                  Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: Text(strings.guestTab)),
                ],
              ),
              const SizedBox(height: 24),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _tabIndex == 2
                    ? _GuestPanel(strings: strings, onEnter: widget.onEnter)
                    : _AuthForm(
                        strings: strings,
                        isSignup: _tabIndex == 1,
                        obscure: _obscure,
                        onToggleObscure: () => setState(() => _obscure = !_obscure),
                        onEnter: widget.onEnter,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AuthForm extends StatelessWidget {
  const _AuthForm({
    required this.strings,
    required this.isSignup,
    required this.obscure,
    required this.onToggleObscure,
    required this.onEnter,
  });

  final AppStrings strings;
  final bool isSignup;
  final bool obscure;
  final VoidCallback onToggleObscure;
  final FutureOr<void> Function() onEnter;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: ValueKey(isSignup),
      children: [
        if (isSignup)
          TextField(
            decoration: InputDecoration(labelText: strings.fullName),
          ),
        const SizedBox(height: 12),
        TextField(
          decoration: InputDecoration(labelText: strings.email),
        ),
        const SizedBox(height: 12),
        TextField(
          obscureText: obscure,
          decoration: InputDecoration(
            labelText: strings.password,
            suffixIcon: IconButton(
              icon: Icon(obscure ? Icons.visibility : Icons.visibility_off),
              onPressed: onToggleObscure,
            ),
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton(onPressed: onEnter, child: Text(strings.enter)),
      ],
    );
  }
}

class _GuestPanel extends StatelessWidget {
  const _GuestPanel({required this.strings, required this.onEnter});

  final AppStrings strings;
  final FutureOr<void> Function() onEnter;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: const ValueKey('guest'),
      children: [
        Text(strings.enterGuest, style: Theme.of(context).textTheme.bodyLarge),
        const SizedBox(height: 16),
        ElevatedButton(onPressed: onEnter, child: Text(strings.enterGuest)),
      ],
    );
  }
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({
    super.key,
    required this.locale,
    required this.onToggleLocale,
    required this.onShowLoading,
  });

  final Locale locale;
  final VoidCallback onToggleLocale;
  final void Function(bool) onShowLoading;

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _navIndex = 0;
  final TextEditingController _aiController = TextEditingController();
  final TextEditingController _settingsController = TextEditingController();
  String _aiOutput = '';
  String _reportOutput = '';
  String _settingsOutput = '';

  final GeminiService _geminiService = GeminiService();

  @override
  void dispose() {
    _aiController.dispose();
    _settingsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(widget.locale);
    return Scaffold(
      appBar: AppBar(
        title: Text(strings.brandTitle),
        actions: [
          TextButton(
            onPressed: widget.onToggleLocale,
            child: Text(strings.toggleLanguage, style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: _navIndex,
            onDestinationSelected: (index) => setState(() => _navIndex = index),
            labelType: NavigationRailLabelType.all,
            destinations: [
              NavigationRailDestination(icon: const Icon(Icons.table_chart), label: Text(strings.workspace)),
              NavigationRailDestination(icon: const Icon(Icons.auto_awesome), label: Text(strings.aiCenter)),
              NavigationRailDestination(icon: const Icon(Icons.pie_chart), label: Text(strings.reports)),
              NavigationRailDestination(icon: const Icon(Icons.search), label: Text(strings.search)),
              NavigationRailDestination(icon: const Icon(Icons.settings), label: Text(strings.settings)),
            ],
          ),
          const VerticalDivider(width: 1),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: _buildPanel(strings),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPanel(AppStrings strings) {
    switch (_navIndex) {
      case 0:
        return _WorkspacePanel(strings: strings);
      case 1:
        return _AiCenterPanel(
          strings: strings,
          controller: _aiController,
          output: _aiOutput,
          onRun: () async {
            await _runGemini(
              prompt: _aiController.text,
              onResult: (value) => setState(() => _aiOutput = value),
            );
          },
        );
      case 2:
        return _ReportsPanel(
          strings: strings,
          output: _reportOutput,
          onGenerate: (prompt) async {
            await _runGemini(
              prompt: prompt,
              onResult: (value) => setState(() => _reportOutput = value),
            );
          },
        );
      case 3:
        return _SearchPanel(strings: strings);
      case 4:
        return _SettingsPanel(
          strings: strings,
          controller: _settingsController,
          output: _settingsOutput,
          onRun: () async {
            await _runGemini(
              prompt: _settingsController.text,
              onResult: (value) => setState(() => _settingsOutput = value),
            );
          },
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Future<void> _runGemini({required String prompt, required ValueChanged<String> onResult}) async {
    if (prompt.trim().isEmpty) {
      return;
    }
    widget.onShowLoading(true);
    final response = await _geminiService.runPrompt(prompt: prompt, locale: widget.locale);
    widget.onShowLoading(false);
    onResult(response);
  }
}

class _WorkspacePanel extends StatelessWidget {
  const _WorkspacePanel({required this.strings});

  final AppStrings strings;

  @override
  Widget build(BuildContext context) {
    return Padding(
      key: const ValueKey('workspace'),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(strings.workspace, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 12),
          Text(strings.fileSupport),
          const SizedBox(height: 24),
          Wrap(
            spacing: 12,
            children: [
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.upload_file),
                label: Text(strings.isArabic ? 'رفع ملف' : 'Upload file'),
              ),
              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.download),
                label: Text(strings.isArabic ? 'تصدير' : 'Export'),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 2.4,
              ),
              itemCount: 12,
              itemBuilder: (context, index) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeInOut,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xff1a1c32),
                        const Color(0xff1a1c32).withOpacity(0.6),
                      ],
                    ),
                  ),
                  child: Center(
                    child: Text(
                      '${strings.isArabic ? 'خلية' : 'Cell'} ${index + 1}',
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _AiCenterPanel extends StatelessWidget {
  const _AiCenterPanel({
    required this.strings,
    required this.controller,
    required this.output,
    required this.onRun,
  });

  final AppStrings strings;
  final TextEditingController controller;
  final String output;
  final VoidCallback onRun;

  @override
  Widget build(BuildContext context) {
    return Padding(
      key: const ValueKey('ai'),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(strings.aiCenter, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 16),
          TextField(
            controller: controller,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: strings.isArabic ? 'اكتب طلبك هنا' : 'Type your request here',
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: onRun,
            icon: const Icon(Icons.auto_awesome),
            label: Text(strings.runWithGemini),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: const Color(0xff14142a),
              ),
              child: SingleChildScrollView(child: Text(output.isEmpty ? '...' : output)),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReportsPanel extends StatelessWidget {
  const _ReportsPanel({required this.strings, required this.output, required this.onGenerate});

  final AppStrings strings;
  final String output;
  final Future<void> Function(String prompt) onGenerate;

  @override
  Widget build(BuildContext context) {
    final prompts = {
      'kpi': strings.isArabic ? 'حلل مؤشرات الأداء الرئيسية' : 'Analyze KPI dashboard',
      'forecast': strings.isArabic ? 'توقع الاتجاهات القادمة' : 'Forecast upcoming trends',
      'story': strings.isArabic ? 'اكتب تقريرا سرديا للبيانات' : 'Write a narrative report',
    };
    return Padding(
      key: const ValueKey('reports'),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(strings.reports, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: prompts.entries
                .map(
                  (entry) => OutlinedButton.icon(
                    onPressed: () => onGenerate(entry.value),
                    icon: const Icon(Icons.auto_graph),
                    label: Text(entry.key.toUpperCase()),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: const Color(0xff14142a),
              ),
              child: SingleChildScrollView(child: Text(output.isEmpty ? '...' : output)),
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchPanel extends StatelessWidget {
  const _SearchPanel({required this.strings});

  final AppStrings strings;

  @override
  Widget build(BuildContext context) {
    return Padding(
      key: const ValueKey('search'),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(strings.search, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 12),
          Text(strings.searchHint),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () async {
              final url = Uri.parse('https://cse.google.com/cse?cx=$searchCx');
              await launchUrl(url, mode: LaunchMode.externalApplication);
            },
            icon: const Icon(Icons.open_in_new),
            label: Text(strings.openSearch),
          ),
          const SizedBox(height: 12),
          Text(
            strings.isArabic
                ? 'المفتاح الحالي: $searchApiKey'
                : 'Current search API key: $searchApiKey',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

class _SettingsPanel extends StatelessWidget {
  const _SettingsPanel({
    required this.strings,
    required this.controller,
    required this.output,
    required this.onRun,
  });

  final AppStrings strings;
  final TextEditingController controller;
  final String output;
  final VoidCallback onRun;

  @override
  Widget build(BuildContext context) {
    return Padding(
      key: const ValueKey('settings'),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(strings.settings, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 16),
          TextField(
            controller: controller,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: strings.isArabic ? 'مثال: اجعل الواجهة ليلية' : 'Example: enable night mode',
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: onRun,
            icon: const Icon(Icons.tune),
            label: Text(strings.apply),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: const Color(0xff14142a),
              ),
              child: SingleChildScrollView(child: Text(output.isEmpty ? '...' : output)),
            ),
          ),
        ],
      ),
    );
  }
}

class GeminiService {
  static const _endpoint =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent';

  Future<String> runPrompt({required String prompt, required Locale locale}) async {
    try {
      final response = await http.post(
        Uri.parse('$_endpoint?key=$geminiApiKey'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'contents': [
            {
              'parts': [
                {'text': prompt}
              ]
            }
          ]
        }),
      );
      if (response.statusCode != 200) {
        throw Exception('Gemini error ${response.statusCode}');
      }
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      final candidates = json['candidates'] as List<dynamic>?;
      if (candidates == null || candidates.isEmpty) {
        return locale.languageCode == 'ar'
            ? 'لا توجد إجابة حالياً من Gemini.'
            : 'No response from Gemini yet.';
      }
      final content = candidates.first as Map<String, dynamic>;
      final parts = (content['content'] as Map<String, dynamic>)['parts'] as List<dynamic>;
      return parts.first['text']?.toString() ?? '';
    } catch (_) {
      return locale.languageCode == 'ar'
          ? 'تعذر الاتصال بـ Gemini حالياً. سيتم التنفيذ عند الربط الخلفي.'
          : 'Unable to reach Gemini now. Will run once backend wiring is ready.';
    }
  }
}
