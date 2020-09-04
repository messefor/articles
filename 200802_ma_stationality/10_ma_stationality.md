時系列分析モデルでは、系列の統計量が時点$t$に依存しないというシンプルな構造が基本となっています。この定常条件の元に基本的なモデルが構築され、非定常のモデル化に拡張されていくようです。なので、定常かどうかというのが議論されることが多いです。



## 定常性について

我々が定常性を見る場合、以下2つのケースがあると思います

1. データの定常性の確認（定常性の推定）

2. モデルの定常性の確認

前者は観測したデータの構造を理解して、モデル化出来る構造があるかどうか見る際に行います。グラフを確認したり、検定したりです。後者は色々な時系列モデルの性質を理解するために行います。この際モデルは定式化されているので、その式を展開し、定常性の条件を満たしているか確認します。この投稿では[2]の定常性確認をMA(q)モデルに対して行います。



### 定常性の定義

$\mu$を任意の定数とすると
$$
\begin{eqnarray}
&E[y_t] = \mu \tag{1}\\
\\
&\operatorname{Cov}(y_t, y_{t+k}) = \gamma_k \tag{2}\\
\end{eqnarray}
$$


となります。$t$は時点、$\gamma$は自己共分散、$k$は時点のラグを表します。言葉でいうと**系列の期待値と自己共分散が時点$t$に依存しない** ということ。自己共分散は$\gamma_k$の下付き$k$は時刻$t$に依存してないが、ラグ$k$には依存しても良いという気持ちが現れているのでしょう



## 移動平均過程 MA(q) の性質と定常性



### 移動平均過程 MA(q)​

移動平均過程では、現在の値$y_t$ は過去のノイズからの影響を引きずっている（記憶している）と仮定します
$$
\begin{align}
&y_t = \beta_0\varepsilon_t + \beta_1\varepsilon_{t-1} + .. + \beta_q\varepsilon_{t-q} \\
\\
&\varepsilon_t \sim iid(0, \mu)

\end{align}
$$
ここで$\varepsilon_t$はホワイトノイズ

直感的に理解しにくいですが、ここに具体例としてはスーパーマーケットの売上の例が書いてあります。分析者が知らないところで発行されている裏クーポンがあるケースを考えます。分析者はクーポンの存在を知らないため、このクーポンによる売上増加は分析者からノイズに含まれて見えます。ノイズは裏クーポン有効開始日に跳ね上がって、徐々に減衰していきます。売上はこのノイズの影響を受け、時点間の相関関係が生まれます。こういった構造を記述しているようです。



### 性質

$ma(q)$ モデルが定常であるか確認してみます。



#### 1. 期待値

移動平均過程$y_t$の期待値をとってみるだけです
$$
\begin{align}
E[y_t] &= E[\beta_0\varepsilon_t + \beta_1\varepsilon_{t-1} + .. + \beta_q\varepsilon_{t-q}] \\
& = E[\beta_0\varepsilon_t] + E[\beta_1\varepsilon_{t-1}] + ... + E[\beta_q\varepsilon_{t-q}] \\
& = \beta_0E[\varepsilon_t] + \beta_1E[\varepsilon_{t-1}] + ... + \beta_qE[\varepsilon_{t-q}] 
\\
& = 0
\end{align}
$$
これは常に0で一定なので、**期待値は時点$t$に依存しません**

式展開では期待値の線形性と$ \varepsilon_t \sim iid(0, \mu)$ なので $E[\varepsilon_t] = 0$を使っています



#### 2. 自己共分散

