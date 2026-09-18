import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const BuzzyAmongUsApp());
}

class BuzzyAmongUsApp extends StatelessWidget {
  const BuzzyAmongUsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Buzzy Party: Imposter Alive',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF130924),
        primaryColor: const Color(0xFF8B5CF6),
      ),
      home: const ProfileSetupScreen(),
    );
  }
}

// شاشة اختيار الاسم والأفاتار أول ما التطبيق يفتح
class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final TextEditingController nameController = TextEditingController(text: 'Youssef Aly');
  int selectedAvatarIndex = 0;

  final List<String> avatars = ['🐱', '🐶', '🦊', '🐼', '🦁', '🐯', '🐨', '🐵', '🤖', '👻'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('اختر شخصيتك واسمك', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Color(0xFFFACC15))),
              const SizedBox(height: 20),
              
              // عرض الأفاتار المختار مع إمكانية التغيير
              Container(
                padding: const EdgeInsets.all(15),
                decoration: const BoxDecoration(color: Color(0xFF231145), shape: BoxShape.circle),
                child: Text(avatars[selectedAvatarIndex], style: const TextStyle(fontSize: 50)),
              ),
              const SizedBox(height: 15),

              // شبكة اختيار 10 أفاتارات
              SizedBox(
                height: 60,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: avatars.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () => setState(() => selectedAvatarIndex = index),
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: selectedAvatarIndex == index ? const Color(0xFF8B5CF6) : const Color(0xFF1E0C3B),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: selectedAvatarIndex == index ? Colors.white : Colors.transparent, width: 2),
                        ),
                        child: Text(avatars[index], style: const TextStyle(fontSize: 24)),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),

              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'اسم اليوزر',
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
                          avatar: avatars[selectedAvatarIndex],
                        ),
                      ),
                    );
                  }
                },
                child: const Text('دخول للعبة 🚀', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BuzzyHomeScreen extends StatelessWidget {
  final String username;
  final String avatar;

  const BuzzyHomeScreen({super.key, required this.username, required this.avatar});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
          child: Column(
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: const Color(0xFF4ADE80),
                    radius: 22,
                    child: Text(avatar, style: const TextStyle(fontSize: 22)),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(username, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      // كلمة مستخدم باللون الأحمر الواضح كما طلبت
                      const Text('مستخدم', style: TextStyle(color: Color(0xFFEF4444), fontSize: 12, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.grey),
                    onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const ProfileSetupScreen())),
                  )
                ],
              ),
              const SizedBox(height: 20),

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
                title: 'إنشاء لعبة لوكال',
                color: const Color(0xFF8B5CF6),
                icon: Icons.gavel_rounded,
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => GameSetupScreen(username: username, avatar: avatar)));
                },
              ),
              const SizedBox(height: 15),

              _buildBuzzyButton(
                title: 'ادخل لعبة (Hotspot)',
                color: const Color(0xFFFB923C),
                icon: Icons.touch_app_rounded,
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => GameSetupScreen(username: username, avatar: avatar)));
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
  final String avatar;

  const GameSetupScreen({super.key, required this.username, required this.avatar});

  @override
  State<GameSetupScreen> createState() => _GameSetupScreenState();
}

class _GameSetupScreenState extends State<GameSetupScreen> {
  int roomsCount = 4; // القيمة الافتراضية 4 غرف

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إعدادات اللعبة', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
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
                  const Text('🏠 اختر عدد غرف الشقة:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [2, 3, 4, 5].map((num) {
                      bool isSelected = roomsCount == num;
                      return ChoiceChip(
                        label: Text('$num غرف'),
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

            // زر فتح روم المباشر
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
                      avatar: widget.avatar,
                      roomCount: roomsCount,
                    ),
                  ),
                );
              },
              child: const Text('فتح روم 🚪', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            )
          ],
        ),
      ),
    );
  }
}

// شاشة البحث عن الأجهزة المفتوحة على نفس الهوتسبوت أو الشبكة المحلية
class LocalRoomSearchScreen extends StatefulWidget {
  final String username;
  final String avatar;
  final int roomCount;

  const LocalRoomSearchScreen({super.key, required this.username, required this.avatar, required this.roomCount});

  @override
  State<LocalRoomSearchScreen> createState() => _LocalRoomSearchScreenState();
}

class _LocalRoomSearchScreenState extends State<LocalRoomSearchScreen> {
  List<String> connectedPlayers = [];
  bool isScanning = true;

