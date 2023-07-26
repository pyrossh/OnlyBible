import flexsearch from "flexsearch";
import fs from "fs";
import bible from "../src/data/kannada.json" assert { type: "json" };

const index = new flexsearch.Index({
  tokenize: "forward",
  split: /[\p{Z}\p{S}\p{P}\p{C}]+/u,
});
let verses = ""
const books = []
let count = 0;
for (const book of bible) {
  const offsets = [];
  for (const chapter of book.chapters) {
    for (const item of chapter) {
      verses += item.verse + "\n";
      index.add(count, item.verse);
      count++
    }
    offsets.push(count);
  }
  books.push({
    name: {
      en: book.name,
    },
    chapters: offsets
  });
}
console.log(books)
fs.writeFileSync("./books.json", JSON.stringify(books, 2, 2));

// fs.writeFileSync("./verses.txt", verses);
// const results = index.search("ದೇವರು");
// console.log(results);

// index.export((key, data) => {
//   console.log(key, data);
// });


0
1
2
3
4
4