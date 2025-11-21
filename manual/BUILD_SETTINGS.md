# LaTeX Workshop ビルド設定

## 現在のデフォルト設定

### デフォルトレシピ

**設定値:** `"uplatex + pbibtex + dvipdfmx + optimize"`

### Ctrl+Alt+B でビルドする際の動作

`Ctrl+Alt+B` (Windows/Linux) または `Cmd+Option+B` (macOS) を押すと、以下のレシピが実行されます：

**レシピ名:** `uplatex + pbibtex + dvipdfmx + optimize`

**実行順序:**
1. **uplatex** - LaTeXコンパイル（1回目）
   - コマンド: `uplatex`
   - 引数: `-synctex=1 -interaction=nonstopmode -file-line-error -kanji=utf8 main.tex`
   - 目的: 下準備と目次・参照ラベル作成、`main.aux`を生成

2. **pbibtex** - 参考文献処理
   - コマンド: `pbibtex`
   - 引数: `-kanji=utf8 main`
   - 目的: 参考文献データベースを処理、`main.bbl`を生成

3. **uplatex** - LaTeXコンパイル（2回目）
   - コマンド: `uplatex`
   - 引数: `-synctex=1 -interaction=nonstopmode -file-line-error -kanji=utf8 main.tex`
   - 目的: 参考文献や目次に反映

4. **uplatex** - LaTeXコンパイル（3回目）
   - コマンド: `uplatex`
   - 引数: `-synctex=1 -interaction=nonstopmode -file-line-error -kanji=utf8 main.tex`
   - 目的: 相互参照や目次・参考文献の完全な反映

5. **dvipdfmx-temp** - DVIからPDFへ変換（一時ファイル）
   - コマンド: `dvipdfmx`
   - 引数: `-f ptex-ipaex.map -z 0 -o main_temp.pdf main.dvi`
   - 目的: DVIファイルをPDFに変換（フォントマップ使用、SyncTeX有効）
   - 出力: `main_temp.pdf`（一時ファイル）

6. **optimize-pdf** - PDF最適化（フォント埋め込み）
   - コマンド: `bash -c "gs ..."`
   - 引数: GhostscriptでPDFを最適化
   - 目的: フォントを埋め込み、エディタのPDF viewerで正しく表示されるようにする
   - 出力: `main.pdf`（最終的なPDF）
   - 処理後: `main_temp.pdf`を削除

## 設定の詳細

### ツール定義

#### uplatex
```json
{
    "name": "uplatex",
    "command": "uplatex",
    "args": [
        "-synctex=1",
        "-interaction=nonstopmode",
        "-file-line-error",
        "-kanji=utf8",
        "%DOC%"
    ]
}
```

#### pbibtex
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

#### dvipdfmx-temp
```json
{
    "name": "dvipdfmx-temp",
    "command": "dvipdfmx",
    "args": [
        "-f",
        "ptex-ipaex.map",
        "-z",
        "0",
        "-o",
        "%DOC%_temp.pdf",
        "%DOC%.dvi"
    ]
}
```

#### optimize-pdf
```json
{
    "name": "optimize-pdf",
    "command": "bash",
    "args": [
        "-c",
        "gs -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -dEmbedAllFonts=true -dSubsetFonts=true -dCompatibilityLevel=1.5 -sOutputFile='%DOC%.pdf' '%DOC%_temp.pdf' && rm -f '%DOC%_temp.pdf'"
    ]
}
```

## その他の設定

### 自動ビルド
- `"latex-workshop.latex.autoBuild.run": "onFileChange"`
- ファイル変更時に自動的にビルドが実行されます

### クリーンアップ対象ファイル
以下のファイルタイプが自動クリーンアップ対象です：
- `*.aux`, `*.bbl`, `*.blg` - LaTeX補助ファイル
- `*.synctex.gz` - SyncTeXファイル
- `*.fdb_latexmk`, `*.fls` - LaTeX Workshopの状態ファイル
- `*.dvi` - DVIファイル
- `*_temp.pdf` - 一時PDFファイル

### PDF Viewer設定
- `"latex-workshop.view.pdf.viewer": "tab"` - エディタ内のタブで表示
- SyncTeX: 有効（ダブルクリックで対応箇所に移動）

## レシピの変更方法

別のレシピを使用したい場合：

1. `Ctrl+Shift+P` (Windows/Linux) または `Cmd+Shift+P` (macOS)
2. 「LaTeX Workshop: Build with recipe」と入力
3. 使用したいレシピを選択

または、`.vscode/settings.json`で`latex-workshop.latex.recipe.default`を変更します。



