import 'package:intl/intl.dart';

String formatarDataHoraBrasil(DateTime dt) {
  if (dt == null) return '-';
  return DateFormat('dd/MM/yyyy HH:mm').format(dt);
}