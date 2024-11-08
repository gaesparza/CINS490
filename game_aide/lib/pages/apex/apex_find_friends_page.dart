import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ApexFindFriendsPage extends StatefulWidget{
  const ApexFindFriendsPage({Key? key}) : super(key: key);

  @override
  _ApexFindFriendsPageState createState() => _ApexFindFriendsPageState();
}

class _ApexFindFriendsPageState extends State<ApexFindFriendsPage> {
  void _launchDiscordInvite(BuildContext context) async {
    const String _discordInviteUrl = 'https://discord.gg/apexlegends';

    final Uri uri = Uri.parse(_discordInviteUrl);

    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not launch Discord link')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Find Friends'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Join the official Apex Legends Discord to find teammates and be apart of our gaming community!',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () => _launchDiscordInvite(context),
              icon: const Icon(Icons.chat),
              label: const Text('Join Apex Discord server'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightBlue,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                textStyle: const TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
