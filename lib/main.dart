import 'package:flutter/material.dart';

void main() {
  runApp(const BuzzyApp());
}

class BuzzyApp extends StatefulWidget {
  const BuzzyApp({super.key});

  @override
  State<BuzzyApp> createState() => _BuzzyAppState();
}

class _BuzzyAppState extends State<BuzzyApp> {
  bool isEnglish = false;

  void toggleLanguage() {
    setState(() {
      isEnglish = !isEnglish;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF130924),
      ),
      home: ProfileScreen(onToggleLanguage: toggleLanguage, isEnglish: isEnglish),
    );
  }
}

// 1. شاشة اختيار الأفاتار والاسم
class ProfileScreen extends StatefulWidget {
  final Function() onToggleLanguage;
  final bool isEnglish;

  const ProfileScreen({super.key, required this.onToggleLanguage, required this.isEnglish});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController nameController = TextEditingController();
  int selectedIndex = 0;

  // 10 أڤاتارات حقيقية وشغالة 100%
  final List<String> avatars = [
    'https://api.dicebear.com/7.x/bottts/png?seed=buzzy1',
    'https://api.dicebear.com/7.x/bottts/png?seed=buzzy2',
    'https://api.dicebear.com/7.x/bottts/png?seed=buzzy3',
    'https://api.dicebear.com/7.x/bottts/png?seed=buzzy4',
    'https://api.dicebear.com/7.x/bottts/png?seed=buzzy5',
    'https://api.dicebear.com/7.x/bottts/png?seed=buzzy6',
    'https://api.dicebear.com/7.x/bottts/png?seed=buzzy7',
    'https://api.dicebear.com/7.x/bottts/png?seed=buzzy8',
    'https://api.dicebear.com/7.x/bottts/png?seed=buzzy9',
    'https://api.dicebear.com/7.x/bottts/png?seed=buzzy10',
  ];

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Color(0xFFFACC15)),
            onPressed: () {
              // زر الإعدادات لتغيير اللغة
              widget.onToggleLanguage();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(widget.isEnglish ? "Language switched to Arabic" : "تم تغيير اللغة إلى الإنجليزية"),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.isEnglish ? 'Choose your Avatar & Name' : 'اختر شخصيتك واسمك',
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFFFACC15)),
                  ),
                  const SizedBox(height: 20),
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: const Color(0xFF231145),
                    backgroundImage: NetworkImage(avatars[selectedIndex]),
                  ),
                  const SizedBox(height: 15),
                  SizedBox(
                    height: 60,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: avatars.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () => setState(() => selectedIndex = index),
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 5),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: selectedIndex == index ? Colors.yellowAccent : Colors.transparent,
                                width: 3,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(avatars[index]),
                              radius: 22,
                              backgroundColor: Colors.white12,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: widget.isEnglish ? 'Enter your name' : 'أدخل اسمك',
                      filled: true,
                      fillColor: const Color(0xFF231145),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF8B5CF6),
                      minimumSize: const Size.fromHeight(50),
                    ),
                    onPressed: () {
                      String name = nameController.text.trim();
                      if (name.isEmpty) {
                        name = widget.isEnglish ? 'Unknown Player' : 'لاعب مجهول';
                      }

                      // الانتقال لقائمة الخيارين (إنشاء / لعب لوكال)
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MainMenuScreen(
                            playerName: name,
                            avatarUrl: avatars[selectedIndex],
                            isEnglish: widget.isEnglish,
                          ),
                        ),
                      );
                    },
                    child: Text(
                      widget.isEnglish ? 'Enter Game 🚀' : 'دخول للعبة 🚀',
                      style: const TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// 2. القائمة الرئيسية (إنشاء لعبة أو لعب لوكال)
class MainMenuScreen extends StatelessWidget {
  final String playerName;
  final String avatarUrl;
  final bool isEnglish;

  const MainMenuScreen({super.key, required this.playerName, required this.avatarUrl, required this.isEnglish});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEnglish ? 'Buzzy Party: Main Menu' : 'القائمة الرئيسية'),
        backgroundColor: const Color(0xFF231145),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(radius: 40, backgroundImage: NetworkImage(avatarUrl)),
            const SizedBox(height: 10),
            Text(playerName, style: const TextStyle(fontSize: 18, color: Color(0xFFFACC15))),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade700,
                minimumSize: const Size.fromHeight(60),
              ),
              onPressed: () {
                // الانتقال لصفحة إعدادات الأوض وتفاصيل الشقة
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RoomSetupScreen(
                      playerName: playerName,
                      avatarUrl: avatarUrl,
                      isHost: true,
                      isEnglish: isEnglish,
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.add_circle, color: Colors.white),
              label: Text(
                isEnglish ? 'Create Game (Host)' : 'إنشاء لعبة (Host)',
                style: const TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade700,
                minimumSize: const Size.fromHeight(60),
              ),
              onPressed: () {
                // شاشة الانضمام المحلي (البحث عن هوت سبوت الأصدقاء بدون نت)
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LocalLobbyScreen(
                      playerName: playerName,
                      avatarUrl: avatarUrl,
                      isEnglish: isEnglish,
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.wifi_tethering, color: Colors.white),
              label: Text(
                isEnglish ? 'Local Play (Hotspot)' : 'لعب لوكال (بدون نت / هوت سبوت)',
                style: const TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 3. شاشة إعدادات الأوض وتفاصيل الشقة وعدد اللاعبين (من 4 لـ 20)
class RoomSetupScreen extends StatefulWidget {
  final String playerName;
  final String avatarUrl;
  final bool isHost;
  final bool isEnglish;

  const RoomSetupScreen({
    super.key,
    required this.playerName,
    required this.avatarUrl,
    required this.isHost,
    required this.isEnglish,
  });

  @override
  State<RoomSetupScreen> createState() => _RoomSetupScreenState();
}

class _RoomSetupScreenState extends State<RoomSetupScreen> {
  int roomsCount = 3; // عدد الأوض
  bool hasReception = true; // ريسبشن
  bool hasKitchen = true; // مطبخ
  bool hasBathroom = true; // حمام
  double maxPlayers = 8; // أقصى عدد اللاعبين (من 4 لـ 20)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEnglish ? 'Room Setup' : 'إعدادات الشقة والأوض'),
        backgroundColor: const Color(0xFF231145),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.isEnglish ? 'Select Number of Rooms: $roomsCount' : 'عدد أوض الشقة: $roomsCount',
              style: const TextStyle(fontSize: 16, color: Color(0xFFFACC15)),
            ),
            Slider(
              value: roomsCount.toDouble(),
              min: 1,
              max: 6,
              divisions: 5,
              activeColor: const Color(0xFF8B5CF6),
              onChanged: (val) => setState(() => roomsCount = val.toInt()),
            ),
            const Divider(color: Colors.white24),
            SwitchListTile(
              title: Text(widget.isEnglish ? 'Contains Reception?' : 'هل يوجد ريسبشن؟'),
              value: hasReception,
              activeColor: const Color(0xFF8B5CF6),
              onChanged: (val) => setState(() => hasReception = val),
            ),
            SwitchListTile(
              title: Text(widget.isEnglish ? 'Contains Kitchen?' : 'هل يوجد مطبخ؟'),
              value: hasKitchen,
              activeColor: const Color(0xFF8B5CF6),
              onChanged: (val) => setState(() => hasKitchen = val),
            ),
            SwitchListTile(
              title: Text(widget.isEnglish ? 'Contains Bathroom?' : 'هل يوجد حمام؟'),
              value: hasBathroom,
              activeColor: const Color(0xFF8B5CF6),
              onChanged: (val) => setState(() => hasBathroom = val),
            ),
            const Divider(color: Colors.white24),
            Text(
              widget.isEnglish
                  ? 'Players Count (Min 4, Max 20): ${maxPlayers.toInt()}'
                  : 'عدد اللاعبين (من 4 إلى 20): ${maxPlayers.toInt()}',
              style: const TextStyle(fontSize: 16, color: Color(0xFFFACC15)),
            ),
            Slider(
              value: maxPlayers,
              min: 4,
              max: 20,
              divisions: 16,
              activeColor: const Color(0xFF8B5CF6),
              onChanged: (val) => setState(() => maxPlayers = val),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8B5CF6),
                minimumSize: const Size.fromHeight(55),
              ),
              onPressed: () {
                // فتح لوبي الانتظار المحلي بالهوت سبوت
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WaitingLobbyScreen(
                      playerName: widget.playerName,
                      avatarUrl: widget.avatarUrl,
                      maxPlayers: maxPlayers.toInt(),
                      roomsCount: roomsCount,
                      hasReception: hasReception,
                      hasKitchen: hasKitchen,
                      hasBathroom: hasBathroom,
                      isEnglish: widget.isEnglish,
                    ),
                  ),
                );
              },
              child: Text(
                widget.isEnglish ? 'Start Local Room 🚀' : 'فتح الأوضة للعب المحلي 🚀',
                style: const TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 4. شاشة اللعب اللوكال والبحث عن الأصدقاء ع الشبكة بدون نت
class LocalLobbyScreen extends StatelessWidget {
  final String playerName;
  final String avatarUrl;
  final bool isEnglish;

  const LocalLobbyScreen({super.key, required this.playerName, required this.avatarUrl, required this.isEnglish});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEnglish ? 'Local Hotspot Rooms' : 'الأوض المتاحة على شبكتك المحلية'),
        backgroundColor: const Color(0xFF231145),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text(
              isEnglish
                  ? 'Scanning nearby devices (Hotspot / Local Network)...'
                  : 'جاري البحث عن أصدقاء على نفس الهوت سبوت أو الشبكة المحلية...',
              style: const TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 20),
            const LinearProgressIndicator(color: Color(0xFF8B5CF6)),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  Card(
                    color: const Color(0xFF231145),
                    child: ListTile(
                      leading: const CircleAvatar(backgroundImage: NetworkImage('https://api.dicebear.com/7.x/bottts/png?seed=host')),
                      title: const Text('أوضة يوسف (Buzzy House)', style: TextStyle(color: Colors.white)),
                      subtitle: const Text('الريسبشن: موجود | الأوض: 3 | اللاعبين: 1/20', style: TextStyle(color: Colors.white60)),
                      trailing: ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                        onPressed: () {
                          // الدخول للأوضة
                        },
                        child: Text(isEnglish ? 'Join' : 'انضمام'),
                      ),
                    ),
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

// 5. لوبي الانتظار الداخلي قبل بدء الجيم الفعلي
class WaitingLobbyScreen extends StatelessWidget {
  final String playerName;
  final String avatarUrl;
  final int maxPlayers;
  final int roomsCount;
  final bool hasReception;
  final bool hasKitchen;
  final bool hasBathroom;
  final bool isEnglish;

  const WaitingLobbyScreen({
    super.key,
    required this.playerName,
    required this.avatarUrl,
    required this.maxPlayers,
    required this.roomsCount,
    required this.hasReception,
    required this.hasKitchen,
    required this.hasBathroom,
    required this.isEnglish,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEnglish ? 'Waiting Lobby' : 'لوبي الانتظار (محلي)'),
        backgroundColor: const Color(0xFF231145),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text(
              isEnglish ? 'Room Info / الخريطة جاهزة:' : 'تفاصيل الشقة والخريطة:',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFFFACC15)),
            ),
            const SizedBox(height: 10),
            Text(isEnglish ? 'Rooms: $roomsCount | Max Players: $maxPlayers' : 'عدد الأوض: $roomsCount | الحد الأقصى: $maxPlayers لاعب'),
            Text(isEnglish
                ? 'Reception: ${hasReception ? "Yes" : "No"} | Kitchen: ${hasKitchen ? "Yes" : "No"} | Bathroom: ${hasBathroom ? "Yes" : "No"}'
                : 'الريسبشن: ${hasReception ? "نعم" : "لا"} | المطبخ: ${hasKitchen ? "نعم" : "لا"} | الحمام: ${hasBathroom ? "نعم" : "لا"}'),
            const Divider(color: Colors.white24, height: 30),
            Expanded(
              child: ListView(
                children: [
                  ListTile(
                    leading: CircleAvatar(backgroundImage: NetworkImage(avatarUrl)),
                    title: Text(playerName, style: const TextStyle(color: Colors.white)),
                    subtitle: Text(isEnglish ? 'Host (You)' : 'المضيف (أنت)', style: const TextStyle(color: Colors.greenAccent)),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade700,
                minimumSize: const Size.fromHeight(50),
              ),
              onPressed: () {
                // بدء اللعبة الفعلي داخل الشقة
              },
              child: Text(
                isEnglish ? 'Start Game Now 🎮' : 'بدء الجيم الآن 🎮',
                style: const TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
