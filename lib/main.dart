import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const BuzzyAmongUsApp());
}

// نظام اللغات البسيط داخل التطبيق (عربي / إنجليزي)
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
      'usernameHint': 'أدخل اسمك هنا...',
      'enterGame': 'دخول للعبة 🚀',
      'createLocal': 'إنشاء لعبة لوكال',
      'joinHotspot': 'ادخل لعبة (Hotspot)',
      'settings': 'الإعدادات',
      'language': 'لغة التطبيق (Language)',
      'roomsCount': 'اختر عدد غرف الشقة:',
      'openRoom': 'فتح روم 🚪',
      'searching': 'جاري البحث عن أجهزة متصلة بالهوتسبوت أو الشبكة...',
      'foundDevices': 'تم العثور على أجهزة متصلة بالروم:',
      'startGameNow': 'بدء الجيم الآن 🚀',
      'youArrived': 'أنت وصلت؟ (ابدأ العد)',
      'taskCompleted': 'تم إنجاز المهمة بنجاح!',
      'sabotageAlert': '🚨 سابوتاج تم تنفيذه في',
      'repairIt': 'صلحت السابوتاج',
      'wheelTitle': '🎡 عجلة الحظ: من هو الإمبوستر؟',
      'spinning': 'جاري سحب الأدوار عشوائياً...',
    },
    'en': {
      'appTitle': 'Buzzy Party: Imposter',
      'chooseProfile': 'Choose Your Avatar & Name',
      'usernameHint': 'Enter your username...',
      'enterGame': 'Enter Game 🚀',
      'createLocal': 'Create Local Game',
      'joinHotspot': 'Join Game (Hotspot)',
      'settings': 'Settings',
      'language': 'Language / اللغة',
      'roomsCount': 'Select Apartment Rooms:',
      'openRoom': 'Open Room 🚪',
      'searching': 'Scanning for nearby hotspot & network devices...',
      'foundDevices': 'Connected players found:',
      'startGameNow': 'Start Match Now 🚀',
      'youArrived': 'Are You There? (Start Timer)',
      'taskCompleted': 'Task Completed Successfully!',
      'sabotageAlert': '🚨 Sabotage triggered in',
      'repairIt': 'Repair Sabotage',
      'wheelTitle': '🎡 Lucky Wheel: Who is the Imposter?',
      'spinning': 'Spinning roles randomly...',
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
  Locale _locale = const Locale('ar'); // الافتراضي عربي

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

// شاشة اختيار الاسم والأفاتارات الاحترافية (مضبوطة الـ Layout تماماً)
class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final TextEditingController nameController = TextEditingController(text: ''); 
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: const Icon(Icons.settings, color: Colors.amber, size: 28),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsScreen()));
                    },
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                isArabic ? 'اختر شخصيتك واسمك' : 'Choose Your Avatar & Name',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Color(0xFFFACC15)),
              ),
              const SizedBox(height: 25),
              
              Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(color: Color(0xFF231145), shape: BoxShape.circle),
                child: CircleAvatar(
                  radius: 45,
                  backgroundColor: Colors.transparent,
                  backgroundImage: NetworkImage(avatars[selectedAvatarIndex]),
                ),
              ),
              const SizedBox(height: 20),

              // شبكة اختيار الأفاتارات بمقاسات محددة وسليمة 100%
              SizedBox(
                height: 75,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemCount: avatars.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () => setState(() => selectedAvatarIndex = index),
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 6),
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: selectedAvatarIndex == index ? const Color(0xFF8B5CF6) : const Color(0xFF1E0C3B),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: selectedAvatarIndex == index ? Colors.white : Colors.transparent, width: 2),
                        ),
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(avatars[index]),
                          radius: 26,
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 30),

              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: isArabic ? 'أدخل اسمك (مثال: يوسف)' : 'Enter your name (e.g. Youssef)',
                  filled: true,
                  fillColor: const Color(0xFF231145),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 30),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8B5CF6),
                  minimumSize: const Size.fromHeight(55),
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
    );
  }
}

