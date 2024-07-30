import fs from 'node:fs/promises';

const filename = 'en_kjv';
const outputLines = [];
const data = await fs.readFile(`../app/src/main/assets/bibles/${filename}.txt`, 'utf8');
const lines = data.split('\n');
const data2 = await fs.readFile(`./bsb.txt`, 'utf8');
const lines2 = data2.split('\n')

if (lines.length !== lines2.length) {
    throw new Error("Lines length not matching")
}

for (var i =0; i < lines.length; i++) {
    const line = lines[i]
    const line2 = lines2[i]
    if (line === '' || line2 === '') {
        break;
    }
    const arr = line.split('|');
    const bookName = arr[0];
    const book = parseInt(arr[1]);
    const chapter = parseInt(arr[2]);
    const verseNo = parseInt(arr[3]);
    const heading = arr[4];
    const verseText = arr.slice(5, arr.length).join("|");
    const verse2Text = line2.replace(bookName, "").replace(`${chapter+1}:${verseNo+1}`, "").trim()
    outputLines.push(`${bookName}|${book}|${chapter}|${verseNo}|${heading}|${verse2Text}`);
}

await fs.writeFile(`./out.txt`, outputLines.join("\n") , 'utf8');
