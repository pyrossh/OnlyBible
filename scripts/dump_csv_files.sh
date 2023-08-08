for f in Bible-Database/*; do
  filename=${f:15}
  echo "File: ${filename}"
  sqlite3 Bible-Database/${filename}/holybible.db -cmd ".mode list"  ".output ../assets/bibles/${filename}.txt" "select printf('%02d', Book+1), printf('%03d', Chapter), printf('%03d', Versecount), verse from bible;" ".exit"
done