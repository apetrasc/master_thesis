# ショートカットキーで実行する方法

LaTeX Workshopの操作をショートカットキーで実行する方法を説明します。

## LaTeX Workshopの標準ショートカットキー

### ビルド関連

| ショートカット | 操作 | 説明 |
|---------------|------|------|
| `Ctrl+Shift+B` (Win/Linux)<br>`Cmd+Shift+B` (macOS) | Build LaTeX project | デフォルトレシピでビルド実行<br>※Ctrl+Alt+Bは競合の可能性があるため変更 |
| `Ctrl+Alt+L` (Win/Linux)<br>`Cmd+Option+L` (macOS) | Build with recipe | レシピを選択してビルド |
| `Ctrl+Alt+C` (Win/Linux)<br>`Cmd+Option+C` (macOS) | Clean up auxiliary files | 中間ファイルをクリーンアップ |

### PDF Viewer関連

| ショートカット | 操作 | 説明 |
|---------------|------|------|
| `Ctrl+Alt+V` (Win/Linux)<br>`Cmd+Option+V` (macOS) | View LaTeX PDF | PDFを表示 |
| `Ctrl+Alt+J` (Win/Linux)<br>`Cmd+Option+J` (macOS) | SyncTeX from cursor | カーソル位置からPDFへ移動 |
| `Ctrl+Alt+S` (Win/Linux)<br>`Cmd+Option+S` (macOS) | SyncTeX from PDF | PDFからソースコードへ移動 |

### その他

| ショートカット | 操作 | 説明 |
|---------------|------|------|
| `Ctrl+Alt+X` (Win/Linux)<br>`Cmd+Option+X` (macOS) | Kill LaTeX compiler | ビルドプロセスを停止 |

## カスタムショートカットキーの設定

### 方法1: コマンドパレットから設定

1. `Ctrl+Shift+P` (Windows/Linux) または `Cmd+Shift+P` (macOS)
2. 「Preferences: Open Keyboard Shortcuts (JSON)」と入力
3. `keybindings.json`が開く
4. カスタムショートカットを追加

### 方法2: keybindings.jsonを直接編集

`.vscode/keybindings.json`を作成または編集：

```json
[
    {
        "key": "ctrl+alt+b",
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
        "key": "ctrl+alt+r",
        "command": "latex-workshop.refresh-viewer",
        "when": "editorTextFocus && editorLangId == 'latex'"
    }
]
```

## よく使うLaTeX Workshopコマンド

### コマンドパレットから実行

`Ctrl+Shift+P` (Windows/Linux) または `Cmd+Shift+P` (macOS) で以下を実行：

| コマンド | 説明 |
|---------|------|
| `LaTeX Workshop: Build LaTeX project` | ビルド実行 |
| `LaTeX Workshop: Build with recipe` | レシピを選択してビルド |
| `LaTeX Workshop: View LaTeX PDF` | PDFを表示 |
| `LaTeX Workshop: Clean up auxiliary files` | 中間ファイルをクリーンアップ |
| `LaTeX Workshop: Refresh all latex pdf viewers` | PDF viewerをリフレッシュ |
| `LaTeX Workshop: SyncTeX from cursor` | カーソル位置からPDFへ移動 |
| `LaTeX Workshop: SyncTeX from PDF` | PDFからソースコードへ移動 |
| `LaTeX Workshop: Kill LaTeX compiler` | ビルドプロセスを停止 |

## カスタムショートカットの例

### Refresh all latex pdf viewers にショートカットを割り当て

`.vscode/keybindings.json`に追加：

```json
[
    {
        "key": "ctrl+shift+r",
        "command": "latex-workshop.refresh-viewer",
        "when": "editorTextFocus && editorLangId == 'latex'"
    }
]
```

### クリーンアップにショートカットを割り当て

```json
[
    {
        "key": "ctrl+alt+k",
        "command": "latex-workshop.clean",
        "when": "editorTextFocus && editorLangId == 'latex'"
    }
]
```

