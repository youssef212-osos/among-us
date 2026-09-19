import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart' hide Router;
import 'package:bonsoir/bonsoir.dart';
import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_router/shelf_router.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const BuzzyApp());
}

class BuzzyApp extends StatelessWidget {
  const BuzzyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF130924),
      ),
      home: const ProfileScreen(),
    );
  }
}

// 1. شاشة الملف الشخصي
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

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
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('اختر صورتك واسمك الحقيقي', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFFFACC15))),
                const SizedBox(height: 20),
                CircleAvatar(radius: 40, backgroundColor: const Color(0xFF231145), backgroundImage: NetworkImage(avatars[selectedIndex])),
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
                            border: Border.all(color: selectedIndex == index ? Colors.yellowAccent : Colors.transparent, width: 3),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: CircleAvatar(backgroundImage: NetworkImage(avatars[index]), radius: 22),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'أدخل اسمك الحقيقي',
                    filled: true,
                    fillColor: const Color(0xFF231145),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF8B5CF6), minimumSize: const Size.fromHeight(50)),
                  onPressed: () {
                    String name = nameController.text.trim();
                    if (name.isEmpty) name = 'لاعب_${Random().nextInt(100)}';

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MainMenuScreen(playerName: name, avatarUrl: avatars[selectedIndex]),
                      ),
                    );
                  },
                  child: const Text('دخول للعبة 🚀', style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// 2. القائمة الرئيسية
class MainMenuScreen extends StatelessWidget {
  final String playerName;
  final String avatarUrl;

  const MainMenuScreen({super.key, required this.playerName, required this.avatarUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('القائمة الرئيسية'), backgroundColor: const Color(0xFF231145)),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(radius: 40, backgroundImage: NetworkImage(avatarUrl)),
            const SizedBox(height: 10),
            Text(playerName, style: const TextStyle(fontSize: 20, color: Color(0xFFFACC15))),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green.shade700, minimumSize: const Size.fromHeight(60)),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RoomSetupScreen(playerName: playerName, avatarUrl: avatarUrl)),
                );
              },
              icon: const Icon(Icons.add_circle, color: Colors.white),
              label: const Text('إنشاء غرفة (الهوست)', style: TextStyle(fontSize: 18, color: Colors.white)),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue.shade700, minimumSize: const Size.fromHeight(60)),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LocalLobbyScreen(playerName: playerName, avatarUrl: avatarUrl)),
                );
              },
              icon: const Icon(Icons.wifi_tethering, color: Colors.white),
              label: const Text('البحث والانضمام لغرفة', style: TextStyle(fontSize: 18, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}

// 3. إعدادات الغرفة للهوست (مع الأشرطة)
class RoomSetupScreen extends StatefulWidget {
  final String playerName;
  final String avatarUrl;

  const RoomSetupScreen({super.key, required this.playerName, required this.avatarUrl});

  @override
  State<RoomSetupScreen> createState() => _RoomSetupScreenState();
}

class _RoomSetupScreenState extends State<RoomSetupScreen> {
  int roomsCount = 3;
  int maxPlayers = 6;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('إعدادات الغرفة')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('عدد الغرف/الأوض: $roomsCount', style: const TextStyle(fontSize: 18, color: Color(0xFFFACC15), fontWeight: FontWeight.bold)),
            Slider(
              value: roomsCount.toDouble(),
              min: 2,
              max: 8,
              divisions: 6,
              label: '$roomsCount غرف',
              activeColor: const Color(0xFF8B5CF6),
              onChanged: (val) => setState(() => roomsCount = val.toInt()),
            ),
            const SizedBox(height: 20),
            Text('أقصى عدد للاعبين: $maxPlayers', style: const TextStyle(fontSize: 18, color: Color(0xFFFACC15), fontWeight: FontWeight.bold)),
            Slider(
              value: maxPlayers.toDouble(),
              min: 2,
              max: 10,
              divisions: 8,
              label: '$maxPlayers لاعبين',
              activeColor: Colors.greenAccent,
              onChanged: (val) => setState(() => maxPlayers = val.toInt()),
            ),
            const Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF8B5CF6), minimumSize: const Size.fromHeight(55)),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HostGameRoom(
                      playerName: widget.playerName,
                      avatarUrl: widget.avatarUrl,
                      roomsCount: roomsCount,
                      maxPlayers: maxPlayers,
                    ),
                  ),
                );
              },
              child: const Text('فتح اللوبي بانتظار اللاعبين 🚀', style: TextStyle(fontSize: 18, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}

// 4. غرفة الهوست السيرفر (تتحكم بالشبكة وتزامن الحالات)
class HostGameRoom extends StatefulWidget {
  final String playerName;
  final String avatarUrl;
  final int roomsCount;
  final int maxPlayers;

  const HostGameRoom({
    super.key,
    required this.playerName,
    required this.avatarUrl,
    required this.roomsCount,
    required this.maxPlayers,
  });

  @override
  State<HostGameRoom> createState() => _HostGameRoomState();
}

class _HostGameRoomState extends State<HostGameRoom> {
  HttpServer? _server;
  BonsoirBroadcast? _broadcast;
  List<Map<String, dynamic>> players = [];
  
  String gamePhase = 'lobby'; // phases: 'lobby', 'wheel', 'playing'
  String impostorName = '';
  List<String> eliminated = [];

  @override
  void initState() {
    super.initState();
    players.add({'name': widget.playerName, 'avatar': widget.avatarUrl});
    _startServer();
  }

  Future<void> _startServer() async {
    try {
      var router = Router();

      // انضمام
      router.get('/join', (shelf.Request request) {
        var params = request.requestedUri.queryParameters;
        String name = params['name'] ?? 'Guest';
        String avatar = params['avatar'] ?? '';

        if (!players.any((p) => p['name'] == name)) {
          setState(() {
            players.add({'name': name, 'avatar': avatar});
          });
        }
        return shelf.Response.ok(jsonEncode({'status': 'ok'}), headers: {'Content-Type': 'application/json'});
      });

      // استعلام عن حالة اللعبة التلقائي للموبايل التاني
      router.get('/status', (shelf.Request request) {
        return shelf.Response.ok(
          jsonEncode({
            'phase': gamePhase,
            'impostor': impostorName,
            'roomsCount': widget.roomsCount,
            'players': players,
            'eliminated': eliminated,
          }),
          headers: {'Content-Type': 'application/json'},
        );
      });

      // تسجيل عملية قتل/إقصاء
      router.get('/kill', (shelf.Request request) {
        var target = request.requestedUri.queryParameters['target'];
        if (target != null && !eliminated.contains(target)) {
          setState(() {
            eliminated.add(target);
          });
        }
        return shelf.Response.ok(jsonEncode({'status': 'ok'}), headers: {'Content-Type': 'application/json'});
      });

      _server = await shelf_io.serve(router.call, InternetAddress.anyIPv4, 0);

      _broadcast = BonsoirBroadcast(
        service: BonsoirService(
          name: 'BuzzyParty_${widget.playerName}',
          type: '_buzzyparty._tcp',
          port: _server!.port,
        ),
      );
      await _broadcast!.ready;
      await _broadcast!.start();
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  void _triggerWheelAndStart() {
    if (players.isEmpty) return;
    
    // اختيار إمبوستر واحد فقط عشوائياً من السيرفر
    int randIndex = Random().nextInt(players.length);
    setState(() {
      impostorName = players[randIndex]['name'];
      gamePhase = 'wheel';
    });

    // الانتقال لشاشة العجلة عند الهوست
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WheelScreen(
          playerName: widget.playerName,
          impostorName: impostorName,
          roomsCount: widget.roomsCount,
          players: players,
          hostIp: '127.0.0.1',
          hostPort: _server?.port ?? 0,
          isHost: true,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _server?.close(force: true);
    _broadcast?.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('اللوبي الرئيسي (الهوست)')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text('اللاعبون المتصلون: ${players.length}/${widget.maxPlayers}', style: const TextStyle(fontSize: 18, color: Color(0xFFFACC15))),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: players.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: CircleAvatar(backgroundImage: NetworkImage(players[index]['avatar'])),
                    title: Text(players[index]['name'], style: const TextStyle(color: Colors.white)),
                  );
                },
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green.shade700, minimumSize: const Size.fromHeight(55)),
              onPressed: _triggerWheelAndStart,
              child: const Text('بدء اللف والعجلة للجميع 🎡', style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}

// 5. شاشة البحث عن الغرف للعميل (Client)
class LocalLobbyScreen extends StatefulWidget {
  final String playerName;
  final String avatarUrl;

  const LocalLobbyScreen({super.key, required this.playerName, required this.avatarUrl});

  @override
  State<LocalLobbyScreen> createState() => _LocalLobbyScreenState();
}

class _LocalLobbyScreenState extends State<LocalLobbyScreen> {
  BonsoirDiscovery? _discovery;
  List<ResolvedBonsoirService> foundRooms = [];

  @override
  void initState() {
    super.initState();
    _startDiscovery();
  }

  Future<void> _startDiscovery() async {
    _discovery = BonsoirDiscovery(type: '_buzzyparty._tcp');
    await _discovery!.ready;

    _discovery!.eventStream!.listen((event) {
      if (event.service == null) return;
      if (event.type == BonsoirDiscoveryEventType.discoveryServiceFound) {
        event.service!.resolve(_discovery!.serviceResolver);
      } else if (event.type == BonsoirDiscoveryEventType.discoveryServiceResolved) {
        final service = event.service;
        if (service is ResolvedBonsoirService) {
          setState(() {
            if (!foundRooms.any((r) => r.name == service.name)) {
              foundRooms.add(service);
            }
          });
        }
      }
    });

    await _discovery!.start();
  }

  Future<void> _joinRoom(ResolvedBonsoirService room) async {
    try {
      String url = 'http://${room.host}:${room.port}/join?name=${Uri.encodeComponent(widget.playerName)}&avatar=${Uri.encodeComponent(widget.avatarUrl)}';
      await http.get(Uri.parse(url));

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ClientWaitingRoom(
            playerName: widget.playerName,
            hostIp: room.host,
            hostPort: room.port,
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('تعذر الانضمام: $e')));
    }
  }

  @override
  void dispose() {
    _discovery?.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('الغرف المتاحة')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: foundRooms.isEmpty
            ? const Center(child: Text('جاري البحث عن غرف في الشبكة...'))
            : ListView.builder(
                itemCount: foundRooms.length,
                itemBuilder: (context, index) {
                  var room = foundRooms[index];
                  return ListTile(
                    title: Text(room.name, style: const TextStyle(color: Colors.white)),
                    trailing: ElevatedButton(
                      onPressed: () => _joinRoom(room),
                      child: const Text('انضمام'),
                    ),
                  );
                },
              ),
      ),
    );
  }
}

