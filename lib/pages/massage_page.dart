import 'package:flutter/material.dart';

class MassagePage extends StatefulWidget {
  const MassagePage({super.key});

  @override
  State<MassagePage> createState() => _MassagePageState();
}

class _MassagePageState extends State<MassagePage> {
  static const kGreen = Color(0xFF1E6B4C);
  final TextEditingController _searchC = TextEditingController();
  final TextEditingController _inputC = TextEditingController();

  String? _activeId;

  final List<_Thread> _threads = [
    _Thread(
      id: '1',
      name: 'Kevin Louis',
      avatar: 'assets/images/profile_avatar1.jpg',
      online: false,
      time: '2m ago',
      status: 'Read',
      preview: 'Hello William, Thankyou for your app',
      messages: [
        _Msg(false, 'Hello William, Thankyou for your app', '2m'),
        _Msg(true, 'Appreciate it Kevin!', '2m'),
      ],
    ),
    _Thread(
      id: '2',
      name: 'Olivia James',
      avatar: 'assets/images/profile_avatar2.jpg',
      online: false,
      time: '2m ago',
      status: 'Unread',
      preview: 'OK. Lorem ipsum dolor sect...',
      messages: [
        _Msg(false, 'OK. Lorem ipsum dolor sect...', '2m'),
        _Msg(true, 'Noted Liv, will check soon', '2m'),
      ],
    ),
    _Thread(
      id: '3',
      name: 'joko tingkir',
      avatar: 'assets/images/profile_avatar3.jpg',
      online: true,
      time: '2m ago',
      status: 'Pending',
      preview: 'Roger that sir, thankyou',
      messages: [
        _Msg(false, 'Could you review the banner?', '3m'),
        _Msg(true, 'Sure, send it here', '3m'),
        _Msg(false, 'Roger that sir, thankyou', '2m'),
      ],
    ),
    _Thread(
      id: '4',
      name: 'David Mckanzie',
      avatar: 'assets/images/profile_avatar4.jpg',
      online: true,
      time: '2m ago',
      status: 'Read',
      preview: 'Lorem ipsum dolor sit amet, consect...',
      messages: [
        _Msg(false, 'Lorem ipsum dolor sit amet, consect...', '2m'),
        _Msg(true, 'Looks good to me.', '2m'),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final thread = _threads.firstWhere(
      (t) => t.id == _activeId,
      orElse: () => _Thread.empty(),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () {
            if (_activeId != null) {
              setState(() => _activeId = null);
            } else {
              Navigator.pop(context);
            }
          },
        ),
        title: Text(
          _activeId == null ? 'Messages' : thread.name,
          style: const TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.black87),
            onPressed: () {},
          ),
        ],
      ),
      body: _activeId == null ? _buildList() : _buildConversation(thread),
    );
  }

  Widget _buildList() {
    final filtered = _threads.where((t) {
      final q = _searchC.text.trim().toLowerCase();
      if (q.isEmpty) return true;
      return t.name.toLowerCase().contains(q) ||
          t.preview.toLowerCase().contains(q);
    }).toList();

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
      children: [
        Container(
          height: 50,
          decoration: BoxDecoration(
            color: const Color(0xFFF5F6F7),
            borderRadius: BorderRadius.circular(28),
          ),
          child: TextField(
            controller: _searchC,
            onChanged: (_) => setState(() {}),
            decoration: const InputDecoration(
              hintText: 'Search...',
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 18),
              suffixIcon: Icon(Icons.search),
            ),
          ),
        ),
        const SizedBox(height: 14),
        ...filtered.map(
          (t) => _ThreadTile(
            thread: t,
            onTap: () => setState(() => _activeId = t.id),
          ),
        ),
      ],
    );
  }

  Widget _buildConversation(_Thread t) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            itemCount: t.messages.length,
            itemBuilder: (context, i) {
              final m = t.messages[i];
              return Align(
                alignment: m.fromMe
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.7,
                  ),
                  decoration: BoxDecoration(
                    color: m.fromMe ? kGreen : const Color(0xFFF2F4F7),
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(16),
                      topRight: const Radius.circular(16),
                      bottomLeft: Radius.circular(m.fromMe ? 16 : 4),
                      bottomRight: Radius.circular(m.fromMe ? 4 : 16),
                    ),
                  ),
                  child: Text(
                    m.text,
                    style: TextStyle(
                      color: m.fromMe ? Colors.white : Colors.black87,
                      fontSize: 15,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 16),
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Color(0x14000000),
                blurRadius: 8,
                offset: Offset(0, -2),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F6F7),
                    borderRadius: BorderRadius.circular(28),
                  ),
                  child: TextField(
                    controller: _inputC,
                    decoration: const InputDecoration(
                      hintText: 'Type a message',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              CircleAvatar(
                radius: 24,
                backgroundColor: kGreen,
                child: IconButton(
                  onPressed: () {
                    final txt = _inputC.text.trim();
                    if (txt.isEmpty) return;
                    setState(() {
                      t.messages.add(_Msg(true, txt, 'now'));
                      _inputC.clear();
                    });
                  },
                  icon: const Icon(Icons.send, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ThreadTile extends StatelessWidget {
  final _Thread thread;
  final VoidCallback onTap;

  const _ThreadTile({required this.thread, required this.onTap});

  static const kGreen = Color(0xFF1E6B4C);
  static const kGrey = Color(0xFF9FA5B0);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundImage: AssetImage(thread.avatar),
                ),
                if (thread.online)
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 2,
                          ),
                        ],
                      ),
                      child: Container(
                        margin: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                          color: kGreen,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    thread.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    thread.preview,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.black54, fontSize: 14),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Text(
                        thread.time,
                        style: const TextStyle(color: kGrey, fontSize: 12.5),
                      ),
                      const Spacer(),
                      if (thread.status == 'Unread')
                        const Text(
                          'Unread',
                          style: TextStyle(
                            color: kGrey,
                            fontWeight: FontWeight.w700,
                            fontSize: 12.5,
                          ),
                        ),
                      if (thread.status == 'Pending')
                        const Text(
                          'Pending',
                          style: TextStyle(
                            color: kGrey,
                            fontWeight: FontWeight.w700,
                            fontSize: 12.5,
                          ),
                        ),
                      if (thread.status == 'Read')
                        const Text(
                          'Read',
                          style: TextStyle(
                            color: kGreen,
                            fontWeight: FontWeight.w700,
                            fontSize: 12.5,
                          ),
                        ),
                      const SizedBox(width: 6),
                      Icon(
                        thread.status == 'Read'
                            ? Icons.check
                            : Icons.check_outlined,
                        size: 16,
                        color: thread.status == 'Read' ? kGreen : kGrey,
                      ),
                    ],
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

class _Thread {
  final String id;
  final String name;
  final String avatar;
  final String preview;
  final String time;
  final String status; 
  final bool online;
  final List<_Msg> messages;

  _Thread({
    required this.id,
    required this.name,
    required this.avatar,
    required this.preview,
    required this.time,
    required this.status,
    required this.online,
    required this.messages,
  });

  _Thread.empty()
    : id = '',
      name = '',
      avatar = 'assets/images/profile_avatar.jpg',
      preview = '',
      time = '',
      status = 'Read',
      online = false,
      messages = const [];
}

class _Msg {
  final bool fromMe;
  final String text;
  final String time;
  const _Msg(this.fromMe, this.text, this.time);
}
