import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const BuzzyAmongUsApp());
}

class AppLocalizations {
  final Locale locale;
  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const _localizedValues = {
    'ar': {
      'appTitle': 'باري فارتي: إمبوستر',
      'chooseProfile': 'اختر شخصيتك واسمك',
      'enterGame': 'دخول للعبة 🚀',
    },
    'en': {
      'appTitle': 'Buzzy Party: Imposter',
      'chooseProfile': 'Choose Your Avatar & Name',
      'enterGame': 'Enter Game 🚀',
    }
  };

  String get(String key) {
    return _localizedValues[locale.languageCode]?[key] ?? key;
  }
}

class BuzzyAmongUsApp extends StatefulWidget {
  const BuzzyAmongUsApp({super.key});

  @override
  State<BuzzyAmongUsApp> createState() => _BuzzyAmongUsAppState();

  static void setLocale(BuildContext context, Locale newLocale) {
    _BuzzyAmongUsAppState? state = context.findAncestorStateOfType<_BuzzyAmongUsAppState>();
    state?.setLocale(newLocale);
  }
}

class _BuzzyAmongUsAppState extends State<BuzzyAmongUsApp> {
  Locale _locale = const Locale('ar');

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Buzzy Party',
      debugShowCheckedModeBanner: false,
      locale: _locale,
      supportedLocales: const [Locale('ar', ''), Locale('en', '')],
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF130924),
        primaryColor: const Color(0xFF8B5CF6),
      ),
      home: const ProfileSetupScreen(),
    );
  }
}

// شاشة إعداد الملف الشخصي (مضبوطة تماماً في المنتصف بدون مساحات رمادية)
class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final TextEditingController nameController = TextEditingController();
  int selectedAvatarIndex = 0;

  final List<String> avatars = [
    'https://cdn.jsdelivr.net/gh/alohe/avatars/png/3d_1.png',
    'https://cdn.jsdelivr.net/gh/alohe/avatars/png/3d_2.png',
    'https://cdn.jsdelivr.net/gh/alohe/avatars/png/3d_3.png',
    'https://cdn.jsdelivr.net/gh/alohe/avatars/png/3d_4.png',
    'https://cdn.jsdelivr.net/gh/alohe/avatars/png/memo_1.png',
    'https://cdn.jsdelivr.net/gh/alohe/avatars/png/memo_5.png',
    'https://cdn.jsdelivr.net/gh/alohe/avatars/png/toon_1.png',
    'https://cdn.jsdelivr.net/gh/alohe/avatars/png/toon_4.png',
  ];

  @override
  Widget build(BuildContext context) {
    bool isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  isArabic ? 'اختر شخصيتك واسمك' : 'Choose Your Avatar & Name',
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Color(0xFFFACC15)),
                ),
                const SizedBox(height: 20),
                
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(color: Color(0xFF231145), shape: BoxShape.circle),
                  child: CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.transparent,
                    backgroundImage: NetworkImage(avatars[selectedAvatarIndex]),
                  ),
                ),
                const SizedBox(height: 15),

                SizedBox(
                  height: 70,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    itemCount: avatars.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () => setState(() => selectedAvatarIndex = index),
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            color: selectedAvatarIndex == index ? const Color(0xFF8B5CF6) : const Color(0xFF1E0C3B),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: selectedAvatarIndex == index ? Colors.white : Colors.transparent, width: 2),
                          ),
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(avatars[index]),
                            radius: 24,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 25),

                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: isArabic ? 'أدخل اسمك (مثال: يوسف)' : 'Enter your name (e.g. Youssef)',
                    filled: true,
                    fillColor: const Color(0xFF231145),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 25),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8B5CF6),
                    minimumSize: const Size.fromHeight(50),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  onPressed: () {
                    if (nameController.text.isNotEmpty) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BuzzyHomeScreen(
                            username: nameController.text,
                            avatarUrl: avatars[selectedAvatarIndex],
                          ),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('⚠️ برجاء كتابة الاسم أولاً!')),
                      );
                    }
                  },
                  child: Text(isArabic ? 'دخول للعبة 🚀' : 'Enter Game 🚀', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class BuzzyHomeScreen extends StatelessWidget {
  final String username;
  final String avatarUrl;

  const BuzzyHomeScreen({super.key, required this.username, required this.avatarUrl});

  @override
  Widget build(BuildContext context) {
    bool isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(backgroundImage: NetworkImage(avatarUrl), radius: 30),
              const SizedBox(height: 10),
              Text(username, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 40),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8B5CF6),
                  minimumSize: const Size.fromHeight(55),
                ),
                onPressed: () {},
                child: Text(isArabic ? 'ابدأ اللعبة' : 'Start Game'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
