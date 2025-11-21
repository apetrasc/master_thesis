# 手動コンパイルコマンド

## 概要

日本語LaTeX文書を手動でコンパイルする場合のコマンド手順です。

## 基本的なコンパイル手順

### 1行で実行する場合

```bash
cd /home/apetr/Documents/sandbox/master_thesis && \
uplatex -synctex=1 -interaction=nonstopmode -file-line-error -kanji=utf8 main.tex && \
pbibtex -kanji=utf8 main && \
uplatex -synctex=1 -interaction=nonstopmode -file-line-error -kanji=utf8 main.tex && \
uplatex -synctex=1 -interaction=nonstopmode -file-line-error -kanji=utf8 main.tex && \
dvipdfmx -f ptex-ipaex.map -z 0 main.dvi
```

### ステップごとに実行する場合

#### ステップ1: uplatex（1回目）

```bash
uplatex -synctex=1 -interaction=nonstopmode -file-line-error -kanji=utf8 main.tex
```

**目的**:
- LaTeXコンパイルの下準備
- 目次・参照ラベルの作成
- `main.aux`ファイルの生成
- SyncTeXファイルの生成開始

**生成されるファイル**:
- `main.aux` - 補助ファイル
- `main.log` - コンパイルログ
- `main.dvi` - DVIファイル（不完全）

#### ステップ2: pbibtex（参考文献処理）

```bash
pbibtex -kanji=utf8 main
```

**目的**:
- 参考文献データベース（`reference.bib`）の処理
- `main.bbl`ファイルの生成（参考文献リスト）
- `main.blg`ファイルの生成（ログ）

**生成されるファイル**:
- `main.bbl` - 参考文献リスト
- `main.blg` - BibTeXログ

**注意**: 作業ディレクトリが正しく設定されていることを確認してください。

#### ステップ3: uplatex（2回目）

```bash
uplatex -synctex=1 -interaction=nonstopmode -file-line-error -kanji=utf8 main.tex
```

**目的**:
- 参考文献（`main.bbl`）を反映
- 目次を更新
- 相互参照を部分的に反映

#### ステップ4: uplatex（3回目）

```bash
uplatex -synctex=1 -interaction=nonstopmode -file-line-error -kanji=utf8 main.tex
```

**目的**:
- 相互参照を完全に反映
- 目次・参考文献の最終更新
- `main.dvi`ファイルの完成
- `main.synctex.gz`ファイルの完成

#### ステップ5: dvipdfmx（PDF変換）

```bash
dvipdfmx -f ptex-ipaex.map -z 0 main.dvi
```

**目的**:
- DVIファイルをPDFに変換
- 日本語フォント（IPAex）を埋め込み

**生成されるファイル**:
- `main.pdf` - 最終的なPDFファイル

## オプションの説明

### uplatexのオプション

- `-synctex=1`: SyncTeXを有効化（PDFとソースコードの双方向同期）
- `-interaction=nonstopmode`: エラー時も停止せず続行（自動ビルドに適している）
- `-file-line-error`: エラー行番号を表示
- `-kanji=utf8`: UTF-8エンコーディングで日本語を処理
- `main.tex`: コンパイルするLaTeXファイル

### pbibtexのオプション

- `-kanji=utf8`: UTF-8エンコーディングで日本語を処理
- `main`: ドキュメント名（拡張子なし）

### dvipdfmxのオプション

- `-f ptex-ipaex.map`: 日本語フォント（IPAex）のマップファイルを指定
- `-z 0`: 圧縮レベル（0=無圧縮、デバッグ時に便利）
- `main.dvi`: 変換するDVIファイル

## 簡易版（参考文献なしの場合）

参考文献を使用しない場合は、`pbibtex`のステップを省略できます：

```bash
uplatex -synctex=1 -interaction=nonstopmode -file-line-error -kanji=utf8 main.tex && \
uplatex -synctex=1 -interaction=nonstopmode -file-line-error -kanji=utf8 main.tex && \
dvipdfmx -f ptex-ipaex.map -z 0 main.dvi
```

