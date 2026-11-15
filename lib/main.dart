import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

void main() => runApp(const AccelerometerApp());

class AccelerometerApp extends StatelessWidget {
  const AccelerometerApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Phone Movement Sensor',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF3659A8)),
          scaffoldBackgroundColor: const Color(0xFFF7F8FC),
          useMaterial3: true,
        ),
        home: const AccelerometerPage(),
      );
}

class AccelerometerPage extends StatefulWidget {
  const AccelerometerPage({super.key});

  @override
  State<AccelerometerPage> createState() => _AccelerometerPageState();
}

class _AccelerometerPageState extends State<AccelerometerPage> {
  StreamSubscription<AccelerometerEvent>? _subscription;
  double? _x;
  double? _y;
  double? _z;
  String _status = 'The sensor is not collecting readings right now.';

  bool get _isListening => _subscription != null;

  void _startListening() {
    if (_isListening) return;
    try {
      final subscription = accelerometerEventStream().listen(
        (event) {
          if (!mounted) return;
          setState(() {
            _x = event.x;
            _y = event.y;
            _z = event.z;
          });
        },
        onError: (Object error) {
          if (!mounted) return;
          setState(() => _status = 'Could not read accelerometer data.');
        },
      );
      setState(() {
        _subscription = subscription;
        _status = 'Readings are updating live as you move or tilt your phone.';
      });
    } catch (_) {
      setState(() => _status = 'Could not start the phone movement sensor.');
    }
  }

  Future<void> _stopListening() async {
    final subscription = _subscription;
    if (subscription == null) return;
    setState(() {
      _subscription = null;
      _status = 'The sensor is not collecting readings right now.';
    });
    await subscription.cancel();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
          children: [
            Text('Phone movement sensor', style: theme.textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text(
              'This app measures movement and tilt using your phone\'s accelerometer.',
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 20),
            _StatusCard(isActive: _isListening, message: _status),
            const SizedBox(height: 24),
            Text('Your phone\'s axes', style: theme.textTheme.titleLarge),
            const SizedBox(height: 4),
            Text(
              'The directions below belong to the phone itself. Hold it in front of you to try them.',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 12),
            _AxisCard(
              axis: 'X axis', value: _x, icon: Icons.swap_horiz_rounded,
              accent: const Color(0xFF2855A6), direction: 'Left and right',
              explanation: 'Tilt the left or right side of your phone down to change this value.',
            ),
            const SizedBox(height: 12),
            _AxisCard(
              axis: 'Y axis', value: _y, icon: Icons.swap_vert_rounded,
              accent: const Color(0xFF0E766E), direction: 'Top and bottom',
              explanation: 'Tilt the top or bottom of your phone down to change this value.',
            ),
            const SizedBox(height: 12),
            _AxisCard(
              axis: 'Z axis', value: _z, icon: Icons.unfold_more_rounded,
              accent: const Color(0xFF8A4C00), direction: 'Through the screen',
              explanation: 'This shows acceleration going into or out from the screen.',
            ),
            const SizedBox(height: 24),
            if (_isListening)
              FilledButton.icon(onPressed: _stopListening, icon: const Icon(Icons.stop_rounded), label: const Text('Stop sensor'))
            else
              FilledButton.icon(onPressed: _startListening, icon: const Icon(Icons.play_arrow_rounded), label: const Text('Start sensor')),
            const SizedBox(height: 24),
            _InfoSection(
              icon: Icons.touch_app_outlined, title: 'Try it yourself',
              child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                _Step(number: '1', text: 'Press Start sensor.'),
                _Step(number: '2', text: 'Hold the phone flat.'),
                _Step(number: '3', text: 'Tilt it left and right.'),
                _Step(number: '4', text: 'Tilt it forward and backward.'),
                _Step(number: '5', text: 'Watch how the values change.'),
              ]),
            ),
            const SizedBox(height: 12),
            _InfoSection(
              icon: Icons.public_rounded, title: 'Why do values change?',
              child: const Text('Your phone can show acceleration values even when it is not moving because the sensor also measures gravity. When you tilt your phone, the values change.'),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusCard extends StatelessWidget {
  const _StatusCard({required this.isActive, required this.message});
  final bool isActive;
  final String message;

  @override
  Widget build(BuildContext context) {
    final color = isActive ? const Color(0xFF087A4B) : const Color(0xFF555B6A);
    return Semantics(
      liveRegion: true,
      label: isActive ? 'Sensor active. $message' : 'Sensor stopped. $message',
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.10), borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.35)),
        ),
        child: Row(children: [
          Icon(isActive ? Icons.sensors_rounded : Icons.sensors_off_rounded, color: color),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(isActive ? 'Sensor active' : 'Sensor stopped', style: Theme.of(context).textTheme.titleSmall?.copyWith(color: color)),
            const SizedBox(height: 2), Text(message),
          ])),
        ]),
      ),
    );
  }
}

class _AxisCard extends StatelessWidget {
  const _AxisCard({required this.axis, required this.value, required this.icon, required this.accent, required this.direction, required this.explanation});
  final String axis;
  final double? value;
  final IconData icon;
  final Color accent;
  final String direction;
  final String explanation;

  @override
  Widget build(BuildContext context) {
    final reading = value == null ? '--' : value!.toStringAsFixed(2);
    return Card(
      elevation: 0, clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: accent.withValues(alpha: 0.12), shape: BoxShape.circle),
            child: Icon(icon, color: accent, size: 28, semanticLabel: direction),
          ),
          const SizedBox(width: 14),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(axis, style: Theme.of(context).textTheme.titleMedium),
            Text(direction, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: accent)),
            const SizedBox(height: 8),
            RichText(text: TextSpan(
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: accent),
              children: [TextSpan(text: reading), const TextSpan(text: ' m/s²')],
            )),
            const SizedBox(height: 8), Text(explanation),
          ])),
        ]),
      ),
    );
  }
}

class _InfoSection extends StatelessWidget {
  const _InfoSection({required this.icon, required this.title, required this.child});
  final IconData icon;
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) => Card(
    elevation: 0,
    color: Theme.of(context).colorScheme.surfaceContainerLowest,
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [Icon(icon, color: Theme.of(context).colorScheme.primary), const SizedBox(width: 8), Text(title, style: Theme.of(context).textTheme.titleMedium)]),
        const SizedBox(height: 12), child,
      ]),
    ),
  );
}

class _Step extends StatelessWidget {
  const _Step({required this.number, required this.text});
  final String number;
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      CircleAvatar(radius: 12, child: Text(number)),
      const SizedBox(width: 10), Expanded(child: Text(text)),
    ]),
  );
}
