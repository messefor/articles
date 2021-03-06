# 時系列分析：MAモデルの反転可能性

自己相関構造は時系列モデル選択の重要な基準になります。しかしながらMAモデルでは同じ自己相関構造を持つモデル（パラメタ）が複数存在するため、その中からMAモデルを一つ選ぶ基準が必要です。この基準として反転可能性の議論がでてきます。本投稿ではMAモデルの反転可能性について確認します。
時系列分析において反転可能性は重要な性質の一つで、ARモデルの収束性判定でも用いられます。



contents

# MAモデルの選択

自己相関構造は時系列モデル選択の目安となりますが、MAモデルでは同じ期待値や自己相関構造を持つパラメタは複数存在します。以下の２つのMA(1)モデルそれぞれの自己相関構造を確認してみましょう。
<div  align="center">
[tex:\displaystyle{


\begin{eqnarray}

y_t = \varepsilon_t + 2\varepsilon_{t-1} \tag{1}\\

y_t = \varepsilon_t + \frac{1}{2}\varepsilon_{t-1} \tag{2}\\

\\

\varepsilon_t \sim \operatorname{W.N}(\sigma^2)
\end{eqnarray}

}]
</div>



[tex:\displaystyle{(1)}]の期待値と自己共分散を定義どおりに計算すると
<div  align="center">
[tex:\displaystyle{


\begin{align}
\mu &= E\[y_t\] = E\[\varepsilon_t + 2\varepsilon_{t-1}\] = 0

\\
\\
\gamma_k &= \operatorname{Cov}\[\varepsilon_t + 2\varepsilon_{t-1}, \varepsilon_{t+k} + 2\varepsilon_{t+k-1}\]\\
&= E\[(\varepsilon_t + 2\varepsilon_{t-1})(\varepsilon_{t+k} + 2\varepsilon_{t+k-1})\] - E\[\varepsilon_t + 2\varepsilon_{t-1}\]E\[\varepsilon_{t+k} + 2\varepsilon_{t+k-1}\] \\
&= E\[\varepsilon_t\varepsilon_{t+k}\] + 2E\[\varepsilon_t\varepsilon_{t+k-1}\] + 2E\[\varepsilon_{t-1}\varepsilon_{t+k}\] + 4E\[\varepsilon_{t-1}\varepsilon_{t+k-1}\] \tag{3}

\end{align}

}]
</div>

