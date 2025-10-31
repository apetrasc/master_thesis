1. 序論
   ├── 1.1 研究背景
   ├── 1.2 関連研究  
   └── 1.3 研究目的

2. 技術的背景
   ├── 2.1 超音波計測
   ├── 2.2 音響信号処理
   ├── 2.3 数値計算
   └── 2.4 機械学習

3. 実験手法・実験系
   ├── 3.1 実験装置・計測機器
   ├── 3.2 実験条件・手順
   └── 3.3 データ取得方法

4. 数値計算手法
   └── 4.1 計算系の設計


5. データセット構築・前処理
6. 提案手法
7. 結果・評価
8. 結論
memo, dataset

超音波画像データをMNISTやCifar10のようなテンソル形式（例： [バッチ数, チャンネル数, 高さ, 幅] ）で整理することを提案する。以下にそのための処理フローを示す。

1. **データ収集**
   - 各測定ごとに複数チャンネル（例：トランスデューサの台数分のチャネル）でデータを取得。

2. **前処理**
   - 欠損値・異常値の除去
   - 必要に応じて正規化（各ピクセル値を[0,1]や[-1,1]などにスケーリング）

3. **形状の統一**
   - 画像サイズを統一（リサイズやパディング）
   - 全データを [測定数, チャンネル数, 高さ, 幅] のテンソルに変換

4. **ラベルの付与**
   - 必要に応じて、分類/回帰用のラベル情報も同じ順序で対応付けて保存

5. **データセットの保存・整理**
   - numpyファイル、またはtorch/tensorflowのデータセットクラス等にまとめて保存

この流れでデータセットを構築しておくことで、MNISTやCifar10同様、深層学習フレームワーク上で容易にデータローディングやバッチ処理が可能となる。
超音波画像データ $X$ のテンソル化形式は以下で表される：

### 主な対応策

1. **対応したエディタやビューワを使う**  
   - Typora, Obsidian, Notion, Jupyter Notebook などMathJax対応のもの

