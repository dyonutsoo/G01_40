class SignUpWithEmailAndPasswordFailure {
  final String message;

  const SignUpWithEmailAndPasswordFailure([this.message = "An Unknown error occured."]);

  factory SignUpWithEmailAndPasswordFailure.code(String code){
    switch(code){
      case 'invalid email' :
        return const SignUpWithEmailAndPasswordFailure('Email is not valid');
      default: return const SignUpWithEmailAndPasswordFailure();
    }
  }
}
