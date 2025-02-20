class Quiz {
  final List<dynamic> questions;
  Quiz({required this.questions});
  //can add title later

}



class MultipleChoice {
  final String question;
  final List<String> choices;
  final String answer;

  MultipleChoice({required this.question, required this.choices, required this.answer});
}


class QuestionAnswer {
  //just q/a for now
}

class FillInTheBlank {
  //just a text 
}