2. **HTML埋め込みに変換する**  
   - KaTeX/MathJaxでHTML出力→そのHTMLを文書に埋め込み  
   - 例: [公式KaTeX playground](https://katex.org/)でレンダしてコピー

3. **GitHub Pages用にJekyll+MathJax等を導入**  
   - `github-pages`や独自Webにする場合はMathJaxスクリプトを追加

4. **プレーンテキストで妥協する（数式を画像化する）**  
   - 複雑な $\LaTeX$ 数式を画像で貼る（万全）

----

### 参考（LaTeX数式サンプル）

$X \in \mathbb{R}^{N \times C \times H \times W}$

- $N$ ：サンプル数
- $C$ ：チャンネル数（例：トランスデューサ本数）
- $H$ ：高さ
- $W$ ：幅

正規化処理例：

$\displaystyle
\tilde{x}_{nchw} = \frac{x_{nchw} - \mu}{\sigma}
$

or スケーリング処理：

$\displaystyle
\tilde{x}_{nchw} = \frac{x_{nchw} - x_{\min}}{x_{\max} - x_{\min}}
$

ラベル例（回帰の場合）：

$y \in \mathbb{R}^N$

分類・one-hotの場合：

$y \in \{0, 1\}^{N \times K} \;\; (K:\text{クラス数})$

----
#### ラベル（教師信号）のCSVファイル読み込みと利用フロー例

超音波信号データから体積率や分類クラスなどのラベル（教師信号）を用いる場合、ラベル情報は`labels.csv`などCSVファイルで管理するのが一般的です。以下は典型的な処理フロー例です。

1. **CSVファイルの準備**
   - 1行目：カラム名（例：`filename, label`）
   - 2行目以降：画像ファイル名とそのラベル（例：`sample_001.npy, 0.34`）

2. **CSVファイルの読み込み**
   - Pythonなら`pandas.read_csv()`等で読み込む

   ```python
   import pandas as pd
   labels_df = pd.read_csv('labels.csv')  # カラム: filename, label
   ```

3. **データセットのマッピング**
   - 画像データ$X$のファイル名とラベルを結び付ける
   - 例：ファイル名リスト`file_list`から各画像に対しラベルを検索

   ```python
   for fname in file_list:
       label = labels_df.loc[labels_df['filename'] == fname, 'label'].values[0]
       # (画像読み込み・変換/ペア化の処理) ...
   ```

4. **深層学習データセットクラスへの組み込み**
   - PyTorch等のDatasetクラス実装時、`__getitem__()`で画像とラベルを返す
   - 学習/評価時もラベル付きでデータローダに渡る

5. **エラーケース対応**
   - ファイル名揺れ/ラベル欠損時は例外処理や欠損値対応が必要

#### 備考
- クラス分類の場合は、CSV内のラベルをint化やone-hot化
- 目的が回帰か分類かでラベル型（float/分類int/one-hot）を調整
- pandas/numpy標準APIで容易に処理可能

```csv
filename,label
sample_001.npy,0.34
sample_002.npy,0.38
sample_003.npy,0.41
...
```

このような仕組みにより、データ本体（npy/png/wav等）と教師信号CSVを簡潔に管理・利用でき、MNISTやCifar10同様のバッチ読み込み・教師出力が行える構造となります。
**ログ出力による確認例**

読み込み時やデータセット組み込み時に「ファイルパス」「ラベル」を逐次出力することで、手動/目視での対応付け・誤りチェックが容易になります。

```python
for fname in file_list:
    label = labels_df.loc[labels_df['filename'] == fname, 'label'].values[0]
    print(f"[LOG] ファイル: {fname} / ラベル: {label}")  # ログ出力で全件を記録
    # (画像読み込み・ペア化の処理) ...
```

エラーケースも含めて処理する場合：

```python
for fname in file_list:
    label_row = labels_df.loc[labels_df['filename'] == fname, 'label']
    if label_row.empty:
        print(f"[WARN] 対応ラベルなし: {fname}")
        continue
    label = label_row.values[0]
    print(f"[LOG] ファイル: {fname} / ラベル: {label}")
    # ...
```

このようなログを残しておくことで、ラベル付けミスやデータ名の不一致なども後から目で追いやすくなります。

```python
import os
import pandas as pd

def generate_log_csv(data_folder, info_csv, out_csv):
    """
    data_folder: 入力データ（画像やnpyなど）が格納されたディレクトリ
    info_csv: 付帯情報（相体積率・流速など）が記載されたcsv
    out_csv: 作成されるログcsvファイル
    """
    # info_csvの読み込み
    info_df = pd.read_csv(info_csv)
    # 拡張子値の有無によらずファイル名比較のために、ベース名をキーとして保持
    info_df['basename'] = info_df['filename'].apply(lambda x: os.path.splitext(os.path.basename(x))[0])
    info_map = info_df.set_index('basename')

    # data_folder内のサンプル検出
    filepaths = []
    for fname in os.listdir(data_folder):
        if fname.startswith('.'):
            continue  # 隠しファイル無視
        path = os.path.join(data_folder, fname)
        if os.path.isfile(path):
            filepaths.append(path)

    # ログ用の行リスト
    log_rows = []

    # ログ出力処理
    for filepath in sorted(filepaths):
        fbase = os.path.splitext(os.path.basename(filepath))[0]
        if fbase not in info_map.index:
            print(f"[WARN] ラベル情報が見つかりません: {filepath}")
            continue
        row = info_map.loc[fbase]
        log_row = [
            filepath,
            row.get('liq_velocity', ''),   # 液相流速
            row.get('sol_velocity', ''),   # 固相流速
            row.get('gas_velocity', ''),   # 気相流速
            row.get('liq_alpha', ''),      # 液相体積率
            row.get('sol_alpha', ''),      # 固相体積率
            row.get('gas_alpha', '')       # 気相体積率
        ]
        log_rows.append(log_row)

    # 出力ラベル定義
    cols = [
        'filepath',
        'liq_velocity',
        'sol_velocity',
        'gas_velocity',
        'liq_alpha',
        'sol_alpha',
        'gas_alpha'
    ]

    # CSVとして保存
    log_df = pd.DataFrame(log_rows, columns=cols)
    log_df.to_csv(out_csv, index=False, encoding='utf-8')
    print(f"[INFO] ログCSVを出力しました: {out_csv}")

# 既存のconvert_expの関数と組み合わせる場合
# 例えば:
# convert_exp(src, dst, other_args)
# のあとに generate_log_csv を使うと一貫したデータ管理・確認ができます
```
**備考**  
- info_csvは例えば`filename,liq_velocity,sol_velocity,gas_velocity,liq_alpha,sol_alpha,gas_alpha,...`の形で各種カラムが入っていることを想定
- convert_exp関数でデータ形式を変換した際にも、同様に`generate_log_csv`を合せて使えば管理/可視化/チェックの効率化が図れます
- ファイルパスや順序（カラム名）は用途で調整してください



