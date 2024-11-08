import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ValorantFriendsPage extends StatefulWidget{
  const ValorantFriendsPage({Key? key}) : super(key: key);

  @override
  _ValorantFriendsPageState createState() => _ValorantFriendsPageState();
}

class _ValorantFriendsPageState extends State<ValorantFriendsPage> {
  void _launchDiscordInvite(BuildContext context) async {
    const String _discordInviteUrl = 'https://discord.com/invite/valorant';

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
        title: const Text('Valorant Find Friends'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Join the official Valorant Discord to find teammates and be apart of our gaming community!',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () => _launchDiscordInvite(context),
              icon: const Icon(Icons.chat),
              label: const Text('Join Valorant Discord server'),
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