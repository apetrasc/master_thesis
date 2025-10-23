# master_thesis
修士論文Latexレポジトリ

## PDF作成手順
2026卒　修士　学位論文をここに記します。

### PDF作成

手順：
latexmkrcを使う場合
```
latexmk -pdf main.tex
```
手動で行う場合
```bash
uplatex main.tex    # 1回目：下準備と目次・参照ラベル作成
pbibtex main        # 参考文献の処理
uplatex main.tex    # 2回目：参考文献や目次に反映
uplatex main.tex    # 3回目：相互参照や目次・参考文献の完全な反映
dvipdfmx main.dvi   # PDFに変換
```

### 必要なソフトウェア

- uplatex（日本語LaTeX）
- dvipdfmx（DVIからPDFへの変換）
- pbibtex（参考文献処理）

### 生成されるファイル

- `main.pdf` - 最終的なPDFファイル
- `main.dvi` - 中間ファイル（DVI形式）
- `main.aux` - 補助ファイル
- `main.toc` - 目次ファイル
- `main.bbl` - 参考文献ファイル
- `main.log` - コンパイルログ

### VS Code LaTeX Workshop設定

このプロジェクトには`.vscode/settings.json`が含まれており、LaTeX Workshop拡張機能が正しく動作するように設定されています。

**重要な設定:**
- デフォルトのLaTeXエンジン: `uplatex`（`pdflatex`ではない）
- 自動ビルドレシピ: 目次と参考文献を含む完全なPDF作成
- クリーンアップ対象: 中間ファイルの自動削除

### トラブルシューティング

**よくあるエラーと解決方法:**

1. **"This file needs format `pLaTeX2e'"エラー**
   - 原因: `pdflatex`を使用している
   - 解決: `uplatex`を使用する（設定済み）

2. **LaTeX Workshopでエラーが発生する場合**
   - VS Codeを再起動
   - LaTeX Workshop拡張機能を再読み込み
   - `.vscode/settings.json`の設定を確認

3. **目次が表示されない場合**
   - 2回目のコンパイルを実行してください

4. **参考文献が表示されない場合**
   - pbibtexを実行してから3回目のコンパイルを実行してください

5. **エラーが発生した場合**
   - main.logファイルを確認してください
   - 中間ファイルをクリーンアップしてから再コンパイル

