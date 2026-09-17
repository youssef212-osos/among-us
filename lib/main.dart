import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Imposter Real-Life',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const GameHomeScreen(),
    );
  }
}

class GameHomeScreen extends StatefulWidget {
  const GameHomeScreen({super.key});

  @override
  State<GameHomeScreen> createState() => _GameHomeScreenState();
}

class _GameHomeScreenState extends State<GameHomeScreen> {
  String statusMessage = "جاهز للبدء";
  bool isServerRunning = false;
  RawDatagramSocket? socket;
  StreamSubscription? subscription;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Imposter Real-Life P2P'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Icon(
                Icons.sports_esports,
                size: 80,
                color: Colors.deepPurple,
              ),
              const SizedBox(height: 20),
              Text(
                statusMessage,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 40),
              ElevatedButton.icon(
                onPressed: isServerRunning ? stopLocalServer : startLocalServer,
                icon: Icon(isServerRunning ? Icons.stop : Icons.play_arrow),
                label: Text(isServerRunning ? 'إيقاف السيرفر المحلي' : 'تشغيل السيرفر المحلي'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  textStyle: const TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void startLocalServer() async {
    try {
      socket = await RawDatagramSocket.bind(InternetAddress.anyIPv4, 8888);
      setState(() {
        isServerRunning = true;
        statusMessage = "السيرفر شغال الآن على البورت 8888\nفي انتظار بقية اللاعبين...";
      });

      subscription = socket?.listen((RawSocketEvent event) {
        if (event == RawSocketEvent.read) {
          Datagram? dg = socket?.receive();
          if (dg != null) {
            String message = String.fromCharCodes(dg.data);
            setState(() {
              statusMessage = "تم استقبال رسالة: $message";
            });
          }
        }
      });
    } catch (e) {
      setState(() {
        statusMessage = "حدث خطأ أثناء تشغيل السيرفر: $e";
      });
    }
  }

  void stopLocalServer() {
    subscription?.cancel();
    socket?.close();
    setState(() {
      isServerRunning = false;
      statusMessage = "تم إيقاف السيرفر المحلي";
    });
  }

  @override
  void dispose() {
    stopLocalServer();
    super.dispose();
  }
}
