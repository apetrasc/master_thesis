# Ctrl+Alt+B で実行される設定の詳細

## 概要

`Ctrl+Alt+B` (Windows/Linux) または `Cmd+Option+B` (macOS) を押すと、LaTeX Workshopが以下のレシピを実行します。

## デフォルトレシピ

**レシピ名:** `uplatex + pbibtex + dvipdfmx + optimize`

## 実行順序と各ツールの詳細設定

### 1. uplatex (1回目)
- **コマンド:** `uplatex`
- **引数:** `-synctex=1 -interaction=nonstopmode -file-line-error -kanji=utf8 main.tex`
- **目的:** 
  - LaTeXコンパイルの下準備
  - 目次・参照ラベルの作成
  - `main.aux`ファイルの生成
  - SyncTeXファイルの生成開始

### 2. pbibtex
- **コマンド:** `pbibtex`
- **引数:** `-kanji=utf8 main`
- **目的:**
  - 参考文献データベース（`reference.bib`）の処理
  - `main.bbl`ファイルの生成
  - `main.blg`ファイルの生成（ログ）
- **⚠️ エラーが発生する可能性:**
  - `openout_any = p`エラーが発生する場合がある
  - LaTeX Workshopの実行環境でセキュリティ制限が適用される
  - 手動で実行すると正常に動作する

### 3. uplatex (2回目)
- **コマンド:** `uplatex`
- **引数:** `-synctex=1 -interaction=nonstopmode -file-line-error -kanji=utf8 main.tex`
- **目的:**
  - 参考文献（`main.bbl`）を反映
  - 目次を更新
  - 相互参照を部分的に反映

### 4. uplatex (3回目)
- **コマンド:** `uplatex`
- **引数:** `-synctex=1 -interaction=nonstopmode -file-line-error -kanji=utf8 main.tex`
- **目的:**
  - 相互参照を完全に反映
  - 目次・参考文献の最終更新
  - `main.dvi`ファイルの生成
  - `main.synctex.gz`ファイルの完成

### 5. dvipdfmx-temp
- **コマンド:** `dvipdfmx`
- **引数:** `-f ptex-ipaex.map -z 0 -o main_temp.pdf main.dvi`
- **目的:**
  - DVIファイルをPDFに変換
  - フォントマップ（`ptex-ipaex.map`）を使用
  - SyncTeXを有効化（`-z 0`）
  - 一時ファイル（`main_temp.pdf`）として出力
- **フォント設定:**
  - `ptex-ipaex.map`を使用して日本語フォントを処理

### 6. optimize-pdf
- **コマンド:** `bash -c "gs ..."`
- **引数:** 
  ```
  gs -dNOPAUSE -dBATCH -sDEVICE=pdfwrite 
     -dEmbedAllFonts=true -dSubsetFonts=true 
     -dCompatibilityLevel=1.5 
     -sOutputFile='main.pdf' 'main_temp.pdf' 
     && rm -f 'main_temp.pdf'
  ```
- **目的:**
  - GhostscriptでPDFを最適化
  - フォントを埋め込み（`-dEmbedAllFonts=true`）
  - フォントをサブセット化（`-dSubsetFonts=true`）
  - 最終的な`main.pdf`を生成
  - 一時ファイル（`main_temp.pdf`）を削除
- **重要:** このステップにより、エディタのPDF viewerで日本語が正しく表示される

## エラーが発生する原因と解決策

### pbibtexの`openout_any = p`エラー

**現象:**
- `Ctrl+Alt+B`を実行すると`pbibtex`でエラーが発生
- 日本語が表示されない
- 「Refresh all latex pdf viewers」を実行すると正常に表示される

**原因:**
1. LaTeX Workshopの実行環境で`openout_any = p`のセキュリティ制限が適用される
2. `pbibtex`が`.blg`ファイルに書き込もうとして失敗
3. ビルドプロセスが中断される
4. フォントが埋め込まれていないPDFが生成される
5. エディタのPDF viewerで日本語が表示されない

**解決策:**
1. **「Refresh all latex pdf viewers」を実行**
   - `Ctrl+Shift+P` → "LaTeX Workshop: Refresh all latex pdf viewers"
   - LaTeX Workshopの内部状態をリフレッシュ
   - PDF viewerの接続をリセット

2. **中間ファイルをクリーンアップ**
   - `Ctrl+Shift+P` → "LaTeX Workshop: Clean up auxiliary files"
   - 古い中間ファイルを削除

3. **エディタを再起動**
   - LaTeX Workshopの実行環境を完全にリセット

4. **ビルドを再実行**
   - `Ctrl+Alt+B`で再度ビルド
   - 正常に完了すれば、フォントが埋め込まれたPDFが生成される

## その他の重要な設定

### 自動ビルド
- `"latex-workshop.latex.autoBuild.run": "onFileChange"`
- ファイル変更時に自動的にビルドが実行される

### PDF Viewer
- `"latex-workshop.view.pdf.viewer": "tab"`
- エディタ内のタブでPDFを表示

### SyncTeX
- `"latex-workshop.view.pdf.internal.synctex.mode": 1`
- `"latex-workshop.view.pdf.internal.synctex.keybinding": "double-click"`
- PDFとソースコードの双方向同期が有効
- ダブルクリックで対応箇所に移動

### 出力設定
- `"latex-workshop.latex.outDir": "%DIR%"`
- `"latex-workshop.latex.root": "main.tex"`
- 出力はワークスペースのルートディレクトリ
- ルートファイルは`main.tex`

### クリーンアップ対象
以下のファイルタイプが自動クリーンアップ対象：
- `*.aux`, `*.bbl`, `*.blg` - LaTeX補助ファイル
- `*.synctex.gz` - SyncTeXファイル
- `*.fdb_latexmk`, `*.fls` - LaTeX Workshopの状態ファイル
- `*.dvi` - DVIファイル
- `*_temp.pdf` - 一時PDFファイル

## フォント設定

### フォントマップファイル
- `ptex-ipaex.map` - 日本語フォント（IPAex）のマップファイル
- システムにインストールされているTeX Liveのファイル
- パス: `/usr/share/texlive/texmf-dist/fonts/map/dvipdfmx/ptex-fontmaps/ipaex/ptex-ipaex.map`

### フォント埋め込み
- `optimize-pdf`ステップでGhostscriptを使用
- `-dEmbedAllFonts=true`でフォントを埋め込み
- エディタのPDF viewerで日本語が正しく表示される

## まとめ

**Ctrl+Alt+Bで実行される処理:**
1. uplatex (3回) + pbibtex でLaTeXコンパイル
2. dvipdfmx でDVI→PDF変換（フォントマップ使用）
3. Ghostscript でPDF最適化（フォント埋め込み）

**エラーが発生する場合:**
- `pbibtex`の`openout_any = p`エラー
- LaTeX Workshopの実行環境の問題
- 「Refresh all latex pdf viewers」で解決

**リロードで解決する理由:**
- LaTeX Workshopの内部状態がリフレッシュされる
- PDF viewerの接続がリセットされる
- フォントが埋め込まれたPDFが正しく読み込まれる