MA(q)​のラグ$k$での自己共分散$\operatorname{Cov}(y_t, y_{t+k})$は以下の様に書き下せます
$$
\begin{eqnarray}
\operatorname{Cov}(y_t, y_{t+k})
&= E[(\beta_0\epsilon_t + \beta_1\epsilon_{t-1} + .. + \beta_q\epsilon_{t-q})
(\beta_0\epsilon_{t+k} + \beta_1\epsilon_{t+k-1} + .. + \beta_q\epsilon_{t+k-q})] \tag{3}\\
\\
 &= E\left(
\begin{array}{l}
\beta_{0}\beta_{0} \varepsilon_{t} \varepsilon_{t+k}+\beta_{0} \beta_{1} \varepsilon_{t} \varepsilon_{t+k-1}+\cdots+\beta_{0} \beta_{q} \varepsilon_{t} \varepsilon_{t+k-q} \\
\hspace{5.2cm} + \\
\beta_{1} \beta_{0} \varepsilon_{t-1} \varepsilon_{t+k}+\beta_{1}\beta_{1} \varepsilon_{t-1} \varepsilon_{t+k-1}+\cdots+\beta_{1} \beta_{q} \varepsilon_{t-1} \varepsilon_{t+k-q}\\
\vdots  \hspace{5cm} + \hspace{5cm} \vdots \\
\beta_{q}\beta_{0} \varepsilon_{t-q} \varepsilon_{t+k} + \beta_{q}\beta_{1} \varepsilon_{t-q} \varepsilon_{t+k-1}+\cdots+\beta_{q} \beta_{q} \varepsilon_{t-q} \varepsilon_{t+k-q}
\end{array}
\right)　\tag{4}
\end{eqnarray}
$$


$(4)$の括弧の中は、$(3)$の多項式の積の展開を行列の様に縦に方向に積み上げて表記したものです。なので$(4)$の括弧の中の項をすべて足し合わせ、期待値をとったものが$\operatorname{Cov}(y_t, y_{t+k})$になります。

