import fs from "fs";
import assert from "assert";

const arr = fs.readFileSync("./scripts/nepali.csv", "utf-8")
  .split("\n")
  .map((v) => v.split("|"))

assert.equal(arr[arr.length - 1][0], 65);
assert.equal(arr[arr.length - 1][1], 22);
assert.equal(arr[arr.length - 1][2], 21);
assert.equal(!!arr[arr.length - 1][3], true);

const src = fs.readFileSync("./scripts/kannada.txt", "utf-8").split("\n")
for (const [i, v] of arr.entries()) {
  arr[i][3] = src[i];
  assert.equal(src[i].includes("|"), false);
}

fs.writeFileSync("./scripts/kannada.csv", arr.map((v) => v.join("|")).join("\n"));