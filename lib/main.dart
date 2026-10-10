
import 'package:flutter/material.dart';

void main() {
  runApp(const SOSNetApp());
}

class SOSNetApp extends StatelessWidget {
  const SOSNetApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SOSNet',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF174A8B),
        ),
        useMaterial3: true,
      ),
      home: const SOSNetHome(),
    );
  }
}

class SOSNetHome extends StatelessWidget {
  const SOSNetHome({super.key});

  @override
  Widget build(BuildContext context) {
    const blu = Color(0xFF174A8B);
    const rosso = Color(0xFFD62828);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: blu,
        foregroundColor: Colors.white,
        title: const Row(
          children: [
            Icon(Icons.favorite, color: Colors.redAccent, size: 30),
            SizedBox(width: 10),
            Text(
              'SOSNet',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Un SOS, mille cuori in ascolto',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    color: blu,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 36),
                SizedBox(
                  width: 210,
                  height: 210,
                  child: ElevatedButton(
                    onPressed: () {
                      showDialog<void>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('SOSNet'),
                          content: const Text(
                            'Questa è una versione di prova. '
                            'Il pulsante SOS non invia ancora '
                            'richieste di soccorso.',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Ho capito'),
                            ),
                          ],
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: rosso,
                      foregroundColor: Colors.white,
                      shape: const CircleBorder(),
                      elevation: 5,
                    ),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.favorite, size: 52),
                        SizedBox(height: 8),
                        Text(
                          'SOS',
                          style: TextStyle(
                            fontSize: 34,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'CHIEDI AIUTO',
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 64,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      showDialog<void>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('I miei contatti'),
                          content: const Text(
                            'La rubrica dei contatti sarà '
                            'aggiunta in una prossima versione.',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Chiudi'),
                            ),
                          ],
                        ),
                      );
                    },
                    icon: const Icon(Icons.people, size: 30),
                    label: const Text(
                      'I MIEI CONTATTI',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: blu,
                      side: const BorderSide(color: blu, width: 2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Semplice. Vicino a te.',
                  style: TextStyle(color: Colors.black54, fontSize: 15),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
