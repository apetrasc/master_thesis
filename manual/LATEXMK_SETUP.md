# latexmk設定ガイド

## 概要

手動コンパイルで動作確認済みの設定を`latexmk`に統合しました。

## latexmkrcの設定

### 更新内容

手動コンパイルで使用していたオプションを`latexmkrc`に反映：

```perl
# LaTeX engine settings for Japanese documents
# 手動コンパイルで動作確認済みの設定を使用
$latex = 'uplatex -synctex=1 -interaction=nonstopmode -file-line-error -kanji=utf8 %O %S';
$pdflatex = 'uplatex -synctex=1 -interaction=nonstopmode -file-line-error -kanji=utf8 %O %S';
$bibtex = 'pbibtex -kanji=utf8 %O %B';
$dvipdf = 'dvipdfmx -f ptex-ipaex.map -z 0 %O -o %D %S';
$makeindex = 'mendex %O -o %D %S';

# PDF generation mode (3 = dvipdfmx)
$pdf_mode = 3;

# Force multiple runs for proper cross-references and bibliography
$max_repeat = 3;

# Clean up auxiliary files
$clean_ext = 'aux bbl blg dvi fdb_latexmk fls log out toc synctex.gz';

# Ensure proper processing order for Japanese documents
$recorder = 1;
```

## 主な変更点

### 1. uplatexのオプション追加

**変更前**:
```perl
$latex = 'uplatex -interaction=nonstopmode';
```

**変更後**:
```perl
$latex = 'uplatex -synctex=1 -interaction=nonstopmode -file-line-error -kanji=utf8 %O %S';
```

**追加されたオプション**:
- `-synctex=1`: PDFとソースコードの双方向同期
- `-file-line-error`: エラー行番号を表示
- `-kanji=utf8`: UTF-8エンコーディングで日本語を処理
- `%O %S`: latexmkの変数（オプションとソースファイル）

### 2. pbibtexの設定

```perl
$bibtex = 'pbibtex -kanji=utf8 %O %B';
```

- `-kanji=utf8`: UTF-8エンコーディングで日本語を処理
- `%O %B`: latexmkの変数（オプションとベース名）

### 3. dvipdfmxのオプション追加

**変更前**:
```perl
$dvipdf = 'dvipdfmx -f ptex-ipaex.map %O -o %D %S';
```

**変更後**:
```perl
$dvipdf = 'dvipdfmx -f ptex-ipaex.map -z 0 %O -o %D %S';
```

**追加されたオプション**:
- `-z 0`: 圧縮レベル（0=無圧縮、デバッグ時に便利）

## 使用方法

### 基本的な使用方法

```bash
# PDFを生成（DVI経由）
latexmk -pdfdvi main.tex

# または
latexmk -pdf main.tex
```

### クリーンアップ

```bash
# 中間ファイルを削除
latexmk -c main.tex

# すべての中間ファイルを削除（PDFも含む）
latexmk -C main.tex
```

### 連続モード（ファイル変更を監視）

```bash
# ファイル変更を監視して自動コンパイル
latexmk -pdfdvi -pvc main.tex
```

### 詳細なログ表示

```bash
# 詳細なログを表示
latexmk -pdfdvi -verbose main.tex
```

## 実行されるコマンド

`latexmk -pdfdvi main.tex`を実行すると、以下の順序でコマンドが実行されます：

1. **uplatex** (1回目)
   ```
   uplatex -synctex=1 -interaction=nonstopmode -file-line-error -kanji=utf8 main.tex
   ```
   - `.aux`ファイルを生成
   - 目次・参照ラベルを作成

2. **pbibtex**
   ```
   pbibtex -kanji=utf8 main
   ```
   - 参考文献を処理
   - `.bbl`と`.blg`を生成

3. **uplatex** (2回目)
   ```
   uplatex -synctex=1 -interaction=nonstopmode -file-line-error -kanji=utf8 main.tex
   ```
   - 参考文献と目次を反映

4. **uplatex** (3回目)
   ```
   uplatex -synctex=1 -interaction=nonstopmode -file-line-error -kanji=utf8 main.tex
   ```
   - 相互参照を完全に反映

5. **dvipdfmx**
   ```
   dvipdfmx -f ptex-ipaex.map -z 0 -o main.pdf main.dvi
   ```
   - DVIをPDFに変換

## latexmkの変数

latexmkrcで使用される変数：

- `%O`: オプション（通常は空）
- `%S`: ソースファイル（例: `main.tex`）
- `%D`: 出力ファイル（例: `main.pdf`）
- `%B`: ベース名（拡張子なし、例: `main`）

## 手動コンパイルとの対応

| 手動コンパイル | latexmk設定 |
|---------------|------------|
| `uplatex -synctex=1 -interaction=nonstopmode -file-line-error -kanji=utf8 main.tex` | `$latex = 'uplatex -synctex=1 -interaction=nonstopmode -file-line-error -kanji=utf8 %O %S'` |
| `pbibtex -kanji=utf8 main` | `$bibtex = 'pbibtex -kanji=utf8 %O %B'` |
| `dvipdfmx -f ptex-ipaex.map -z 0 main.dvi` | `$dvipdf = 'dvipdfmx -f ptex-ipaex.map -z 0 %O -o %D %S'` |

## トラブルシューティング

### エラーが発生する場合

1. **latexmkrcの構文を確認**:
   ```bash
   perl -c latexmkrc
   ```

2. **実際に実行されるコマンドを確認**:
   ```bash
   latexmk -pdfdvi -verbose main.tex
   ```

3. **中間ファイルをクリーンアップ**:
   ```bash
   latexmk -c main.tex
   ```

### pbibtexで`openout_any = p`エラーが発生する場合

latexmkは自動的に作業ディレクトリを設定するため、通常は問題ありません。エラーが発生する場合は：

1. 作業ディレクトリを確認:
   ```bash
   pwd
   ```

2. プロジェクトディレクトリから実行:
   ```bash
   cd /home/apetr/Documents/sandbox/master_thesis
   latexmk -pdfdvi main.tex
   ```

## 便利なコマンド

### クリーンアップとコンパイル

```bash
# クリーンアップしてからコンパイル
latexmk -c main.tex && latexmk -pdfdvi main.tex
```

### 連続コンパイル（開発時）

```bash
# ファイル変更を監視して自動コンパイル
latexmk -pdfdvi -pvc main.tex
```

### 強制再コンパイル

```bash
# 強制的に再コンパイル（依存関係を無視）
latexmk -pdfdvi -g main.tex
```

## まとめ

### 主な利点

1. **自動化**: 手動で5つのコマンドを実行する必要がない
2. **依存関係の管理**: 必要な回数だけ自動的にコンパイル
3. **クリーンアップ**: 中間ファイルの自動削除
4. **連続モード**: ファイル変更を監視して自動コンパイル

### 実行コマンド

```bash
# 基本的な使用方法
latexmk -pdfdvi main.tex

# クリーンアップ
latexmk -c main.tex

# 連続モード
latexmk -pdfdvi -pvc main.tex
```

手動コンパイルで動作確認済みの設定を`latexmkrc`に反映したため、`latexmk`を使用しても同じ結果が得られます。