// شاشة الإعدادات لتغيير اللغة
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    bool isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return Scaffold(
      appBar: AppBar(
        title: Text(isArabic ? 'الإعدادات' : 'Settings'),
        backgroundColor: const Color(0xFF1E0C3B),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: const Color(0xFF231145), borderRadius: BorderRadius.circular(16)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(isArabic ? 'لغة التطبيق' : 'App Language', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  DropdownButton<Locale>(
                    value: Localizations.localeOf(context),
                    dropdownColor: const Color(0xFF1E0C3B),
                    items: const [
                      DropdownMenuItem(value: Locale('ar'), child: Text('العربية 🇪🇬')),
                      DropdownMenuItem(value: Locale('en'), child: Text('English 🇺🇸')),
                    ],
                    onChanged: (Locale? newLocale) {
                      if (newLocale != null) {
                        BuzzyAmongUsApp.setLocale(context, newLocale);
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
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
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
          child: Column(
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(avatarUrl),
                    radius: 22,
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(username, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      Text(isArabic ? 'مستخدم' : 'User', style: const TextStyle(color: Color(0xFFEF4444), fontSize: 12, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.settings, color: Colors.amber),
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsScreen())),
                  )
                ],
              ),
              const SizedBox(height: 30),

              Column(
                children: [
                  Text(
                    'BUZZY PARTY',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      color: const Color(0xFFFACC15),
                      shadows: [Shadow(offset: const Offset(2, 2), color: Colors.black.withOpacity(0.8), blurRadius: 2)],
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'IMPOSTER ALIVE',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                      color: const Color(0xFFEF4444),
                      shadows: [Shadow(offset: const Offset(2, 2), color: Colors.black.withOpacity(0.8), blurRadius: 2)],
                    ),
                  ),
                ],
              ),
              const Spacer(),

              _buildBuzzyButton(
                title: isArabic ? 'إنشاء لعبة لوكال' : 'Create Local Game',
                color: const Color(0xFF8B5CF6),
                icon: Icons.gavel_rounded,
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => GameSetupScreen(username: username, avatarUrl: avatarUrl)));
                },
              ),
              const SizedBox(height: 15),

              _buildBuzzyButton(
                title: isArabic ? 'ادخل لعبة (Hotspot)' : 'Join Game (Hotspot)',
                color: const Color(0xFFFB923C),
                icon: Icons.touch_app_rounded,
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => GameSetupScreen(username: username, avatarUrl: avatarUrl)));
                },
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBuzzyButton({required String title, required Color color, required IconData icon, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 65,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: color.withOpacity(0.4), blurRadius: 8, offset: const Offset(0, 4))],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.white, size: 28),
                const SizedBox(width: 15),
                Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
              ],
            ),
            const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white),
          ],
        ),
      ),
    );
  }
}

class GameSetupScreen extends StatefulWidget {
  final String username;
  final String avatarUrl;

  const GameSetupScreen({super.key, required this.username, required this.avatarUrl});

  @override
  State<GameSetupScreen> createState() => _GameSetupScreenState();
}

class _GameSetupScreenState extends State<GameSetupScreen> {
  int roomsCount = 4;

  @override
  Widget build(BuildContext context) {
    bool isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return Scaffold(
      appBar: AppBar(
        title: Text(isArabic ? 'إعدادات الشقة' : 'Room Setup'),
        backgroundColor: const Color(0xFF1E0C3B),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: const Color(0xFF231145), borderRadius: BorderRadius.circular(16)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(isArabic ? '🏠 اختر عدد غرف الشقة:' : 'Select Rooms Count:', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [2, 3, 4, 5].map((num) {
                      bool isSelected = roomsCount == num;
                      return ChoiceChip(
                        label: Text(isArabic ? '$num غرف' : '$num Rooms'),
                        selected: isSelected,
                        selectedColor: const Color(0xFFFB923C),
                        onSelected: (val) => setState(() => roomsCount = num),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            const Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8B5CF6),
                minimumSize: const Size.fromHeight(55),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LocalRoomSearchScreen(
                      username: widget.username,
                      avatarUrl: widget.avatarUrl,
                      roomCount: roomsCount,
                    ),
                  ),
                );
              },
              child: Text(isArabic ? 'فتح روم 🚪' : 'Open Room 🚪', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            )
          ],
        ),
      ),
    );
  }
}

