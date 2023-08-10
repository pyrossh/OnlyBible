import "dart:io";
import 'package:flutter_azure_tts/flutter_azure_tts.dart';

Future<void> convertText(Voice v, String fileName, String text) async {
  final ttsResponse = await AzureTts.getTts(TtsParams(
    voice: v,
    audioFormat: AudioOutputFormat.audio48khz96kBitrateMonoMp3,
    rate: 0.80,
    text: text,
  ));
  await File(fileName).writeAsBytes(ttsResponse.audio.buffer.asUint8List(), flush: true);
}

void main() async {
  print("starting");
  AzureTts.init(subscriptionKey: Platform.environment["SUB_KEY"]!, region: "centralindia", withLogs: false);
  final voice = Voice(
    name: "",
    displayName: "",
    localName: "",
    shortName: "kn-IN-GaganNeural",
    gender: "Male",
    locale: "kn-IN",
    sampleRateHertz: AudioOutputFormat.audio24khz48kBitrateMonoMp3,
    voiceType: "",
    status: "",
  );
  final bibleTxt = await File("./assets/bibles/Kannada.txt").readAsString();
  final lines = bibleTxt.split("\n");
  for (final line in lines) {
    if (line.isEmpty) {
      continue;
    }
    final book = line.substring(0, 2);
    final chapter = line.substring(3, 6);
    final verseNo = line.substring(7, 10);
    final verseText = line.substring(11);
    print("${book}-${chapter}-${verseNo}.mp3");
    final outputFilename = "./scripts/audio/${book}-${chapter}-${verseNo}.mp3";
    final outFile = File(outputFilename);
    if (outFile.existsSync() && outFile.lengthSync() > 100) {
      continue;
    }
    await convertText(voice, outputFilename, verseText);
  }
  print("finished");
}
