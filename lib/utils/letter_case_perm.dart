class LetterCasePermutation {
  List<String> letterCasePermutation(String S) {
    List<String> result = [];
    List<String> temp = [];
    for (int i = 0; i < S.length; i++) {
      if (S[i].toLowerCase() != S[i].toUpperCase()) {
        if (result.isEmpty) {
          result.add(S[i].toLowerCase());
          result.add(S[i].toUpperCase());
        } else {
          for (int j = 0; j < result.length; j++) {
            temp.add(result[j] + S[i].toLowerCase());
            temp.add(result[j] + S[i].toUpperCase());
          }
          result = temp;
          temp = [];
        }
      } else {
        if (result.isEmpty) {
          result.add(S[i]);
        } else {
          for (int j = 0; j < result.length; j++) {
            temp.add(result[j] + S[i]);
          }
          result = temp;
          temp = [];
        }
      }
    }
    print(result);
    return result;
  }
}
