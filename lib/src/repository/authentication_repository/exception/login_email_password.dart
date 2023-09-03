class LogInWithEmailAndPasswordFailure {
  final String message;

  const LogInWithEmailAndPasswordFailure([this.message = "An Unknown error occured."]);

  factory LogInWithEmailAndPasswordFailure.code(String code){
    switch(code){
      case '' : return const LogInWithEmailAndPasswordFailure('');
      default: return const LogInWithEmailAndPasswordFailure();
    }
  }

}