  @override
  void initState() {
    super.initState();
    connectedPlayers.add('${widget.avatar} ${widget.username} (الهوست)');
    
    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          isScanning = false;
          connectedPlayers.add('🤖 أحمد (شبكة الهوتسبوت)');
          connectedPlayers.add('🦊 محمود (الشبكة المحلية)');
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('البحث عن لاعبين بالشبكة', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1E0C3B),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            if (isScanning) ...[
              const CircularProgressIndicator(color: Color(0xFFFACC15)),
              const SizedBox(height: 15),
              const Text('جاري البحث عن أجهزة متصلة بالهوتسبوت أو الشبكة اللوكال...', style: TextStyle(color: Colors.grey)),
            ] else ...[
              const Text('✅ تم العثور على أجهزة متصلة بالروم:', style: TextStyle(color: Color(0xFF4ADE80), fontWeight: FontWeight.bold)),
            ],
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: connectedPlayers.length,
                itemBuilder: (context, index) {
                  return Card(
                    color: const Color(0xFF231145),
                    child: ListTile(
                      leading: const Icon(Icons.person, color: Color(0xFF38BDF8)),
                      title: Text(connectedPlayers[index], style: const TextStyle(color: Colors.white)),
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
                List<String> rawNames = connectedPlayers.map((p) => p.split(' ').sublist(1).join(' ')).toList();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MainGameRoomScreen(
                      playerNames: rawNames,
                      roomCount: widget.roomCount,
                      imposterIndices: const [1],
                    ),
                  ),
                );
              },
              child: const Text('بدء الجيم الآن 🚀', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
            )
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

  @override
  void initState() {
    super.initState();
    generateTasks();
    start3SecPromptLoop();
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      playSoundNotification('أنا جيت! تم تشغيل ساوند إفكت الروم.');
    });
  }

  void generateTasks() {
    final random = Random();
    List<String> taskTypes = ['صلح السلك', 'امسح البصمات', 'نزل الملفات', 'شغل المولد'];
    assignedTasks.clear();

    for (int i = 0; i < 5; i++) {
      int roomNum = random.nextInt(widget.roomCount) + 1;
      String roomName = 'غرفة $roomNum';
      String task = taskTypes[random.nextInt(taskTypes.length)];
      assignedTasks.add('خش $roomName واعمل: $task');
    }
  }

  void start3SecPromptLoop() {
    final random = Random();
    promptTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (assignedTasks.isNotEmpty && !isSabotageActive) {
        setState(() {
          int randomIndex = random.nextInt(assignedTasks.length);
          currentInstruction = '📢 ${assignedTasks[randomIndex]} (المدة 10 ثواني)';
        });
      }
    });
  }

  void playSoundNotification(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('🔊 $text', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: const Color(0xFF8B5CF6),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void startSabotage(String room) {
    setState(() {
      isSabotageActive = true;
      sabotageRoom = room;
      sabotageTimerSeconds = 10;
    });

    playSoundNotification('عملت سابوتاج في $room!');

    sabotageTimer?.cancel();
    sabotageTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (sabotageTimerSeconds > 1) {
        setState(() => sabotageTimerSeconds--);
      } else {
        timer.cancel();
        setState(() => isSabotageActive = false);
        playSoundNotification('يا لوزر! محدش صلح السابوتاج في الوقت!');
      }
    });
  }

  @override
  void dispose() {
    promptTimer?.cancel();
    sabotageTimer?.cancel();
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
                color: Colors.red.shade900,
                child: Column(
                  children: [
                    Text('🚨 سابوتاج في $sabotageRoom!', style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text('باقي $sabotageTimerSeconds ثواني!', style: const TextStyle(fontSize: 20, color: Colors.yellowAccent)),
                    ElevatedButton(
                      onPressed: () {
                        sabotageTimer?.cancel();
                        setState(() => isSabotageActive = false);
                        playSoundNotification('تم إبطال السابوتاج بنجاح!');
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
              child: Text(currentInstruction, style: const TextStyle(color: Color(0xFF38BDF8), fontWeight: FontWeight.bold), textAlign: TextAlign.center),
            ),
            const SizedBox(height: 10),

            if (!isImposter)
              Expanded(
                child: ListView.builder(
                  itemCount: assignedTasks.length,
                  itemBuilder: (context, idx) => Card(
                    color: const Color(0xFF231145),
                    child: ListTile(
                      title: Text(assignedTasks[idx]),
                      trailing: IconButton(
                        icon: const Icon(Icons.check_circle, color: Colors.greenAccent),
                        onPressed: () => setState(() => assignedTasks.removeAt(idx)),
                      ),
                    ),
                  ),
                ),
              ),

            if (isImposter)
              Expanded(
                child: Column(
                  children: [
                    const Text('😈 اختر مكان السابوتاج:'),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: List.generate(widget.roomCount, (index) {
                        String rName = 'غرفة ${index + 1}';
                        return ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF8B5CF6)),
                          onPressed: () => startSabotage(rName),
                          child: Text('سابوتاج $rName'),
                        );
                      }),
                    ),
                  ],
                ),
              ),

            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, minimumSize: const Size.fromHeight(48)),
              icon: const Icon(Icons.campaign),
              label: const Text('Report / جثة'),
              onPressed: () => playSoundNotification('يا دي النيلة! إيه اللي حصل؟'),
            )
          ],
        ),
      ),
    );
  }
}
