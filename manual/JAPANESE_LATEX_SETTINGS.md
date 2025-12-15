# 日本語LaTeXコンパイルに適したLaTeX Workshop設定

## 概要

このドキュメントでは、日本語LaTeX文書（uplatex + pbibtex + dvipdfmx）をコンパイルするためのLaTeX Workshop設定を説明します。

## 推奨設定

### `.vscode/settings.json`の主要な設定

```json
{
    "latex-workshop.latex.tools": [
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
        },
        {
            "name": "pbibtex",
            "command": "bash",
            "args": [
                "-c",
                "cd '%DIR%' && pbibtex -kanji=utf8 '%DOC%'"
            ]
        },
        {
            "name": "dvipdfmx",
            "command": "dvipdfmx",
            "args": [
                "-f",
                "ptex-ipaex.map",
                "-z",
                "0",
                "%DOC%.dvi"
            ]
        }
    ],
    "latex-workshop.latex.recipes": [
        {
            "name": "uplatex + pbibtex + dvipdfmx",
            "tools": [
                "uplatex",
                "pbibtex",
                "uplatex",
                "uplatex",
                "dvipdfmx"
            ]
        }
    ],
    "latex-workshop.latex.recipe.default": "uplatex + pbibtex + dvipdfmx",
    "latex-workshop.latex.outDir": "%DIR%",
    "latex-workshop.latex.root": "main.tex",
    "latex-workshop.synctex.afterBuild.enabled": true,
    "latex-workshop.view.pdf.viewer": "tab",
    "latex-workshop.latex.option.shellEscape": "never"
}
```

## 各設定の説明

### 1. uplatex（日本語LaTeXコンパイラ）

```json
{
    "name": "uplatex",
    "command": "uplatex",
    "args": [
        "-synctex=1",              // SyncTeX有効化（PDFとソースの同期）
        "-interaction=nonstopmode", // エラー時も停止せず続行
        "-file-line-error",        // エラー行番号を表示
        "-kanji=utf8",             // UTF-8日本語対応
        "%DOC%"                    // ドキュメント名（拡張子なし）
    ]
}
```

**重要なオプション**:
- `-kanji=utf8`: UTF-8エンコーディングで日本語を処理
- `-synctex=1`: PDFとソースコードの双方向同期を有効化
- `-interaction=nonstopmode`: エラー時も処理を続行（自動ビルドに適している）

### 2. pbibtex（日本語参考文献処理）

```json
{
    "name": "pbibtex",
    "command": "bash",
    "args": [
        "-c",
        "cd '%DIR%' && pbibtex -kanji=utf8 '%DOC%'"
    ]
}
```

**重要なポイント**:
- `cd '%DIR%'`: 作業ディレクトリを明示的に設定（`openout_any = p`エラーを回避）
- `-kanji=utf8`: UTF-8エンコーディングで日本語を処理
- シェルスクリプトを使用して作業ディレクトリを確実に設定

**`openout_any = p`エラーについて**:
- LaTeXのセキュリティ設定により、絶対パスでのファイル書き込みが制限される
- 作業ディレクトリを明示的に設定することで、相対パスでアクセスしエラーを回避

### 3. dvipdfmx（DVIからPDFへの変換）

```json
{
    "name": "dvipdfmx",
    "command": "dvipdfmx",
    "args": [
        "-f", "ptex-ipaex.map",  // 日本語フォントマップ
        "-z", "0",                // 圧縮レベル（0=無圧縮）
        "%DOC%.dvi"               // DVIファイル
    ]
}
```

**重要なオプション**:
- `-f ptex-ipaex.map`: 日本語フォント（IPAex）のマップファイルを指定
- `-z 0`: 圧縮なし（デバッグ時に便利）

### 4. ビルドレシピ

