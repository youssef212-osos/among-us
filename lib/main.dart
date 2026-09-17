import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const ImposterGameApp());
}

class ImposterGameApp extends StatelessWidget {
  const ImposterGameApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Imposter Real-Life P2P',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.redAccent,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF0F172A),
      ),
      home: const MainHomeScreen(),
    );
  }
}

class MainHomeScreen extends StatefulWidget {
  const MainHomeScreen({super.key});

  @override
  State<MainHomeScreen> createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  final TextEditingController _nameController = TextEditingController(text: 'لاعب 1');
  final TextEditingController _codeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🕵️ Imposter Real-Life'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.security, size: 70, color: Colors.redAccent),
              const SizedBox(height: 15),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'اسم اللاعب',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 25),
              // خيار انشاء روم
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: () {
                  if (_nameController.text.trim().isEmpty) return;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HostLobbyScreen(playerName: _nameController.text.trim()),
                    ),
                  );
                },
                icon: const Icon(Icons.add_box),
                label: const Text('إنشاء غرفة (Host)', style: TextStyle(fontSize: 18)),
              ),
              const SizedBox(height: 15),
              // خيار الـ Local
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: () {
                  if (_nameController.text.trim().isEmpty) return;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LocalDiscoveryScreen(playerName: _nameController.text.trim()),
                    ),
                  );
                },
                icon: const Icon(Icons.wifi_find),
                label: const Text('البحث عن سيرفر محلي (Local)', style: TextStyle(fontSize: 18)),
              ),
              const SizedBox(height: 25),
              const Divider(),
              const SizedBox(height: 10),
              // خيار الانضمام بكود مباشر
              TextField(
                controller: _codeController,
                decoration: const InputDecoration(
                  labelText: 'أدخل كود/IP الغرفة',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.qr_code),
                ),
              ),
              const SizedBox(height: 15),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: () {
                  if (_nameController.text.trim().isEmpty || _codeController.text.trim().isEmpty) return;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ClientLobbyScreen(
                        playerName: _nameController.text.trim(),
                        hostIp: _codeController.text.trim(),
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.login),
                label: const Text('انضمام بالكود', style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==================== شاشة البحث المحلي (Local) ====================
class LocalDiscoveryScreen extends StatefulWidget {
  final String playerName;
  const LocalDiscoveryScreen({super.key, required this.playerName});

  @override
  State<LocalDiscoveryScreen> createState() => _LocalDiscoveryScreenState();
}

class _LocalDiscoveryScreenState extends State<LocalDiscoveryScreen> {
  RawDatagramSocket? _udpSocket;
  String? foundHostIp;
  String status = "جاري البحث عن الهوست على نفس الشبكة...";

  @override
  void initState() {
    super.initState();
    _listenForBroadcast();
  }

  void _listenForBroadcast() async {
    try {
      _udpSocket = await RawDatagramSocket.bind(InternetAddress.anyIPv4, 8889);
      _udpSocket?.broadcastEnabled = true;
      _udpSocket?.listen((RawSocketEvent event) {
        if (event == RawSocketEvent.read) {
          Datagram? dg = _udpSocket?.receive();
          if (dg != null) {
            String message = utf8.decode(dg.data);
            if (message.startsWith("IMPOSTER_HOST:")) {
              setState(() {
                foundHostIp = dg.address.address;
                status = "تم العثور على غرفة الهوست!";
              });
            }
          }
        }
      });
    } catch (e) {
      setState(() {
        status = "خطأ أثناء البحث: $e";
      });
    }
  }

  @override
  void dispose() {
    _udpSocket?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('شبكة Local')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (foundHostIp == null) ...[
                const CircularProgressIndicator(),
                const SizedBox(height: 20),
                Text(status, textAlign: TextAlign.center, style: const TextStyle(fontSize: 16)),
              ] else ...[
                const Icon(Icons.check_circle, color: Colors.green, size: 80),
                const SizedBox(height: 20),
                Text('عُثر على الهوست: $foundHostIp', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 30),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green, minimumSize: const Size(double.infinity, 50)),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ClientLobbyScreen(
                          playerName: widget.playerName,
                          hostIp: foundHostIp!,
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('دخول الجيم الان 🚀', style: TextStyle(fontSize: 18)),
                )
              ]
            ],
          ),
        ),
      ),
    );
  }
}

// ==================== شاشة الهوست (Host) ====================
class HostLobbyScreen extends StatefulWidget {
  final String playerName;
  const HostLobbyScreen({super.key, required this.playerName});

  @override
  State<HostLobbyScreen> createState() => _HostLobbyScreenState();
}

class _HostLobbyScreenState extends State<HostLobbyScreen> {
  ServerSocket? _server;
  Timer? _broadcastTimer;
  List<Socket> clients = [];
  List<String> players = [];
  String roomCode = "جاري التحميل...";
  bool gameStarted = false;
  String myRole = "Crewmate (طاقم العمل)";

  @override
  void initState() {
    super.initState();
    players.add(widget.playerName);
    _startServer();
  }

