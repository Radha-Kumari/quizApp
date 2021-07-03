import 'dart:convert';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart'  as http;
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:quiz_app/model/quiz_questions.dart';
import 'package:quiz_app/ui/quiz_main_screen_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quiz App',
      theme: ThemeData(primarySwatch: Colors.blue, ),
      home: MyHomePage(title: 'Quiz App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  bool loadingQuestion=false;

  List<QuizQuestions> questions=[];

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: AutoSizeText(widget.title,style: TextStyle(fontFamily: "FuturaHeavy")),
      ),
      body:Center(
        child:loadingQuestion
         ?Center(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                CircularProgressIndicator(backgroundColor: Colors.blue,),

                Container(
                  margin: EdgeInsets.only(top: 10),
                  child:AutoSizeText('Loading...',maxFontSize: 17,
                    style: TextStyle(fontFamily: "FuturaMedium",color: Colors.black87),),
                ),

              ],
            ),
          ),
        )
        :InkWell(
          onTap: (){
            setState(() { loadingQuestion=true;  });
            fetchQuestion();
          },
          child:Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  gradient: LinearGradient(
                    begin:FractionalOffset.centerLeft,
                    end:FractionalOffset.centerRight,
                    colors:[Colors.blue[600],Colors.blue[300],Colors.blue[600]],
                  )
              ),
              padding: EdgeInsets.all(20),
              child:AutoSizeText('START QUIZ',minFontSize: 20,maxFontSize: 30,
                style: TextStyle(fontFamily: "FuturaHeavy",color: Colors.white),),
          ),
        ),
      ),
    );
  }

  fetchQuestion()async{

    try{

      String url="http://demoapp.in/practical/practical.php";

      final response = await http.Client().get(url);

      print("Question response...${response.body}");

      var data = json.decode(response.body);

      if (data["STATUS_CODE"] == 200 && data["DATA"]["questions"] != null) {
        var result = data["DATA"]["questions"] as List;

        setState(() {
          questions = result.map<QuizQuestions>((json) => QuizQuestions.fromJson(json)).toList();
          Navigator.of(context).push(PageTransition(curve:Curves.decelerate,type: PageTransitionType.rightToLeft,
             child: QuizMainScreenView(questions:questions,) ) );
          loadingQuestion = false;
        });
      }
      else {
        setState(() {
          loadingQuestion = false;
          questions = [];
        });

        Flushbar(
          message: 'Something went wrong, please retry after some time.',
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
          flushbarPosition: FlushbarPosition.BOTTOM,
          icon: Icon(Icons.close,color: Colors.white,),
        )..show(context);

      }//else

    }catch(e){
      print("Try Catch error...$e");
      setState(() { loadingQuestion = false; questions=[]; });
      Flushbar(
        message: 'Something went wrong, please retry after some time',
        backgroundColor: Colors.red,
        duration: Duration(seconds: 3),
        flushbarPosition: FlushbarPosition.BOTTOM,
        icon: Icon(Icons.close,color: Colors.white,),
      )..show(context);
    }
  }//func


}
