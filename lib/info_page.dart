import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

class Info extends StatelessWidget {
  const Info({super.key});
  Future<void> _launch(String? url) async {
    if (await canLaunchUrlString(url!)) {
      await launchUrlString(url);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            width: 120,
            height: 120,
            child: CircleAvatar(
              backgroundImage: AssetImage('assets/app_logo.png'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'WhatsChat Direct',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(10.0),
            child: Text(
              'Effortlessly open WhatsApp chats without saving numbers. Just enter the number and start chatting instantly.',
              textAlign: TextAlign.center,
            ),
          ),
          TextButton(
            onPressed: () {
              _launch('https://github.com/dracxi/whatschat_direct');
            },
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ImageIcon(
                  AssetImage('assets/github.png'),
                ),
                Text(" Source Code"),
              ],
            ),
          ),
          const Divider(
            indent: 20,
            endIndent: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: ListTile(
              onTap: () => _launch("https://github.com/dracxi"),
              tileColor: Colors.grey[800],
              shape: ContinuousRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              title: const Text("DracX"),
              subtitle: const Text('@dracxi'),
              trailing: const Text(
                "Developer",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                  height: -2,
                  color: Colors.purpleAccent,
                ),
              ),
              leading: const SizedBox(
                height: 60,
                width: 60,
                child: CircleAvatar(
                  backgroundImage: AssetImage("assets/pfp.jpg"),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