  void _startServer() async {
    try {
      for (var interface in await NetworkInterface.list()) {
        for (var addr in interface.addresses) {
          if (addr.type == InternetAddressType.IPv4 && !addr.isLoopback) {
            setState(() {
              roomCode = addr.address;
            });
            break;
          }
        }
      }

      _server = await ServerSocket.bind(InternetAddress.anyIPv4, 4444);
      _server?.listen((Socket client) {
        clients.add(client);
        client.listen((data) {
          String message = utf8.decode(data);
          var msgData = jsonDecode(message);
          if (msgData['type'] == 'join') {
            setState(() {
              players.add(msgData['name']);
            });
            _broadcastPlayers();
          }
        });
      });

      // إرسال إشارة للـ Local كل ثانية لتعريف وجود السيرفر
      RawDatagramSocket udp = await RawDatagramSocket.bind(InternetAddress.anyIPv4, 0);
      udp.broadcastEnabled = true;
      _broadcastTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        udp.send(utf8.encode("IMPOSTER_HOST:$roomCode"), InternetAddress("255.255.255.255"), 8889);
      });
    } catch (e) {
      setState(() {
        roomCode = "خطأ: $e";
      });
    }
  }

  void _broadcastPlayers() {
    var msg = jsonEncode({'type': 'players_update', 'players': players});
    for (var c in clients) {
      c.write(msg);
    }
  }

  void _startGame() {
    if (players.length < 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يلزم وجود لاعبين على الأقل للبدء!')),
      );
      return;
    }

    int imposterIndex = Random().nextInt(players.length);
    setState(() {
      gameStarted = true;
      myRole = (imposterIndex == 0) ? "🔪 Imposter (القاتل)" : "😇 Crewmate (طاقم العمل)";
    });

    for (int i = 0; i < clients.length; i++) {
      String role = (i + 1 == imposterIndex) ? "🔪 Imposter (القاتل)" : "😇 Crewmate (طاقم العمل)";
      clients[i].write(jsonEncode({'type': 'start_game', 'role': role}));
    }
  }

  @override
  void dispose() {
    _broadcastTimer?.cancel();
    _server?.close();
    for (var c in clients) {
      c.close();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('غرفة الهوست')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.redAccent.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.redAccent),
              ),
              child: Column(
                children: [
                  const Text('كود الدخول المباشر للغرفة:', style: TextStyle(fontSize: 14)),
                  const SizedBox(height: 5),
                  SelectableText(
                    roomCode,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.greenAccent),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            if (!gameStarted) ...[
              Text('اللاعبون في الغرفة (${players.length}):', style: const TextStyle(fontSize: 18)),
              Expanded(
                child: ListView.builder(
                  itemCount: players.length,
                  itemBuilder: (context, index) => ListTile(
                    leading: const Icon(Icons.person),
                    title: Text(players[index]),
                  ),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green, minimumSize: const Size(double.infinity, 50)),
                onPressed: _startGame,
                child: const Text('بدء اللعبة وتوزيع الأدوار 🚀', style: TextStyle(fontSize: 18)),
              )
            ] else ...[
              const SizedBox(height: 40),
              const Text('دورك في اللعبة:', style: TextStyle(fontSize: 20)),
              const SizedBox(height: 10),
              Text(
                myRole,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: myRole.contains('Imposter') ? Colors.red : Colors.blue,
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}

// ==================== شاشة العميل (Client) ====================
class ClientLobbyScreen extends StatefulWidget {
  final String playerName;
  final String hostIp;
  const ClientLobbyScreen({super.key, required this.playerName, required this.hostIp});

  @override
  State<ClientLobbyScreen> createState() => _ClientLobbyScreenState();
}

class _ClientLobbyScreenState extends State<ClientLobbyScreen> {
  Socket? _socket;
  List<String> players = [];
  bool gameStarted = false;
  String myRole = "في انتظار بدء اللعبة...";
  String statusMsg = "جاري الاتصال بالسيرفر...";

  @override
  void initState() {
    super.initState();
    _connectToHost();
  }

  void _connectToHost() async {
    try {
      _socket = await Socket.connect(widget.hostIp, 4444);
      setState(() {
        statusMsg = "تم الاتصال بنجاح!";
      });

      _socket?.write(jsonEncode({'type': 'join', 'name': widget.playerName}));

      _socket?.listen((data) {
        String message = utf8.decode(data);
        var msgData = jsonDecode(message);

        if (msgData['type'] == 'players_update') {
          setState(() {
            players = List<String>.from(msgData['players']);
          });
        } else if (msgData['type'] == 'start_game') {
          setState(() {
            gameStarted = true;
            myRole = msgData['role'];
          });
        }
      });
    } catch (e) {
      setState(() {
        statusMsg = "فشل الاتصال: $e";
      });
    }
  }

  @override
  void dispose() {
    _socket?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('الانضمام للغرفة')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text(statusMsg, style: const TextStyle(fontSize: 16, color: Colors.amber)),
            const SizedBox(height: 20),
            if (!gameStarted) ...[
              Text('اللاعبون المنضمون (${players.length}):', style: const TextStyle(fontSize: 18)),
              Expanded(
                child: ListView.builder(
                  itemCount: players.length,
                  itemBuilder: (context, index) => ListTile(
                    leading: const Icon(Icons.person),
                    title: Text(players[index]),
                  ),
                ),
              ),
            ] else ...[
              const SizedBox(height: 40),
              const Text('دورك في اللعبة:', style: TextStyle(fontSize: 20)),
              const SizedBox(height: 10),
              Text(
                myRole,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: myRole.contains('Imposter') ? Colors.red : Colors.blue,
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
