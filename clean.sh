#!/bin/bash
# LaTeX中間ファイルのクリーンアップスクリプト

echo "LaTeX中間ファイルをクリーンアップしています..."

# 中間ファイルを削除
rm -f *.aux *.bbl *.blg *.idx *.ind *.lof *.lot *.out *.toc *.acn *.acr *.alg
rm -f *.glg *.glo *.gls *.ist *.fls *.log *.fdb_latexmk *.synctex.gz *.dvi

echo "クリーンアップ完了！"
echo "再コンパイルするには以下のコマンドを実行してください："
echo "uplatex main.tex && pbibtex main && uplatex main.tex && uplatex main.tex && dvipdfmx main.dvi"
