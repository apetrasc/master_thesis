# VSCodeの再起動とReload Windowの違い

## 再起動方法の違い

### 1. Reload Window（Developer: Reload Window）

**実行方法**:
- `Ctrl+Shift+P` → "Developer: Reload Window"
- または `Ctrl+R` (Mac: `Cmd+R`)

**何が起こるか**:
- VSCodeのウィンドウをリロード
- 拡張機能の設定を再読み込み
- **VSCodeのプロセスは継続**（完全には終了しない）
- メモリ上の状態が一部残る可能性

**適用される変更**:
- 拡張機能の設定変更
- ワークスペース設定の変更
- 一部の環境変数の変更

**適用されない可能性がある変更**:
- 拡張機能の深い内部状態
- プロセスレベルの環境変数
- 拡張機能の初期化時の設定

### 2. 完全再起動

**実行方法**:
1. VSCodeを完全に閉じる（すべてのウィンドウを閉じる）
2. タスクマネージャーでプロセスが残っていないか確認
3. 再度VSCodeを開く

**何が起こるか**:
- VSCodeのプロセスを完全に終了
- すべてのメモリ状態をクリア
- 拡張機能を完全に再初期化
- 環境変数を完全に再読み込み

**適用される変更**:
- すべての設定変更
- 拡張機能の完全な再初期化
- 環境変数の完全な再読み込み

## LaTeX Workshopでの違い

### Reload Windowの場合

LaTeX Workshopの内部状態が一部残る可能性：
- 実行環境のキャッシュ
- 変数展開のキャッシュ
- 作業ディレクトリの設定

### 完全再起動の場合

LaTeX Workshopが完全に再初期化：
- すべてのキャッシュがクリア
- 設定が完全に再読み込み
- 実行環境が完全にリセット

## エラーが続く場合の対処方法

### ステップ1: 設定の確認

```bash
# 設定ファイルの確認
cat .vscode/settings.json | python3 -m json.tool

# pbibtex設定の確認
cat .vscode/settings.json | python3 -c "import json,sys; d=json.load(sys.stdin); t=[t for t in d['latex-workshop.latex.tools'] if t['name']=='pbibtex'][0]; print(json.dumps(t, indent=2, ensure_ascii=False))"
```

正しい設定:
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

### ステップ2: 中間ファイルのクリーンアップ

```bash
cd /home/apetr/Documents/sandbox/master_thesis
rm -f main.aux main.bbl main.blg main.dvi main.log main.synctex.gz
```

### ステップ3: LaTeX Workshopの出力を確認

1. 出力パネルを開く（`Ctrl+Shift+U`）
2. 「LaTeX Compiler」を選択
3. ビルドを実行（`Ctrl+Alt+B`）
4. 実際に実行されたコマンドを確認

**確認ポイント**:
- `%DIR%`と`%DOC%`が正しく展開されているか
- `cd`コマンドが実行されているか
- エラーメッセージの詳細

### ステップ4: 手動でコマンドをテスト

LaTeX Workshopの出力に表示されたコマンドを手動で実行：

```bash
cd /home/apetr/Documents/sandbox/master_thesis
bash -c "cd '/home/apetr/Documents/sandbox/master_thesis' && pbibtex -kanji=utf8 'main'"
```

手動で動作する場合、LaTeX Workshopの変数展開に問題がある可能性。

### ステップ5: 代替設定を試す

#### 方法1: 環境変数を使用

```json
{
    "name": "pbibtex",
    "command": "bash",
    "args": [
        "-c",
        "cd \"${LATEX_DIR}\" && pbibtex -kanji=utf8 \"${LATEX_DOC}\""
    ],
    "env": {
        "LATEX_DIR": "%DIR%",
        "LATEX_DOC": "%DOC%"
    }
}
```

#### 方法2: より明示的なパス指定

```json
{
    "name": "pbibtex",
    "command": "bash",
    "args": [
        "-c",
        "cd \"%DIR%\" && pbibtex -kanji=utf8 \"%DOC%\""
    ]
}
```

（引用符を変更：シングルクォートからダブルクォートへ）

#### 方法3: スクリプトファイルを使用

`pbibtex_wrapper.sh`を作成：

```bash
#!/bin/bash
cd "$1"
pbibtex -kanji=utf8 "$2"
```

設定：
```json
{
    "name": "pbibtex",
    "command": "./pbibtex_wrapper.sh",
    "args": ["%DIR%", "%DOC%"]
}
```

### ステップ6: LaTeX Workshopの拡張機能を確認

1. 拡張機能パネルを開く（`Ctrl+Shift+X`）
2. "LaTeX Workshop"を検索
3. 拡張機能のバージョンを確認
4. 必要に応じて更新または再インストール

### ステップ7: デバッグモードで確認

LaTeX Workshopの設定でデバッグを有効化：

```json
{
    "latex-workshop.message.log.show": true,
    "latex-workshop.message.badge.show": true
}
```

出力パネルでより詳細なログを確認。

## 推奨される手順

エラーが続く場合の推奨手順：

1. **設定を確認**
   ```bash
   cat .vscode/settings.json | python3 -m json.tool
   ```

2. **中間ファイルをクリーンアップ**
   ```bash
   rm -f main.{aux,bbl,blg,dvi,log,synctex.gz}
   ```

3. **Reload Windowを実行**
   - `Ctrl+Shift+P` → "Developer: Reload Window"

4. **ビルドを実行してエラーを確認**
   - `Ctrl+Alt+B`
   - 出力パネルで実際のコマンドを確認

5. **まだエラーが続く場合、完全再起動**
   - VSCodeを完全に閉じる
   - プロセスが残っていないか確認
   - 再度開く

