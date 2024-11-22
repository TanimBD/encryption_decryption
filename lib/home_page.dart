import 'package:flutter/material.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var textMessageController = TextEditingController();
  String? encryptedMessage;
  String? decryptedMessage;
  final initVector = encrypt.IV.fromLength(16);
  final encrypter =
      encrypt.Encrypter(encrypt.AES(encrypt.Key.fromUtf8("16characterslong")));

  void encryptMessage() {
    final message = textMessageController.text;
    if (message.isNotEmpty) {
      final encrypted = encrypter.encrypt(message, iv: initVector);
      setState(() {
        encryptedMessage = encrypted.base64;
      });
    }
  }




  void decryptMessage() {
    final encryptedData = encrypt.Encrypted.fromBase64(encryptedMessage!);
    final decryptData=encrypter.decrypt(encryptedData,iv: initVector);



      setState(() {
        decryptedMessage = decryptData;
      });

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text("Encryption"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(22.0),
            child: TextField(
              controller: textMessageController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Message",
                labelText: "Enter your message",
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          ElevatedButton(
              onPressed: () {
                encryptMessage();
              },
              child: Text("Encrypt Message")),
          SizedBox(
            height: 15,
          ),
          Text(
            "Encrypted Message",
            style: TextStyle(
              fontWeight: FontWeight.w100,
            ),
          ),
          SizedBox(
            height: 15,
          ),
          if (encryptedMessage != null) ...[
            Text(encryptedMessage!),
            SizedBox(
              height: 15,
            ),
            ElevatedButton(onPressed: (){
                 decryptMessage();
            }, child: Text("Decrypt message")),
            SizedBox(
              height: 15,
            ),


          ],
          if(decryptedMessage != null)...[
            AnimatedContainer(
              decoration: BoxDecoration(
                  color: Colors.grey,

              ),
              duration: Durations.extralong2,
              child: Text(decryptedMessage!,
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 30,
                ),
              ),
            )
          ]
        ],
      ),
    );
  }
}
