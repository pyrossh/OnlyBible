import fs from 'node:fs/promises';
import { v2 } from '@google-cloud/translate';
import { USFMParser } from "usfm-grammar";

const translate = new v2.Translate({
  key: "AIzaSyAYS5LdP5_i2AxIJprVQFYzb-7Nk2iJfv8",
});

const capitalizeFirstLetter = (s) => s.charAt(0).toUpperCase() + s.slice(1)

const filename = "en_bsb"
const code = "te"
const outputLines = [];
const data = await fs.readFile(`./bsb_usfm/01GENBSB.usfm`, "utf8");
const parser = new USFMParser(data.replaceAll('\\', ""))
const json = parser.toJSON();
console.log(json)
//const lines = data.split("\n");
//try {
//  for (const line of lines) {
//    if (line === "") {
//      break;
//    }
//    const arr = line.split("|");
//    const bookName = arr[0];
//    const book = parseInt(arr[1]);
//    const chapter = parseInt(arr[2]);
//    const verseNo = parseInt(arr[3]);
//    let heading = arr[4];
//    const verseText = capitalizeFirstLetter(arr.slice(5, arr.length).join("|"));
////    if (heading) {
////      const [translation] = await translate.translate(heading, code);
////      heading = translation;
////      console.log(book, chapter, heading);
////    }
//    outputLines.push(`${book}|${chapter}|${verseNo}|${heading}|${verseText}`);
//    const res = await fetch("https://biblehub.com/bsb/genesis/5.htm");
//    const text = await res.text();
//    const root = parse(text)
//    break
//  }
//} catch (err) {
//  console.log("err", err);
//}
//
//await fs.writeFile(`./out.txt`, outputLines.join("\n") , 'utf8');
