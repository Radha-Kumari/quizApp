class QuizQuestions {
  int questionId;
  String question;
  String ansA;
  String ansB;
  String ansC;
  String ansD;
  List<Map<String,dynamic>> options;
  String answer;

  QuizQuestions(
      {this.questionId,
        this.question,
        this.ansA,
        this.ansB,
        this.ansC,
        this.ansD,
        this.answer});

  QuizQuestions.fromJson(Map<String, dynamic> json) {
    questionId = json['question_id'];
    question = json['question'];
    ansA = json['ans_a'];
    ansB = json['ans_b'];
    ansC = json['ans_c'];
    ansD = json['ans_d'];
    options=[
      {"id":"A","option":"$ansA"},
      {"id":"B","option":"$ansB"},
      {"id":"C","option":"$ansC"},
      {"id":"D","option":"$ansD"},
    ];
    answer = json['answer'];
  }

}