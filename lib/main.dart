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
  final TextEditingController _ipController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🕵️ Imposter Real-Life'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.security, size: 80, color: Colors.redAccent),
            const SizedBox(height: 20),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'اسم اللاعب',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 30),
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
              icon: const Icon(Icons.wifi_tethering),
              label: const Text('إنشاء غرفة (الهوست / السيرفر)', style: TextStyle(fontSize: 18)),
            ),
            const SizedBox(height: 15),
            const Text('أو للانضمام لغرفة صديق:'),
            const SizedBox(height: 15),
            TextField(
              controller: _ipController,
              decoration: const InputDecoration(
                labelText: 'IP الهوست (مثال: 192.168.43.1)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.wifi),
              ),
            ),
            const SizedBox(height: 15),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: () {
                if (_nameController.text.trim().isEmpty || _ipController.text.trim().isEmpty) return;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ClientLobbyScreen(
                      playerName: _nameController.text.trim(),
                      hostIp: _ipController.text.trim(),
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.login),
              label: const Text('انضمام للعبة', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}

// ==================== شاشة الهوست (Host Screen) ====================
class HostLobbyScreen extends StatefulWidget {
  final String playerName;
  const HostLobbyScreen({super.key, required this.playerName});

  @override
  State<HostLobbyScreen> createState() => _HostLobbyScreenState();
}

class _HostLobbyScreenState extends State<HostLobbyScreen> {
  ServerSocket? _server;
  List<Socket> clients = [];
  List<String> players = [];
  String hostIpAddress = "جاري التحميل...";
  bool gameStarted = false;
  String myRole = "Crewmate (طاقم العمل)";
  String gameStatus = "في انتظار انضمام اللاعبين...";

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
              hostIpAddress = addr.address;
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
    } catch (e) {
      setState(() {
        hostIpAddress = "خطأ في تشغيل السيرفر: $e";
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
        const SnackBar(content: Text('يجب أن يكون هناك لاعبين على الأقل للبدء!')),
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
            Card(
              color: Colors.black45,
              child: ListTile(
                title: const Text('عنوان IP للغرفة (شيره مع أصحابك):'),
                subtitle: SelectableText(
                  hostIpAddress,
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.greenAccent),
                ),
              ),
            ),
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
              const SizedBox(height: 50),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, minimumSize: const Size(double.infinity, 50)),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم الإبلاغ عن اجتماع طارئ!')));
                },
                icon: const Icon(Icons.warning),
                label: const Text('اجتماع طارئ / Emergency Meeting'),
              )
            ]
          ],
        ),
      ),
    );
  }
}

// ==================== شاشة العميل/اللاعب المنضم (Client Screen) ====================
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
  String statusMsg = "جاري الاتصال بالهوست...";

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
        statusMsg = "فشل الاتصال: تأكد من الـ IP وأن الهوست فاتح هوتسبوت";
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
              Text('اللاعبون بالداخل (${players.length}):', style: const TextStyle(fontSize: 18)),
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
              const SizedBox(height: 50),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, minimumSize: const Size(double.infinity, 50)),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم الإبلاغ عن اجتماع طارئ!')));
                },
                icon: const Icon(Icons.warning),
                label: const Text('اجتماع طارئ / Emergency Meeting'),
              )
            ]
          ],
        ),
      ),
    );
  }
}
