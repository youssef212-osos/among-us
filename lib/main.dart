import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const AmongUsPartyApp());
}

class AmongUsPartyApp extends StatelessWidget {
  const AmongUsPartyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Among Us Party',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0F172A),
      ),
      home: const RoleSelectionScreen(),
    );
  }
}

class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
  final TextEditingController nameController = TextEditingController();
  bool isHost = false;
  String role = 'Crewmate';

  void showSoundNotification(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('🔊 الصوت: "$text"', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.redAccent,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('إعدادات اللاعب')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'اسمك في اللعبة', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Text('هل أنت الـ Host (منظم اللعبة)؟'),
                Switch(
                  value: isHost,
                  onChanged: (val) => setState(() => isHost = val),
                ),
              ],
            ),
            Row(
              children: [
                const Text('دورك: '),
                DropdownButton<String>(
                  value: role,
                  items: ['Crewmate', 'Imposter'].map((String value) {
                    return DropdownMenuItem<String>(value: value, child: Text(value));
                  }).toList(),
                  onChanged: (val) => setState(() => role = val!),
                ),
              ],
            ),
            const Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(50)),
              onPressed: () {
                if (nameController.text.isEmpty) return;
                showSoundNotification('أنا جيت!');
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GamePartyScreen(
                      playerName: nameController.text,
                      isHost: isHost,
                      isImposter: role == 'Imposter',
                    ),
                  ),
                );
              },
              child: const Text('دخول الروم', style: TextStyle(fontSize: 20)),
            )
          ],
        ),
      ),
    );
  }
}

class GamePartyScreen extends StatefulWidget {
  final String playerName;
  final bool isHost;
  final bool isImposter;

  const GamePartyScreen({
    super.key,
    required this.playerName,
    required this.isHost,
    required this.isImposter,
  });

  @override
  State<GamePartyScreen> createState() => _GamePartyScreenState();
}

class _GamePartyScreenState extends State<GamePartyScreen> {
  String currentTask = 'اضغط "تاسك جديد" لبدء مهمتك!';
  bool isTaskRunning = false;
  int taskProgress = 0;
  Timer? taskTimer;

  final List<String> rooms = ['الشرقية', 'الغربية', 'الصالون', 'المطبخ', 'الريسبشن'];
  final List<String> taskTypes = ['صلح السلك', 'امسح البصمات', 'نزل الملفات', 'شغل المولد'];

  void generateNewTask() {
    final random = Random();
    String selectedRoom = rooms[random.nextInt(rooms.length)];
    String selectedTask = taskTypes[random.nextInt(taskTypes.length)];
    int taskDuration = random.nextInt(10) + 1;

    setState(() {
      currentTask = 'روح $selectedRoom وإعمل: $selectedTask (المدة: $taskDuration ثواني)';
    });
  }

  void startTaskTimer() {
    setState(() {
      isTaskRunning = true;
      taskProgress = 0;
    });

    taskTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        taskProgress += 10;
        if (taskProgress >= 100) {
          timer.cancel();
          isTaskRunning = false;
          currentTask = 'تمت المهمة بنجاح! خذ مهمة جديدة.';
        }
      });
    });
  }

  void playVoice(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('🔊 $text', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.amber.shade900,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void triggerEmergencyMeeting() {
    playVoice('يا دي النيلة! إيه اللي حصل؟');
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('🚨 اجتماااع طارئ! 🚨'),
        content: const Text('في حد داس على الميتينج أو لقى جثة! اتجمعوا واتناقشوا.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              playVoice('يا دي النيلة... طلع بريء!');
            },
            child: const Text('طردنا واحد بريء'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              if (widget.isImposter) {
                playVoice('يا لوزر يا لوزر!');
              } else {
                playVoice('وكسبناااا وكسبناااا!');
              }
            },
            child: const Text('كشفنا الإمبوستر!'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.playerName} (${widget.isImposter ? 'Imposter' : 'Crewmate'})'),
        backgroundColor: widget.isImposter ? Colors.red.shade900 : Colors.blue.shade900,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (widget.isHost) ...[
              Container(
                padding: const EdgeInsets.all(12),
                color: Colors.amber.shade800,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.star),
                    SizedBox(width: 8),
                    Text('أنت الـ HOST: عندك زرار الميتينج روم', style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red, minimumSize: const Size.fromHeight(50)),
                icon: const Icon(Icons.warning, color: Colors.white),
                label: const Text('EMERGENCY MEETING (الهوست)', style: TextStyle(fontSize: 18, color: Colors.white)),
                onPressed: triggerEmergencyMeeting,
              ),
              const Divider(height: 30),
            ],

            if (!widget.isImposter) ...[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(currentTask, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                      const SizedBox(height: 15),
                      if (isTaskRunning) LinearProgressIndicator(value: taskProgress / 100),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(onPressed: generateNewTask, child: const Text('تاسك جديد')),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                            onPressed: isTaskRunning ? null : startTaskTimer,
                            child: const Text('ابدأ تنفيذ التاسك'),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],

            if (widget.isImposter) ...[
              Card(
                color: const Color(0xFF2C0B0B),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Text('😈 خيارات الـ Imposter', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red)),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                        onPressed: () => playVoice('عملت سابوتاج! الأبواب اتقفلت والنور قطع!'),
                        child: const Text('تفعيل سابوتاج (Sabotage)'),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF8B0000)),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              TextEditingController victimController = TextEditingController();
                              return AlertDialog(
                                title: const Text('قتل شخص في الحقيقة'),
                                content: TextField(
                                  controller: victimController,
                                  decoration: const InputDecoration(hintText: 'اكتب اسم الشخص اللي لمسته'),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      playVoice('قتلت ${victimController.text}! ينزل على الأرض فوراً!');
                                    },
                                    child: const Text('تأكيد القتل 💀'),
                                  )
                                ],
                              );
                            },
                          );
                        },
                        child: const Text('قتل لاعب (لما تلمسه)'),
                      ),
                    ],
                  ),
                ),
              ),
            ],

            const Spacer(),

            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, minimumSize: const Size.fromHeight(50)),
              icon: const Icon(Icons.campaign),
              label: const Text('لقيت جثة! (Report)', style: TextStyle(fontSize: 18)),
              onPressed: triggerEmergencyMeeting,
            ),
          ],
        ),
      ),
    );
  }
}
