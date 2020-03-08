String censor(String messageText) {
  final List profanity = [
    'fuck',
    'bitch',
    'bastard',
    'sex',
    'shit',
    'cunt',
    'pussy',
    'vagina',
    'dick',
    'penis',
    'cock',
    'ass',
    'boob',
    'breast',
    'tits',
    'nigg',
    'whore',
    'prostitute',
    'retard',
    'fag',
    'chut',
    'chod',
    'gaand',
    'bhosdike',
    'kamina',
    'kutta',
    'rundi',
    'randi',
    'saala',
    'bhangi',
  ]; // add more LOL

  profanity.forEach((badWord) {
    String lowerCaseMessage = messageText.toLowerCase();
    if (lowerCaseMessage.contains(badWord)) {
      messageText = lowerCaseMessage.replaceAll(badWord, '****');
    }
  });
  return messageText;
}
