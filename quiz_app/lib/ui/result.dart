import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class Result extends StatefulWidget {

   final List<int> resultList;
   final totalRight;
   final totalWrong;
   final totalNoAnswer;

   Result({Key key,this.resultList,this.totalRight,this.totalWrong,this.totalNoAnswer}):super(key:key);

  @override
  _ResultState createState() => _ResultState();
}

class _ResultState extends State<Result> {

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: (){ print("no operation");  return null; },
      child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: AutoSizeText('Result',style: TextStyle(fontFamily: "FuturaHeavy")),
            centerTitle: true,
          ),
          body:Container(
            margin: EdgeInsets.all(15),
            child:ListView(
              shrinkWrap: true,
              physics: AlwaysScrollableScrollPhysics(),
              children: [

                Container(
                  child: ListView.builder(
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      itemCount: widget.resultList!=null ? widget.resultList.length : 0,
                      itemBuilder: (context,index){

                        return Container(
                              margin: EdgeInsets.only(top:10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [

                                  Container(
                                    child: AutoSizeText("Question ${index+1}  >",style: TextStyle(fontFamily: "FuturaMedium")),
                                  ),

                                  Container(
                                    child: AutoSizeText("${widget.resultList[index]==1 ? "Right" : widget.resultList[index]==2 ? "Wrong" : "No Answer"}",
                                        style: TextStyle(fontFamily: "FuturaMedium",color:widget.resultList[index]==1 ?
                                        Colors.green : widget.resultList[index]==2  ? Colors.red  : Colors.blue,)),
                                  )
                              ],
                           )
                        );

                    }
                  ),
                ),

                Container(
                  margin: EdgeInsets.only(top:20,bottom: 15),
                  alignment: Alignment.center,
                  child:AutoSizeText('Total Right Question : ${widget.totalRight}',minFontSize: 20,
                    style: TextStyle(fontFamily: "FuturaHeavy",color: Colors.green),),
                ),

                Container(
                  margin: EdgeInsets.only(bottom: 15),
                  alignment: Alignment.center,
                  child:AutoSizeText('Total Wrong Question : ${widget.totalWrong}',minFontSize: 20,
                    style: TextStyle(fontFamily: "FuturaHeavy",color: Colors.red),),
                ),

                Container(
                  margin: EdgeInsets.only(bottom: 15),
                  alignment: Alignment.center,
                  child:AutoSizeText('Total No Answer Question : ${widget.totalNoAnswer}',minFontSize: 20,
                    style: TextStyle(fontFamily: "FuturaHeavy",color: Colors.blue),),
                ),

              ],
            ),
          )
      ),
    );
  }
}