ここでホワイトノイズの性質から次が成り立ちます
$$
\begin{align}
E[\varepsilon_i\varepsilon_j]
&= 
\left\{
\begin{array}{ll}
E[\varepsilon_i^2] = \sigma^2 & i = j \\
\tag{5}\\
E[\varepsilon_i]E[\varepsilon_j] = 0 & i\neq j
\end{array}
\right.

\end{align}
$$


つまり$(4)$式の括弧の中にある、例えば最初の項$\beta_{0}\beta_{0} \varepsilon_{t} \varepsilon_{t+k}$を考えると、2つの$\varepsilon$の下付きの$t$と$t+k$が一致しない場合、この項の期待値は0になります。結局2つの$\varepsilon$の下付きの値が一致する後のみを考慮すれば良いことになります。$\varepsilon$の下付きの値が一致する項はどういう時に現れるでしょうか。具体例で見てみます。



##### $ma(2), k=0$の場合：

2次の移動平均過程のラグが2での例をみてみます。つまりMA$(q=2), k=0$の自己共分散は

式$(4)$に$q=2, k=0$を代入して
$$
\begin{eqnarray}
\operatorname{Cov}(y_t, y_{t})

&= E\left(

\begin{array}{l}

\beta_{0}\beta_{0} \varepsilon_{t} \varepsilon_{t}\ \ \ +
\beta_{0} \beta_{1} \varepsilon_{t} \varepsilon_{t-1}\ \ \ +
\beta_{0} \beta_{2} \varepsilon_{t} \varepsilon_{t-2} \\
\hspace{4cm}＋\\
\beta_{1} \beta_{0} \varepsilon_{t-1} \varepsilon_{t}+
\beta_{1}\beta_{1} \varepsilon_{t-1} \varepsilon_{t-1}+
\beta_{1} \beta_{2} \varepsilon_{t-1} \varepsilon_{t-2}\\
\hspace{4cm}＋\\
\beta_{2}\beta_{0} \varepsilon_{t-2} \varepsilon_{t} + 
\beta_{2}\beta_{1} \varepsilon_{t-2} \varepsilon_{t-1}+
\beta_{2} \beta_{2} \varepsilon_{t-2} \varepsilon_{t-2}

\end{array}
\right)　\tag{4-0}
\end{eqnarray}
$$
2つの$\varepsilon$の下付きの値が一致するのは、括弧内の対角にある項のみで
$$
\begin{align}
\operatorname{Cov}(y_t, y_{t}) 
&= E[\beta_{0}\beta_{0} \varepsilon_{t} \varepsilon_{t}] + 
E[\beta_{1}\beta_{1} \varepsilon_{t-1} \varepsilon_{t-1}] +
E[\beta_{2} \beta_{2} \varepsilon_{t-2} \varepsilon_{t-2}]\\

&= \beta_{0}\beta_{0}E[\varepsilon_{t} \varepsilon_{t}] + 
\beta_{1}\beta_{1}E[ \varepsilon_{t-1} \varepsilon_{t-1}] +
\beta_{2} \beta_{2}E[ \varepsilon_{t-2} \varepsilon_{t-2}]\\

&= \beta_{0}\beta_{0}\sigma^2 + 
\beta_{1}\beta_{1}\sigma^2 +
\beta_{2} \beta_{2}\sigma^2\\

&= \sigma^2\sum_{i}^2\beta_{i}\beta_{i}
\end{align}
$$
2行目から3行目の展開は(5)を利用しています。

##### $ma(2), k=1$の場合：

同様に$ma(q=2), k=1$の自己共分散は、$(4)$に$q=2, k=1$を代入すると
$$
\begin{align}
\operatorname{Cov}(y_t, y_{t+1})

&= E\left(

\begin{array}{l}

\beta_{0}\beta_{0} \varepsilon_{t} \varepsilon_{t+1}\ \ \ +
\beta_{0} \beta_{1} \varepsilon_{t} \varepsilon_{t}\ \ \ +
\beta_{0} \beta_{2} \varepsilon_{t} \varepsilon_{t-1} \\
\hspace{4cm}＋\\
\beta_{1} \beta_{0} \varepsilon_{t-1} \varepsilon_{t+1}+
\beta_{1}\beta_{1} \varepsilon_{t-1} \varepsilon_{t}+
\beta_{1} \beta_{2} \varepsilon_{t-1} \varepsilon_{t-1}\\
\hspace{4cm}＋\\
\beta_{2}\beta_{0} \varepsilon_{t-2} \varepsilon_{t+1} + 
\beta_{2}\beta_{1} \varepsilon_{t-2} \varepsilon_{t}+
\beta_{2} \beta_{2} \varepsilon_{t-2} \varepsilon_{t-1}

\end{array}
\right)　\tag{4-1}\\
\\
&= E[\beta_{0}\beta_{1} \varepsilon_{t} \varepsilon_{t}] + 
E[\beta_{1} \beta_{2} \varepsilon_{t-1} \varepsilon_{t-1}]\\
\\
&= \beta_{0}\beta_{1}\sigma^2 + 
\beta_{1} \beta_{2}\sigma^2\\

&= \sigma^2\sum_{i}^{1}\beta_{i}\beta_{i+1}

\end{align}
$$

##### $ma(2), k=2$の場合：


$$
\begin{align}
\operatorname{Cov}(y_t, y_{t+2})

&= E\left(

\begin{array}{l}

\beta_{0}\beta_{0} \varepsilon_{t} \varepsilon_{t+2}\ \ \ +
\beta_{0} \beta_{1} \varepsilon_{t} \varepsilon_{t+1}\ \ \ +
\beta_{0} \beta_{2} \varepsilon_{t} \varepsilon_{t} \\
\hspace{4cm}＋\\
\beta_{1} \beta_{0} \varepsilon_{t-1} \varepsilon_{t+2}+
\beta_{1}\beta_{1} \varepsilon_{t-1} \varepsilon_{t+1}+
\beta_{1} \beta_{2} \varepsilon_{t-1} \varepsilon_{t}\\
\hspace{4cm}＋\\
\beta_{2}\beta_{0} \varepsilon_{t-2} \varepsilon_{t+2} + 
\beta_{2}\beta_{1} \varepsilon_{t-2} \varepsilon_{t+1}+
\beta_{2} \beta_{2} \varepsilon_{t-2} \varepsilon_{t}

\end{array}
\right)　\tag{4-2}\\
\\
&= E[\beta_{0}\beta_{2} \varepsilon_{t} \varepsilon_{t}]\\
\\
&= \beta_{0}\beta_{2}\sigma^2\\

&= \sigma^2\sum_{i=0}^{0}\beta_{i}\beta_{i+2}

\end{align}
$$

##### $ma(2), k=3$の場合：

さらに$k=3$でも自己共分散を見てみましょう


$$
\begin{align}
\operatorname{Cov}(y_t, y_{t+3})

&= E\left(

\begin{array}{l}

\beta_{0}\beta_{0} \varepsilon_{t} \varepsilon_{t+3}\ \ \ +
\beta_{0} \beta_{1} \varepsilon_{t} \varepsilon_{t+2}\ \ \ +
\beta_{0} \beta_{2} \varepsilon_{t} \varepsilon_{t+1} \\
\hspace{4cm}＋\\
\beta_{1} \beta_{0} \varepsilon_{t-1} \varepsilon_{t+3}+
\beta_{1}\beta_{1} \varepsilon_{t-1} \varepsilon_{t+2}+
\beta_{1} \beta_{2} \varepsilon_{t-1} \varepsilon_{t+1}\\
\hspace{4cm}＋\\
\beta_{2}\beta_{0} \varepsilon_{t-2} \varepsilon_{t+3} + 
\beta_{2}\beta_{1} \varepsilon_{t-2} \varepsilon_{t+2}+
\beta_{2} \beta_{2} \varepsilon_{t-2} \varepsilon_{t+1}

\end{array}
\right)　\tag{4-2}\\
\\
&= 0


\end{align}
$$
$k = 3$では$\varepsilon$の下付きが一致する項は存在しないので、すべての項の期待値は0になります。**MA過程の次数$q$より大きいラグ$k$（$k > q$）での自己共分散は0になります**



##### 一般に

$MA(q)$の自己共分散は、$k \leq q$において
$$
\operatorname{Cov}(y_t, y_{t+k}) = \sigma^2\sum_{i=0}^{q-k}\beta_{i}\beta_{i+k}　=\gamma_k
$$
$k > q$では0になります。**自己共分散はラグ$k$にのみ依存して$t$に依存しません**



#### 3. 分散

分散は共分散の$k=0$の場合なので
$$
\gamma_0 = \sigma^2\sum_{i=0}^{q}\beta_{i}^2
$$

#### 4. 自己相関係数

自己相関係数は、共分散を分散で正規化したものなので
$$
\rho_k = \frac{\gamma_k}{\gamma_0} = \frac{\sum_{i=0}^{q-k}\beta_i\beta_{i+k}}{\sum_{i=0}^{q}\beta_i^2}
$$


#### 定常性

MA(q)の期待値と自己共分散は時点$t$に依存せしないため、**移動平均過程は弱定常である**といえます



### まとめ

移動平均過程MA(q)  $y_t = \beta_0\varepsilon_t + \beta_1\varepsilon_{t-1} + .. + \beta_q\varepsilon_{t-q} $において



| 統計量     | 値                                                           |
| ---------- | ------------------------------------------------------------ |
| 期待値     | $\mu = E[y_t] = 0$                                           |
| 自己共分散 | $\gamma_k = \operatorname{Cov}(y_t, y_{t+k}) = \sigma^2\sum_{i=0}^{q-k}\beta_{i}\beta_{i+k}$ |
| 分散       | $\gamma_0 = \operatorname{Var}[y_t] = \sigma^2\sum_{i=0}^{q}\beta_i^2$ |
| 自己相関   | $\rho = \frac{\gamma_k}{\gamma_0} = \frac{\sum_{i=0}^{q-k}\beta_{i}\beta_{i+k}}{\sum_{i=0}^{q}\beta_i^2}$ |
| 定常性     | 常に弱定常を満たす                                           |







----

※定常というと広くは弱定常と強定常をさすが、ここでは時系列モデルで広く仮定さえれいる弱定常性の定義を振り返る。



時系列モデリングでは時間とともに変わる値の列（時系列）に含まれる特徴をうまく抽出して、何か知見を得ようとする訳だが、その際、例えば絶対時点やタイムインデックス$t$を使って系列性質を表現しても、あまり旨味はない。`2020年3月4日 5:00`に気温は20℃だった、みたいなことが分かっても`2020年3月4日 5:00`はという時点は一度しかないのだから、予測



モデリングしたとしても

