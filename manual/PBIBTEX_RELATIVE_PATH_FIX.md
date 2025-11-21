# pbibtexのmain.blgへのアクセスを相対パスに修正

## 問題

LaTeX Workshopで`pbibtex`を実行する際、`main.blg`へのアクセスが絶対パスで行われ、`openout_any = p`のセキュリティ制限によりエラーが発生する場合がありました。

エラーメッセージ例：
```
pbibtex: Not writing to /home/apetr/Documents/sandbox/master_thesis/main.blg (openout_any = p).
I couldn't open file name `/home/apetr/Documents/sandbox/master_thesis/main.blg'
```

## 原因

LaTeX Workshopが`pbibtex`を実行する際、作業ディレクトリが正しく設定されていない場合、`pbibtex`が絶対パスで`main.blg`にアクセスしようとしていました。

`openout_any = p`は、現在のディレクトリとそのサブディレクトリへの書き込みのみを許可するLaTeXのセキュリティ設定です。絶対パスでのアクセスはこの制限に違反するため、エラーが発生します。

## 解決策

`.vscode/settings.json`の`pbibtex`設定を修正し、シェルスクリプトを使用して作業ディレクトリを明示的に設定するようにしました。

### 修正前

```json
{
    "name": "pbibtex",
    "command": "pbibtex",
    "args": [
        "-kanji=utf8",
        "%DOC%"
    ]
}
```

### 修正後

```14:21:.vscode/settings.json
        {
            "name": "pbibtex",
            "command": "bash",
            "args": [
                "-c",
                "cd '%DIR%' && pbibtex -kanji=utf8 '%DOC%'"
            ]
        },
```

## 変更内容の説明

1. **コマンドを`bash`に変更**: シェルスクリプトを実行できるようにしました
2. **`cd '%DIR%'`を追加**: 実行前に作業ディレクトリ（`%DIR%`）に移動
3. **`&&`でコマンドを連結**: ディレクトリ移動が成功したら`pbibtex`を実行

### 変数の展開

- `%DIR%`: ドキュメントがあるディレクトリの絶対パス（例：`/home/apetr/Documents/sandbox/master_thesis`）
- `%DOC%`: ドキュメントのベース名（拡張子なし）（例：`main`）

実際の実行コマンド例：
```bash
cd '/home/apetr/Documents/sandbox/master_thesis' && pbibtex -kanji=utf8 'main'
```

## 効果

この修正により：

1. **作業ディレクトリが明示的に設定される**: `cd '%DIR%'`により、`pbibtex`は常に正しいディレクトリで実行されます
2. **相対パスでアクセス**: 作業ディレクトリが正しく設定されているため、`pbibtex`は相対パスで`main.blg`にアクセスします
3. **`openout_any = p`エラーの解消**: 相対パスでのアクセスにより、セキュリティ制限に違反しなくなります

## 確認方法

### 1. ファイルアクセスの確認

```bash
cd /home/apetr/Documents/sandbox/master_thesis
strace -e open,openat pbibtex -kanji=utf8 main 2>&1 | grep -E "main\.(aux|bbl|blg)"
```

出力例（相対パスでアクセスしていることを確認）：
```
openat(AT_FDCWD, "main.aux", O_RDONLY)  = 5
openat(AT_FDCWD, "main.blg", O_WRONLY|O_CREAT|O_TRUNC, 0666) = 6
openat(AT_FDCWD, "main.bbl", O_WRONLY|O_CREAT|O_TRUNC, 0666) = 7
```

`AT_FDCWD`は現在の作業ディレクトリを意味し、相対パスでアクセスしていることを示します。

### 2. LaTeX Workshopでビルドを実行

1. `Ctrl+Alt+B` (Windows/Linux) または `Cmd+Option+B` (macOS) でビルドを実行
2. `main.blg`と`main.bbl`が正常に生成されることを確認
3. エラーメッセージが表示されないことを確認

## 関連設定

### latexmkrc

`latexmkrc`ファイルでも`pbibtex`の設定が行われています：

```4:4:latexmkrc
$bibtex = 'pbibtex -kanji=utf8';
```

この設定は`latexmk`が`pbibtex`を呼び出す際に使用されますが、LaTeX Workshopの設定とは独立しています。

## まとめ

- **問題**: `pbibtex`が絶対パスで`main.blg`にアクセスし、`openout_any = p`エラーが発生
- **解決策**: シェルスクリプトを使用して作業ディレクトリを明示的に設定
- **効果**: 相対パスでアクセスするようになり、エラーが解消
- **設定ファイル**: `.vscode/settings.json`の`pbibtex`ツール設定を修正

