Pythonでmode(最頻値)を算出する最良の方法



Pythonでたまにmode（最頻値）を算出したくなるのですが、いつもどう算出するか迷います。算出方法を整理して、処理時間も計測してみました。

# 5つの方法

代表的な方法は以下でしょうか。思いついたものを試してみました。

1. [statistics.mode](https://docs.python.org/ja/3/library/statistics.html)
2. [scipy.stats.mode](https://docs.scipy.org/doc/scipy/reference/generated/scipy.stats.mode.html)
3. [numpy.unique](https://numpy.org/doc/stable/reference/generated/numpy.unique.html) 
4. [pandas.DataFrame.mode](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.DataFrame.mode.html) or [pandas.Series.mode](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.Series.mode.html#pandas.Series.mode)
5. [collections.Counter](https://docs.python.org/3/library/collections.html#collections.Counter)



# 最良の方法（結論）

**どれでも良い。**が私が至った結論です。強いて言うなら`pd.DataFrame`を使っていたらそのまま`pandas`を使って、そうでないなら `scipy`か`statistics`を使う。になると思います。状況に応じて好きなのを使えばいいと思います。

以下の視点で違いを考察しました。

| #    | 視点                                           | 差異     |
| ---- | ---------------------------------------------- | -------- |
| 1    | 最頻値が複数ある場合の挙動                     | **あり** |
| 2    | 関数一発か                                     | あり     |
| 3    | 処理速度（最頻値のうち、最小の値を求める場合） | ほぼなし |

## 1. 最頻値が複数ある場合の挙動の差

特に注意しなければ行けないのが、**mode（最頻値）が複数ある場合の挙動**です。例えば、`[1, 2, 2, 3, 3, 4]`の最頻値は`[2, 3]`です。ライブラリや関数によって、以下のように挙動に違いがあるみたいです。**`statistics`はPythonのバージョンによって挙動が異なるので注意が必要です。**

| 挙動                   | 方法                                       |
| ---------------------- | ------------------------------------------ |
| 最頻値を複数返す       | pandas, statistics(Python3 $\ge$ 3.8)      |
| 最初に出現した値を返す | statistics(Python3 $\ge$ 3.8), collections |
| 最小の値を返す         | scipy                                      |
| 例外を返す             | statistics(Python3 < 3.8のみ)              |
| 自分で処理             | numpy                                      |

## 2. 関数一発かの差

`numpy`と`collections`は自分で処理を書く必要があります。自由度は高いですが、特別理由がない限りは自分で書く必要もないでしょう。あと最頻値が複数あるケースで、一つに絞り場合は結局`max`だか`min`だか自分で処理する必要はあります。

|            | 方法                                         |
| ---------- | -------------------------------------------- |
| 関数一発   | scipy, pandas, statistics(Python3 $\ge$ 3.8) |
| 自分で処理 | numpy, collections                           |

## 3. 処理速度の差

「`pandas`が番早い」という目を疑いたくなる結果でしたが、個人的にはmodeに処理速度を求めることがそんなにないと思いますので、気ににしなくて良いかなと。`pd.DataFrame`や`pd.Sereis`を使っている場合は`mode`メソッドをそのまま使えばいいと思いますが、modeを算出するためだけにわざわざ`pd.Series`とかにキャストするのは個人的に違和感があります。



# 求め方

メモとして、それぞれの求め方を羅列していきます。

## 設定

入力する値は以下です。ヒストグラムを見ると、最頻値が`[2, 3, 4]`であることが分かります。

```python
import matplotlib.pyplot as plt

x = [1, 2, 2, 2, 3, 3, 3, 4, 4, 4, 5, 6]  # has two modes: [2, 3, 4]

# Plot histogram
fig, ax = plt.subplots()
ax.hist(x, bins=np.arange(8) - 0.5, ec='white')
ax.set(xlabel='values', ylabel='Frequency', title='Distribution of x')
```



![hist](/Users/daisuke/prj/900_analysis/articles/200819_mode/hist.png)

## 1.statistics.mode

標準ライブラリのみで算出することができます。Python3 < 3.8では複数の最頻値があった場合に例外を吐きますので、version3.8+を使うのがおすすめです。

```python
# 最頻値のうち、最初に出現した値を返す@version3.8+
import statistics

statistics.mode(x) # 2
```

**3.8以上では、`mode`関数は最頻値があった場合、出現した最初のものを返す仕様です。**複数最頻値を求めたい場合は`modemulti`関数を使いましょう。

>  If there are multiple modes with the same frequency, returns the first one encountered in the *data*.

```python
# 複数の最頻値を返したい場合はmodemulti()を使う
statistics.multimode(x) # [2, 3, 4]
```

例えば、複数の最頻値の中から最小値のみを求めたい場合

```python
# statisticsで複数の最頻値のうち最小の値のみを返す
min(statistics.multimode(x))
```



## 2. scipy.stats.mode

`scipy.mode`は、値と頻度に分けて出力を抽出できます。**scipyの`mode`関数は最頻値があった場合、最小のものを返す仕様です。**

> If there is more than one such value, only the smallest is returned. 

```python
# scipyで最頻値を算出
import scipy
mode, count = scipy.stats.mode(x) # ModeResult(mode=array([2]), count=array([3]))
mode[0] # 2
```

1つしか最頻値返さないくせにちょっと仰々しい印象を持ちました。



## 3.numpy.unique

`numpy`には最頻値を求める関数はなさそうですが、あえて求めるなら以下でしょうか。

```python
# numpyで最頻値を求める
import numpy as np

uniqs, counts = np.unique(x, return_counts=True)
uniqs[counts == np.amax(counts)] # [2, 3, 4]
```

他のライブラリをインポートする気分じゃないときは良いかもしれません。

複数の最頻値の中から最小値のみを求めたい場合はもちろん以下のようになります

```python
# numpyで複数の最頻値のうち最小の値のみを返す
uniqs[counts == np.amax(counts)].min() # 2
```



## 4. pandas.Series.mode

`pandas`で最頻値を求める場合は以下です。複数の最頻値が返ります。

```python
# pandasで最頻値を求める
import pandas as pd
pd.Series(x, name='values').mode()

# 0    2
# 1    3
# 2    4
# dtype: int64
```

処理速度を計測すると意外なことに、キャストを含めても`pandas.Series.mode`が処理が早かったです。

複数の最頻値の中から最小値のみを求めたい場合は以下のようになります

```python
# pandasで複数の最頻値のうち最小の値のみを返す
pd.Series(x, name='values').mode().min() # 2
```



## 5. collections.Counter

最後に`collections.Counter`です。複数の最頻値のうち最初の値を返す場合は以下のようになります

```python
from collections import Counter
# collections.Counter複数の最頻値のうち最小の値のみを返す
Counter(x).most_common()[0][0] # 2
```

ただ複数の最頻値をすべて返したい場合は、あまり`Counter`を使う利点がないように思いましたので割愛します。



# 処理速度の比較

処理速度を比較してみました。最頻値を求める際、あまり処理速度をきにすることはないので、個人的には参考程度に思っています。

フェアな比較かどうか微妙なところですが、仕様は以下です。

* **最頻値の最初のものを一つ求める**
* 入力の1次元配列（リスト）の長さを変えて計測
* 1条件ごと50回ずつ計測

結果は以下のようになりました。これだけ見ると`statistics`, `collections`は入力の長さが大きくなると比較的遅くなるように見えますが、何秒もかかる訳ではないので大差無いと思います。



![result1](/Users/daisuke/prj/900_analysis/articles/200819_mode/result1.png)

標準誤差をいれると以下です。

![result2](/Users/daisuke/prj/900_analysis/articles/200819_mode/result2.png)

---

**どれでも良い。**という結論を出すために長々検証しました。分析としてはコスパが悪くて悪い見本ですが、お役に立てればこれ幸い。日々精進