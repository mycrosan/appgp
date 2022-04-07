import 'package:flutter/cupertino.dart';

void alfabetSortList(List data) {
  //Ordem Alfabetica
  return data.sort((a, b) => a.descricao.compareTo(b.descricao));
}