```json
{
    "name": "uplatex + pbibtex + dvipdfmx",
    "tools": [
        "uplatex",    // 1回目：下準備と目次・参照ラベル作成
        "pbibtex",    // 参考文献の処理
        "uplatex",    // 2回目：参考文献や目次に反映
        "uplatex",    // 3回目：相互参照や目次・参考文献の完全な反映
        "dvipdfmx"    // PDFに変換
    ]
}
```

**実行順序の理由**:
1. **1回目のuplatex**: `.aux`ファイルを生成し、目次や参照ラベルを作成
2. **pbibtex**: `.aux`から参考文献情報を読み取り、`.bbl`を生成
3. **2回目のuplatex**: 参考文献や目次を反映
4. **3回目のuplatex**: 相互参照を完全に反映
5. **dvipdfmx**: DVIをPDFに変換

### 5. その他の重要な設定

```json
{
    "latex-workshop.latex.outDir": "%DIR%",           // 出力ディレクトリ
    "latex-workshop.latex.root": "main.tex",         // ルートファイル
    "latex-workshop.synctex.afterBuild.enabled": true, // ビルド後SyncTeX実行
    "latex-workshop.view.pdf.viewer": "tab",         // PDFをタブで表示
    "latex-workshop.latex.option.shellEscape": "never" // シェルエスケープ無効
}
```

## コンパイル手順

### LaTeX Workshopを使用する場合

1. `Ctrl+Alt+B` (Windows/Linux) または `Cmd+Option+B` (macOS) でビルド
2. 自動的に以下の順序で実行されます：
   - uplatex → pbibtex → uplatex → uplatex → dvipdfmx

### 手動でコンパイルする場合

```bash
uplatex -kanji=utf8 -synctex=1 -interaction=nonstopmode main.tex
pbibtex -kanji=utf8 main
uplatex -kanji=utf8 -synctex=1 -interaction=nonstopmode main.tex
uplatex -kanji=utf8 -synctex=1 -interaction=nonstopmode main.tex
dvipdfmx -f ptex-ipaex.map -z 0 main.dvi
```

## よくある問題と解決方法

### 1. `openout_any = p`エラー

**エラーメッセージ**:
```
pbibtex: Not writing to /path/to/main.blg (openout_any = p).
I couldn't open file name `/path/to/main.blg'
```

**解決方法**:
- `pbibtex`の設定で`cd '%DIR%'`を追加して作業ディレクトリを明示的に設定
- これにより相対パスでアクセスし、エラーを回避

### 2. 日本語が正しく表示されない

**原因**:
- `-kanji=utf8`オプションが欠けている
- フォントマップが正しく設定されていない

**解決方法**:
- `uplatex`に`-kanji=utf8`を追加
- `pbibtex`に`-kanji=utf8`を追加
- `dvipdfmx`に`-f ptex-ipaex.map`を追加

### 3. 参考文献が表示されない

**原因**:
- `pbibtex`が実行されていない
- コンパイル回数が不足

**解決方法**:
- レシピで`pbibtex`が含まれていることを確認
- uplatexを3回実行することを確認

### 4. 目次が更新されない

**原因**:
- コンパイル回数が不足

**解決方法**:
- uplatexを複数回実行（通常2-3回）

## 関連ファイル

- `latexmkrc`: `latexmk`を使用する場合の設定
- `main.tex`: メインのLaTeXファイル
- `reference.bib`: 参考文献データベース

## まとめ

日本語LaTeXコンパイルに適した設定の要点：

1. **uplatex**: `-kanji=utf8`オプション必須
2. **pbibtex**: `-kanji=utf8`オプション + 作業ディレクトリの明示的設定
3. **dvipdfmx**: `-f ptex-ipaex.map`で日本語フォント指定
4. **実行順序**: uplatex → pbibtex → uplatex → uplatex → dvipdfmx
5. **SyncTeX**: PDFとソースコードの双方向同期を有効化

これらの設定により、日本語LaTeX文書を効率的にコンパイルできます。

