import fs from "fs";
import sdk from "microsoft-cognitiveservices-speech-sdk";

const sleep = (ms) => new Promise((resolve) => setTimeout(resolve, ms));

const speechConfig = sdk.SpeechConfig.fromSubscription(
  "cbc860f2564b4869b922c17dfb100b1d",
  "eastus"
);
speechConfig.speechSynthesisOutputFormat =
  sdk.SpeechSynthesisOutputFormat.Audio48Khz96KBitRateMonoMp3;

const createSSML = ({ voice, rate, text }) => {
  return `<speak xmlns="http://www.w3.org/2001/10/synthesis" xmlns:mstts="http://www.w3.org/2001/mstts" xmlns:emo="http://www.w3.org/2009/10/emotionml" version="1.0" xml:lang="en-GB">
    <voice name="${voice}">
      <prosody rate="${rate}">${text}</prosody>
    </voice>
    </speak>
  `;
};
//kn-IN-SapnaNeural 0.85
//kn-IN-GaganNeural 0.85

//HemkalaNeural 0.9
//SagarNeural 0.9
const tts = (synthesizer, data) => {
  return new Promise((resolve, reject) => {
    synthesizer.speakSsmlAsync(
      data,
      function (result) {
        if (result.reason === sdk.ResultReason.SynthesizingAudioCompleted) {
          resolve(result);
        } else {
          reject(result.errorDetails);
        }
      },
      function (err) {
        reject(err);
      }
    );
  });
};

class PushAudioOutputStreamTestCallback extends sdk.PushAudioOutputStreamCallback {
  constructor() {
    super();
    this.output = fs.createWriteStream("./scripts/output.mp3");
    this.output.on("error", (error) => {
      console.log("error", error);
      throw error;
    });
  }

  write(dataBuffer) {
    this.output.write(new Uint8Array(dataBuffer));
  }

  close() {
    this.output.close();
  }
}

const main = async () => {
  const pushStream = new PushAudioOutputStreamTestCallback();
  const audioConfig = sdk.AudioConfig.fromStreamOutput(pushStream);
  const synthesizer = new sdk.SpeechSynthesizer(speechConfig, audioConfig);
  const arr = fs
    .readFileSync("./scripts/kannada.csv", "utf-8")
    .split("\n")
    .map((v) => v.split("|"));
  let durationAcc = 0;
  const books = {};
  for (const item of arr) {
    const book = item[0];
    const chapter = parseInt(item[1]);
    const verse = parseInt(item[2]);
    books[book] = { chapters: [] }
    // const result = await tts(
    //   synthesizer,
    //   createSSML({
    //     voice: "kn-IN-GaganNeural",
    //     rate: 0.85,
    //     text: item[3],
    //   })
    // );
    // const start = durationAcc;
    // const end = durationAcc + result.privAudioDuration / 10000000;
    // durationAcc = end;
    // item.push(start.toFixed(4), end.toFixed(4));
    if (chapter === 2) {
      break;
    }
    await sleep(20);
  }
  synthesizer.close();
  pushStream.close();
  fs.writeFileSync(
    "./src/data/new_kannada.csv",
    arr.map((v) => v.join("|")).join("\n")
  );
};
main();