## クリーンアップコマンド

中間ファイルを削除する場合：

```bash
rm -f main.aux main.bbl main.blg main.idx main.ind main.lof main.lot main.out main.toc \
      main.acn main.acr main.alg main.glg main.glo main.gls main.ist \
      main.fls main.log main.fdb_latexmk main.synctex.gz main.dvi
```

または、より簡潔に：

```bash
rm -f main.{aux,bbl,blg,idx,ind,lof,lot,out,toc,acn,acr,alg,glg,glo,gls,ist,fls,log,fdb_latexmk,synctex.gz,dvi}
```

## latexmkを使用する場合

`latexmkrc`ファイルが設定されている場合：

```bash
latexmk -pdf main.tex
```

または：

```bash
latexmk -pdfdvi main.tex
```

`latexmk`が自動的に必要な回数だけコンパイルを実行します。

## 実行例

### 完全なコンパイル

```bash
# プロジェクトディレクトリに移動
cd /home/apetr/Documents/sandbox/master_thesis

# 1回目のコンパイル
uplatex -synctex=1 -interaction=nonstopmode -file-line-error -kanji=utf8 main.tex

# 参考文献処理
pbibtex -kanji=utf8 main

# 2回目のコンパイル
uplatex -synctex=1 -interaction=nonstopmode -file-line-error -kanji=utf8 main.tex

# 3回目のコンパイル
uplatex -synctex=1 -interaction=nonstopmode -file-line-error -kanji=utf8 main.tex

# PDF変換
dvipdfmx -f ptex-ipaex.map -z 0 main.dvi

# 結果の確認
ls -lh main.pdf
```

### エラーチェック付き

```bash
#!/bin/bash
set -e  # エラー時に停止

cd /home/apetr/Documents/sandbox/master_thesis

echo "Step 1: First uplatex compilation..."
uplatex -synctex=1 -interaction=nonstopmode -file-line-error -kanji=utf8 main.tex

echo "Step 2: Processing bibliography..."
pbibtex -kanji=utf8 main

echo "Step 3: Second uplatex compilation..."
uplatex -synctex=1 -interaction=nonstopmode -file-line-error -kanji=utf8 main.tex

echo "Step 4: Third uplatex compilation..."
uplatex -synctex=1 -interaction=nonstopmode -file-line-error -kanji=utf8 main.tex

echo "Step 5: Converting to PDF..."
dvipdfmx -f ptex-ipaex.map -z 0 main.dvi

echo "Compilation completed successfully!"
ls -lh main.pdf
```

## トラブルシューティング

### pbibtexで`openout_any = p`エラーが発生する場合

作業ディレクトリを明示的に設定：

```bash
cd /home/apetr/Documents/sandbox/master_thesis
pbibtex -kanji=utf8 main
```

または、絶対パスを避ける：

```bash
(cd /home/apetr/Documents/sandbox/master_thesis && pbibtex -kanji=utf8 main)
```

### コンパイルが失敗する場合

1. **エラーログを確認**:
   ```bash
   cat main.log | grep -A 5 "Error"
   ```

2. **中間ファイルをクリーンアップして再試行**:
   ```bash
   rm -f main.{aux,bbl,blg,dvi,log}
   # 再度コンパイル
   ```

3. **必要なパッケージがインストールされているか確認**:
   ```bash
   which uplatex pbibtex dvipdfmx
   ```

## まとめ

手動コンパイルの基本手順：

1. **uplatex** (1回目) - 下準備と`.aux`生成
2. **pbibtex** - 参考文献処理
3. **uplatex** (2回目) - 参考文献と目次の反映
4. **uplatex** (3回目) - 相互参照の完全な反映
5. **dvipdfmx** - PDF変換

重要なオプション：
- `-kanji=utf8`: 日本語処理に必須
- `-synctex=1`: PDFとソースの同期
- `-f ptex-ipaex.map`: 日本語フォント指定

