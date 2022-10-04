import 'dart:io';
import 'package:flutter/material.dart';
import 'package:window_size/window_size.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    setWindowTitle('Happy Flappy');
    setWindowMinSize(const Size(500, 400));
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

class Letcircle {
  int index;
  Letcircle(this.index);
}

class FaceOutlinePainter extends CustomPainter {
  late List<Letcircle> x;
  late int row;
  FaceOutlinePainter(this.x, this.row);
  @override
  void paint(Canvas canvas, Size size) {
    // Define a paint object
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0
      ..color = Colors.indigo;

    // Left eye
    // canvas.drawRRect(
    //   RRect.fromRectAndRadius(
    //       Rect.fromLTWH(20, 40, 100, 100), Radius.circular(20)),
    //   paint,
    // );
    // Right eye
    // canvas.drawOval(
    //   Rect.fromLTWH(size.width - 120, 40, 100, 100),
    //   paint,
    // );
    // canvas.drawOval(
    //   Rect.fromLTWH(
    //       (size.width / 5 / 2) - 10, (size.height / 5 / 2) - 10, 20, 20),
    //   paint,
    // );

    double by = (size.width / row);
    double byy = (size.height / row);
    for (Letcircle point in x) {
      int column = (point.index % row);
      int rowin = (point.index / row).floor();
      canvas.drawOval(
        Rect.fromLTWH(
            (by * column) + by / 2 - 10, (byy * rowin) + byy / 2 - 10, 20, 20),
        paint,
      );
    }

    // Mouth
    // final mouth = Path();
    // mouth.moveTo(size.width * 0.8, size.height * 0.6);
    // mouth.arcToPoint(
    //   Offset(size.width * 0.2, size.height * 0.6),
    //   radius: Radius.circular(150),
    // );
    // mouth.arcToPoint(
    //   Offset(size.width * 0.8, size.height * 0.6),
    //   radius: Radius.circular(200),
    //   clockwise: false,
    // );
    // canvas.drawPath(mouth, paint);
  }

  @override
  bool shouldRepaint(FaceOutlinePainter oldDelegate) => false;
}

class _MyPageState extends State<MyPage> {
  final formKey = GlobalKey<FormState>();
  final monKey = GlobalKey<FormState>();
  var redraw = Object();
  late TextEditingController _c;
  int row = 26;

  List<List<List<Letcircle>>> anim = [];

  List<Letcircle> show = [];

  List<Widget> wid = <Widget>[];
  List<String> list = <String>['Caesar', 'Playfair'];

  String chosen = "";

  int animationletter = 0;

  int animationstep = -1;

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
  String keyencrypt = '';

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
                        Expanded(flex: 3, child: buildEncrypt()),
                        Expanded(flex: 3, child: keyEncrypt()),
                        Expanded(flex: 3, child: buildEncrypted()),
                        Expanded(flex: 1, child: buildSubmit()),
                      ],
                    ))),
          ),
          Expanded(
              flex: 7,
              child: Column(children: [
                Expanded(
                    flex: 9,
                    child: LayoutBuilder(
                        builder: (_, constraints) => SizedBox(
                            width: constraints.widthConstraints().maxWidth,
                            height: constraints.widthConstraints().maxHeight,
                            child: CustomPaint(
                              foregroundPainter: FaceOutlinePainter(show, row),
                              willChange: true,
                              child: buildList(),
                            )))),
                Expanded(
                  flex: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment
                        .center, //Center Column contents vertically,
                    crossAxisAlignment: CrossAxisAlignment
                        .center, //Center Column contents horizontally,
                    children: [
                      Encrypting(),
                      TextButton(onPressed: Vpred, child: const Text("Vpred")),
                      TextButton(onPressed: Vzad, child: const Text("Vzad"))
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
  Widget keyEncrypt() => TextFormField(
        decoration: const InputDecoration(
          labelText: 'Klic k šifrování',
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return 'Zadej klic k šifrování';
          } else {
            return null;
          }
        },
        keyboardType: TextInputType.multiline,
        minLines: 1,
        maxLines: null,
        onSaved: (value) => setState(() => keyencrypt = value!),
      );

  // ignore: non_constant_identifier_names
  Widget Encrypting() => Text((() {
        if (encrypt.isNotEmpty) {
          return "Šifruje se: ${encrypt[animationletter]}";
        }
        return "Chybí text k zašifrování";
      })());
  Widget buildList() => Builder(
      builder: ((context) => GridView(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: row,
                childAspectRatio: MediaQuery.of(context).size.width /
                    (MediaQuery.of(context).size.height)),
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            key: ValueKey<Object>(redraw),
            children: wid,
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

  // ignore: non_constant_identifier_names
  List<Widget> AlphabetPlayfair() {
    List<Widget> x = <Widget>[];
    for (int i = 0; i < 25; i++) {
      x.add(TextButton(
          onPressed: Guess(),
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.red)),
          child: const Center(child: Text("A"))));
    }

    return x;
  }

  // ignore: non_constant_identifier_names
  List<Widget> Alphabet() {
    List<Widget> x = <Widget>[];
    for (int i = 0; i < 26; i++) {
      String letter = String.fromCharCode(65 + i);
      x.add(TextButton(
          onPressed: Guess(),
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.red)),
          child: Center(child: Text(letter))));
    }

    return x;
  }

  // ignore: non_constant_identifier_names
  Vpred() {
    if (anim[animationletter].length - 1 > animationstep) {
      animationstep++;
    } else {
      if (animationletter < anim.length - 1) {
        animationletter++;
        animationstep = 0;
      }
    }
    print(animationletter);
    setState(() {
      animationletter = animationletter;
      show = anim[animationletter][animationstep];
    });
  }

  // ignore: non_constant_identifier_names
  Vzad() {
    if (animationstep - 1 >= 0) {
      animationstep--;
    } else {
      if (animationletter != 0) {
        animationletter--;
        animationstep = anim[animationletter].length - 1;
      }
    }
    setState(() {
      animationletter = animationletter;
      show = anim[animationletter][animationstep];
    });
  }

  // ignore: non_constant_identifier_names
  Guess() {}
  // ignore: non_constant_identifier_names
  ShowCaesar() {
    wid = Alphabet();
    row = 26;
    int key = int.parse(keyencrypt);
    encrypt = encrypt.toUpperCase();
    String encryptedstring = '';
    for (int i = 0; i < encrypt.length; i++) {
      List<List<Letcircle>> steps = [];
      int charcode = encrypt.codeUnitAt(i);
      if (!(charcode > 64 && charcode < 91)) continue;
      //animation
      int condition1 = (charcode + key - 65) % 26;
      int condition2 = (charcode - 65) % 26;
      while (condition1 != condition2) {
        List<Letcircle> stepped = [];
        stepped.add(Letcircle(condition2));
        steps.add(stepped);
        if (condition2 == 26) {
          condition2 = 0;
        }
        condition2++;
      }
      int encryptedchar = (charcode + key - 65) % 26 + 65;
      encryptedstring += String.fromCharCode(encryptedchar);
      if (condition1 == condition2) {
        List<Letcircle> stepped = [];
        stepped.add(Letcircle(condition2));
        steps.add(stepped);
      }
      anim.add(steps);
      print(anim);
    }
    setState(() {
      _c.text = encryptedstring;
    });
  }

  // ignore: non_constant_identifier_names
  Refresh() {
    // ignore: unnecessary_this
    this.anim = [];
    redraw = Object();
  }

  // ignore: non_constant_identifier_names
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
