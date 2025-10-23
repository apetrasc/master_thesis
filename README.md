# master_thesis
修士論文Latexレポジトリ

## PDF作成手順
2026卒　修士　学位論文をここに記します。

### PDF作成

手順：

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

