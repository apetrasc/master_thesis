# LaTeX Workshop PDF Viewer キャッシュの場所

## 「Refresh all latex pdf viewers」が動作する理由

このコマンドを実行すると、LaTeX WorkshopがPDF viewerの内部状態をリフレッシュします。

## キャッシュが残る可能性のある場所

### 1. LaTeX Workshopの内部状態（エディタ内）

**場所:** エディタのメモリ内（ファイルシステム上には存在しない）

LaTeX Workshop拡張機能が保持する内部状態：
- PDF viewerの接続状態
- SyncTeXファイルの読み込み状態
- PDFファイルのパス情報
- ビューアの設定状態
- 最後に開いたPDFファイルの情報

**解決方法:**
- 「Refresh all latex pdf viewers」コマンドを実行（`Ctrl+Shift+P` → "LaTeX Workshop: Refresh all latex pdf viewers"）
- または、エディタを再起動

### 2. ワークスペース内のファイル

以下のファイルが古い状態で残っている可能性があります：

```bash
# SyncTeXファイル（PDFとソースコードの対応関係）
main.synctex.gz

# LaTeX Workshopの状態ファイル
*.fdb_latexmk  # latexmkのデータベース
*.fls          # ファイルリスト

# 一時PDFファイル
*_temp.pdf
```

**確認方法:**
```bash
ls -lh main.synctex.gz *.fdb_latexmk *.fls *_temp.pdf 2>/dev/null
```

**解決方法:**
- LaTeX Workshopでビルドを再実行（`Ctrl+Alt+B`）
- または、LaTeX Workshopの「Clean up auxiliary files」コマンドを実行

### 3. エディタのワークスペースキャッシュ

**場所:** `.vscode/`ディレクトリ内（設定ファイルのみ、キャッシュファイルは通常存在しない）

エディタが保持するワークスペース情報は設定ファイルのみで、通常はキャッシュファイルは保存されません。

### 4. PDF viewer拡張機能のキャッシュ

**場所:** エディタの拡張機能ディレクトリ（ユーザーのホームディレクトリ内）

PDF viewer拡張機能（PDF Previewなど）が保持するキャッシュ：
- 読み込んだPDFの状態
- フォント情報のキャッシュ
- レンダリング結果のキャッシュ

**解決方法:**
- 「Refresh all latex pdf viewers」コマンドを実行
- PDF viewer拡張機能を無効化→再有効化
- エディタを再起動

## 推奨される解決方法

### 方法1: 「Refresh all latex pdf viewers」を実行（最も簡単・推奨）

1. `Ctrl+Shift+P` (Windows/Linux) または `Cmd+Shift+P` (macOS)
2. 「LaTeX Workshop: Refresh all latex pdf viewers」と入力
3. 実行

このコマンドは以下を実行します：
- PDF viewerの接続をリセット
- SyncTeXファイルの再読み込み
- PDF viewerの状態をリフレッシュ

### 方法2: LaTeX Workshopでビルドを再実行

1. `Ctrl+Alt+B` (Windows/Linux) または `Cmd+Option+B` (macOS)
2. ビルドが完了するまで待つ
3. SyncTeXファイルが再生成される
4. 「View LaTeX PDF」を実行

### 方法3: エディタを再起動

1. エディタを完全に閉じる
2. 再度開く
3. LaTeX Workshopの内部状態がリセットされる

### 方法4: 中間ファイルをクリーンアップ

LaTeX Workshopの「Clean up auxiliary files」コマンドを実行：
1. `Ctrl+Shift+P` (Windows/Linux) または `Cmd+Shift+P` (macOS)
2. 「LaTeX Workshop: Clean up auxiliary files」と入力
3. 実行

または、手動で削除：
```bash
rm -f main.aux main.bbl main.blg main.synctex.gz *.fdb_latexmk *.fls *_temp.pdf
```

## 自動クリーンアップの設定

`.vscode/settings.json`で以下のファイルタイプが自動クリーンアップ対象になっています：

```json
{
    "latex-workshop.latex.clean.fileTypes": [
        "*.aux",
        "*.bbl",
        "*.blg",
        "*.synctex.gz",
        "*.fdb_latexmk",
        "*.fls",
        "*_temp.pdf"
    ]
}
```

## まとめ

**キャッシュが残る主な場所:**
1. **LaTeX Workshopの内部状態**（エディタのメモリ内）- 「Refresh all latex pdf viewers」で解決
2. **SyncTeXファイル**（`main.synctex.gz`）- ビルドを再実行で再生成
3. **LaTeX Workshopの状態ファイル**（`*.fdb_latexmk`, `*.fls`）- クリーンアップで削除
4. **PDF viewer拡張機能のキャッシュ**（エディタの拡張機能ディレクトリ）- エディタ再起動で解決

**最も簡単な解決方法:**
- 「Refresh all latex pdf viewers」コマンドを実行
- これにより、LaTeX Workshopの内部状態がリフレッシュされ、PDF viewerが正しく動作するようになります