### ビルド + 表示を一度に実行

```json
[
    {
        "key": "ctrl+alt+m",
        "command": "runCommands",
        "args": {
            "commands": [
                "latex-workshop.build",
                {
                    "command": "latex-workshop.view",
                    "args": ["tab"]
                }
            ],
            "interval": 1000
        },
        "when": "editorTextFocus && editorLangId == 'latex'"
    }
]
```

## ターミナルでコマンドを実行するショートカット

### 方法1: タスクランナーを使用

`.vscode/tasks.json`を作成：

```json
{
    "version": "2.0.0",
    "tasks": [
        {
            "label": "Build LaTeX",
            "type": "shell",
            "command": "uplatex -synctex=1 -interaction=nonstopmode -file-line-error -kanji=utf8 main.tex && pbibtex -kanji=utf8 main && uplatex -synctex=1 -interaction=nonstopmode -file-line-error -kanji=utf8 main.tex && uplatex -synctex=1 -interaction=nonstopmode -file-line-error -kanji=utf8 main.tex && dvipdfmx -f ptex-ipaex.map -z 0 -o main_temp.pdf main.dvi && gs -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -dEmbedAllFonts=true -dSubsetFonts=true -dCompatibilityLevel=1.5 -sOutputFile=main.pdf main_temp.pdf && rm -f main_temp.pdf",
            "group": "build",
            "presentation": {
                "reveal": "always",
                "panel": "new"
            },
            "problemMatcher": []
        },
        {
            "label": "Clean LaTeX",
            "type": "shell",
            "command": "rm -f main.aux main.bbl main.blg main.synctex.gz main.dvi main_temp.pdf",
            "group": "build",
            "presentation": {
                "reveal": "always",
                "panel": "new"
            }
        }
    ]
}
```

ショートカットを割り当て（`.vscode/keybindings.json`）：

```json
[
    {
        "key": "ctrl+shift+b",
        "command": "workbench.action.tasks.runTask",
        "args": "Build LaTeX",
        "when": "editorTextFocus && editorLangId == 'latex'"
    },
    {
        "key": "ctrl+shift+k",
        "command": "workbench.action.tasks.runTask",
        "args": "Clean LaTeX",
        "when": "editorTextFocus && editorLangId == 'latex'"
    }
]
```

## 推奨ショートカット設定

`.vscode/keybindings.json`の推奨設定：

```json
[
    {
        "key": "ctrl+alt+b",
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
        "command": "latex-workshop.refresh-viewer"
    },
    {
        "key": "ctrl+alt+j",
        "command": "latex-workshop.synctex",
        "when": "editorTextFocus && editorLangId == 'latex'"
    }
]
```

## ショートカットキーの確認方法

1. `Ctrl+Shift+P` (Windows/Linux) または `Cmd+Shift+P` (macOS)
2. 「Preferences: Open Keyboard Shortcuts」と入力
3. 「LaTeX Workshop」で検索
4. 各コマンドに割り当てられたショートカットを確認

## まとめ

**標準ショートカット:**
- `Ctrl+Shift+B` - ビルド（Ctrl+Alt+Bは競合の可能性があるため変更）
- `Ctrl+Alt+V` - PDF表示
- `Ctrl+Alt+C` - クリーンアップ
- `Ctrl+Shift+R` - PDF viewerリフレッシュ（Ctrl+Alt+Rは競合の可能性があるため変更）
- `Ctrl+Alt+J` - SyncTeX

**注意**: `latex-workshop.refresh-viewer`は「Refresh all latex pdf viewers」であり、「Developer: Reload Window」とは別のコマンドです。

**カスタムショートカットの設定:**
- `.vscode/keybindings.json`を作成
- または、コマンドパレットから「Preferences: Open Keyboard Shortcuts (JSON)」

**コマンドパレットから実行:**
- `Ctrl+Shift+P` → 「LaTeX Workshop:」で検索