// 6. غرفة انتظار العميل (تستمع لتغيير الهوست أوتوماتيكياً)
class ClientWaitingRoom extends StatefulWidget {
  final String playerName;
  final String hostIp;
  final int hostPort;

  const ClientWaitingRoom({super.key, required this.playerName, required this.hostIp, required this.hostPort});

  @override
  State<ClientWaitingRoom> createState() => _ClientWaitingRoomState();
}

class _ClientWaitingRoomState extends State<ClientWaitingRoom> {
  Timer? _pollingTimer;

  @override
  void initState() {
    super.initState();
    // فحص حالة السيرفر كل ثانية لتتبع بدء اللعبة
    _pollingTimer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      try {
        var response = await http.get(Uri.parse('http://${widget.hostIp}:${widget.hostPort}/status'));
        if (response.statusCode == 200) {
          var data = jsonDecode(response.body);
          String phase = data['phase'];
          if (phase == 'wheel') {
            _pollingTimer?.cancel();
            if (!mounted) return;
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => WheelScreen(
                  playerName: widget.playerName,
                  impostorName: data['impostor'],
                  roomsCount: data['roomsCount'],
                  players: List<Map<String, dynamic>>.from(data['players']),
                  hostIp: widget.hostIp,
                  hostPort: widget.hostPort,
                  isHost: false,
                ),
              ),
            );
          }
        }
      } catch (_) {}
    });
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            CircularProgressIndicator(color: Color(0xFF8B5CF6)),
            SizedBox(height: 20),
            Text('تم الانضمام بنجاح! 🎮\nفي انتظار الهوست ليبدأ عجلة الحظ...', textAlign: TextAlign.center, style: TextStyle(fontSize: 18, color: Color(0xFFFACC15))),
          ],
        ),
      ),
    );
  }
}

