# pbibtexのパス設定について

## main.blgのパスが決定される箇所

### 1. main.texでの設定

`main.tex`の最後に以下のコマンドがあります：

```latex
\bibliographystyle{junsrt}
\bibliography{reference}
```

これらが`pbibtex`が読み出すパスの元になります。

### 2. main.auxへの書き込み

`uplatex`が実行されると、`main.aux`に以下の行が書き込まれます：

```
\bibstyle{junsrt}
\bibdata{reference}
```

- `\bibstyle{junsrt}` → `junsrt.bst`スタイルファイルを指定
- `\bibdata{reference}` → `reference.bib`データベースファイルを指定（拡張子なし）

### 3. pbibtexの動作

`pbibtex`は以下の順序でファイルを処理します：

1. **入力ファイルの読み込み**
   - `main.aux`を読み込む（相対パス）
   - `\bibdata{reference}`から`reference.bib`のパスを取得
   - `\bibstyle{junsrt}`から`junsrt.bst`のパスを取得

2. **出力ファイルの生成**
   - `main.bbl` - 参考文献リスト（相対パスで出力）
   - `main.blg` - BibTeXログファイル（相対パスで出力）

### 4. パスの解決方法

`pbibtex`は以下の順序でファイルを探します：

#### reference.bibの検索
1. 作業ディレクトリ（`main.tex`があるディレクトリ）
2. `BIBINPUTS`環境変数で指定されたパス
3. `TEXINPUTS`環境変数で指定されたパス

#### junsrt.bstの検索
1. 作業ディレクトリ
2. `BSTINPUTS`環境変数で指定されたパス
3. TeXの標準パス（`/usr/share/texmf/`など）

#### 出力ファイル（main.blg, main.bbl）
- 常に作業ディレクトリに相対パスで出力される
- 絶対パスで出力することはできない

## 現在の設定

### .vscode/settings.json

```json
{
    "name": "pbibtex",
    "command": "pbibtex",
    "args": [
        "-kanji=utf8",
        "%DOC%"
    ]
}
```

- `%DOC%`は`main`に展開される
- `pbibtex -kanji=utf8 main`が実行される
- 作業ディレクトリは`main.tex`があるディレクトリ

### latexmkrc

```
$bibtex = 'pbibtex -kanji=utf8';
```

- `latexmk`が`pbibtex`を呼び出す際の設定

## 相対パスに変更する方法

### 現在の状態

既に相対パスで動作しています：

1. **入力ファイル**
   - `main.aux` - 作業ディレクトリから相対パス
   - `reference.bib` - `\bibdata{reference}`から相対パスで解決
   - `junsrt.bst` - スタイルファイルを相対パスで検索

2. **出力ファイル**
   - `main.blg` - 作業ディレクトリに相対パスで出力
   - `main.bbl` - 作業ディレクトリに相対パスで出力

### もしサブディレクトリに配置したい場合

#### 方法1: \bibliographyで相対パスを指定

```latex
\bibliography{./bib/reference}
```

または

```latex
\bibliography{bib/reference}
```

#### 方法2: 環境変数でパスを指定

`.vscode/settings.json`で環境変数を設定：

```json
{
    "latex-workshop.latex.tools": [
        {
            "name": "pbibtex",
            "command": "pbibtex",
            "args": [
                "-kanji=utf8",
                "%DOC%"
            ],
            "env": {
                "BIBINPUTS": "%DIR%/bib:"
            }
        }
    ]
}
```

#### 方法3: 出力ディレクトリを変更

`.vscode/settings.json`で出力ディレクトリを設定：

```json
{
    "latex-workshop.latex.outDir": "%DIR%/build"
}
```

ただし、`pbibtex`の出力（`main.blg`, `main.bbl`）は常に作業ディレクトリに出力されるため、`latex-workshop.latex.outDir`の設定は`uplatex`や`dvipdfmx`の出力にのみ影響します。

## 確認方法

### 1. main.auxの内容を確認

```bash
grep -E "\\bibdata|\\bibstyle" main.aux
```

出力例：
```
\bibstyle{junsrt}
\bibdata{reference}
```

### 2. pbibtexの実行ログを確認

```bash
pbibtex -kanji=utf8 main
```

出力例：
```
The top-level auxiliary file: main.aux
The style file: junsrt.bst
Database file #1: reference.bib
```

### 3. ファイルアクセスを確認

```bash
strace -e open,openat pbibtex -kanji=utf8 main 2>&1 | grep -E "reference\.bib|main\.(aux|bbl|blg)"
```

出力例：
```
openat(AT_FDCWD, "main.aux", O_RDONLY)  = 5
openat(AT_FDCWD, "main.blg", O_WRONLY|O_CREAT|O_TRUNC, 0666) = 6
openat(AT_FDCWD, "main.bbl", O_WRONLY|O_CREAT|O_TRUNC, 0666) = 7
openat(AT_FDCWD, "reference.bib", O_RDONLY) = 9
```

これらはすべて相対パス（`AT_FDCWD`は現在の作業ディレクトリ）で開かれています。

## まとめ

- `main.blg`のパスは`pbibtex`の実行時の作業ディレクトリで決定される
- `\bibliography{reference}`が`main.aux`に`\bibdata{reference}`として書き込まれる
- `pbibtex`は`main.aux`から`\bibdata{reference}`を読み、`reference.bib`を相対パスで探す
- `main.blg`と`main.bbl`は常に作業ディレクトリに相対パスで出力される
- 既に相対パスで動作しているため、特別な設定は不要

