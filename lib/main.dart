import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

void main() => runApp(const AccelerometerApp());

class AccelerometerApp extends StatelessWidget {
  const AccelerometerApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Accelerometer Practice',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
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
  String _status = 'Press Start accelerometer to begin.';

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
        _status = 'Accelerometer is running. Move or tilt your phone.';
      });
    } catch (_) {
      setState(() => _status = 'Could not start the accelerometer.');
    }
  }

  Future<void> _stopListening() async {
    final subscription = _subscription;
    if (subscription == null) return;

    setState(() {
      _subscription = null;
      _status = 'Accelerometer stopped.';
    });
    await subscription.cancel();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Accelerometer Practice')),
    body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(_status, style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: _AxisCard(axis: 'X', value: _x),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _AxisCard(axis: 'Y', value: _y),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _AxisCard(axis: 'Z', value: _z),
                ),
              ],
            ),
            const SizedBox(height: 32),
            FilledButton.icon(
              onPressed: _isListening ? null : _startListening,
              icon: const Icon(Icons.play_arrow),
              label: const Text('Start accelerometer'),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: _isListening ? _stopListening : null,
              icon: const Icon(Icons.stop),
              label: const Text('Stop accelerometer'),
            ),
            const SizedBox(height: 24),
            Text(
              'Values are measured in m/s² and include gravity. '
              'Tilt the phone slowly to see each axis change.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    ),
  );
}

class _AxisCard extends StatelessWidget {
  const _AxisCard({required this.axis, required this.value});

  final String axis;
  final double? value;

  @override
  Widget build(BuildContext context) {
    final reading = value == null ? '--' : value!.toStringAsFixed(2);
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
        child: Column(
          children: [
            Text(axis, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(reading, style: Theme.of(context).textTheme.titleMedium),
            const Text('m/s²'),
          ],
        ),
      ),
    );
  }
}