// شاشة البحث عن الأجهزة
class LocalRoomSearchScreen extends StatefulWidget {
  final String username;
  final String avatarUrl;
  final int roomCount;

  const LocalRoomSearchScreen({super.key, required this.username, required this.avatarUrl, required this.roomCount});

  @override
  State<LocalRoomSearchScreen> createState() => _LocalRoomSearchScreenState();
}

class _LocalRoomSearchScreenState extends State<LocalRoomSearchScreen> {
  List<Map<String, String>> connectedPlayers = [];
  bool isScanning = true;

  @override
  void initState() {
    super.initState();
    connectedPlayers.add({'name': widget.username, 'avatar': widget.avatarUrl});

    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          isScanning = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return Scaffold(
      appBar: AppBar(
        title: Text(isArabic ? 'البحث عن لاعبين بالشبكة' : 'Scanning Network'),
        backgroundColor: const Color(0xFF1E0C3B),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            if (isScanning) ...[
              const CircularProgressIndicator(color: Color(0xFFFACC15)),
              const SizedBox(height: 15),
              Text(isArabic ? 'جاري البحث عن أجهزة متصلة بالهوتسبوت...' : 'Scanning for hotspot devices...', style: const TextStyle(color: Colors.grey)),
            ] else ...[
              Text(isArabic ? '✅ تم العثور على أجهزة متصلة بالروم:' : '✅ Connected players found:', style: const TextStyle(color: Color(0xFF4ADE80), fontWeight: FontWeight.bold)),
            ],
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: connectedPlayers.length,
                itemBuilder: (context, index) {
                  return Card(
                    color: const Color(0xFF231145),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(connectedPlayers[index]['avatar']!),
                      ),
                      title: Text(connectedPlayers[index]['name']!, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      subtitle: const Text('متصل بالشبكة المحلية', style: TextStyle(fontSize: 11, color: Colors.grey)),
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4ADE80),
                minimumSize: const Size.fromHeight(55),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              onPressed: () {
                List<String> rawNames = connectedPlayers.map((p) => p['name']!).toList();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RoleWheelScreen(
                      playerNames: rawNames,
                      roomCount: widget.roomCount,
                    ),
                  ),
                );
              },
              child: Text(isArabic ? 'بدء الجيم الآن 🚀' : 'Start Match Now 🚀', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
            )
          ],
        ),
      ),
    );
  }
}

// شاشة عجلة الحظ لاختيار الأدوار
class RoleWheelScreen extends StatefulWidget {
  final List<String> playerNames;
  final int roomCount;

  const RoleWheelScreen({super.key, required this.playerNames, required this.roomCount});

  @override
  State<RoleWheelScreen> createState() => _RoleWheelScreenState();
}

class _RoleWheelScreenState extends State<RoleWheelScreen> {
  bool isSpinning = true;
  String assignedRoleText = 'جارٍ سحب الأدوار عشوائياً...';
  List<int> imposterIndices = [];

  @override
  void initState() {
    super.initState();
    startSpinningWheel();
  }

