# 時系列分析：ARモデルの性質と定常性（1/2）

ARモデルはシンプルなモデルですが、自己共分散や自己相関はMAモデルほど簡素な表現はなく、Yule-Walker方程式のような連立方程式を解いていくのが一般的のようです。本投稿では2回に分けてARモデルの期待値、自己相関、定常性などの性質を整理したいと思います。

MAモデルの性質と定常性



contents

# ARモデル

ARモデルは現在の値が、過去の自分自身の状態を引きずっている（記憶している）というモデル。世の中の現象ってだいたい過去の状態を引きずっていそうです。

ARモデルではこの過去の記憶を、過去の値の線形和で表現します。p次のARモデル、AR(p)は以下のように定式化されています。


<div  align="center">
[tex:\displaystyle{


\begin{align}
y_t &= c + \phi_{1}y_{t-1} + \phi_{2}y_{t-2} + \dots + \phi_{p}y_{t-p} + \varepsilon_t\\
&=c + \sum_{k=1}^{p}\phi_ky_{t-k} + \varepsilon_t\\
\\
\\
\varepsilon_t &\sim \operatorname{W.N.}(\sigma_{\varepsilon}^2)
\end{align}

}]
</div>

ここで[tex:\displaystyle{c}]は定数項でベースのレベルを決めます（直流成分）、[tex:\displaystyle{\varepsilon\_t}]はホワイトノイズです。[tex:\displaystyle{\varepsilon\_t}]は、[tex:\displaystyle{t-1}]以前には含まれていない[tex:\displaystyle{t}]時点で新しく加わった唯一の情報でイノベーションなどとも呼ばれています。



## AR(1)の例

いくつかAR過程の具体例を見てみます。ここでは[tex:\displaystyle{c=0}]とします。生成に使ったPythonスクリプトはここにあります。

[tex:\displaystyle{\phi\_1=1}]の場合(ランダムウォーク ):

1次のAR過程のうち、[tex:\displaystyle{\phi\_1=1}]かつホワイトノイズに同分布を仮定すると有名なランダムウォークになります。
<div  align="center">
[tex:\displaystyle{


y_{t} = y_{t-1} + \varepsilon_t
\\
\\
\varepsilon_t \sim \operatorname{iid}(0, \sigma_{\varepsilon}^2)

}]
</div>



[tex:\displaystyle{\phi\_1=0.3}]の場合:



[tex:\displaystyle{\phi\_1=1.1}]の場合:



同じAR(1)過程でも[tex:\displaystyle{\phi}]のとる値によって印象は随分違います。[tex:\displaystyle{\phi\_1=1.1}] の例が発散していることからも明らかなようにAR過程は[tex:\displaystyle{\phi}]の値によって定常性も異なります。

# ARモデルの性質

## 期待値

### AR(1)の場合：

1次のARモデル[tex:\displaystyle{y\_t = c + \phi\_{1}y\_{t-1} + \varepsilon\_t}]の期待値をとると
<div  align="center">
[tex:\displaystyle{


\begin{align}
E\[y_{t}\] &= E\[c + \phi_{1}y_{t-1} + \varepsilon_t\]\\
&=c + \phi_{1}E\[y_{t-1}\]
\end{align}

}]
</div>

ここで定常を仮定とすると期待値は時刻[tex:\displaystyle{t}]に依存しないため、[tex:\displaystyle{E\\[y\_t\\]=E\\[y\_{t-1}\\]}]となります。この期待値を[tex:\displaystyle{\mu}]と置くと以下のようになります。
<div  align="center">
[tex:\displaystyle{


\begin{align}

\mu &=c + \phi_{1}\mu \\
\\
\mu &= \frac{c}{1-\phi_1}
\end{align}

}]
</div>


## AR(p)の場合：

p次の場合も同様に期待値をとって
<div  align="center">
[tex:\displaystyle{


\begin{align}
E\[y_t\] &= E\[c + \phi_{1}y_{t-1} + \phi_{2}y_{t-2} + \dots + \phi_{p}y_{t-p} + \varepsilon_t\]\\
\\
&=c + \phi_{1}E\[y_{t-1}\] + \phi_{2}E\[y_{t-2}\] + \dots + \phi_{p}E\[y_{t-p}\] \\
\end{align}

}]
</div>

