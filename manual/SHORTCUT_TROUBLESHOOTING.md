# ショートカットキーのトラブルシューティング

## 問題の整理

### 1. Ctrl+Alt+Bでチャットボックスが消える
**原因**: ショートカットキーの競合
- `Ctrl+Alt+B`が別のコマンド（例：パネルの表示/非表示）に割り当てられている可能性
- LaTeX Workshopのビルドコマンドが正しく実行されていない

### 2. ビルドが実行できない
**原因**: コマンドIDが間違っている、または`when`条件が厳しすぎる

### 3. Ctrl+Alt+RでReloadされない
**訂正**: 私の説明が不正確でした
- `latex-workshop.refresh-viewer`は「Refresh all latex pdf viewers」（PDF viewerをリフレッシュ）
- 「Developer: Reload Window」（VS Codeウィンドウをリロード）とは別物
- 混同して説明していた点を訂正します

## 正しいコマンドIDの確認方法

### 手順1: コマンドパレットで確認
1. `Ctrl+Shift+P` (Win/Linux) または `Cmd+Shift+P` (macOS) を押す
2. "LaTeX Workshop:" と入力
3. 各コマンドの右側に表示されるコマンドIDを確認

### 手順2: キーボードショートカット設定で確認
1. `Ctrl+K Ctrl+S` (Win/Linux) または `Cmd+K Cmd+S` (macOS) を押す
2. 検索バーに `Ctrl+Alt+B` を入力
3. 何に割り当てられているか確認

## 推奨される対処方法

### 方法1: コマンドパレットから直接実行
まず、コマンドパレットから以下を実行して動作確認：
- "LaTeX Workshop: Build LaTeX project"
- "LaTeX Workshop: Refresh all latex pdf viewers"

これらが動作する場合、コマンドIDは正しいがショートカットキーの競合が原因

### 方法2: ショートカットキーを変更
競合を避けるため、別のショートカットキーに変更：

```json
[
    {
        "key": "ctrl+shift+b",
        "command": "latex-workshop.build",
        "when": "editorTextFocus && editorLangId == 'latex'"
    },
    {
        "key": "ctrl+shift+r",
        "command": "latex-workshop.refresh-viewer"
    }
]
```

### 方法3: `when`条件を緩和
LaTeXファイル以外でも動作するように：

```json
[
    {
        "key": "ctrl+alt+b",
        "command": "latex-workshop.build",
        "when": "editorTextFocus"
    }
]
```

## よくあるLaTeX WorkshopのコマンドID

以下は一般的なコマンドID（実際の環境で確認が必要）：
- `latex-workshop.build` - Build LaTeX project
- `latex-workshop.view` - View LaTeX PDF
- `latex-workshop.clean` - Clean up auxiliary files
- `latex-workshop.refresh-viewer` - Refresh all latex pdf viewers
- `latex-workshop.synctex` - SyncTeX from cursor

## 確認手順まとめ

1. **コマンドパレットで動作確認**
   - `Ctrl+Shift+P` → "LaTeX Workshop: Build LaTeX project"
   - 動作する場合、コマンドIDは正しい

2. **ショートカットキーの競合確認**
   - `Ctrl+K Ctrl+S` → `Ctrl+Alt+B` を検索
   - 複数のコマンドに割り当てられている場合、競合が原因

3. **必要に応じて別のショートカットキーに変更**
   - 競合を避けるため、`Ctrl+Shift+B`などに変更

## 謝罪

最初の説明で「Ctrl+Alt+RでReload Window」と説明していましたが、
`latex-workshop.refresh-viewer`は「Refresh all latex pdf viewers」であり、
「Developer: Reload Window」とは別のコマンドです。混同して説明していた点を訂正します。

