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
        scaffoldBackgroundColor: const Color(0xFF130924), // الخلفية الكحلي الغامق
        primaryColor: const Color(0xFF8B5CF6),
      ),
      home: const BuzzyHomeScreen(),
    );
  }
}

class BuzzyHomeScreen extends StatelessWidget {
  const BuzzyHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
          child: Column(
            children: [
              // الهيدر علوي
              Row(
                children: [
                  const CircleAvatar(
                    backgroundColor: Color(0xFF4ADE80),
                    radius: 22,
                    child: Text('Y', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                  const SizedBox(width: 10),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Youssef Aly', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      Text('🎮 لاعب محترف', style: TextStyle(color: Colors.grey, fontSize: 12)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // اللوجو الجديد المعدل (Buzzy Party: Imposter Alive)
              Column(
                children: [
                  Text(
                    'BUZZY PARTY',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.black,
                      color: const Color(0xFFFACC15),
                      shadows: [
                        Shadow(offset: const Offset(2, 2), color: Colors.black.withOpacity(0.8), blurRadius: 2),
                      ],
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'IMPOSTER ALIVE',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.black,
                      color: const Color(0xFFEF4444), // لون أحمر مميز للأجواء الحماسية
                      shadows: [
                        Shadow(offset: const Offset(2, 2), color: Colors.black.withOpacity(0.8), blurRadius: 2),
                      ],
                    ),
                  ),
                ],
              ),
              const Spacer(),

              // أزرار Buzzy Party الشهيرة
              _buildBuzzyButton(
                title: 'إنشاء لعبة لوكال',
                color: const Color(0xFF8B5CF6),
                icon: Icons.gavel_rounded,
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const GameSetupScreen()));
                },
              ),
              const SizedBox(height: 15),

              _buildBuzzyButton(
                title: 'ادخل لعبة (Hotspot)',
                color: const Color(0xFFFB923C),
                icon: Icons.touch_app_rounded,
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const GameSetupScreen()));
                },
              ),
              const SizedBox(height: 15),

              _buildBuzzyButton(
                title: 'هاتف واحد (OffLine)',
                color: const Color(0xFF38BDF8),
                icon: Icons.phone_android_rounded,
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const GameSetupScreen()));
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
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.4),
              blurRadius: 8,
              offset: const Offset(0, 4),
            )
          ],
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
  const GameSetupScreen({super.key});

  @override
  State<GameSetupScreen> createState() => _GameSetupScreenState();
}

class _GameSetupScreenState extends State<GameSetupScreen> {
  final List<TextEditingController> playerControllers = [
    TextEditingController(text: 'لاعب 1'),
    TextEditingController(text: 'لاعب 2'),
  ];
  int roomsCount = 2; 
  int selectedTaskTime = 10;
  int hostIndex = 0;

  int getCalculatedImposters() {
    int total = playerControllers.length;
    if (total >= 10) return 3;
    if (total >= 5) return 2;
    return 1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إعدادات اللعبة', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: const Color(0xFF1E0C3B),
      ),
      body: SingleChildScrollView(
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('👥 اللعيبة الموجودة (${playerControllers.length})', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      IconButton(
                        icon: const Icon(Icons.add_circle, color: Color(0xFF4ADE80)),
                        onPressed: () {
                          if (playerControllers.length < 15) {
                            setState(() => playerControllers.add(TextEditingController(text: 'لاعب ${playerControllers.length + 1}')));
                          }
                        },
                      )
                    ],
                  ),
                  const SizedBox(height: 10),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: playerControllers.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: TextField(
                          controller: playerControllers[index],
                          decoration: InputDecoration(
                            labelText: 'اسم اللاعب ${index + 1}',
                            filled: true,
                            fillColor: const Color(0xFF130924),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: const Color(0xFF231145), borderRadius: BorderRadius.circular(16)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('🏠 عدد غرف الشقة (أقل حد 2):', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
                  const SizedBox(height: 15),
                  Text('😈 عدد الإمبوسترز التلقائي: ${getCalculatedImposters()}', style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const SizedBox(height: 25),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8B5CF6),
                minimumSize: const Size.fromHeight(55),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              onPressed: () {
                List<String> names = playerControllers.map((e) => e.text).toList();
                List<int> imposters = [];
                final rand = Random();
                while (imposters.length < getCalculatedImposters()) {
                  int r = rand.nextInt(names.length);
                  if (!imposters.contains(r)) imposters.add(r);
                }

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MainGameRoomScreen(
                      playerNames: names,
                      roomCount: roomsCount,
                      hostIndex: hostIndex,
                      imposterIndices: imposters,
                    ),
                  ),
                );
              },
              child: const Text('دخول الجيم 🚀', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
  final int hostIndex;
  final List<int> imposterIndices;

  const MainGameRoomScreen({
    super.key,
    required this.playerNames,
    required this.roomCount,
    required this.hostIndex,
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
      playSoundNotification('أنا جيت!');
    });
  }

  void generateTasks() {
    final random = Random();
    List<String> taskTypes = ['صلح السلك', 'امسح البصمات', 'نزل الملفات', 'شغل المولد'];
    assignedTasks.clear();

    for (int i = 0; i < 5; i++) {
      int roomNum = random.nextInt(widget.roomCount) + 1;
      String roomName = roomNum == 1 ? 'المطبخ' : (roomNum == 2 ? 'الريسبشن' : 'الأوضة $roomNum');
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
        content: Text('🔊 $text', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
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
        playSoundNotification('يا لوزر يا لوزر! محدش صلح السابوتاج!');
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
                        playSoundNotification('تم إبطال السابوتاج!');
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
                    Wrap(
                      spacing: 8,
                      children: List.generate(widget.roomCount, (index) {
                        String rName = (index + 1) == 1 ? 'المطبخ' : ((index + 1) == 2 ? 'الريسبشن' : 'الأوضة ${index + 1}');
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
