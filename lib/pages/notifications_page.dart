import 'package:flutter/material.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  static const kGreen = Color(0xFF1E6B4C);
  static const kGrey = Color(0xFF9FA5B0);

  final List<_NotifItem> _items = [
    _NotifItem(
      title: 'Apply Success',
      desc: 'You has apply an job in Queenify Group as UI Designer',
      time: '10h ago',
      unread: true,
    ),
    _NotifItem(
      title: 'Interview Calls',
      desc:
          'Congratulations! You have interview calls tomorrow. Check schedule here..',
      time: '4m ago',
      unread: true,
    ),
    _NotifItem(
      title: 'Apply Success',
      desc: 'You has apply an job in Queenify Group as UI Designer',
      time: '8h ago',
      unread: false,
    ),
    _NotifItem(
      title: 'Complete your profile',
      desc: 'Please verify your profile information to continue using this app',
      time: '4h ago',
      unread: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Notifications',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w800,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.black87),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
        itemCount: _items.length,
        itemBuilder: (context, i) {
          final n = _items[i];
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.fromLTRB(18, 20, 18, 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 14,
                  spreadRadius: 1,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    if (n.unread) ...[
                      Container(
                        width: 12,
                        height: 12,
                        decoration: const BoxDecoration(
                          color: kGreen,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 10),
                    ],
                    Expanded(
                      child: Text(
                        n.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: Colors.black87,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  n.desc,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 15,
                    height: 1.55,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Icon(Icons.access_time, size: 16, color: kGrey),
                    const SizedBox(width: 8),
                    Text(
                      n.time,
                      style: const TextStyle(
                        color: kGrey,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    InkWell(
                      onTap: () {
                        setState(() => _items[i] = n.copyWith(unread: false));
                      },
                      borderRadius: BorderRadius.circular(8),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 6,
                        ),
                        child: Text(
                          'Mark as read',
                          style: TextStyle(
                            color: kGreen,
                            fontWeight: FontWeight.w800,
                            fontSize: 15,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _NotifItem {
  final String title;
  final String desc;
  final String time;
  final bool unread;

  const _NotifItem({
    required this.title,
    required this.desc,
    required this.time,
    required this.unread,
  });

  _NotifItem copyWith({
    String? title,
    String? desc,
    String? time,
    bool? unread,
  }) {
    return _NotifItem(
      title: title ?? this.title,
      desc: desc ?? this.desc,
      time: time ?? this.time,
      unread: unread ?? this.unread,
    );
  }
}