6. **それでもエラーが続く場合、代替設定を試す**
   - 環境変数を使用
   - スクリプトファイルを使用

## エラーが続く場合の具体的な対処手順

### ステップバイステップの対処

#### ステップ1: LaTeX Workshopの出力を確認（最重要）

1. 出力パネルを開く（`Ctrl+Shift+U`）
2. ドロップダウンで「LaTeX Compiler」を選択
3. `Ctrl+Alt+B`でビルドを実行
4. 出力に表示される**実際のコマンド**を確認

**確認ポイント**:
```
期待されるコマンド:
  bash -c "cd '/home/apetr/Documents/sandbox/master_thesis' && pbibtex -kanji=utf8 'main'"

実際に表示されるコマンドは？
- %DIR%と%DOC%が展開されているか
- cdコマンドが含まれているか
- エラーメッセージの詳細
```

#### ステップ2: 引用符を変更

現在の設定（ダブルクォート）:
```json
"cd \"%DIR%\" && pbibtex -kanji=utf8 \"%DOC%\""
```

シングルクォートに戻す場合:
```json
"cd '%DIR%' && pbibtex -kanji=utf8 '%DOC%'"
```

#### ステップ3: 環境変数を使用する方法

より確実な方法として、環境変数を使用：

```json
{
    "name": "pbibtex",
    "command": "bash",
    "args": [
        "-c",
        "cd \"${LATEX_DIR}\" && pbibtex -kanji=utf8 \"${LATEX_DOC}\""
    ],
    "env": {
        "LATEX_DIR": "%DIR%",
        "LATEX_DOC": "%DOC%"
    }
}
```

#### ステップ4: デバッグ用の設定

一時的にデバッグ情報を出力：

```json
{
    "name": "pbibtex",
    "command": "bash",
    "args": [
        "-c",
        "echo 'DEBUG: DIR=%DIR%' && echo 'DEBUG: DOC=%DOC%' && cd \"%DIR%\" && echo 'DEBUG: PWD=' && pwd && pbibtex -kanji=utf8 \"%DOC%\""
    ]
}
```

出力パネルで`DEBUG:`の後に表示される値を確認。

## Reload Window vs 完全再起動の違い

### 詳細な比較

| 項目 | Reload Window | 完全再起動 |
|------|--------------|-----------|
| **実行方法** | `Ctrl+Shift+P` → "Reload Window" | VSCodeを完全に閉じて再度開く |
| **プロセス** | 継続（VSCodeのメインプロセスは生きている） | 完全終了 |
| **メモリ状態** | 一部残る（拡張機能の内部状態など） | 完全クリア |
| **拡張機能** | 再読み込み（設定は再読み込みされるが、内部状態は残る可能性） | 完全再初期化 |
| **環境変数** | 一部再読み込み | 完全再読み込み |
| **適用される変更** | 大部分（90%程度） | すべて（100%） |
| **実行時間** | 数秒 | 数十秒〜1分 |
| **確実性** | 中程度 | 高い |

### なぜ完全再起動でも変化がないのか？

考えられる原因：

1. **LaTeX Workshopの変数展開の問題**
   - `%DIR%`と`%DOC%`が正しく展開されていない
   - 引用符の扱いの問題
   - LaTeX Workshopのバージョンの問題

2. **設定ファイルの読み込みタイミング**
   - 設定は読み込まれているが、実行時に問題が発生
   - キャッシュの問題ではなく、実行時の問題

3. **実行環境の違い**
   - LaTeX Workshopが使用するシェル環境
   - 環境変数の違い

## 推奨される対処手順

### 1. まずLaTeX Workshopの出力を確認

**これが最も重要です**。実際に実行されたコマンドを見ることで、問題の原因がわかります。

### 2. 出力パネルで確認すべきこと

```
✅ 正常な場合:
   bash -c "cd '/home/apetr/.../master_thesis' && pbibtex -kanji=utf8 'main'"
   → %DIR%と%DOC%が正しく展開されている

❌ 問題がある場合:
   bash -c "cd '%DIR%' && pbibtex -kanji=utf8 '%DOC%'"
   → 変数が展開されていない
   
   または
   
   pbibtex -kanji=utf8 main
   → cdコマンドが実行されていない
```

### 3. 変数が展開されていない場合

環境変数を使用する方法に変更：

```json
{
    "name": "pbibtex",
    "command": "bash",
    "args": [
        "-c",
        "cd \"${LATEX_DIR}\" && pbibtex -kanji=utf8 \"${LATEX_DOC}\""
    ],
    "env": {
        "LATEX_DIR": "%DIR%",
        "LATEX_DOC": "%DOC%"
    }
}
```

### 4. それでも解決しない場合

LaTeX Workshopの拡張機能を確認：
- バージョンを確認
- 更新があるか確認
- 必要に応じて再インストール

## まとめ

### Reload Window vs 完全再起動

- **Reload Window**: 拡張機能の設定を再読み込み（プロセスは継続）
- **完全再起動**: すべてを完全にリセット（プロセスを終了）

### エラーが続く場合の最重要ポイント

**LaTeX Workshopの出力パネルで実際に実行されたコマンドを確認する**

これにより、問題の原因が明確になります：
- 変数が展開されていない → 環境変数を使用
- cdコマンドが実行されていない → 設定の見直し
- その他の問題 → エラーメッセージから原因を特定

Reload Windowや完全再起動で解決しない場合、**LaTeX Workshopの変数展開に問題がある可能性が高い**ため、環境変数を使用する方法や、出力パネルで実際のコマンドを確認することを強くお勧めします。

