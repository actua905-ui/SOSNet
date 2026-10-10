
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
          child: SingleChildScrollView(
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
                        builder: (dialogContext) => AlertDialog(
                          title: const Text('SOSNet - Versione di prova'),
                          content: const Text(
                            'Il pulsante SOS non invia ancora '
                            'richieste di soccorso reali.',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () =>
                                  Navigator.pop(dialogContext),
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
                        Text('CHIEDI AIUTO'),
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ContactsPage(),
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

class ContactsPage extends StatefulWidget {
  const ContactsPage({super.key});

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  static const storageKey = 'sosnet_contacts';

  List<Map<String, String>> contacts = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadContacts();
  }

  Future<void> loadContacts() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final saved = prefs.getString(storageKey);

      if (saved != null) {
        final List<dynamic> decoded = jsonDecode(saved);
        contacts = decoded.map((item) {
          return Map<String, String>.from(item);
        }).toList();
      }
    } catch (_) {
      contacts = [];
    }

    if (mounted) {
      setState(() => loading = false);
    }
  }

  Future<void> saveContacts() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(storageKey, jsonEncode(contacts));
  }

  Future<void> addContact() async {
    final nameController = TextEditingController();
    final phoneController = TextEditingController();

    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Nuovo contatto'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Nome e cognome',
                  prefixIcon: Icon(Icons.person),
                ),
                textCapitalization: TextCapitalization.words,
              ),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(
                  labelText: 'Numero di telefono',
                  prefixIcon: Icon(Icons.phone),
                ),
                keyboardType: TextInputType.phone,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Annulla'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.trim().isNotEmpty &&
                  phoneController.text.trim().isNotEmpty) {
                Navigator.pop(dialogContext, true);
              }
            },
            child: const Text('Salva'),
          ),
        ],
      ),
    );

    if (result == true && mounted) {
      setState(() {
        contacts.add({
          'name': nameController.text.trim(),
          'phone': phoneController.text.trim(),
        });
      });

      try {
        await saveContacts();
      } catch (_) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Non è stato possibile salvare il contatto.'),
            ),
          );
        }
      }
    }

    nameController.dispose();
    phoneController.dispose();
  }

  Future<void> deleteContact(int index) async {
    final removed = contacts.removeAt(index);
    setState(() {});

    try {
      await saveContacts();
    } catch (_) {
      if (mounted) {
        setState(() => contacts.insert(index, removed));
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Non è stato possibile eliminare il contatto.'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const blu = Color(0xFF174A8B);

    return Scaffold(
      appBar: AppBar(
        title: const Text('I miei contatti'),
        backgroundColor: blu,
        foregroundColor: Colors.white,
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : contacts.isEmpty
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: Text(
                      'Non hai ancora aggiunto contatti.\n'
                      'Premi + per inserire una persona fidata.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 17),
                    ),
                  ),
                )
              : ListView.builder(
                  itemCount: contacts.length,
                  itemBuilder: (context, index) {
                    final contact = contacts[index];
                    return ListTile(
                      leading: const CircleAvatar(
                        backgroundColor: blu,
                        child: Icon(Icons.person, color: Colors.white),
                      ),
                      title: Text(contact['name'] ?? ''),
                      subtitle: Text(contact['phone'] ?? ''),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline),
                        tooltip: 'Elimina contatto',
                        onPressed: () => deleteContact(index),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: addContact,
        backgroundColor: blu,
        foregroundColor: Colors.white,
        tooltip: 'Aggiungi contatto',
        child: const Icon(Icons.add),
      ),
    );
  }
}
