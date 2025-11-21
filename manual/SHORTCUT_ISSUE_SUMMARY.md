# ショートカットキーが動作しない理由の要約

## 問題

- `Ctrl+Alt+B`でビルド → PDFが生成されるがプレビューがおかしい
- LaTeX Workshopの「Refresh all latex pdf viewers」をGUIで実行 → 正常に動作
- 同じコマンドを`Ctrl+Shift+R`で実行 → 動作しない
- 設定ファイルでは正しく設定されている

## 原因

### 主な原因：キーバインドの競合

`Ctrl+Shift+R`はVSCodeのデフォルトで**Reload Window** (`workbench.action.reloadWindow`)に割り当てられています。

ワークスペースの`.vscode/keybindings.json`で`latex-workshop.refresh-viewer`に割り当てていても、以下の理由で競合が発生します：

1. **キーバインドの評価順序**: VSCodeは複数のキーバインドを評価し、優先順位に従って実行する
2. **評価タイミング**: キー入力時に評価されるため、タイミングによってはデフォルトのキーバインドが優先される
3. **`when`条件の欠如**: 現在の設定には`when`条件がないため、コマンドが実行されるべきコンテキストが不明確

### なぜGUIでは動作するのか

- **コマンドパレットは利用可能なコマンドのみを表示**する
- ユーザーが明示的にコマンドを選択するため、**キーバインドの評価が不要**
- キーバインドの競合の影響を受けない

### なぜショートカットキーでは動作しないのか

- キー入力時に**すべてのキーバインドが評価**される
- 複数のキーバインドが同じキーに割り当てられている場合、**優先順位に従って評価**される
- 評価順序やタイミングによって、**デフォルトのキーバインド（Reload Window）が実行される**
- `when`条件がないため、コマンドが実行されるべきコンテキストが不明確

## 解決策

`.vscode/keybindings.json`を以下のように修正：

```json
[
    {
        "key": "ctrl+shift+b",
        "command": "latex-workshop.build",
        "when": "editorTextFocus && editorLangId == 'latex'"
    },
    {
        "key": "ctrl+alt+v",
        "command": "latex-workshop.view",
        "when": "editorTextFocus && editorLangId == 'latex'"
    },
    {
        "key": "ctrl+alt+c",
        "command": "latex-workshop.clean",
        "when": "editorTextFocus && editorLangId == 'latex'"
    },
    {
        "key": "ctrl+shift+r",
        "command": "latex-workshop.refresh-viewer",
        "when": "editorLangId == 'latex'"
    },
    {
        "key": "ctrl+shift+r",
        "command": "-workbench.action.reloadWindow"
    },
    {
        "key": "ctrl+alt+j",
        "command": "latex-workshop.synctex",
        "when": "editorTextFocus && editorLangId == 'latex'"
    }
]
```

**変更点**：
1. `latex-workshop.refresh-viewer`に`when`条件を追加
2. `workbench.action.reloadWindow`のキーバインドを明示的に無効化（`-`を付ける）

これにより、`Ctrl+Shift+R`を押した時に確実に`latex-workshop.refresh-viewer`が実行されるようになります。

## 確認方法

1. `Ctrl+K Ctrl+S`でキーボードショートカット設定を開く
2. 検索バーに`Ctrl+Shift+R`を入力
3. `latex-workshop.refresh-viewer`のみが表示されることを確認
4. `Ctrl+Shift+P` → 「Developer: Toggle Keyboard Shortcuts Troubleshooting」を実行
5. `Ctrl+Shift+R`を押して、どのコマンドが実行されているか確認