  void startSpinningWheel() {
    final random = Random();
    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          isSpinning = false;
          int impIndex = random.nextInt(widget.playerNames.length);
          imposterIndices = [impIndex];
          assignedRoleText = 'تم تحديد الأدوار بنجاح!';
        });

        Timer(const Duration(seconds: 2), () {
          if (mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => MainGameRoomScreen(
                  playerNames: widget.playerNames,
                  roomCount: widget.roomCount,
                  imposterIndices: imposterIndices,
                ),
              ),
            );
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF130924),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('🎡 عجلة الحظ للأدوار', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xFFFACC15))),
            const SizedBox(height: 40),
            if (isSpinning) ...[
              const CircularProgressIndicator(color: Color(0xFF8B5CF6), strokeWidth: 6),
              const SizedBox(height: 25),
              Text(assignedRoleText, style: const TextStyle(fontSize: 18, color: Colors.grey)),
            ] else ...[
              const Icon(Icons.check_circle_rounded, color: Color(0xFF4ADE80), size: 80),
              const SizedBox(height: 15),
              const Text('تم الكشف عن هويتك السرية!', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
            ]
          ],
        ),
      ),
    );
  }
}

class MainGameRoomScreen extends StatefulWidget {
  final List<String> playerNames;
  final int roomCount;
  final List<int> imposterIndices;

  const MainGameRoomScreen({
    super.key,
    required this.playerNames,
    required this.roomCount,
    required this.imposterIndices,
  });

  @override
  State<MainGameRoomScreen> createState() => _MainGameRoomScreenState();
}

class _MainGameRoomScreenState extends State<MainGameRoomScreen> {
  int currentPlayerIndex = 0;
  List<String> assignedTasks = [];
  String currentInstruction = 'جاري التحضير...';
  Timer? promptTimer;

  bool isSabotageActive = false;
  String sabotageRoom = '';
  int sabotageTimerSeconds = 10;
  Timer? sabotageTimer;

  bool isTaskActive = false;
  int taskCountdownSeconds = 0;
  Timer? taskTimer;

