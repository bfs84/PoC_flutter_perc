import 'dart:convert';
import 'dart:io';

/// metrics.json の中から最初に出現する '{' または '[' 以降を取り出す
String extractValidJson(String content) {
  int index = content.indexOf('{');
  if (index == -1) {
    index = content.indexOf('[');
  }
  return index != -1 ? content.substring(index) : content;
}

void main() async {
  final metricsFile = File('metrics.json');
  if (!await metricsFile.exists()) {
    print('metrics.json not found. Run the dart_code_metrics command first.');
    return;
  }
  final content = await metricsFile.readAsString();
  // 余分な先頭の警告やメッセージを取り除く
  final validContent = extractValidJson(content);
  final jsonData = jsonDecode(validContent);

  // ここでは仮に、各ファイルの import 情報を抽出できたと仮定
  // 実際には JSON の構造に合わせたパース処理が必要です。
  // 例: dependencyRelations の形式は [{'from': 'lib/a.dart', 'to': 'lib/b.dart'}, ...] とする
  final dependencyRelations = <Map<String, String>>[
    {'from': 'lib/a.dart', 'to': 'lib/b.dart'},
    {'from': 'lib/b.dart', 'to': 'lib/c.dart'},
  ];

  final buffer = StringBuffer();
  buffer.writeln('@startuml');
  for (final relation in dependencyRelations) {
    buffer.writeln('[${relation['from']}] --> [${relation['to']}]');
  }
  buffer.writeln('@enduml');

  final outputFile = File('dependencies.puml');
  await outputFile.writeAsString(buffer.toString());
  print('PlantUML file generated: dependencies.puml');
}
