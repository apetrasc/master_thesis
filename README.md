# master_thesis
修士論文Latexレポジトリ

## PDF作成手順
2026卒　修士　学位論文をここに記します。

### PDF作成

#### latexmkを使用する場合（推奨）

`latexmkrc`ファイルに手動コンパイルで動作確認済みの設定を反映しています。

```bash
# PDFを生成（DVI経由）
latexmk -pdfdvi main.tex

# または
latexmk -pdf main.tex

# クリーンアップ（中間ファイルを削除）
latexmk -c main.tex

# 連続モード（ファイル変更を監視して自動コンパイル）
latexmk -pdfdvi -pvc main.tex
```

**latexmkの利点**:
- 手動で5つのコマンドを実行する必要がない
- 必要な回数だけ自動的にコンパイル
- 依存関係を自動管理
- 中間ファイルの自動クリーンアップ

#### 手動で行う場合

```bash
uplatex -synctex=1 -interaction=nonstopmode -file-line-error -kanji=utf8 main.tex    # 1回目：下準備と目次・参照ラベル作成
pbibtex -kanji=utf8 main        # 参考文献の処理
uplatex -synctex=1 -interaction=nonstopmode -file-line-error -kanji=utf8 main.tex    # 2回目：参考文献や目次に反映
uplatex -synctex=1 -interaction=nonstopmode -file-line-error -kanji=utf8 main.tex    # 3回目：相互参照や目次・参考文献の完全な反映
dvipdfmx -f ptex-ipaex.map -z 0 main.dvi   # PDFに変換
```

詳細は `manual/MANUAL_BUILD_COMMANDS.md` を参照してください。

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

6. **`pbibtex: Not writing to .../main.blg (openout_any = p)`エラー**
   - 原因: `pbibtex`が絶対パスでファイルにアクセスしようとしている
   - 解決: `texmf.cnf`の`openout_any`設定を変更（システムファイルのため要管理者権限）
   - または: `.vscode/settings.json`で`pbibtex`の実行環境を適切に設定（設定済み）

7. **PDFビューワが古い内容を表示する**
   - ビルド後、PDFビューワが更新されない場合
   - 解決: `Ctrl+Shift+P` → "LaTeX Workshop: Refresh all LaTeX pdf viewers"を実行
   - または: ショートカットキー`Ctrl+Shift+R`でリフレッシュ（設定済み）

### VS Code LaTeX Workshop Tips

#### コンパイルログの確認方法

**方法1: LaTeX Workshopの出力パネル（推奨）**
1. `Ctrl+Shift+U`で出力パネルを開く
2. ドロップダウンで「LaTeX Compiler」を選択
3. `Ctrl+Alt+B`でビルド実行
4. 実行されたコマンドとエラーを確認
5. **注意**: 複数のツール（uplatex, pbibtex, dvipdfmx）を実行する場合、出力パネルを上にスクロールして全ツールのログを確認

**方法2: ログファイルを直接確認（確実）**
```bash
# uplatexのログ
cat main.log
tail -100 main.log  # 最新100行

# pbibtexのログ
cat main.blg

# エラーのみ抽出
grep -i "error" main.log -A 5
```

**方法3: リアルタイムで確認**
```bash
# コンパイル中にリアルタイムでログを確認
tail -f main.log
```

#### 自動ビルド設定

- **設定場所**: `.vscode/settings.json`
- **設定項目**: `latex-workshop.latex.autoBuild.run`
- **現在の設定**: `onSave`（Ctrl+Sで保存時に自動ビルド）

**利用可能な値**:
- `onSave`: 保存時のみ自動ビルド
- `onFileChange`: ファイル変更時に自動ビルド
- `never`: 自動ビルドしない

#### ショートカットキー

- `Ctrl+Alt+B`: LaTeXプロジェクトをビルド
- `Ctrl+Alt+V`: PDFビューワを開く
- `Ctrl+Alt+C`: 中間ファイルをクリーンアップ
- `Ctrl+Shift+R`: PDFビューワをリフレッシュ
- `Ctrl+Alt+J`: SyncTeX（PDFとソースの同期）