  @override
  void initState() {
    super.initState();
    generateTasks();
    start3SecPromptLoop();
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showAudioSoundEffect('🔊 [تنبيه صوتي]: تم بدء الجيم وتشغيل المؤثرات بسلام!');
    });
  }

  void generateTasks() {
    final random = Random();
    List<String> taskTypes = ['صلح السلك الكهربائي', 'امسح بصمات الأصابع', 'نزل الملفات السرية', 'شغل مولد الطاقة'];
    assignedTasks.clear();

    for (int i = 0; i < 4; i++) {
      int roomNum = random.nextInt(widget.roomCount) + 1;
      String roomName = 'غرفة $roomNum';
      String task = taskTypes[random.nextInt(taskTypes.length)];
      assignedTasks.add('ادخل $roomName ونفذ: $task');
    }
  }

  void start3SecPromptLoop() {
    final random = Random();
    promptTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (assignedTasks.isNotEmpty && !isSabotageActive && !isTaskActive) {
        setState(() {
          int randomIndex = random.nextInt(assignedTasks.length);
          currentInstruction = '📢 ${assignedTasks[randomIndex]}';
        });
      }
    });
  }

  void showAudioSoundEffect(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: const Color(0xFF8B5CF6),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void startTaskCountdown() {
    final random = Random();
    int randomSeconds = random.nextInt(8) + 3;

    setState(() {
      isTaskActive = true;
      taskCountdownSeconds = randomSeconds;
    });

    showAudioSoundEffect('⏱️ بدء عد تنازلي للمهمة: $randomSeconds ثواني!');

    taskTimer?.cancel();
    taskTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (taskCountdownSeconds > 1) {
        setState(() => taskCountdownSeconds--);
      } else {
        timer.cancel();
        setState(() {
          isTaskActive = false;
          if (assignedTasks.isNotEmpty) {
            assignedTasks.removeAt(0);
          }
        });
        showAudioSoundEffect('✅ تم إنجاز المهمة بنجاح يا بطل!');
      }
    });
  }

  void startSabotage(String room) {
    setState(() {
      isSabotageActive = true;
      sabotageRoom = room;
      sabotageTimerSeconds = 10;
    });

    showAudioSoundEffect('🚨 تنبيه سابوتاج خطير في $room!');

    sabotageTimer?.cancel();
    sabotageTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (sabotageTimerSeconds > 1) {
        setState(() => sabotageTimerSeconds--);
      } else {
        timer.cancel();
        setState(() => isSabotageActive = false);
        showAudioSoundEffect('❌ انتهى الوقت ولم يتم إصلاح السابوتاج!');
      }
    });
  }

  @override
  void dispose() {
    promptTimer?.cancel();
    sabotageTimer?.cancel();
    taskTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isImposter = widget.imposterIndices.contains(currentPlayerIndex);
    String playerName = widget.playerNames[currentPlayerIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text('$playerName (${isImposter ? 'Imposter 😈' : 'Crewmate 👨‍🚀'})'),
        backgroundColor: isImposter ? Colors.red.shade900 : const Color(0xFF1E0C3B),
        actions: [
          DropdownButton<int>(
            value: currentPlayerIndex,
            dropdownColor: const Color(0xFF231145),
            items: List.generate(
              widget.playerNames.length,
              (i) => DropdownMenuItem(value: i, child: Text(widget.playerNames[i])),
            ),
            onChanged: (val) {
              setState(() {
                currentPlayerIndex = val!;
                generateTasks();
              });
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (isSabotageActive) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: Colors.red.shade900, borderRadius: BorderRadius.circular(12)),
                child: Column(
                  children: [
                    Text('🚨 سابوتاج في $sabotageRoom!', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    Text('باقي $sabotageTimerSeconds ثواني!', style: const TextStyle(fontSize: 22, color: Colors.yellowAccent, fontWeight: FontWeight.w900)),
                    const SizedBox(height: 5),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.black),
                      onPressed: () {
                        sabotageTimer?.cancel();
                        setState(() => isSabotageActive = false);
                        showAudioSoundEffect('🛡️ تم إبطال السابوتاج بنجاح!');
                      },
                      child: const Text('صلحت السابوتاج'),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 10),
            ],

            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: const Color(0xFF231145), borderRadius: BorderRadius.circular(12)),
              child: Text(currentInstruction, style: const TextStyle(color: Color(0xFF38BDF8), fontWeight: FontWeight.bold, fontSize: 16), textAlign: TextAlign.center),
            ),
            const SizedBox(height: 15),

            if (!isImposter) ...[
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: isTaskActive ? Colors.grey : const Color(0xFFFB923C),
                  minimumSize: const Size.fromHeight(50),
                ),
                icon: const Icon(Icons.location_pin),
                label: Text(
                  isTaskActive ? 'جاري إنجاز المهمة... ($taskCountdownSeconds ثواني)' : 'أنت وصلت للأوضة؟ (ابدأ العد)',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                onPressed: isTaskActive ? null : () => startTaskCountdown(),
              ),
              const SizedBox(height: 15),
              Expanded(
                child: ListView.builder(
                  itemCount: assignedTasks.length,
                  itemBuilder: (context, idx) => Card(
                    color: const Color(0xFF231145),
                    child: ListTile(
                      title: Text(assignedTasks[idx]),
                      trailing: const Icon(Icons.bolt, color: Colors.amber),
                    ),
                  ),
                ),
              ),
            ],

            if (isImposter)
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('😈 اختر الغرفة لتنفيذ السابوتاج:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 15),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: List.generate(widget.roomCount, (index) {
                        String rName = 'غرفة ${index + 1}';
                        return ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF8B5CF6), padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12)),
                          onPressed: () => startSabotage(rName),
                          child: Text('سابوتاج $rName', style: const TextStyle(fontSize: 16)),
                        );
                      }),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 10),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange.shade800, minimumSize: const Size.fromHeight(48)),
              icon: const Icon(Icons.campaign),
              label: const Text('الإبلاغ عن جثة / Report'),
              onPressed: () => showAudioSoundEffect('📢 [إبلاغ طارئ]: تم اكتشاف جثة في الممر! الاجتماع يبدأ الآن.'),
            )
          ],
        ),
      ),
    );
  }
}
