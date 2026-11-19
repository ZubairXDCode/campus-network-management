import 'package:material_ui/material_ui.dart';

const Color _ink = Color(0xFF172554);
const Color _muted = Color(0xFF64748B);
const Color _blue = Color(0xFF2563EB);
const Color _line = Color(0xFFE8EDF5);

class _Ev {
  final String day, month, title, place, tag, when;
  final Color color;
  final IconData icon;

  const _Ev(
    this.day,
    this.month,
    this.title,
    this.place,
    this.tag,
    this.when,
    this.color,
    this.icon,
  );
}

const List<_Ev> _events = [
  _Ev(
    '22',
    'NOV',
    'Tech & Innovation Meetup',
    'Main Auditorium • 10:00 AM',
    'Tech',
    'Upcoming',
    Color(0xFF2563EB),
    Icons.memory_rounded,
  ),
  _Ev(
    '25',
    'NOV',
    'Inter-College Football',
    'College Ground • 3:30 PM',
    'Sports',
    'Upcoming',
    Color(0xFF0F9D8A),
    Icons.sports_soccer_rounded,
  ),
  _Ev(
    '28',
    'NOV',
    'Design Thinking Workshop',
    'Seminar Hall • 11:00 AM',
    'Study',
    'Upcoming',
    Color(0xFF8B5CF6),
    Icons.lightbulb_rounded,
  ),
  _Ev(
    '02',
    'DEC',
    'Cultural Club Auditions',
    'Open Stage • 1:00 PM',
    'Culture',
    'Upcoming',
    Color(0xFFEA580C),
    Icons.theater_comedy_rounded,
  ),
];

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> with TickerProviderStateMixin {
  late final AnimationController _enter = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1500),
  )..forward();

  late final AnimationController _pulse = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1100),
  )..repeat(reverse: true);

  static const _vibes = ['All', 'Tech', 'Sports', 'Study', 'Culture'];

  int _vibe = 0;
  final Set<int> _joined = {};

  @override
  void dispose() {
    _enter.dispose();
    _pulse.dispose();
    super.dispose();
  }

  String get _greeting {
    final h = DateTime.now().hour;
    if (h < 12) return 'GOOD MORNING ☀️';
    if (h < 17) return 'GOOD AFTERNOON 👋';
    return 'GOOD EVENING 🌙';
  }

  Widget _reveal(int i, Widget child) {
    final start = (i * 0.09).clamp(0.0, 0.6);

    final anim = CurvedAnimation(
      parent: _enter,
      curve: Interval(start, start + 0.4, curve: Curves.easeOutCubic),
    );

    return FadeTransition(
      opacity: anim,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.08),
          end: Offset.zero,
        ).animate(anim),
        child: child,
      ),
    );
  }

  Widget _pad(Widget child) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: child,
    );
  }

  Widget _heading(String title, String action) {
    return _pad(
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: _ink,
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
          if (action.isNotEmpty)
            Text(
              action,
              style: const TextStyle(
                color: _blue,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _vibe == 0
        ? _events
        : _events.where((e) => e.tag == _vibes[_vibe]).toList();

    return ListView(
      padding: const EdgeInsets.only(top: 8, bottom: 100),
      children: [
        _reveal(0, _pad(_header())),
        const SizedBox(height: 18),
        _reveal(1, _pad(_searchBar())),
        const SizedBox(height: 20),
        _reveal(2, _stories()),
        const SizedBox(height: 22),
        _reveal(3, _pad(_liveCard())),
        const SizedBox(height: 26),
        _reveal(4, _heading('Pick your vibe', 'Customise')),
        const SizedBox(height: 12),
        _reveal(4, _vibeChips()),
        const SizedBox(height: 16),
        _reveal(5, _eventCarousel(filtered)),
        const SizedBox(height: 26),
        _reveal(6, _heading('Trending circles', 'See all')),
        const SizedBox(height: 12),
        _reveal(6, _circles()),
        const SizedBox(height: 26),
        _reveal(7, _heading('Quick poll', '')),
        const SizedBox(height: 12),
        _reveal(7, _pad(const _PollCard())),
        const SizedBox(height: 26),
        _reveal(8, _heading('Campus conversations', 'See feed')),
        const SizedBox(height: 12),
        _reveal(
          8,
          _pad(
            Column(
              children: const [
                _Post(
                  initials: 'AK',
                  name: 'Aarav Kumar',
                  time: '2 hours ago',
                  message: 'Anyone interested in forming a team for the upcoming hackathon? Let’s build something useful!',
                  likes: 24,
                  comments: 8,
                ),
                SizedBox(height: 12),
                _Post(
                  initials: 'SP',
                  name: 'Sneha Patel',
                  time: 'Yesterday',
                  message: 'The photography club is planning a campus photo walk this weekend. Everyone is welcome!',
                  likes: 18,
                  comments: 5,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 14),
        _pad(
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF7E6),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              'Preview mode: events and posts are sample content. They are not live campus updates.',
              style: TextStyle(color: Color(0xFF8A5A00), fontSize: 10),
            ),
          ),
        ),
      ],
    );
  }

  Widget _header() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              _greeting,
              style: const TextStyle(
                color: _blue,
                fontSize: 11,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.5,
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF1E6),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                '🔥 5-day streak',
                style: TextStyle(
                  color: Color(0xFFEA580C),
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ShaderMask(
          shaderCallback: (rect) =>
              const LinearGradient(colors: [_ink, _blue, Color(0xFF8B5CF6)])
                  .createShader(rect),
          child: const Text(
            'Your campus,\nyour community.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 30,
              height: 1.15,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ],
    );
  }

  Widget _searchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: _line),
        boxShadow: [
          BoxShadow(
            color: _blue.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.search_rounded, color: _muted),
          const SizedBox(width: 10),
          const Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search people, events, communities',
                hintStyle: TextStyle(color: _muted, fontSize: 12),
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _stories() {
    const items = [
      ('You', Icons.add_rounded, true),
      ('Hackathon', Icons.code_rounded, false),
      ('Football', Icons.sports_soccer_rounded, false),
      ('Photo Club', Icons.camera_alt_rounded, false),
      ('ML Club', Icons.psychology_rounded, false),
      ('Music', Icons.music_note_rounded, false),
    ];

    return SizedBox(
      height: 92,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: items.length,
        separatorBuilder: (_, _) => const SizedBox(width: 14),
        itemBuilder: (context, i) {
          final (label, icon, isYou) = items[i];

          return Column(
            children: [
              Container(
                height: 62,
                width: 62,
                padding: const EdgeInsets.all(2.5),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: isYou
                      ? null
                      : const LinearGradient(
                          colors: [
                            Color(0xFF2563EB),
                            Color(0xFF8B5CF6),
                            Color(0xFFEA580C),
                          ],
                        ),
                  border: isYou ? Border.all(color: _line, width: 2) : null,
                ),
                child: Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  padding: const EdgeInsets.all(2.5),
                  child: CircleAvatar(
                    backgroundColor: const Color(0xFFEAF0FF),
                    child: Icon(icon, color: _blue, size: 24),
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                label,
                style: const TextStyle(
                  color: _ink,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _liveCard() {
    return Container(
      clipBehavior: Clip.antiAlias,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: [Color(0xFF0F172A), Color(0xFF172554), Color(0xFF2563EB)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: _blue.withValues(alpha: 0.35),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -30,
            top: -30,
            child: Container(
              height: 120,
              width: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.06),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  AnimatedBuilder(
                    animation: _pulse,
                    builder: (context, _) => Container(
                      height: 10,
                      width: 10,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFFEF4444),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFEF4444)
                                .withValues(alpha: 0.7 * _pulse.value),
                            blurRadius: 4 + 10 * _pulse.value,
                            spreadRadius: 1 + 4 * _pulse.value,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'HAPPENING NOW',
                    style: TextStyle(
                      color: Color(0xFFBFDBFE),
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.4,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              const Text(
                'Hackathon Team Formation',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Room 204 • Find teammates for the 24h build',
                style: TextStyle(color: Color(0xFFDBEAFE), fontSize: 11),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  SizedBox(
                    width: 84,
                    height: 30,
                    child: Stack(
                      children: [
                        for (var i = 0; i < 4; i++)
                          Positioned(
                            left: i * 17.0,
                            child: CircleAvatar(
                              radius: 15,
                              backgroundColor: Colors.white,
                              child: CircleAvatar(
                                radius: 13,
                                backgroundColor: [
                                  const Color(0xFF8B5CF6),
                                  const Color(0xFF0F9D8A),
                                  const Color(0xFFEA580C),
                                  const Color(0xFF2563EB),
                                ][i],
                                child: Text(
                                  'ARSK'[i],
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const Text(
                    '+36 joined',
                    style: TextStyle(color: Color(0xFFDBEAFE), fontSize: 11),
                  ),
                  const Spacer(),
                  FilledButton(
                    onPressed: () {},
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: _ink,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Join',
                      style: TextStyle(fontWeight: FontWeight.w800),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _vibeChips() {
    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: _vibes.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final on = i == _vibe;

          return GestureDetector(
            onTap: () => setState(() => _vibe = i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOut,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: on ? _ink : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: on ? _ink : _line),
              ),
              child: Text(
                _vibes[i],
                style: TextStyle(
                  color: on ? Colors.white : _muted,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _eventCarousel(List<_Ev> list) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: SizedBox(
        key: ValueKey(_vibe),
        height: 176,
        child: list.isEmpty
            ? const Center(
                child: Text(
                  'No events for this vibe yet',
                  style: TextStyle(color: _muted, fontSize: 12),
                ),
              )
            : ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: list.length,
                separatorBuilder: (_, _) => const SizedBox(width: 12),
                itemBuilder: (context, i) => _eventTile(list[i]),
              ),
      ),
    );
  }

  Widget _eventTile(_Ev e) {
    return Container(
      width: 250,
      clipBehavior: Clip.antiAlias,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: LinearGradient(
          colors: [e.color, e.color.withValues(alpha: 0.7)],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -14,
            bottom: -14,
            child: Icon(
              e.icon,
              size: 96,
              color: Colors.white.withValues(alpha: 0.18),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.22),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '${e.day} ${e.month}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    e.when,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Text(
                e.tag.toUpperCase(),
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.85),
                  fontSize: 9,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                e.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  height: 1.2,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                e.place,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.9),
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _circles() {
    const data = [
      (
        'AI & ML Club',
        '1.2k members',
        Icons.psychology_rounded,
        Color(0xFF2563EB),
      ),
      (
        'Football Squad',
        '860 members',
        Icons.sports_soccer_rounded,
        Color(0xFF0F9D8A),
      ),
      (
        'Shutterbugs',
        '540 members',
        Icons.camera_alt_rounded,
        Color(0xFF8B5CF6),
      ),
      ('Open Mic', '410 members', Icons.mic_rounded, Color(0xFFEA580C)),
    ];

    return SizedBox(
      height: 150,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: data.length,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (context, i) {
          final (name, members, icon, color) = data[i];
          final joined = _joined.contains(i);

          return Container(
            width: 140,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: _line),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 38,
                  width: 38,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color, size: 22),
                ),
                const Spacer(),
                Text(
                  name,
                  style: const TextStyle(
                    color: _ink,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  members,
                  style: const TextStyle(color: _muted, fontSize: 10),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      if (joined) {
                        _joined.remove(i);
                      } else {
                        _joined.add(i);
                      }
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    height: 26,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: joined ? color : color.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      joined ? 'Joined ✓' : 'Join',
                      style: TextStyle(
                        color: joined ? Colors.white : color,
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _PollCard extends StatefulWidget {
  const _PollCard();

  @override
  State<_PollCard> createState() => _PollCardState();
}

class _PollCardState extends State<_PollCard> {
  static const _options = ['Main Canteen', 'Library Lawn', 'Open Stage'];

  final List<int> _votes = [42, 31, 19];
  int? _choice;

  void _vote(int i) {
    if (_choice != null) return;

    setState(() {
      _choice = i;
      _votes[i]++;
    });
  }

  @override
  Widget build(BuildContext context) {
    final total = _votes.reduce((a, b) => a + b);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Where should the next meetup be?',
            style: TextStyle(
              color: _ink,
              fontSize: 13,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          for (var i = 0; i < _options.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: GestureDetector(
                onTap: () => _vote(i),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final pct = _votes[i] / total;
                    final mine = _choice == i;

                    return Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5FB),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: mine ? _blue : Colors.transparent,
                          width: 1.5,
                        ),
                      ),
                      child: Stack(
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 600),
                            curve: Curves.easeOutCubic,
                            width: _choice == null
                                ? 0
                                : constraints.maxWidth * pct,
                            decoration: BoxDecoration(
                              color: _blue.withValues(
                                alpha: mine ? 0.25 : 0.12,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Row(
                              children: [
                                Text(
                                  _options[i],
                                  style: const TextStyle(
                                    color: _ink,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const Spacer(),
                                if (_choice != null)
                                  Text(
                                    '${(pct * 100).round()}%',
                                    style: const TextStyle(
                                      color: _blue,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          Text(
            _choice == null ? 'Tap to vote' : '$total votes',
            style: const TextStyle(color: _muted, fontSize: 10),
          ),
        ],
      ),
    );
  }
}

class _Post extends StatefulWidget {
  final String initials, name, time, message;
  final int likes, comments;

  const _Post({
    required this.initials,
    required this.name,
    required this.time,
    required this.message,
    required this.likes,
    required this.comments,
  });

  @override
  State<_Post> createState() => _PostState();
}

class _PostState extends State<_Post> {
  bool _liked = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: _line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 19,
                backgroundColor: const Color(0xFFE7EEFF),
                child: Text(
                  widget.initials,
                  style: const TextStyle(
                    color: _blue,
                    fontWeight: FontWeight.w800,
                    fontSize: 11,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.name,
                      style: const TextStyle(
                        color: _ink,
                        fontWeight: FontWeight.w800,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      widget.time,
                      style: const TextStyle(
                        color: Color(0xFF94A3B8),
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.more_horiz_rounded, color: Color(0xFF94A3B8)),
            ],
          ),
          const SizedBox(height: 13),
          Text(
            widget.message,
            style: const TextStyle(
              color: Color(0xFF334155),
              fontSize: 12,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 14),
          const Divider(height: 1, color: Color(0xFFEEF1F6)),
          const SizedBox(height: 10),
          Row(
            children: [
              GestureDetector(
                onTap: () => setState(() => _liked = !_liked),
                child: Row(
                  children: [
                    AnimatedScale(
                      scale: _liked ? 1.3 : 1.0,
                      duration: const Duration(milliseconds: 350),
                      curve: Curves.elasticOut,
                      child: Icon(
                        _liked
                            ? Icons.favorite_rounded
                            : Icons.favorite_border_rounded,
                        size: 18,
                        color: _liked ? const Color(0xFFEF4444) : _muted,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      '${widget.likes + (_liked ? 1 : 0)}',
                      style: const TextStyle(color: _muted, fontSize: 10),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              const Icon(Icons.mode_comment_outlined, size: 16, color: _muted),
              const SizedBox(width: 5),
              Text(
                '${widget.comments}',
                style: const TextStyle(color: _muted, fontSize: 10),
              ),
              const Spacer(),
              const Icon(Icons.share_outlined, size: 16, color: _muted),
            ],
          ),
        ],
      ),
    );
  }
}

/// Main screen displayed after a successful login or signup.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFFF8FAFC),
      body: SafeArea(child: HomeTab()),
    );
  }
}
