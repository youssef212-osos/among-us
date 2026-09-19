import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart' hide Router; // تم إخفاء Router لمنع التداخل
import 'package:bonsoir/bonsoir.dart';
import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_router/shelf_router.dart';
import 'package:http/http.dart' as http;

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

  final List<String> avatars = [
    'https://api.dicebear.com/7.x/bottts/png?seed=buzzy1',
    'https://api.dicebear.com/7.x/bottts/png?seed=buzzy2',
    'https://api.dicebear.com/7.x/bottts/png?seed=buzzy3',
    'https://api.dicebear.com/7.x/bottts/png?seed=buzzy4',
    'https://api.dicebear.com/7.x/bottts/png?seed=buzzy5',
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
            onPressed: widget.onToggleLanguage,
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
                    widget.isEnglish ? 'Choose your Avatar & Name' : 'اختر صورتك واسمك الحقيقي',
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
                      labelText: widget.isEnglish ? 'Enter your actual name' : 'أدخل اسمك الحقيقي',
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
                        name = widget.isEnglish ? 'Player' : 'لاعب';
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

// 2. القائمة الرئيسية
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
                isEnglish ? 'Create Room (Host)' : 'إنشاء غرفة حقيقية',
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
                isEnglish ? 'Join Local Room' : 'البحث والانضمام لغرفة محلية',
                style: const TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 3. إعدادات الغرفة
class RoomSetupScreen extends StatefulWidget {
  final String playerName;
  final String avatarUrl;
  final bool isEnglish;

  const RoomSetupScreen({super.key, required this.playerName, required this.avatarUrl, required this.isEnglish});

  @override
  State<RoomSetupScreen> createState() => _RoomSetupScreenState();
}

class _RoomSetupScreenState extends State<RoomSetupScreen> {
  bool hasReception = true;
  bool hasKitchen = true;
  bool hasBathroom = true;
  int roomsCount = 2;
  int maxPlayers = 8;

  int get minRooms {
    if (!hasReception && !hasKitchen && !hasBathroom) return 5;
    if (!hasReception && !hasKitchen) return 4;
    if (!hasReception) return 3;
    return 2;
  }

  @override
  Widget build(BuildContext context) {
    if (roomsCount < minRooms) roomsCount = minRooms;
    return Scaffold(
      appBar: AppBar(title: Text(widget.isEnglish ? 'Room Setup' : 'إعدادات الغرفة')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SwitchListTile(
              title: Text(widget.isEnglish ? 'Contains Reception?' : 'هل يوجد ريسبشن؟'),
              value: hasReception,
              onChanged: (val) => setState(() => hasReception = val),
            ),
            SwitchListTile(
              title: Text(widget.isEnglish ? 'Contains Kitchen?' : 'هل يوجد مطبخ؟'),
              value: hasKitchen,
              onChanged: (val) => setState(() => hasKitchen = val),
            ),
            SwitchListTile(
              title: Text(widget.isEnglish ? 'Contains Bathroom?' : 'هل يوجد حمام؟'),
              value: hasBathroom,
              onChanged: (val) => setState(() => hasBathroom = val),
            ),
            const Divider(color: Colors.white24, height: 30),
            Text('عدد الأوض: $roomsCount (الحد الأدنى: $minRooms)', style: const TextStyle(color: Color(0xFFFACC15))),
            Slider(
              value: roomsCount.toDouble(),
              min: minRooms.toDouble(),
              max: 10,
              divisions: 10 - minRooms > 0 ? 10 - minRooms : 1,
              onChanged: (val) => setState(() => roomsCount = val.toInt()),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF8B5CF6), minimumSize: const Size.fromHeight(55)),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HostWaitingRoom(
                      playerName: widget.playerName,
                      avatarUrl: widget.avatarUrl,
                      roomsCount: roomsCount,
                      maxPlayers: maxPlayers,
                      isEnglish: widget.isEnglish,
                    ),
                  ),
                );
              },
              child: Text(widget.isEnglish ? 'Open Server Room 🚀' : 'فتح السيرفر وإطلاق الغرفة 🚀', style: const TextStyle(fontSize: 18, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}

// 4. واجهة المضيف (السيرفر المحلي)
class HostWaitingRoom extends StatefulWidget {
  final String playerName;
  final String avatarUrl;
  final int roomsCount;
  final int maxPlayers;
  final bool isEnglish;

  const HostWaitingRoom({
    super.key,
    required this.playerName,
    required this.avatarUrl,
    required this.roomsCount,
    required this.maxPlayers,
    required this.isEnglish,
  });

  @override
  State<HostWaitingRoom> createState() => _HostWaitingRoomState();
}

class _HostWaitingRoomState extends State<HostWaitingRoom> {
  HttpServer? _server;
  BonsoirBroadcast? _broadcast;
  List<Map<String, dynamic>> connectedPlayers = [];
  bool isServerStarted = false;

  @override
  void initState() {
    super.initState();
    connectedPlayers.add({
      'name': widget.playerName,
      'avatar': widget.avatarUrl,
      'isHost': true,
    });
    _startRealServer();
  }

  Future<void> _startRealServer() async {
    try {
      var router = Router();
      router.get('/join', (shelf.Request request) {
        var params = request.requestedUri.queryParameters;
        String pName = params['name'] ?? 'Guest';
        String pAvatar = params['avatar'] ?? '';

        setState(() {
          if (!connectedPlayers.any((p) => p['name'] == pName)) {
            connectedPlayers.add({'name': pName, 'avatar': pAvatar, 'isHost': false});
          }
        });

        return shelf.Response.ok(jsonEncode({
          'status': 'success',
          'players': connectedPlayers,
          'rooms': widget.roomsCount,
        }), headers: {'Content-Type': 'application/json'});
      });

      _server = await shelf_io.serve(router.call, InternetAddress.anyIPv4, 0);
      int port = _server!.port;

      _broadcast = BonsoirBroadcast(
        service: BonsoirService(
          name: 'BuzzyRoom_${widget.playerName}',
          type: '_buzzygame._tcp',
          port: port,
          attributes: {'host': widget.playerName},
        ),
      );

      await _broadcast!.ready;
      await _broadcast!.start();
      setState(() => isServerStarted = true);
    } catch (e) {
      debugPrint('Error starting server: $e');
    }
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
      appBar: AppBar(title: Text(widget.isEnglish ? 'Hosting Room...' : 'غرفة المضيف (بانتظار الأصدقاء)')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text(
              isServerStarted
                  ? (widget.isEnglish ? 'Server Active! Share Hotspot' : 'السيرفر شغال وفي انتظار اتصال الأصدقاء على الهوت سبوت...')
                  : (widget.isEnglish ? 'Starting Server...' : 'جاري تشغيل السيرفر المحلي...'),
              style: TextStyle(color: isServerStarted ? Colors.greenAccent : Colors.orangeAccent),
            ),
            const SizedBox(height: 15),
            Text('الغرفة الخاصة بـ: ${widget.playerName}', style: const TextStyle(fontSize: 16, color: Color(0xFFFACC15))),
            const Divider(color: Colors.white24, height: 30),
            Expanded(
              child: ListView.builder(
                itemCount: connectedPlayers.length,
                itemBuilder: (context, index) {
                  var player = connectedPlayers[index];
                  return ListTile(
                    leading: CircleAvatar(backgroundImage: NetworkImage(player['avatar'])),
                    title: Text(player['name'], style: const TextStyle(color: Colors.white)),
                    subtitle: Text(player['isHost'] ? (widget.isEnglish ? 'Host' : 'المضيف') : (widget.isEnglish ? 'Player' : 'لاعب منضم')),
                  );
                },
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green.shade700, minimumSize: const Size.fromHeight(50)),
              onPressed: connectedPlayers.length > 1 ? () {} : null,
              child: Text(widget.isEnglish ? 'Start Game 🎮' : 'ابدأ اللعبة مع اللاعبين 🎮', style: const TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}

// 5. واجهة البحث والانضمام
class LocalLobbyScreen extends StatefulWidget {
  final String playerName;
  final String avatarUrl;
  final bool isEnglish;

  const LocalLobbyScreen({super.key, required this.playerName, required this.avatarUrl, required this.isEnglish});

  @override
  State<LocalLobbyScreen> createState() => _LocalLobbyScreenState();
}

class _LocalLobbyScreenState extends State<LocalLobbyScreen> {
  BonsoirDiscovery? _discovery;
  List<ResolvedBonsoirService> foundRooms = [];
  bool isScanning = false;

  @override
  void initState() {
    super.initState();
    _startDiscovery();
  }

  Future<void> _startDiscovery() async {
    setState(() => isScanning = true);
    _discovery = BonsoirDiscovery(type: '_buzzygame._tcp');
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
      } else if (event.type == BonsoirDiscoveryEventType.discoveryServiceLost) {
        setState(() {
          foundRooms.removeWhere((r) => r.name == event.service!.name);
        });
      }
    });

    await _discovery!.start();
  }

  Future<void> _joinRoom(ResolvedBonsoirService room) async {
    try {
      String url = 'http://${room.host}:${room.port}/join?name=${Uri.encodeComponent(widget.playerName)}&avatar=${Uri.encodeComponent(widget.avatarUrl)}';
      var response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (!mounted) return;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ClientWaitingRoom(
              playerName: widget.playerName,
              avatarUrl: widget.avatarUrl,
              roomData: data,
              isEnglish: widget.isEnglish,
            ),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('فشل الاتصال بالغرفة: $e')),
      );
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
      appBar: AppBar(title: Text(widget.isEnglish ? 'Local Rooms' : 'البحث عن غرف محلية')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text(
              isScanning
                  ? (widget.isEnglish ? 'Scanning nearby local rooms...' : 'جاري البحث في شبكة الهوت سبوت عن غرف الأصدقاء...')
                  : (widget.isEnglish ? 'Scan stopped' : 'تم إيقاف البحث'),
              style: const TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 10),
            if (isScanning) const LinearProgressIndicator(color: Color(0xFF8B5CF6)),
            const SizedBox(height: 20),
            Expanded(
              child: foundRooms.isEmpty
                  ? Center(
                      child: Text(
                        widget.isEnglish ? 'No rooms found yet.' : 'مفيش غرف لقتها لغاية دلوقتي.. تأكد إن صاحبك فتح غرفة على نفس الشبكة!',
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.white54),
                      ),
                    )
                  : ListView.builder(
                      itemCount: foundRooms.length,
                      itemBuilder: (context, index) {
                        var room = foundRooms[index];
                        return Card(
                          color: const Color(0xFF231145),
                          child: ListTile(
                            leading: const Icon(Icons.meeting_room, color: Color(0xFFFACC15), size: 35),
                            title: Text(room.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                            subtitle: Text('IP: ${room.host}:${room.port}', style: const TextStyle(color: Colors.white60)),
                            trailing: ElevatedButton(
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                              onPressed: () => _joinRoom(room),
                              child: Text(widget.isEnglish ? 'Join' : 'انضمام'),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

// 6. واجهة العميل بعد الانضمام
class ClientWaitingRoom extends StatelessWidget {
  final String playerName;
  final String avatarUrl;
  final Map<String, dynamic> roomData;
  final bool isEnglish;

  const ClientWaitingRoom({super.key, required this.playerName, required this.avatarUrl, required this.roomData, required this.isEnglish});

  @override
  Widget build(BuildContext context) {
    List players = roomData['players'] ?? [];
    return Scaffold(
      appBar: AppBar(title: Text(isEnglish ? 'Joined Room' : 'غرفة الانتظار (منضم بنجاح)')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text(isEnglish ? 'Successfully joined the room!' : 'تم الانضمام بنجاح لغرفة صديقك على الشبكة المحليّة! 🚀', style: const TextStyle(color: Colors.greenAccent, fontSize: 16)),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: players.length,
                itemBuilder: (context, index) {
                  var p = players[index];
                  return ListTile(
                    leading: CircleAvatar(backgroundImage: NetworkImage(p['avatar'])),
                    title: Text(p['name'], style: const TextStyle(color: Colors.white)),
                    subtitle: Text(p['isHost'] ? (isEnglish ? 'Host' : 'المضيف') : (isEnglish ? 'Player' : 'لاعب')),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