// 7. شاشة عجلة الحظ المتحركة للطرفين
class WheelScreen extends StatefulWidget {
  final String playerName;
  final String impostorName;
  final int roomsCount;
  final List<Map<String, dynamic>> players;
  final String hostIp;
  final int hostPort;
  final bool isHost;

  const WheelScreen({
    super.key,
    required this.playerName,
    required this.impostorName,
    required this.roomsCount,
    required this.players,
    required this.hostIp,
    required this.hostPort,
    required this.isHost,
  });

  @override
  State<WheelScreen> createState() => _WheelScreenState();
}

class _WheelScreenState extends State<WheelScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool isSpinning = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 4));
    _controller.forward().then((_) {
      setState(() {
        isSpinning = false;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isImpostor = (widget.playerName == widget.impostorName);

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                isSpinning ? 'جاري دوران العجلة لتحديد الدور... 🎡' : 'تم اختيار دورك!',
                style: const TextStyle(fontSize: 22, color: Color(0xFFFACC15), fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 40),
              RotationTransition(
                turns: Tween(begin: 0.0, end: 6.0).animate(CurvedAnimation(parent: _controller, curve: Curves.decelerate)),
                child: Container(
                  width: 160,
                  height: 160,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const SweepGradient(colors: [Colors.red, Colors.blue, Colors.green, Colors.purple, Colors.red]),
                    border: Border.all(color: Colors.white, width: 4),
                  ),
                  child: const Icon(Icons.casino, size: 60, color: Colors.white),
                ),
              ),
              const SizedBox(height: 40),
              if (!isSpinning) ...[
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: isImpostor ? Colors.red.shade900 : Colors.blue.shade900,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    children: [
                      Text(
                        isImpostor ? '🎭 أنت المحتال (Impostor)' : '🛡️ أنت صديق روميت (Crewmate)',
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        isImpostor ? 'تسلل واقضِ على بقية اللاعبين!' : 'أنهِ الـ 5 مهام المطلوبة في الأوض!',
                        style: const TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF8B5CF6), minimumSize: const Size.fromHeight(55)),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GameplayScreen(
                          playerName: widget.playerName,
                          isImpostor: isImpostor,
                          roomsCount: widget.roomsCount,
                          players: widget.players,
                          hostIp: widget.hostIp,
                          hostPort: widget.hostPort,
                        ),
                      ),
                    );
                  },
                  child: const Text('دخول أرض اللعبة 🚀', style: TextStyle(fontSize: 18, color: Colors.white)),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// 8. نموذج التاسكات
class TaskItem {
  final String title;
  final int roomNumber;
  bool isCompleted;
  bool isCountingDown;
  int secondsLeft;

  TaskItem({
    required this.title,
    required this.roomNumber,
    this.isCompleted = false,
    this.isCountingDown = false,
    this.secondsLeft = 5,
  });
}

// 9. شاشة اللعب الحقيقية (Gameplay)
class GameplayScreen extends StatefulWidget {
  final String playerName;
  final bool isImpostor;
  final int roomsCount;
  final List<Map<String, dynamic>> players;
  final String hostIp;
  final int hostPort;

  const GameplayScreen({
    super.key,
    required this.playerName,
    required this.isImpostor,
    required this.roomsCount,
    required this.players,
    required this.hostIp,
    required this.hostPort,
  });

  @override
  State<GameplayScreen> createState() => _GameplayScreenState();
}

class _GameplayScreenState extends State<GameplayScreen> {
  List<TaskItem> tasks = [];
  List<String> killedPlayers = [];
  Timer? _syncTimer;

  @override
  void initState() {
    super.initState();

    // 1. توليد 5 مهام محددة برقم الغرف للروميت
    if (!widget.isImpostor) {
      List<String> possibleTasks = [
        'معاينة الأسلاك والتوصيلات',
        'تفريغ فلتر الهواء',
        'ضبط أجهزة المراقبة',
        'إصلاح صنبور المياه',
        'إعادة تشغيل المولد',
      ];
      for (int i = 0; i < 5; i++) {
        int roomNum = Random().nextInt(widget.roomsCount) + 1;
        tasks.add(TaskItem(title: possibleTasks[i], roomNumber: roomNum));
      }
    }

    // 2. المزامنة المستمرة لقائمة المقتولين
    _syncTimer = Timer.periodic(const Duration(seconds: 1), (_) async {
      try {
        var res = await http.get(Uri.parse('http://${widget.hostIp}:${widget.hostPort}/status'));
        if (res.statusCode == 200) {
          var data = jsonDecode(res.body);
          List<String> elim = List<String>.from(data['eliminated'] ?? []);
          setState(() {
            killedPlayers = elim;
          });
        }
      } catch (_) {}
    });
  }

  @override
  void dispose() {
    _syncTimer?.cancel();
    super.dispose();
  }

  void _startTaskTimer(TaskItem task) {
    setState(() => task.isCountingDown = true);

    Timer.periodic(const Duration(seconds: 1), (t) {
      if (task.secondsLeft > 1) {
        setState(() => task.secondsLeft--);
      } else {
        t.cancel();
        setState(() {
          task.isCountingDown = false;
          task.isCompleted = true;
        });
      }
    });
  }

  void _showKillDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF231145),
          title: const Text('اختر اللاعب الذي قتلتَه 🔪', style: TextStyle(color: Colors.redAccent)),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: widget.players.length,
              itemBuilder: (context, index) {
                String pName = widget.players[index]['name'];
                if (pName == widget.playerName || killedPlayers.contains(pName)) {
                  return const SizedBox();
                }
                return ListTile(
                  title: Text(pName, style: const TextStyle(color: Colors.white)),
                  trailing: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    onPressed: () async {
                      Navigator.pop(context);
                      // إرسال إشعار القتل للسيرفر
                      try {
                        await http.get(Uri.parse('http://${widget.hostIp}:${widget.hostPort}/kill?target=${Uri.encodeComponent(pName)}'));
                      } catch (_) {}
                    },
                    child: const Text('إقصاء'),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    bool amIDead = killedPlayers.contains(widget.playerName);
    int completedCount = tasks.where((t) => t.isCompleted).length;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isImpostor ? 'شاشة الإمبوستر 🎭' : 'شاشة المهام (روميت) 🛡️'),
        backgroundColor: const Color(0xFF231145),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (amIDead)
              Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 15),
                color: Colors.red,
                child: const Text('☠️ لقد تم قتلك وأصبحت شبحاً!', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
              ),

            // 1. عرض الـ 5 مهام للروميت
            if (!widget.isImpostor) ...[
              Text('المهام المكتملة: $completedCount / 5', style: const TextStyle(fontSize: 16, color: Color(0xFFFACC15), fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              LinearProgressIndicator(value: completedCount / 5, backgroundColor: Colors.white12, color: Colors.greenAccent, minHeight: 10),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    var t = tasks[index];
                    return Card(
                      color: const Color(0xFF231145),
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        title: Text('اذهب للأوضة رقم (${t.roomNumber}): ${t.title}', style: const TextStyle(color: Colors.white, fontSize: 15)),
                        subtitle: t.isCompleted
                            ? const Text('تمت المهمة ✅', style: TextStyle(color: Colors.greenAccent))
                            : (t.isCountingDown
                                ? Text('جاري التنفيذ... متبقي ${t.secondsLeft} ثواني ⏳', style: const TextStyle(color: Colors.orangeAccent))
                                : const Text('لم تبدأ بعد')),
                        trailing: t.isCompleted
                            ? const Icon(Icons.check_circle, color: Colors.greenAccent)
                            : ElevatedButton(
                                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF8B5CF6)),
                                onPressed: (t.isCountingDown || amIDead) ? null : () => _startTaskTimer(t),
                                child: Text(t.isCountingDown ? '${t.secondsLeft}s' : 'وصلت للأوضة'),
                              ),
                      ),
                    );
                  },
                ),
              ),
            ],

            // 2. عرض زر القتل للإمبوستر
            if (widget.isImpostor) ...[
              const Expanded(
                child: Center(
                  child: Text('تسلل بين الأوض واقضِ على اللاعبين بدون أن يراك أحد! 🤫', textAlign: TextAlign.center, style: TextStyle(fontSize: 18, color: Colors.white60)),
                ),
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade800, minimumSize: const Size.fromHeight(60)),
                onPressed: amIDead ? null : _showKillDialog,
                icon: const Icon(Icons.dangerous, color: Colors.white, size: 28),
                label: const Text('اختيار لاعب وقتله 🗡️', style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
              const SizedBox(height: 15),
            ],

            OutlinedButton(
              style: OutlinedButton.styleFrom(foregroundColor: Colors.redAccent),
              onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
              child: const Text('الخروج للقائمة الرئيسية'),
            ),
          ],
        ),
      ),
    );
  }
}
