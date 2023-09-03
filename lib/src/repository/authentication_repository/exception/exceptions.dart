class TExceptions implements Exception{
  final String message;

  const TExceptions([this.message = 'An unknown exception occured']);

  factory TExceptions.fromCode(String code){
    switch (code) {
      case'email-already-in-use':
        return const TExceptions('Email already exists.');
      case'invalid-email':
        return const TExceptions('Email is not valid.');
      default:
        return const TExceptions();
    }
  }
}