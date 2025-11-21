# コンパイル時のログをすべて確認する方法

## 概要

LaTeXコンパイル時のログを確認する方法を説明します。エラーの原因を特定するために重要です。

## 方法1: LaTeX Workshopの出力パネル（最も重要）

### 基本的な確認方法

1. **出力パネルを開く**
   - `Ctrl+Shift+U` (Windows/Linux) または `Cmd+Shift+U` (macOS)
   - または、メニューから「表示」→「出力」

2. **出力チャンネルを選択**
   - 出力パネルの右上のドロップダウンをクリック
   - 以下のチャンネルから選択：
     - **「LaTeX Compiler」**: コンパイル時のログ（最重要）
     - **「LaTeX Workshop」**: 拡張機能の全般的なログ
     - **「LaTeX Workshop Log」**: 詳細なログ

3. **ビルドを実行**
   - `Ctrl+Alt+B` (Windows/Linux) または `Cmd+Option+B` (macOS)
   - または、コマンドパレットから「LaTeX Workshop: Build LaTeX project」

4. **ログを確認**
   - 実行されたコマンド
   - エラーメッセージ
   - 警告メッセージ
   - コンパイルの進行状況

### 出力パネルで確認できる情報

**LaTeX Compilerチャンネル**:
```
Running 'uplatex' with args: -synctex=1 -interaction=nonstopmode -file-line-error -kanji=utf8 main.tex
Running 'pbibtex' with args: ...
Running 'dvipdfmx' with args: ...
```

**実際に実行されたコマンド**:
- 変数の展開結果（`%DIR%` → 実際のパス）
- 実行されたコマンドの完全な形式
- エラーメッセージの詳細

### ログを保存する

出力パネルの内容をコピー：
1. 出力パネルで右クリック
2. 「すべて選択」または範囲選択
3. `Ctrl+C`でコピー
4. テキストファイルに貼り付け

## 方法2: LaTeX Workshopのログ設定を有効化

### 詳細なログを有効にする

`.vscode/settings.json`に以下を追加：

```json
{
    "latex-workshop.message.log.show": true,
    "latex-workshop.message.badge.show": true,
    "latex-workshop.message.error.show": true,
    "latex-workshop.message.warning.show": true
}
```

### 各設定の意味

- `latex-workshop.message.log.show`: ログメッセージを表示
- `latex-workshop.message.badge.show`: ステータスバッジを表示
- `latex-workshop.message.error.show`: エラーメッセージを表示
- `latex-workshop.message.warning.show`: 警告メッセージを表示

## 方法3: 生成されるログファイルを確認

### main.log（uplatexのログ）

```bash
# ログファイルを確認
cat main.log

# エラーのみを確認
grep -i "error" main.log

# 警告のみを確認
grep -i "warning" main.log

# エラーと警告を確認
grep -i -E "error|warning" main.log

# 最後の50行を確認
tail -50 main.log
```

### main.blg（pbibtexのログ）

```bash
# pbibtexのログを確認
cat main.blg

# エラーのみを確認
grep -i "error" main.blg
```

### その他のログファイル

```bash
# すべてのログファイルを確認
ls -lh *.log *.blg 2>/dev/null

# 最新のログファイルを確認
ls -lt *.log *.blg 2>/dev/null | head -10
```

## 方法4: 手動コンパイル時のログ

### ログをファイルに保存

```bash
# すべての出力をログファイルに保存
uplatex -kanji=utf8 -interaction=nonstopmode main.tex 2>&1 | tee uplatex.log
pbibtex -kanji=utf8 main 2>&1 | tee pbibtex.log
dvipdfmx -f ptex-ipaex.map -z 0 main.dvi 2>&1 | tee dvipdfmx.log
```

### 詳細なログを取得

```bash
# すべてのステップを1つのログファイルに保存
{
    echo "=== Step 1: uplatex (1st) ==="
    uplatex -synctex=1 -interaction=nonstopmode -file-line-error -kanji=utf8 main.tex
    echo ""
    echo "=== Step 2: pbibtex ==="
    pbibtex -kanji=utf8 main
    echo ""
    echo "=== Step 3: uplatex (2nd) ==="
    uplatex -synctex=1 -interaction=nonstopmode -file-line-error -kanji=utf8 main.tex
    echo ""
    echo "=== Step 4: uplatex (3rd) ==="
    uplatex -synctex=1 -interaction=nonstopmode -file-line-error -kanji=utf8 main.tex
    echo ""
    echo "=== Step 5: dvipdfmx ==="
    dvipdfmx -f ptex-ipaex.map -z 0 main.dvi
} 2>&1 | tee compile_full.log
```

## 方法5: latexmkのログ

### 詳細モードで実行

```bash
# 詳細なログを表示
latexmk -pdfdvi -verbose main.tex

# ログをファイルに保存
latexmk -pdfdvi -verbose main.tex 2>&1 | tee latexmk.log
```

### latexmkのログファイル

```bash
# .fdb_latexmkファイル（latexmkのデータベース）
cat main.fdb_latexmk

# .flsファイル（ファイルリスト）
cat main.fls
```

## 方法6: VSCodeの統合ターミナルで確認

### ターミナルで直接コンパイル

