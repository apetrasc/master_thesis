# Refresh all latex pdf viewers のショートカットキー設定

## 現在の設定

`.vscode/keybindings.json`に既に設定されています：

```json
{
    "key": "ctrl+shift+r",
    "command": "latex-workshop.refresh-viewer"
}
```

- **ショートカット**: `Ctrl+Shift+R` (Windows/Linux) / `Cmd+Shift+R` (macOS)
- **コマンドID**: `latex-workshop.refresh-viewer`
- **動作**: "Refresh all latex pdf viewers" を実行

## 設定方法

### 方法1: .vscode/keybindings.json を直接編集

`.vscode/keybindings.json`に以下を追加または編集：

```json
[
    {
        "key": "ctrl+shift+r",
        "command": "latex-workshop.refresh-viewer"
    }
]
```

### 方法2: コマンドパレットから設定

1. `Ctrl+Shift+P` (Windows/Linux) または `Cmd+Shift+P` (macOS) を押す
2. 「Preferences: Open Keyboard Shortcuts (JSON)」と入力
3. `keybindings.json`が開く
4. 上記のJSONを追加

### 方法3: キーボードショートカット設定UIから設定

1. `Ctrl+K Ctrl+S` (Windows/Linux) または `Cmd+K Cmd+S` (macOS) を押す
2. 検索バーに「Refresh all latex pdf viewers」と入力
3. 該当するコマンドをクリック
4. キーを押してショートカットを割り当て

## 別のショートカットキーに変更したい場合

### 例1: Ctrl+Alt+R に変更

```json
[
    {
        "key": "ctrl+alt+r",
        "command": "latex-workshop.refresh-viewer"
    }
]
```

### 例2: F5 に変更

```json
[
    {
        "key": "f5",
        "command": "latex-workshop.refresh-viewer"
    }
]
```

### 例3: when条件を追加（LaTeXファイル編集時のみ有効）

```json
[
    {
        "key": "ctrl+shift+r",
        "command": "latex-workshop.refresh-viewer",
        "when": "editorTextFocus && editorLangId == 'latex'"
    }
]
```

## 動作確認

### 1. コマンドパレットから実行して動作確認

1. `Ctrl+Shift+P` (Windows/Linux) または `Cmd+Shift+P` (macOS)
2. 「LaTeX Workshop: Refresh all latex pdf viewers」と入力
3. 実行して動作を確認

### 2. ショートカットキーで実行

設定したショートカットキー（例：`Ctrl+Shift+R`）を押す
→ PDF viewerがリフレッシュされる

### 3. ショートカットキーの競合確認

1. `Ctrl+K Ctrl+S` (Windows/Linux) または `Cmd+K Cmd+S` (macOS)
2. 検索バーに設定したショートカットキーを入力
3. 複数のコマンドに割り当てられている場合、競合が発生している可能性

## よくある問題

### ショートカットキーが動作しない

1. **エディタを再起動**
   - 設定変更後、エディタを再起動するか「Developer: Reload Window」を実行

2. **コマンドIDの確認**
   - `Ctrl+Shift+P` → "LaTeX Workshop: Refresh all latex pdf viewers"
   - コマンドが表示されることを確認

3. **競合の確認**
   - `Ctrl+K Ctrl+S` でショートカットキーの競合を確認
   - 競合している場合は別のキーに変更

## 推奨設定

```json
[
    {
        "key": "ctrl+shift+r",
        "command": "latex-workshop.refresh-viewer"
    }
]
```

- `when`条件なし → いつでも実行可能
- `Ctrl+Shift+R` → 一般的に競合しにくい
- 覚えやすい（Refresh の R）

## まとめ

- **コマンドID**: `latex-workshop.refresh-viewer`
- **現在のショートカット**: `Ctrl+Shift+R` (Win/Linux) / `Cmd+Shift+R` (macOS)
- **設定ファイル**: `.vscode/keybindings.json`
- **動作**: PDF viewerをリフレッシュして最新のPDFを表示