ホワイトノイズの性質から時点が一致する自己共分散以外は0になるので、[tex:\displaystyle{(3)}]式はラグ[tex:\displaystyle{k}]によって場合分けされ
<div  align="center">
[tex:\displaystyle{


\gamma_k = \left\{
\begin{array}{ll}

5\sigma^2 & k = 0\\
2\sigma^2 & k = 1\\
0 & k > 1\\
\gamma(-k) & k < 0

\end{array}
\right.

}]
</div>

　これより自己相関は
<div  align="center">
[tex:\displaystyle{


\rho_k = \frac{\gamma_k}{\gamma_0} = \left\{
\begin{array}{ll}

1 & k = 0\\
\frac{2}{5} & k = 1\\
0 & k > 1\\
\rho(-k) & k < 0

\end{array}
\right.

}]
</div>



なお一般にMA(q)モデルの自己相関は次のようになります。これが分かっていれば、上記はすぐに算出できます。
<div  align="center">
[tex:\displaystyle{


\gamma_k = \frac{\sum_{i=0}^{q-k}\beta_i\beta_{i+k}}{\sum_{i=0}^{q}\beta_i^2}

}]
</div>

MA(q)モデルの自己相関の考え方については以下を参考にしてください。
同様に[tex:\displaystyle{(2)}]の期待値、自己相関を計算すると
<div  align="center">
[tex:\displaystyle{


\begin{align}
\mu &= E\[y_t\] = E\[\varepsilon_t + \frac{1}{2}\varepsilon_{t-1}\] = 0

\\
\\
\gamma_k &= \operatorname{Cov}\[\varepsilon_t + \frac{1}{2}\varepsilon_{t-1}, \varepsilon_{t+k} + \frac{1}{2}\varepsilon_{t+k-1}\]\\
&= E\[(\varepsilon_t + \frac{1}{2}\varepsilon_{t-1})(\varepsilon_{t+k} + \frac{1}{2}\varepsilon_{t+k-1})\] - E\[\varepsilon_t + \frac{1}{2}\varepsilon_{t-1}\]E\[\varepsilon_{t+k} + \frac{1}{2}\varepsilon_{t+k-1}\] \\
&= E\[\varepsilon_t\varepsilon_{t+k}\] + \frac{1}{2}E\[\varepsilon_t\varepsilon_{t+k-1}\] + \frac{1}{2}E\[\varepsilon_{t-1}\varepsilon_{t+k}\] + \frac{1}{4}E\[\varepsilon_{t-1}\varepsilon_{t+k-1}\]

\end{align}

}]
</div>


<div  align="center">
[tex:\displaystyle{


\gamma_k = \left\{
\begin{array}{ll}

\frac{5}{4}\sigma^2 & k = 0\\
\frac{1}{2}\sigma^2 & k = 1\\
0 & k > 1\\
\gamma(-k) & k < 0

\end{array}
\right.

}]
</div>


<div  align="center">
[tex:\displaystyle{


\rho_k = \frac{\rho_k}{\rho_0}\left\{
\begin{array}{ll}

1 & k = 0\\
\frac{2}{5} & k = 1\\
0 & k > 1\\
\rho(-k) & k < 0

\end{array}
\right.

}]
</div>



２つのモデルの期待値、自己相関は全く同じになります。沖本本によると

> 同一の期待値と自己相関構造をもつMA(q)過程は一般的に[tex:\displaystyle{2^ q}]個あることが知られている

とのことなので、自己相関構造からMAモデルを一つ選ぶ基準が必要です。

# 反転可能性（invertiblity）

この基準として登場するのが反転可能性（invertiblity)です。MAモデルは条件によって、以下のようにAR([tex:\displaystyle{\infin}])で表すことができます。これを反転と呼んでいます。
<div  align="center">
[tex:\displaystyle{


\begin{eqnarray}
y_t = \sum_{k=1}^{\infin}\pi_ky_{t-k} + \varepsilon_t 
\\
\mathrm{or}
\\
\varepsilon_t = y_t - \sum_{k=1}^{\infin}\pi_{k}y_{t-k}  \tag{4}
\end{eqnarray}

}]
</div>

[tex:\displaystyle{(4)}]の形を見ると分かりやすいですが、AR([tex:\displaystyle{\infin}])に反転させた形でみると[tex:\displaystyle{\varepsilon\_t}]が[tex:\displaystyle{y\_t}]と、過去の[tex:\displaystyle{y}]の線形和の差になっています。これは現在の[tex:\displaystyle{y\_t}]のうち、過去の[tex:\displaystyle{y}]を使っても表現できない部分が[tex:\displaystyle{\varepsilon\_t}] である、と解釈できます。反転可能なMA過程は、解釈が容易になるなど良い性質を持っています。

## MAモデルの反転のイメージ

なぜMAモデルがAR([tex:\displaystyle{\infin}])で表せるのでしょうか。MA(1)モデルの例で確認します。ここでは等比数列の部分和を用いて導出してみます。まずMA(1)モデルをラグオペレータ（後退オペレータ）[tex:\displaystyle{B}]の多項式を用いて表します。
<div  align="center">
[tex:\displaystyle{


\begin{eqnarray}
y_t &= \varepsilon_t + \beta_1\varepsilon_{t-1}\\
&=\varepsilon_t - \beta_1B\varepsilon_t \\
&=(1 - \beta_1B)\varepsilon_t\\
&=\beta(B)\varepsilon_t\\

\mathrm{where}\\
\\
\beta(B) &= 1 - \beta_1B \tag{5}
\end{eqnarray}

}]
</div>



ラグオペレータについては以下の記事を参考にしてください。

ここで[tex:\displaystyle{\beta(B)}]はラグオペレータの多項式です。ここでもし[tex:\displaystyle{\beta(B)}]の逆演算を定義できるなら次のように撹乱項を[tex:\displaystyle{y\_t}]とラグオペレータで表現できます。
<div  align="center">
[tex:\displaystyle{


\begin{eqnarray}
\varepsilon_t &= \beta(B)^{-1}y_t \tag{6}
\end{eqnarray}

}]
</div>

実際に[tex:\displaystyle{B}]は単位円上の複素数と考えて良いようで、[tex:\displaystyle{\beta(B)^ {-1}}]は次のようになります。
<div  align="center">
[tex:\displaystyle{


\begin{eqnarray}
\beta(B)^{-1}
&= \frac{1}{1 - \beta_1B} \tag{7}
\end{eqnarray}

}]
</div>

ここで高校数学の等比数列の部分和から以下の関係性を使います。
<div  align="center">
[tex:\displaystyle{


\begin{align}
S_n &= a + ar + ar^2 + \dots + ar^{n-1}\\
&= a\frac{1-r^n}{1-r} \tag{8}\\
\end{align}

}]
</div>

[tex:\displaystyle{n}]を[tex:\displaystyle{\infin}]にとばした場合、[tex:\displaystyle{(8)}]式は[tex:\displaystyle{|r| < 1}]のとき収束し次のようになります
<div  align="center">
[tex:\displaystyle{


\begin{align}
\lim_{n \to \infty}S_n &= a + ar + ar^2 + \dots + ar^{n-1} + \dots\\
&= a\frac{1}{1-r} \tag{9}\\
\end{align}

}]
</div>

この関係性を使って[tex:\displaystyle{(7)}]式を展開してみます、[tex:\displaystyle{(8)}]式で[tex:\displaystyle{a=1}]、[tex:\displaystyle{r=\beta\_1B}]と考えて、[tex:\displaystyle{|r| < 1}]のとき
<div  align="center">
[tex:\displaystyle{


\begin{align}
\beta(B)^{-1}
&= \frac{1}{1 - \beta_1B} \\
&=1+\beta_1B + \beta_1^2B^2 + \dots + \beta_1^{n-1}B^{n-1} + \dots\\
\end{align}

}]
</div>

 さらにこれを用いて、[tex:\displaystyle{(6)}]式を展開すると
<div  align="center">
[tex:\displaystyle{


\begin{align}
\varepsilon_t &= \beta(B)^{-1}y_t\\
&=(1+\beta_1B + \beta_1^2B^2 + \dots + \beta_1^{n-1}B^{n-1} + \dots)y_t\\
&=y_t + \beta_1y_{t-1} + \beta_1^2y_{t-2} + \dots + \beta_1^{n-1}y_{t-n+1} + \dots\\
&=y_t + \sum_{k=0}^{\infin}\beta_1^ky_{t-k}
\end{align}

}]
</div>



が成り立ちます。これで[tex:\displaystyle{(4)}]式と同じ形になりました。

ここで[tex:\displaystyle{|r| < 1}]の条件は[tex:\displaystyle{|r|=|\beta\_1B| < 1}]と、 [tex:\displaystyle{B}]が単位円上の複素数であることを考えると[tex:\displaystyle{|B| = 1}]のため、最終的に[tex:\displaystyle{|\beta\_1| < 1}]が満たすべき条件となります。



## MA過程の反転可能条件

MA(1)の反転を行う過程では、[tex:\displaystyle{|r| < 1}]という条件が必要ということがわかりました。一般にMA(q)過程の反転可能性の条件はMA特性方程式の根を使って設定されます。MA特性方程式とは、ラグオペレータ多項式のラグオペレータ[tex:\displaystyle{B}]を複素数[tex:\displaystyle{z}]と置き換え、多項式を0とした方程式で次の形をとります。
<div  align="center">
[tex:\displaystyle{


\begin{align}
\theta(z) &= 1 + \theta_1z + \theta_2z^2 + \dots + \theta_qz^q = 0
\end{align}

}]
</div>

MA過程の判定可能性条件:

 **MA特性方程式[tex:\displaystyle{\theta(z)}]の根がすべて単位円の外に存在する（[tex:\displaystyle{z}]の解の絶対値が1より大きい）**場合、そのMA過程は判定可能

この反転可能性の制約を入れることで、期待値と自己相関構造からMAモデルは一つに定まります。

## MA(1)の反転可能性

先程のMA(1)の例で反転可能性条件を確認してみます。
MA(1)モデル[tex:\displaystyle{y\_t = \varepsilon\_t + \beta\_1\varepsilon\_{t-1}}]のMA特性方程式は、[tex:\displaystyle{(5)}]式のラグオペレータ多項式[tex:\displaystyle{\beta(B) = 1 - \beta\_1B}]を考えて
<div  align="center">
[tex:\displaystyle{


\begin{eqnarray}

\beta(z) = 1 - \beta_1z = 0
\end{eqnarray}

}]
</div>

この方程式の根は[tex:\displaystyle{z = \frac{1}{\beta\_1}}]の一つ 。反転可能になるためには[tex:\displaystyle{|z| > 1}]となればいいので
<div  align="center">
[tex:\displaystyle{


|z| = \left|\frac{1}{\beta_1}\right| > 1
\\
\\
|\beta_1| < 1

}]
</div>

よって[tex:\displaystyle{|\beta\_1| < 1}]が条件となります。先程の[tex:\displaystyle{|r| < 1}]の条件とも一致します。



# まとめ

* MAモデルは同じ自己相関構造をもつ複数のモデルが存在します
* 反転可能性の制約を入れることで、自己相関構造からMAモデルは一つに定まります
* MA(q)の反転可能性条件は以下のMA特性方程式のすべての根が単位円の外側にあることです（[tex:\displaystyle{|z| > 1}]）

<div  align="center">
[tex:\displaystyle{


\begin{align}
\theta(z) &= 1 + \theta_1z + \theta_2z^2 + \dots + \theta_qz^q = 0
\end{align}

}]
</div>




MAモデルを[tex:\displaystyle{\varepsilon\_t}]を入力とするシステムとして捉える感じが出てきました。制御や信号処理とつながるのは興味深いですね。いつかすべて理解出来る日まで日々精進