# コマンドラインでビルドする方法

LaTeX Workshopの操作をコマンドラインで実行する方法を説明します。

## 1. Ctrl+Alt+B のビルドプロセスをコマンドで実行

### 完全なビルドコマンド（ワンライナー）

```bash
uplatex -synctex=1 -interaction=nonstopmode -file-line-error -kanji=utf8 main.tex && \
pbibtex -kanji=utf8 main && \
uplatex -synctex=1 -interaction=nonstopmode -file-line-error -kanji=utf8 main.tex && \
uplatex -synctex=1 -interaction=nonstopmode -file-line-error -kanji=utf8 main.tex && \
dvipdfmx -f ptex-ipaex.map -z 0 -o main_temp.pdf main.dvi && \
gs -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -dEmbedAllFonts=true -dSubsetFonts=true -dCompatibilityLevel=1.5 -sOutputFile=main.pdf main_temp.pdf && \
rm -f main_temp.pdf
```

### ステップごとの実行

```bash
# Step 1: uplatex (1回目) - main.auxを生成
uplatex -synctex=1 -interaction=nonstopmode -file-line-error -kanji=utf8 main.tex

# Step 2: pbibtex - 参考文献処理
pbibtex -kanji=utf8 main

# Step 3: uplatex (2回目) - 参考文献を反映
uplatex -synctex=1 -interaction=nonstopmode -file-line-error -kanji=utf8 main.tex

# Step 4: uplatex (3回目) - 相互参照を完全に反映
uplatex -synctex=1 -interaction=nonstopmode -file-line-error -kanji=utf8 main.tex

# Step 5: dvipdfmx - DVIからPDFへ変換
dvipdfmx -f ptex-ipaex.map -z 0 -o main_temp.pdf main.dvi

# Step 6: Ghostscript - PDF最適化（フォント埋め込み）
gs -dNOPAUSE -dBATCH -sDEVICE=pdfwrite \
   -dEmbedAllFonts=true -dSubsetFonts=true \
   -dCompatibilityLevel=1.5 \
   -sOutputFile=main.pdf main_temp.pdf

# Step 7: 一時ファイルを削除
rm -f main_temp.pdf
```

## 2. 中間ファイルのクリーンアップ

### LaTeX Workshopの「Clean up auxiliary files」をコマンドで実行

```bash
rm -f main.aux main.bbl main.blg main.idx main.ind \
     main.lof main.lot main.out main.toc \
     main.acn main.acr main.alg \
     main.glg main.glo main.gls main.ist \
     main.fls main.log main.fdb_latexmk \
     main.synctex.gz main.dvi main_temp.pdf
```

### 確認付きクリーンアップ

```bash
# 存在するファイルを確認
ls -lh main.aux main.bbl main.blg main.synctex.gz main.dvi 2>/dev/null

# 削除
rm -f main.aux main.bbl main.blg main.synctex.gz main.dvi main_temp.pdf
```

## 3. よく使うコマンド

### ビルド状態の確認

```bash
# 生成されたファイルを確認
ls -lh main.aux main.bbl main.blg main.synctex.gz main.dvi main.pdf

# PDFのフォント埋め込み状態を確認
pdffonts main.pdf | grep IPAex

# PDFの情報を確認
pdfinfo main.pdf | head -15
```

### エラーログの確認

```bash
# LaTeXのログを確認
less main.log

# エラーのみ表示
grep -i error main.log | head -20
```

### PDF最適化のみ（既存のPDFを最適化）

```bash
# 既存のmain.pdfを最適化
gs -dNOPAUSE -dBATCH -sDEVICE=pdfwrite \
   -dEmbedAllFonts=true -dSubsetFonts=true \
   -dCompatibilityLevel=1.5 \
   -sOutputFile=main_optimized.pdf main.pdf
mv main_optimized.pdf main.pdf
```

## 4. クイックビルド（参考文献なし）

参考文献処理をスキップしてビルド：

```bash
uplatex -synctex=1 -interaction=nonstopmode -kanji=utf8 main.tex && \
uplatex -synctex=1 -interaction=nonstopmode -kanji=utf8 main.tex && \
dvipdfmx -f ptex-ipaex.map -z 0 -o main_temp.pdf main.dvi && \
gs -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -dEmbedAllFonts=true -dSubsetFonts=true -dCompatibilityLevel=1.5 -sOutputFile=main.pdf main_temp.pdf && \
rm -f main_temp.pdf
```

## 5. トラブルシューティング

### pbibtexエラーが発生する場合

```bash
# 手動でpbibtexを実行
uplatex -synctex=1 -interaction=nonstopmode -kanji=utf8 main.tex
pbibtex -kanji=utf8 main

# エラーが続く場合、main.auxを確認
head -20 main.aux
```

### PDFが生成されない場合

```bash
# DVIファイルが生成されているか確認
ls -lh main.dvi

# dvipdfmxを直接実行
dvipdfmx -f ptex-ipaex.map -z 0 main.dvi
```

### フォントが埋め込まれていない場合

```bash
# フォント埋め込み状態を確認
pdffonts main.pdf | grep -E "(IPAex|emb)"

# 最適化を再実行
gs -dNOPAUSE -dBATCH -sDEVICE=pdfwrite \
   -dEmbedAllFonts=true -dSubsetFonts=true \
   -dCompatibilityLevel=1.5 \
   -sOutputFile=main_optimized.pdf main.pdf
mv main_optimized.pdf main.pdf
```

## まとめ

**完全なビルド（ワンライナー）:**
```bash
uplatex -synctex=1 -interaction=nonstopmode -file-line-error -kanji=utf8 main.tex && pbibtex -kanji=utf8 main && uplatex -synctex=1 -interaction=nonstopmode -file-line-error -kanji=utf8 main.tex && uplatex -synctex=1 -interaction=nonstopmode -file-line-error -kanji=utf8 main.tex && dvipdfmx -f ptex-ipaex.map -z 0 -o main_temp.pdf main.dvi && gs -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -dEmbedAllFonts=true -dSubsetFonts=true -dCompatibilityLevel=1.5 -sOutputFile=main.pdf main_temp.pdf && rm -f main_temp.pdf
```

**クリーンアップ:**
```bash
rm -f main.aux main.bbl main.blg main.synctex.gz main.dvi main_temp.pdf
```

**状態確認:**
```bash
ls -lh main.pdf && pdffonts main.pdf | grep IPAex
```