1. 統合ターミナルを開く（`` Ctrl+` ``）
2. 手動でコンパイルコマンドを実行
3. リアルタイムでログを確認

```bash
# ターミナルで実行
cd /home/apetr/Documents/sandbox/master_thesis
uplatex -kanji=utf8 -interaction=nonstopmode main.tex
pbibtex -kanji=utf8 main
# ... など
```

## 方法7: エラーと警告のフィルタリング

### main.logからエラーを抽出

```bash
# エラーのみを表示
grep -A 5 "Error" main.log

# 警告のみを表示
grep -A 3 "Warning" main.log

# エラーと警告を表示
grep -E "Error|Warning" main.log -A 3

# 行番号付きで表示
grep -n -E "Error|Warning" main.log
```

### pbibtexのエラーを確認

```bash
# main.blgからエラーを確認
grep -i "error\|warning" main.blg -A 2
```

## 推奨される確認手順

### ステップ1: LaTeX Workshopの出力パネルを確認

1. `Ctrl+Shift+U`で出力パネルを開く
2. 「LaTeX Compiler」を選択
3. `Ctrl+Alt+B`でビルド実行
4. エラーメッセージを確認

### ステップ2: ログファイルを確認

```bash
# 最新のログを確認
tail -100 main.log

# エラーを確認
grep -i "error" main.log -A 5
```

### ステップ3: 詳細なログを有効化

`.vscode/settings.json`に以下を追加：

```json
{
    "latex-workshop.message.log.show": true,
    "latex-workshop.message.badge.show": true
}
```

### ステップ4: 手動でコンパイルしてログを確認

```bash
# すべてのログを1つのファイルに保存
{
    uplatex -synctex=1 -interaction=nonstopmode -file-line-error -kanji=utf8 main.tex
    pbibtex -kanji=utf8 main
    uplatex -synctex=1 -interaction=nonstopmode -file-line-error -kanji=utf8 main.tex
    uplatex -synctex=1 -interaction=nonstopmode -file-line-error -kanji=utf8 main.tex
    dvipdfmx -f ptex-ipaex.map -z 0 main.dvi
} 2>&1 | tee compile_full.log
```

## 便利なコマンド

### ログをまとめて確認

```bash
#!/bin/bash
# compile_log_viewer.sh

echo "=== LaTeX Compilation Logs ==="
echo ""

if [ -f main.log ]; then
    echo "=== main.log (uplatex) ==="
    echo "Last 50 lines:"
    tail -50 main.log
    echo ""
    echo "Errors:"
    grep -i "error" main.log | tail -20
    echo ""
fi

if [ -f main.blg ]; then
    echo "=== main.blg (pbibtex) ==="
    cat main.blg
    echo ""
fi

echo "=== File sizes ==="
ls -lh main.{log,blg,aux,bbl} 2>/dev/null
```

### エラーのみを抽出

```bash
# すべてのログからエラーを抽出
grep -r -i "error" *.log *.blg 2>/dev/null | head -50
```

## LaTeX Workshopの出力パネルのチャンネル

### 利用可能なチャンネル

1. **LaTeX Compiler**
   - コンパイル時のログ
   - 実行されたコマンド
   - エラーメッセージ
   - **最も重要**

2. **LaTeX Workshop**
   - 拡張機能の全般的なログ
   - ビルドの開始/終了
   - PDF viewerの状態

3. **LaTeX Workshop Log**
   - 詳細なデバッグログ
   - 内部的な処理のログ

### チャンネルの切り替え

出力パネルの右上のドロップダウンから選択。

## トラブルシューティング

### ログが表示されない場合

1. **出力パネルが開いているか確認**
   - `Ctrl+Shift+U`で開く

2. **正しいチャンネルを選択しているか確認**
   - 「LaTeX Compiler」を選択

3. **ビルドが実行されているか確認**
   - `Ctrl+Alt+B`でビルド実行
   - 出力パネルに何か表示されるか確認

4. **LaTeX Workshopの設定を確認**
   ```json
   {
       "latex-workshop.message.log.show": true
   }
   ```

### ログファイルが生成されない場合

1. **コンパイルが実行されているか確認**
   ```bash
   ls -la main.log
   ```

2. **手動でコンパイルしてログを生成**
   ```bash
   uplatex -kanji=utf8 main.tex
   ls -la main.log
   ```

## まとめ

### コンパイルログを確認する方法（優先順位順）

1. **LaTeX Workshopの出力パネル**（最重要）
   - `Ctrl+Shift+U` → 「LaTeX Compiler」を選択
   - 実行されたコマンドとエラーを確認

2. **main.logファイル**
   - `tail -100 main.log` または `cat main.log`
   - uplatexの詳細なログ

3. **main.blgファイル**
   - `cat main.blg`
   - pbibtexのログ

4. **手動コンパイル**
   - ターミナルで直接実行してログを確認
   - `tee`コマンドでログを保存

5. **latexmkのログ**
   - `latexmk -pdfdvi -verbose main.tex`
   - 詳細な実行ログ

### エラーを特定するための推奨手順

1. LaTeX Workshopの出力パネルで「LaTeX Compiler」を確認
2. `main.log`からエラーを抽出: `grep -i "error" main.log -A 5`
3. `main.blg`を確認: `cat main.blg`
4. 必要に応じて手動コンパイルでログを確認

これらの方法により、コンパイル時のすべてのログを確認できます。

