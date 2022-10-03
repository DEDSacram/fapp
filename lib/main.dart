import 'dart:io';
import 'package:flutter/material.dart';
import 'package:window_size/window_size.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    setWindowTitle('Happy Flappy');
    setWindowMinSize(const Size(500, 300));
    setWindowMaxSize(Size.infinite);
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fciphers',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "krun". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.grey,
      ),
      home: const MyPage(title: 'Fapp'),
    );
  }
}

class ButtonWidget extends StatelessWidget {
  final String text;
  final VoidCallback onClicked;

  const ButtonWidget({
    required this.text,
    required this.onClicked,
    required Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => TextButton(
        onPressed: onClicked,
        child: Text(
          text,
          style: const TextStyle(fontSize: 24),
        ),
      );
}

class MyPage extends StatefulWidget {
  const MyPage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  final formKey = GlobalKey<FormState>();
  final monKey = GlobalKey<FormState>();
  var redraw = Object();
  late TextEditingController _c;

  int row = 26;

  List<Widget> wid = <Widget>[];
  List<String> list = <String>['Caesar', 'Playfair'];

  String chosen = "";
  @override
  void initState() {
    _c = TextEditingController();
    chosen = list.first;
    super.initState();
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  String encrypt = '';
  String encrypted = '';
  int encryptingletter = 0;
  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[buildAppMenu()],
      ),
      body: Row(
        children: <Widget>[
          Expanded(
            flex: 3,
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                    key: formKey,
                    //autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(flex: 4, child: buildEncrypt()),
                        Expanded(flex: 4, child: buildEncrypted()),
                        Expanded(flex: 2, child: buildSubmit()),
                      ],
                    ))),
          ),
          Expanded(
              flex: 7,
              child: Column(children: [
                Expanded(
                    flex: 9,
                    child: Stack(children: [
                      buildList(),
                      TextButton(onPressed: () => {}, child: Text("ttttt"))
                    ])),
                Expanded(
                  flex: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment
                        .center, //Center Column contents vertically,
                    crossAxisAlignment: CrossAxisAlignment
                        .center, //Center Column contents horizontally,
                    children: [
                      Encrypting(),
                      TextButton(onPressed: Vpred, child: Text("Vpred")),
                      TextButton(onPressed: Vzad, child: Text("Vzad"))
                    ],
                  ),
                )
              ])),
        ],
      ));

  Widget buildEncrypt() => TextFormField(
        decoration: const InputDecoration(
          labelText: 'Text k zašifrování',
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return 'Zadej text k zašifrování';
          } else {
            return null;
          }
        },
        keyboardType: TextInputType.multiline,
        minLines: 1,
        maxLines: null,
        onSaved: (value) => setState(() => encrypt = value!),
      );

  Widget Encrypting() => Text((() {
        if (encrypt.isNotEmpty) {
          return "Šifruje se: " + encrypt[encryptingletter];
        }
        return "Chybí text k zašifrování";
      })());
  Widget buildList() => Builder(
      builder: ((context) => GridView(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: row,
                childAspectRatio: MediaQuery.of(context).size.width /
                    (MediaQuery.of(context).size.height)),
            shrinkWrap: true,
            children: wid,
            key: ValueKey<Object>(redraw),
          )));
  // Widget buildEncrypted() => TextFormField(
  //       decoration: const InputDecoration(
  //         labelText: 'Zašifrovaný text',
  //       ),
  //       keyboardType: TextInputType.multiline,
  //       maxLines: null,
  //       readOnly: true,
  //     );

  Widget buildEncrypted() => TextField(
        decoration: const InputDecoration(
          labelText: 'Zašifrovaný text',
        ),
        controller: _c,
        minLines: 1,
        maxLines: null,
        readOnly: true,
      );

  List<Widget> AlphabetPlayfair() {
    List<Widget> x = <Widget>[];
    for (int i = 0; i < 25; i++) {
      x.add(new TextButton(
          onPressed: Guess(),
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.red)),
          child: Center(child: Text("A"))));
    }

    return x;
  }

  List<Widget> Alphabet() {
    List<Widget> x = <Widget>[];
    for (int i = 0; i < 26; i++) {
      x.add(new TextButton(
          onPressed: Guess(),
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.red)),
          child: Center(child: Text("A"))));
    }

    return x;
  }

  Vpred() {
    setState(() {
      if (encrypt.length - 1 > encryptingletter) encryptingletter += 1;
    });
  }

  Vzad() {}
  Guess() {}
  ShowCaesar() {
    wid = Alphabet();
    row = 26;
    setState(() {
      wid = wid;
      Refresh();
    });
  }

  Refresh() {
    redraw = Object();
  }

  ShowPlayfair() {
    wid = AlphabetPlayfair();
    row = 5;
    setState(() {
      wid = wid;
      Refresh();
    });
  }

  Widget buildSubmit() => Builder(
        builder: (context) => ButtonWidget(
          text: 'Zašifrovat',
          onClicked: () {
            final isValid = formKey.currentState!.validate();
            // FocusScope.of(context).unfocus();

            if (isValid) {
              formKey.currentState!.save();
              setState(() {
                wid = <Widget>[];
                Refresh();
              });
              switch (chosen) {
                case 'Caesar':
                  {
                    ShowCaesar();
                  }
                  break;

                case 'Playfair':
                  {
                    ShowPlayfair();
                  }
                  break;

                default:
                  {
                    //statements;
                  }
                  break;
              }
              _c.text = encrypt;
            }
          },
          key: monKey,
        ),
      );

  Widget buildAppMenu() => Builder(
        builder: (context) => DropdownButton(
            value: chosen,
            items: list.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: ((String? value) => {
                  setState(() {
                    chosen = value!;
                  })
                })),
      );
}
