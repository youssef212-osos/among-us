Future<void> _joinRoom(ResolvedBonsoirService room) async {
    final String? host = room.host;
    if (host == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('عنوان السيرفر غير صالح')),
      );
      return;
    }

    try {
      String url = 'http://$host:${room.port}/join?name=${Uri.encodeComponent(widget.playerName)}&avatar=${Uri.encodeComponent(widget.avatarUrl)}';
      await http.get(Uri.parse(url));

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ClientWaitingRoom(
            playerName: widget.playerName,
            hostIp: host,
            hostPort: room.port,
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('تعذر الانضمام: $e')));
    }
  }
