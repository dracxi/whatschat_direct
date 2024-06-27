import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatschat_direct/db_helper.dart';
import 'package:whatschat_direct/info_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const HomePage(),
      theme: ThemeData.dark(
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _number = '';
  String _message = '';

  List<Map<String, dynamic>> chats = [];
  bool isLoading = true;

  void _refreshData() async {
    final data = await Mydb.getItems();
    setState(() {
      chats = data;
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  Future<void> _launchWhatsApp(String number, String message) async {
    final uri =
        Uri.parse('https://wa.me/$number?text=${Uri.encodeComponent(message)}');
    if (await canLaunchUrl(uri)) {
      Mydb.createItem(number, message);
      _refreshData();
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not launch WhatsApp'),
        ),
      );
    }
  }

  Future<void> _showDialog(String? number) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Launch Chat"),
          actionsAlignment: MainAxisAlignment.center,
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: TextFormField(
                    keyboardType: TextInputType.phone,
                    initialValue: number!,
                    decoration: InputDecoration(
                      labelText: "Number",
                      hintText: "1234567890",
                      prefixIcon: const Icon(Icons.dialpad_rounded),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _number = value;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty || value.length <= 1) {
                        return "Please input a valid number";
                      }
                      if (number.isNotEmpty) {
                        setState(() {
                          _number = number;
                        });
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: "Message",
                      prefixIcon: const Icon(Icons.message),
                      hintText: "hello there!",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _message = value;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please input a message";
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      Navigator.of(context).pop();
                      _launchWhatsApp(_number, _message);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text("Launch"),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "WhatsChat direct",
          style: Theme.of(context)
              .textTheme
              .headlineSmall
              ?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: const Icon(Icons.more_vert_rounded),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Info(),
                    ));
              },
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: Text(
              "Messages",
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          Expanded(
            child: ChatView(
                chats: chats,
                showDialog: _showDialog,
                onDelete: () {
                  _refreshData();
                }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.grey[800],
        onPressed: () {
          _showDialog(_number);
        },
        child: const Icon(
          Icons.add_comment,
          color: Colors.grey,
        ),
      ),
    );
  }
}

class ChatView extends StatefulWidget {
  final Function showDialog;
  final Function onDelete;
  final List<Map<String, dynamic>> chats;
  const ChatView(
      {super.key,
      required this.showDialog,
      required this.chats,
      required this.onDelete});
  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  @override
  Widget build(BuildContext context) {
    if (widget.chats.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: const Text("Add chat"),
            subtitle: const Text("added chats will appear here"),
            onTap: () {
              widget.showDialog("");
            },
            leading: SizedBox(
              width: 60,
              height: 60,
              child: CircleAvatar(
                backgroundColor: Colors.grey[800],
                child: IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.add,
                    size: 30,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 50),
            child: Center(
              child: Lottie.asset('assets/chat.json'),
            ),
          ),
        ],
      );
    } else {
      return ListView.builder(
        itemCount: widget.chats.length,
        itemBuilder: (context, index) {
          final chat = widget.chats[index];
          return Dismissible(
            key: Key(chat['id'].toString()),
            direction: DismissDirection.endToStart,
            background: Container(
              color: Colors.grey[700],
              padding: const EdgeInsets.symmetric(horizontal: 20),
              alignment: Alignment.centerRight,
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            onDismissed: (direction) {
              Mydb.deleteItem(chat['id']);
              widget.onDelete();
            },
            confirmDismiss: (DismissDirection direction) async {
              return await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text("Confirm"),
                    content: const Text(
                        "Are you sure you want to delete this item?"),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: const Text("Delete"),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: const Text("Cancel"),
                      ),
                    ],
                  );
                },
              );
            },
            child: ListTile(
              title: Text(chat['number']),
              subtitle: Text(chat['message']),
              trailing: Text(chat['createdAt']),
              onTap: () {
                widget.showDialog(chat['number']);
              },
              leading: const SizedBox(
                width: 60,
                height: 60,
                child: CircleAvatar(
                  backgroundImage: AssetImage('assets/profile.jpg'),
                ),
              ),
            ),
          );
        },
      );
    }
  }
}
