import fs from 'fs';
import fetch from 'node-fetch';
import abtob from 'arraybuffer-to-buffer';

function sleep(ms) {
  return new Promise((resolve) => {
    setTimeout(resolve, ms);
  });
}

const main = async () => {
  const file = fs.readFileSync('./kannada.json')
  const json = JSON.parse(file.toString())
  for (const book of Object.keys(json)) {
    for (const [c, chapter] of json[book].entries()) {
      for (const [v, _] of chapter.entries()) {
        const dir = `audio/kannada/${book}/chapter_${c + 1}`
        const path = `${dir}/verse_${v + 1}.mp3`;
        fs.mkdirSync(dir, { recursive: true })
        const info = fs.statSync(path)
        if ((info.size / 1024) < 3) {
          console.log(book, c, info.size / 1024)
          const res = await fetch(`http://localhost:3005/assets/${path}`)
          const buf = await res.arrayBuffer()
          fs.writeFileSync(path, abtob(buf))
          await sleep(100);
        }
      }
    }
  }
}
main();
