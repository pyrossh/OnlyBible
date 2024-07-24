import fs from 'node:fs/promises';

const filename = 'English';
const outputLines = [];
const data = await fs.readFile(`../assets/bibles/${filename}.txt`, 'utf8');
const lines = data.split('\n');
const outputMap = {}
try {
	for (const line of lines) {
		if (line === '') {
			break;
		}
		const arr = line.split('|');
		const book = parseInt(arr[0]);
		const chapter = parseInt(arr[1]);
		const verseNo = parseInt(arr[2]);
		const heading = arr[3];
		const verseText = arr.slice(4, arr.length).join("|");
		if (!outputMap[book]) {
			outputMap[book] = {}
		}
		if (!outputMap[book][chapter]) {
			outputMap[book][chapter] = {};
		}
		outputMap[book][chapter][verseNo] = 0
		// const data = await getVerses(book, chapter);
		// const verseText = data.verses.find((v) => v.chapter === chapter + 1 && v.verse === verseNo + 1).text;
		// outputLines.push(`${booksNames[book].trim()}|${book}|${chapter}|${verseNo}|${heading}|${verseText}`);
	}
} catch (err) {
	console.log('err', err);
}

await fs.writeFile(`./outputMap.json`, JSON.stringify(outputMap, null, null), 'utf8');
