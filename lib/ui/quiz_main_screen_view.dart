import 'dart:async';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:quiz_app/model/quiz_questions.dart';
import 'package:quiz_app/ui/result.dart';

class QuizMainScreenView extends StatefulWidget {

  final List<QuizQuestions> questions;

  QuizMainScreenView({Key key,this.questions}):super(key:key);

  @override
  _QuizMainScreenViewState createState() => _QuizMainScreenViewState();
}

class _QuizMainScreenViewState extends State<QuizMainScreenView>{

  bool cancelTimer=false;

  //1 for right answer, 2 for wrong answer and 0 for no answer
  List<int> result=[];

  int timeInterval=60;
  int quesNo=0;
  int selectedIndex;
  int totalRight=0;
  int totalWrong=0;
  int totalNoAnswer=0;

  String selectedOption="";
  String showTimer="";

  Timer timer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (){ print("no operation");  return null; },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: AutoSizeText('Question ${quesNo+1}',style: TextStyle(fontFamily: "FuturaHeavy")),
        ),
         body: Container(
               padding: EdgeInsets.all(15),
               color: Colors.grey[200],
               child:ListView(
                 children: [

                   Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      margin: EdgeInsets.only(bottom:25),
                      child: AutoSizeText("$showTimer",minFontSize: 22,
                        style: TextStyle(fontFamily: "FuturaHeavy",color: Colors.blue),),
                    ),
                   ),

                   Container(
                     child:AutoSizeText('${widget.questions[quesNo].questionId}. ${widget.questions[quesNo].question}',minFontSize: 18,
                       style: TextStyle(fontFamily: "FuturaMedium",color: Colors.black87),),
                   ),

                   Container(
                     margin: EdgeInsets.only(top:30,left: 5,right: 5),
                     child: ListView.builder(
                           shrinkWrap: true,
                           itemCount: widget.questions[quesNo].options.length,
                           itemBuilder: (context,index){

                           return InkWell(
                             onTap: (){
                                    setState(() {
                                      selectedIndex=index;
                                      selectedOption="${widget.questions[quesNo].options[index]["option"]}";
                                    });
                             },
                             child: Container(
                               color:selectedIndex==index ?Colors.green : Colors.white,
                               width: MediaQuery.of(context).size.width,
                               padding: EdgeInsets.all(13),
                               margin: EdgeInsets.only(bottom:25),
                               child:AutoSizeText('${widget.questions[quesNo].options[index]["id"]}. ${widget.questions[quesNo].options[index]["option"]}',minFontSize: 18,
                                     style: TextStyle(fontFamily: "FuturaMedium",fontWeight:selectedIndex==index ? FontWeight.bold : FontWeight.w400,
                                         color:selectedIndex==index ? Colors.white : Colors.black54),),
                             ),
                           );

                         }
                     ),
                   ),

                   Align(
                     alignment: Alignment.bottomRight,
                     child: InkWell(
                       onTap: (){
                           checkAnswer();
                         },
                       child: Container(
                         width: MediaQuery.of(context).size.width / 3,
                         alignment: Alignment.center,
                         margin: EdgeInsets.only(top:35),
                         padding: EdgeInsets.only(left: 15,top: 7,bottom: 7),
                         decoration: BoxDecoration(
                               borderRadius: BorderRadius.circular(5),
                               gradient: LinearGradient(
                                 begin:FractionalOffset.centerLeft,
                                 end:FractionalOffset.centerRight,
                                 colors:[Colors.blue[600],Colors.blue[300],Colors.blue[600]],
                               )
                         ),
                         child:Row(
                           mainAxisSize: MainAxisSize.min,
                           children: [

                             Container(
                               child:AutoSizeText('Next',minFontSize: 18,
                                 style: TextStyle(fontFamily: "FuturaMedium",color: Colors.white),),
                             ),

                             Icon(
                               Icons.arrow_right,
                               color:Colors.white,
                               size: MediaQuery.of(context).size.width / 10,
                             ),

                           ],
                         )
                       ),
                     ),
                   ),

                 ],
               ),
            ),
      ),
    );
  }


  checkAnswer(){

    setState((){

        cancelTimer = true;

       //1 for right answer, 2 for wrong answer and 0 for no answer

       if(selectedOption=="${widget.questions[quesNo].answer}") {
        result.add(1);
        totalRight=totalRight+1;
       }
       else if(selectedOption!="${widget.questions[quesNo].answer}" && selectedOption!="") {
        result.add(2);
        totalWrong=totalWrong+1;
       }
       else {
        result.add(0);
        totalNoAnswer=totalNoAnswer+1;
      }

       selectedOption="";
       selectedIndex=null;

       if(quesNo<widget.questions.length-1) {
         quesNo=quesNo+1;
         cancelTimer=false;
         timeInterval=60;
         startTimer();
       }
       else
         Navigator.of(context).push(PageTransition(curve:Curves.decelerate,type: PageTransitionType.rightToLeft,
             child: Result(resultList: result,totalNoAnswer: totalNoAnswer,totalRight: totalRight,totalWrong: totalWrong,) ) );
    });
  }

  void startTimer(){
    if (timer != null) {
      timer.cancel();
      timeInterval = 60;
    }
     const duration = Duration(seconds: 1);
     timer=Timer.periodic(duration, (Timer t) {
       setState(() {
         showTimer =timeInterval<10 ? "00:0$timeInterval" : "00:$timeInterval";
         if (timeInterval == 0){ t.cancel(); checkAnswer();}
         else if (cancelTimer == true)  t.cancel();
         else   timeInterval = timeInterval - 1;
       });
     });
  }

}