定常を仮定して、[tex:\displaystyle{E\\[y\_t\\]=E\\[y\_{t-1}\\]=\dots=\mu}]と置くと以下のようになります。
<div  align="center">
[tex:\displaystyle{


\begin{align}

\mu &=c + \phi_{1}\mu + \phi_{2}\mu +\dots + \phi_{p}\mu \\
\\
\mu &= \frac{c}{1-\phi_{1}-\phi_{2} - \dots - \phi_{p}}
\end{align}

}]
</div>



また、式より直流成分[tex:\displaystyle{c=0}]のとき、定常なARモデルの期待値は常に0になることが分かります。

# 自己分散・共分散

自己分散・共分散は少し工夫が必要になります。とりあえず愚直に計算してみましょう。

## AR(1)の場合：

分散：

AR(1)モデル[tex:\displaystyle{y\_t = c + \phi\_{1}y\_{t-1} + \varepsilon\_t}]の分散を計算します。
<div  align="center">
[tex:\displaystyle{


\begin{align}
\operatorname{Var}\[y_{t}\] &= \operatorname{Var}\[c + \phi_{1}y_{t-1} + \varepsilon_t\]\\
&= \operatorname{Var}\[c\] + \operatorname{Var}\[\phi_1y_{t-1}\] + \operatorname{Var}\[\varepsilon_t\]  \\&+ 2\operatorname{Cov}(c, \phi_1y_{t-1})+ 2\operatorname{Cov}(\phi_1y_{t-1}, \varepsilon_t) + 2\operatorname{Cov}(c, \varepsilon_t) \\
&=\phi_{1}^2\operatorname{Var}\[y_{t-1}\] + \sigma_{\varepsilon}^2
\end{align}

}]
</div>

定常を仮定して、[tex:\displaystyle{\operatorname{Var}\\[y\_t\\]=\operatorname{Var}\\[y\_{t-1}\\]=\gamma\_0}]と置くと以下のようになります。
<div  align="center">
[tex:\displaystyle{


\begin{align}
\gamma_0
&=\phi_{1}^2\gamma_0 + \sigma_{\varepsilon}^2
\\
\\
\gamma_0 &= \frac{\sigma_{\varepsilon}^2}{1-\phi_1^2} \tag{1}
\end{align}\\

}]
</div>

自己共分散：

[tex:\displaystyle{y\_t}]と[tex:\displaystyle{y\_{t-k}}]の共分散をとります。
<div  align="center">
[tex:\displaystyle{


\begin{align}
\operatorname{Cov}(y_{t}, y_{t-k}) &= \operatorname{Cov}(c + \phi_{1}y_{t-1} + \varepsilon_t, y_{t-k})\\
&= \operatorname{Cov}(c, y_{t-k}) + \phi_{1}\operatorname{Cov}(y_{t-1}, y_{t-k}) + \operatorname{Cov}(\varepsilon_t, y_{t-k})\\
&= \phi_{1}\operatorname{Cov}(y_{t-1}, y_{t-k})
\end{align}

}]
</div>



2行目への展開は、共分散を分配しています。3行目への展開は、定数や独立な変数との共分散は0であることを利用しています。共分散の分散、共分散の計算は以下を参考にしてください。





ここで[tex:\displaystyle{\operatorname{Cov}(y\_{t}, y\_{t-k})}]はラグ[tex:\displaystyle{k}]の自己共分散なので[tex:\displaystyle{\gamma\_k}]、また[tex:\displaystyle{y\_{t-1}}]と[tex:\displaystyle{ y\_{t-k}}]のラグは[tex:\displaystyle{k-1}]なので同様に[tex:\displaystyle{\operatorname{Cov}(y\_{t-1}, y\_{t-k})}]を[tex:\displaystyle{\gamma\_{k-1}}]と置くと
<div  align="center">
[tex:\displaystyle{


\gamma_k = \phi_1\gamma_{k-1} \tag{2}

}]
</div>

