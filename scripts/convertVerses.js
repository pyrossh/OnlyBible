import fs from 'fs';
// import fetch from 'node-fetch';
// import abtob from 'arraybuffer-to-buffer';
const { getAudioDurationInSeconds } = await import('get-audio-duration');

function sleep(ms) {
  return new Promise((resolve) => {
    setTimeout(resolve, ms);
  });
}

const main = async () => {
  const file = fs.readFileSync('./public/kannada.json');
  const json = JSON.parse(file.toString());
  const books = [];
  const files = [];
  let acc = 0;
  for (const key of Object.keys(json)) {
    const newBook = {
      name: key,
      slug: key.replaceAll(" ", "-"),
      chapters: [],
    }
    for (const [c, chapter] of json[key].entries()) {
      const newChapter = []
      for (const [v, verse] of chapter.entries()) {
        const dir = `public/audio/kannada/${key}/chapter_${c + 1}`
        const path = `${dir}/verse_${v + 1}.mp3`;
        files.push(`file '${path}'`);
        const res = await getAudioDurationInSeconds(path);
        newChapter.push({
          start: acc,
          end: acc + res,
          verse,
        });
        acc = acc + res;
      }
      newBook.chapters.push(newChapter);
    }
    books.push(newBook);
  }
  fs.writeFileSync("list.txt", files.join("\n"));
  fs.writeFileSync("./bible.json", JSON.stringify(books, 0, 0));
}
main();
