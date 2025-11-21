# ショートカットキーの問題と修正

## 問題点

1. **Ctrl+Alt+Bでチャットボックスが消える**
   - ショートカットキーの競合が原因の可能性
   - 別のコマンドに割り当てられている可能性

2. **ビルドが実行できない**
   - コマンドIDが間違っている可能性
   - `when`条件が厳しすぎる可能性

3. **Ctrl+Alt+RでReloadされない**
   - `latex-workshop.refresh-viewer`は「Refresh all latex pdf viewers」であり、「Reload Window」ではない
   - 混同していた点を訂正

## 正しいコマンドIDの確認方法

1. `Ctrl+Shift+P` でコマンドパレットを開く
2. "LaTeX Workshop:" で検索
3. 各コマンドの右側に表示されるコマンドIDを確認

## 推奨される確認手順

1. コマンドパレット（Ctrl+Shift+P）から以下を実行して動作確認：
   - "LaTeX Workshop: Build LaTeX project"
   - "LaTeX Workshop: Refresh all latex pdf viewers"

2. ショートカットキーの競合を確認：
   - `Ctrl+K Ctrl+S` でキーボードショートカット設定を開く
   - `Ctrl+Alt+B` を検索して、何に割り当てられているか確認

3. 必要に応じて、別のショートカットキーに変更
