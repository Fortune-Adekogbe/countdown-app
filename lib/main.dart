import 'package:flutter/material.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(MyApp());
}

// Home Page
class CountdownApp extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<CountdownApp> {
  bool button1, button2;
  static GlobalKey _globalKey = GlobalKey();
  static const Color white = Color(0xFFFFFFFF);

  @override
  void initState() {
    button1 = false;
    button2 = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: _globalKey,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text("Countdown App"),
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.03,
              ),
              RichText(
                text: TextSpan(
                  style: DefaultTextStyle.of(context).style,
                  children: [
                    TextSpan(
                        text: 'Count',
                        style: TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.bold)),
                    WidgetSpan(
                      child: Icon(Icons.arrow_downward_outlined, size: 64),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.03,
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.05,
                width: MediaQuery.of(context).size.width * 0.5,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.blue),
                  ),
                  onPressed: () {
                    _navigateToCountToTimePage(context);
                  }, //CountToTimePage
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: button1
                        ? CircularProgressIndicator()
                        : Text(
                            'To a time',
                            style: TextStyle(color: white, fontSize: 17),
                          ),
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.03,
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.05,
                width: MediaQuery.of(context).size.width * 0.5,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.blue),
                  ),
                  onPressed: () {
                    _navigateToTimerPage(context);
                  }, //TimerPage,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: button2
                        ? CircularProgressIndicator()
                        : Text(
                            'Timer',
                            style: TextStyle(color: white, fontSize: 17),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToCountToTimePage(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CountToTimePage(),
        ));
  }

  void _navigateToTimerPage(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TimerPage(),
        ));
  }
}

//Second page in sequence: Count to time Page
class CountToTimePage extends StatefulWidget {
  CountToTimePage({Key key}) : super(key: key);

  @override
  CountToTimeState createState() => CountToTimeState();
}

class CountToTimeState extends State<CountToTimePage> {
  GlobalKey<FormState> _oFormKey = GlobalKey<FormState>();
  TextEditingController _controller;

  //String _initialValue;
  String _valueChanged = '';
  String _valueToValidate = '';
  String _valueSaved = '';

  @override
  void initState() {
    super.initState();
    Intl.defaultLocale = 'en_US';
    _controller = TextEditingController(text: DateTime.now().toString());
    _getValue();
  }

  Future<void> _getValue() async {
    await Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _controller = TextEditingController(text: DateTime.now().toString());
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: Row(
            children: [
              SizedBox(
                width: 15,
              ),
              Icon(Icons.arrow_back),
            ],
          ),
        ),
        title: Text("Countdown App"),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: Form(
            key: _oFormKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  child: new Text(
                    "When should the countdown stop?",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 50),
                DateTimePicker(
                  type: DateTimePickerType.dateTimeSeparate,
                  dateMask: 'd MMM, yyyy',
                  controller: _controller,
                  //initialValue: _initialValue,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                  icon: Icon(Icons.event),
                  dateLabelText: 'Date',
                  timeLabelText: "Hour",
                  //use24HourFormat: false,
                  locale: Locale('en', 'US'),
                  onChanged: (val) => setState(() => _valueChanged = val),
                  //onFieldSubmitted: ,
                  validator: (val) {
                    setState(() => _valueToValidate = val);
                    return null;
                  },
                  onSaved: (val) => setState(() => _valueSaved = val),
                ),
                SizedBox(height: 30),
                RaisedButton(
                  onPressed: () {
                    final enteredDate = DateTime.parse(_controller.text);
                    if (enteredDate.isAfter(DateTime.now())){
                      Duration difference = DateTime.now().difference(enteredDate);
                      int diff = difference.inSeconds;
                    }
                  },
                  child: Text('Start Timer'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

//Second page in sequence: Timer Page
class TimerPage extends StatefulWidget {
  TimerPage({Key key}) : super(key: key);

  @override
  TimerPageState createState() => TimerPageState();
}

class TimerPageState extends State<TimerPage> {
  DateTime _dateTime = DateTime.now();
  DateTime get enteredDate{
    return _dateTime;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: Row(
            children: [
              SizedBox(
                width: 15,
              ),
              Icon(Icons.arrow_back),
            ],
          ),
        ),
        title: Text("Countdown App"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <
            Widget>[
          Container(
            child: new Text(
              "     Hour    Minute   Second",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          TimePickerSpinner(
            is24HourMode: true,
            isShowSeconds: true,
            normalTextStyle: TextStyle(fontSize: 24, color: Colors.deepOrange),
            highlightedTextStyle: TextStyle(fontSize: 24, color: Colors.yellow),
            spacing: 50,
            itemHeight: 80,
            isForce2Digits: true,
            onTimeChange: (time) {
              setState(() {
                _dateTime = time;
              });
            },
          ),
          Container(
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
              ),
              onPressed: (){
                DateTime dt = this.enteredDate;
                if (this.enteredDate.second > 1){
                      int diff = dt.hour*3600 + dt.minute*60+ dt.second;
                }    
              },
              child: Padding(
                padding: const EdgeInsets.all(0.0),
                child: new Text(
                  _dateTime.hour.toString().padLeft(2, '0') +
                      ':' +
                      _dateTime.minute.toString().padLeft(2, '0') +
                      ':' +
                      _dateTime.second.toString().padLeft(2, '0'),
                  style: TextStyle(
                      color: _State.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

//The Application itself.
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Countdown App',
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: CountdownApp(),
      localizationsDelegates: [
        GlobalWidgetsLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [Locale('pt', 'BR')],
    );
  }
}