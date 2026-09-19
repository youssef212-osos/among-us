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

// 1. شاشة اختيار الأفاتار والاسم واللغة
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

// 2. القائمة الرئيسية (إنشاء غرفة / لعب لوكال)
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
            // الاختيار الأول: إنشاء غرفة
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade700,
                minimumSize: const Size.fromHeight(60),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RoomSetupScreen(
                      playerName: playerName,
                      avatarUrl: avatarUrl,
                      isEnglish: isEnglish,
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.add_circle, color: Colors.white),
              label: Text(
                isEnglish ? 'Create Room (Host)' : 'إنشاء غرفة',
                style: const TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            // الاختيار الثاني: لعب لوكال مالتيبلاير (بدون نت / هوت سبوت)
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade700,
                minimumSize: const Size.fromHeight(60),
              ),
              onPressed: () {
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
                isEnglish ? 'Local Multiplayer (Hotspot)' : 'لعب لوكال مالتيبلاير',
                style: const TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 3. شاشة إعدادات الأوض والشقة بالمنطق الهندسي الدقيق
class RoomSetupScreen extends StatefulWidget {
  final String playerName;
  final String avatarUrl;
  final bool isEnglish;

  const RoomSetupScreen({
    super.key,
    required this.playerName,
    required this.avatarUrl,
    required this.isEnglish,
  });

  @override
  State<RoomSetupScreen> createState() => _RoomSetupScreenState();
}

class _RoomSetupScreenState extends State<RoomSetupScreen> {
  bool hasReception = true;
  bool hasKitchen = true;
  bool hasBathroom = true;
  int roomsCount = 2; // عدد الأوض (تبدأ من 2 كحد أدنى لو فيه ريسبشن)
  int maxPlayers = 8; // عدد اللاعبين (من 4 إلى 20)

  // حساب الحد الأدنى للأوض بناءً على وجود الريسبشن والمطبخ والحمام
  int get minRooms {
    if (!hasReception && !hasKitchen && !hasBathroom) return 5;
    if (!hasReception && !hasKitchen) return 4;
    if (!hasReception) return 3;
    return 2; // الافتراضي (مع وجود ريسبشن)
  }

  @override
  void initState() {
    super.initState();
    _validateRooms();
  }

  void _validateRooms() {
    if (roomsCount < minRooms) {
      roomsCount = minRooms;
    }
    if (roomsCount > 10) {
      roomsCount = 10;
    }
  }

  @override
  Widget build(BuildContext context) {
    _validateRooms();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEnglish ? 'Room & Apartment Setup' : 'إعدادات الغرفة والشقة'),
        backgroundColor: const Color(0xFF231145),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SwitchListTile(
              title: Text(widget.isEnglish ? 'Contains Reception?' : 'هل يوجد ريسبشن؟'),
              value: hasReception,
              activeColor: const Color(0xFF8B5CF6),
              onChanged: (val) {
                setState(() {
                  hasReception = val;
                  _validateRooms();
                });
              },
            ),
            SwitchListTile(
              title: Text(widget.isEnglish ? 'Contains Kitchen?' : 'هل يوجد مطبخ؟'),
              value: hasKitchen,
              activeColor: const Color(0xFF8B5CF6),
              onChanged: (val) {
                setState(() {
                  hasKitchen = val;
                  _validateRooms();
                });
              },
            ),
            SwitchListTile(
              title: Text(widget.isEnglish ? 'Contains Bathroom?' : 'هل يوجد حمام؟'),
              value: hasBathroom,
              activeColor: const Color(0xFF8B5CF6),
              onChanged: (val) {
                setState(() {
                  hasBathroom = val;
                  _validateRooms();
                });
              },
            ),
            const Divider(color: Colors.white24, height: 30),
            Text(
              widget.isEnglish
                  ? 'Number of Rooms (Min: $minRooms, Max: 10): $roomsCount'
                  : 'عدد الأوض (الحد الأدنى: $minRooms، الحد الأقصى: 10): $roomsCount',
              style: const TextStyle(fontSize: 16, color: Color(0xFFFACC15)),
            ),
            Slider(
              value: roomsCount.toDouble(),
              min: minRooms.toDouble(),
              max: 10,
              divisions: (10 - minRooms > 0) ? (10 - minRooms) : 1,
              activeColor: const Color(0xFF8B5CF6),
              onChanged: (val) => setState(() => roomsCount = val.toInt()),
            ),
            const Divider(color: Colors.white24, height: 30),
            Text(
              widget.isEnglish
                  ? 'Players Count (Min 4, Max 20): $maxPlayers'
                  : 'عدد اللاعبين (من 4 إلى 20): $maxPlayers',
              style: const TextStyle(fontSize: 16, color: Color(0xFFFACC15)),
            ),
            Slider(
              value: maxPlayers.toDouble(),
              min: 4,
              max: 20,
              divisions: 16,
              activeColor: const Color(0xFF8B5CF6),
              onChanged: (val) => setState(() => maxPlayers = val.toInt()),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8B5CF6),
                minimumSize: const Size.fromHeight(55),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WaitingLobbyScreen(
                      playerName: widget.playerName,
                      avatarUrl: widget.avatarUrl,
                      maxPlayers: maxPlayers,
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
                widget.isEnglish ? 'Start Room 🚀' : 'فتح الغرفة الآن 🚀',
                style: const TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 4. شاشة اللعب اللوكال (مفتوحة للبحث عبر الهوت سبوت المحلي بدون نت)
class LocalLobbyScreen extends StatelessWidget {
  final String playerName;
  final String avatarUrl;
  final bool isEnglish;

  const LocalLobbyScreen({super.key, required this.playerName, required this.avatarUrl, required this.isEnglish});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEnglish ? 'Local Multiplayer' : 'لعب لوكال مالتيبلاير'),
        backgroundColor: const Color(0xFF231145),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text(
              isEnglish
                  ? 'Scanning nearby hotspot/local network rooms...'
                  : 'جاري البحث عن غرف الأصدقاء على شبكة الهوت سبوت المحلية...',
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
                      title: const Text('غرفة يوسف المحلية', style: TextStyle(color: Colors.white)),
                      subtitle: const Text('ريسبشن: نعم | أوض: 3 | اللاعبين: 1/20', style: TextStyle(color: Colors.white60)),
                      trailing: ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                        onPressed: () {},
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

// 5. لوبي الانتظار الخاص بالغرفة
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
        title: Text(isEnglish ? 'Waiting Room' : 'لوبي الغرفة'),
        backgroundColor: const Color(0xFF231145),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text(
              isEnglish ? 'Apartment Details / تفاصيل الشقة:' : 'تفاصيل الشقة:',
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
              onPressed: () {},
              child: Text(
                isEnglish ? 'Start Game 🎮' : 'بدء الجيم 🎮',
                style: const TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