という自己共分散の関係式が現れます。[tex:\displaystyle{k=1}]の自己共分散は、[tex:\displaystyle{(1)(2)}]式を使って次のように表せます。
<div  align="center">
[tex:\displaystyle{


\begin{align}
\gamma_1 = \phi_1\gamma_0
&=\phi_1\frac{\sigma_{\varepsilon}^2}{1-\phi_1^2}
\end{align}

}]
</div>

さらに[tex:\displaystyle{(2)}]を[tex:\displaystyle{\gamma\_0}]で割ると、自己相関でも同様の関係が成り立つことが分かります。


<div  align="center">
[tex:\displaystyle{


\begin{eqnarray}
\frac{\gamma_k}{\gamma_0} = \phi_1\frac{\gamma_{k-1}}{\gamma_0}
\\
\rho_k = \phi_1\rho_{k-1} \tag{3}
\end{eqnarray}

}]
</div>

[tex:\displaystyle{(3)}]式はYule-Walker方程式と呼ばれているものです。

> AR過程の自己相関が[tex:\displaystyle{y\_t}]が従うAR過程と同一の係数をもつ差分方程式に従うことを示す
>
> 
>
> 引用：



[tex:\displaystyle{(3)}]式の関係性を繰り返し適用すると、ラグ[tex:\displaystyle{k}]の自己相関は[tex:\displaystyle{\rho\_0}]を使って次のように書けます。
<div  align="center">
[tex:\displaystyle{


\rho_k = \phi_1\rho_{k-1} = \phi_1^2\rho_{k-2} = \dots = \phi_1^k\rho_0

}]
</div>

ラグ0の自己相関[tex:\displaystyle{\rho\_0=1}]なので
<div  align="center">
[tex:\displaystyle{


\rho_k = \phi_1^k

}]
</div>



[tex:\displaystyle{|\phi\_1| \lt 1}]のとき自己相関は[tex:\displaystyle{k}]が大きくなるにつれて減衰することが分かります。


## AR(2)の場合：

AR(1)のケースでは素直に分散・自己共分散を算出できましたが、同じことをAR(2)でも試してみます。

分散：

AR(2)モデル[tex:\displaystyle{y\_t = c + \phi\_{1}y\_{t-1}+ \phi\_{2}y\_{t-2} + \varepsilon\_t}]の分散を計算します。


<div  align="center">
[tex:\displaystyle{


\begin{align}
\operatorname{Var}\[y_{t}\] &= \operatorname{Var}\[c + \phi_{1}y_{t-1} + \phi_{2}y_{t-2}+ \varepsilon_t\]\\
&= \operatorname{Var}\[\phi_1y_{t-1}\] +\operatorname{Var}\[\phi_2y_{t-2}\]+\operatorname{Var}\[\varepsilon_t\] + 2\operatorname{Cov}(\phi_1y_{t-1}, \phi_2y_{t-2}) \\
&=\phi_{1}^2\operatorname{Var}\[y_{t-1}\] + \phi_{2}^2\operatorname{Var}\[y_{t-2}\] + \sigma_{\varepsilon}^2 + 2\phi_{1}\phi_{2}\operatorname{Cov}(y_{t-1}, y_{t-2})

\end{align}

}]
</div>

定常を仮定すると[tex:\displaystyle{\operatorname{Var}\\[y\_{t}\\] = \operatorname{Var}\\[\phi\_1y\_{t-1}\\] = \operatorname{Var}\\[\phi\_1y\_{t-1}\\] = \gamma\_0, \operatorname{Cov}(y\_{t-1}, y\_{t-2})=\gamma\_1}]といえるので
<div  align="center">
[tex:\displaystyle{


\gamma_0 =\phi_{1}^2\gamma_0 + \phi_{2}^2\gamma_0 + \sigma_{\varepsilon}^2 + 2\phi_{1}\phi_{2}\gamma_1 \tag{4}

}]
</div>

