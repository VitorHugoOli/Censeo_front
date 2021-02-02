String checkDisciplinaName(String sigla, String name) {
  var hasTurma = sigla.replaceAll(new RegExp(r"([A-Za-z]{3}[0-9]{3})"), '');
  if (hasTurma.contains("T")) {
    return name + " - Turma " + hasTurma.replaceAll("T", '');
  }
  return name;
}

String Capitalize(String str) {
  if (str.length > 0)
    return "${str[0].toUpperCase()}${str.substring(1)}";
  else
    return "";
}