このように、[tex:\displaystyle{\gamma\_0}]と[tex:\displaystyle{\gamma\_1}]の関係式が出てきました。つまり分散を知るには、ラグ1自己共分散[tex:\displaystyle{\gamma\_1}]が必要になります。素直に[tex:\displaystyle{\gamma\_1}]を計算します。
<div  align="center">
[tex:\displaystyle{


\begin{align}
\gamma_1 &= \operatorname{Cov}(y_{t}, y_{t-1})\\
&= \operatorname{Cov}(c + \phi_{1}y_{t-1} + \phi_{2}y_{t-2}+ \varepsilon_t, y_{t-1})\\
&=\operatorname{Cov}(c, y_{t-1}) + \phi_{1}\operatorname{Cov}(y_{t-1},y_{t-1}) + \phi_{2}\operatorname{Cov}(y_{t-2}, y_{t-1})+ \operatorname{Cov}(\varepsilon_t, y_{t-1})\\
&=\phi_{1}\gamma_0 + \phi_{2}\gamma_1

\\
\\
\gamma_1 &= \frac{\phi_1}{1-\phi_2}\gamma_0 \tag{5}
\end{align}

}]
</div>

[tex:\displaystyle{(4)}]式に[tex:\displaystyle{(5)}]を代入して整理すると、
<div  align="center">
[tex:\displaystyle{


\begin{eqnarray}
\frac{1-\phi_2  - \phi_2^2 + \phi_2^3 - \phi_1^2 - \phi_1^2\phi_2}{1-\phi_2}\gamma_0 = \sigma_{\varepsilon}^2
\\
\gamma_0 = \frac{1-\phi_2}{1+\phi_1}\frac{\sigma_{\varepsilon}^2}{((1-\phi_2)^2 - \phi_1^2)} \tag{6}
\end{eqnarray}

}]
</div>

ということで分散が求まりました。さらに[tex:\displaystyle{\gamma\_1}]は[tex:\displaystyle{(5)}]式に[tex:\displaystyle{(6)}]を代入して
<div  align="center">
[tex:\displaystyle{


\gamma_1 = \frac{\phi_1}{1+\phi_1}\frac{\sigma_{\varepsilon}^2}{((1-\phi_2)^2 - \phi_1^2)}

}]
</div>

となります。同様に[tex:\displaystyle{\gamma\_2}]以降も求めることができます。ただ一般化するには結構つらいしスマートではありません。そこでYule-Walker方程式を使います。
<div  align="center">
[tex:\displaystyle{


\rho_k = \phi_1\rho_{k-1} + \phi_2\rho_{k-2} + \dots + \phi_p\rho_{k-p}, \ k >0

}]
</div>

この関係性を中心に解いていくとこれらが比較的スマートにすることができます。
次回、Yule-Walker方程式を用いたAR(p)の自己相関関数や定常性について整理します。



# まとめ

* ARモデルは過去の状態の線形和で、過去の記憶を表現します
* ARモデルの定常性は係数によって決まります
* AR(1)の期待値、分散、自己相関係数はそれぞれ次のようになります

<div  align="center">
[tex:\displaystyle{


\begin{align}

\mu &= \frac{c}{1-\phi_1}\\
\\
\gamma_0 &= \frac{\sigma_{\varepsilon}^2}{1-\phi_1^2}\\
\\
\rho_k &= \phi_1^k

\end{align}\\

}]
</div>


* AR過程の自己相関は[tex:\displaystyle{y\_t}]が従うAR過程と同一の係数をもつ差分方程式に従います（Yule-Walker方程式）

<div  align="center">
[tex:\displaystyle{


\rho_k = \phi_1\rho_{k-1}

}]
</div>


* ARモデルの分散や自己相関は上記の関係性を使うことで求めることができます

---

AR(2)の共分散の式展開が合わずに時間を無駄に使いました。とほほ。中年の残りすくない時間を。。。日々精進



# 参考文献

* https://ja.wikipedia.org/wiki/%E8%87%AA%E5%B7%B1%E5%9B%9E%E5%B8%B0%E3%83%A2%E3%83%87%E3%83%AB
* https://stats.stackexchange.com/questions/256437/variance-of-a-stationary-ar2-model
* https://www.reddit.com/r/AskStatistics/comments/48xgvj/time_series_ar2_variance_derivation/
* 経済・ファイナンスデータの計量時系列分析- 沖本 竜義