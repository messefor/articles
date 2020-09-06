

# 後退オペレータとは何なのか

時系列の勉強をしていると、*後退オペレータ（Backshift Operator）*というのが出てきます。このオペレータを使って時系列モデルを表現することで、簡潔で見通しの良い議論が可能になるようです。本投稿ではこれについて考察したいと思います。なお後退オペレータは、様々な呼び名があるようで、*時間シフトオペレータ、Backshift Operator、Backwardshift Operator* など異なる記述で書かれています。



## 後退オペレータの定義

[英語版Wiki](https://en.wikipedia.org/wiki/Lag_operator)では次のように説明してあります

> 時系列分析において後退オペレータは*時系列の要素に作用し、前の要素を生成する*
>
> In time series analysis, the lag operator (L) or backshift operator (B) operates on an element of a time series to produce the previous element. 

つまり時系列のある時点の値[tex:\displaystyle{X\_t}]を一時点前の[tex:\displaystyle{X\_{t-1} }] に戻すような操作になります。

次のような時系列[tex:\displaystyle{X}]があったとすると
<div  align="center">
[tex:\displaystyle{


X = \{X_1, X_2\, X_3, \dots \}

}]
</div>

後退オペレータ[tex:\displaystyle{B}]は以下のように定義されます
<div  align="center">
[tex:\displaystyle{


X_{t-1} = BX_t

}]
</div>



ある時点の要素[tex:\displaystyle{X\_t}]に後退オペレータ[tex:\displaystyle{B}]を乗ずることで、一時点前の要素[tex:\displaystyle{X\_{t-1}}]を得ることができます。

同様に二つ前の要素は
<div  align="center">
[tex:\displaystyle{


\begin{align}
X_{t-2} &= BX_{t-1}\\
&= B(BX_{t}) \\
&= B^2X_t
\end{align}

}]
</div>

のようにアクセスできます。一般に[tex:\displaystyle{k}]時点前の要素は次のようになります。
<div  align="center">
[tex:\displaystyle{


X_{t-k} = B^kX_t

}]
</div>



## 後退オペレータの多項式表現

後退オペレータを用いて時系列モデル（確率過程）を簡潔に表現するケースは多く見受けられます。その際に次のように後退オペレータ[tex:\displaystyle{B}]の多項式[tex:\displaystyle{\phi(B)}]を使って統一的にモデルを表現します。まずこのことを頭に入れておくと良いと思います。


<div  align="center">
[tex:\displaystyle{


\begin{align}
\phi(B) &= \beta_0 + \beta_1B + \beta_2B^2 + \beta_3B^3 + \dots + \beta_kB^k\\
&=\sum_{i=0}^{k}\beta_{i}B^i
\end{align}

}]
</div>



## 後退オペレータの使いどころ

それでは具体例を見ていきましょう。以下の例はCourseraの[ここ](https://d3c33hcgiwev3.cloudfront.net/_a570fb6fd69d113c2fe75b7f2649e856_Week-2---slides---together.pdf?Expires=1597104000&Signature=fPS9kogj8~fETeMCDTDqUnwTcMPGXbBjjCZheekHxs-pqHbvR6~xLm5k1bI5FiqyYZqxy53wgfTSnTo3SBaApH1cRSv3n3zgx~W085TIAMOZoALXpU5mN6SZrAMvyFyR8I-p-mRw2AW-PT-fVQxWAgAsLxlh-E4fxJbDU98O39M_&Key-Pair-Id=APKAJLTNE6QMUY6HBC5A)に記載している内容ほぼそのまんまです。

### 1. ランダムウォーク

まず以下のランダムウォークを考えます。
<div  align="center">
[tex:\displaystyle{


X_t = X_{t-1} + \varepsilon_t\\

}]
</div>

where
<div  align="center">
[tex:\displaystyle{


\varepsilon_t \sim \operatorname{iid}(0, \sigma^2)

}]
</div>



ランダムウォークを後退オペレータを用いて表すと


<div  align="center">
[tex:\displaystyle{


\begin{align}
X_t &= X_{t-1} + \varepsilon_t\\
&=BX_{t} + \varepsilon_t\\

\end{align}

}]
</div>

となります。

さらに後退オペレータの多項式[tex:\displaystyle{\phi(B)}]を使って次のようになります。
<div  align="center">
[tex:\displaystyle{


(1 - B)X_t = \varepsilon_t \\
\phi(B)X_t = \varepsilon_t\\

}]
</div>

where
<div  align="center">
[tex:\displaystyle{


\phi(B) = 1 - B\\

}]
</div>

さほどありがたみは感じません。

### 2. MA(q)モデル

MA(q)モデルを見てみましょう。
ランダムウォークと同じですがMA過程なので[tex:\displaystyle{\varepsilon\_t}]に対して後退オペレータを適用します
<div  align="center">
[tex:\displaystyle{


\begin{align}
X_t &= \varepsilon_t + \beta_1\varepsilon_{t-1} + \beta_2\varepsilon_{t-2} +  \dots + \beta_q\varepsilon_{t-q}\\
&= \varepsilon_t + \beta_1B\varepsilon_{t} + \beta_2B^2\varepsilon_{t} +  \dots + \beta_qB^q\varepsilon_{t}\\
&= （1 + \beta_1B + \beta_2B^2 +  \dots + \beta_qB^q）\varepsilon_{t}\\
\end{align}

}]
</div>


<div  align="center">
[tex:\displaystyle{


\begin{align}
X_t &=（1 + \beta_1B + \beta_2B^2 +  \dots + \beta_qB^q）\varepsilon_{t}\\
&= \phi(B)\varepsilon_{t}
\end{align}

}]
</div>


where
<div  align="center">
[tex:\displaystyle{


\phi(B) = 1 + \beta_1B + \beta_2B^2\varepsilon_{t} +  \dots + \beta_qB^q

}]
</div>



[tex:\displaystyle{X\_t = \phi(B)\varepsilon\_t}] というのは簡潔ですね。

### 3. AR(p)モデル

またAR(p)過程は、次のようになります
<div  align="center">
[tex:\displaystyle{


\begin{align}
X_t &= \beta_1X_{t-1} + \beta_2X_{t-2} +  \dots + \beta_qX_{t-q} + \varepsilon_t\\
&= \beta_1BX_{t} + \beta_2B^2X_{t} +  \dots + \beta_qB^qX_{t} + \varepsilon_t\\
\end{align}

}]
</div>


<div  align="center">
[tex:\displaystyle{


\begin{align}
X_t - \beta_1BX_t + \beta_2B^2X_{t} +  \dots + \beta_qB^qX_{t}= \varepsilon_t\\
(1 - \beta_1B + \beta_2B^2 +  \dots + \beta_qB^q)X_{t}= \varepsilon_t\\
\phi(B)X_{t}= \varepsilon_t\\

\end{align}

}]
</div>


where
<div  align="center">
[tex:\displaystyle{


\phi(B) = 1 - \beta_1B + \beta_2B^2 +  \dots + \beta_qB^q

}]
</div>



[tex:\displaystyle{\phi(B)X\_{t}= \varepsilon\_t}] というのも簡潔ですね。

### 4. ARMAモデル

上記のMA(q)とAR(p)を踏まえてARMAモデルも考えてみます。


<div  align="center">
[tex:\displaystyle{


X_t = \sum_{i=1}^{p}\alpha_iX_{t-i} + \varepsilon_t + \sum_{i=1}^{q}\beta_i\varepsilon_{t-i}\\


X_t - \sum_{i=1}^{p}\alpha_iB^iX_{t} =   \varepsilon_t + \sum_{i=1}^{q}\beta_iB^i\varepsilon_{t}\\

(1 - \sum_{i=1}^{p}\alpha_iB^i)X_{t} =   (1 + \sum_{i=1}^{q}\beta_iB^i)\varepsilon_{t}\\

\phi_{\alpha}(B)X_t = \phi_{\beta}(B)\varepsilon_t\\

}]
</div>



where
<div  align="center">
[tex:\displaystyle{


\phi_{\alpha}(B) = 1 - \sum_{i=1}^{p}\alpha_iB^i\\


\phi_{\beta}(B) = 1 + \sum_{i=1}^{q}\beta_iB^i\\

}]
</div>

ARMAモデルは[tex:\displaystyle{\phi\_{\alpha}(B)X\_t = \phi\_{\beta}(B)\varepsilon\_t}]のように大変スッキリした形で記述できることがわかります。ARモデルとMAモデルの表現も統一感があります。



### 5. 差分作用素

差分作用素は後退オペレータでも記述できます

１階差の場合
<div  align="center">
[tex:\displaystyle{


\begin{align}
\nabla X_t &= X_t - X_{t-1}\\
&= (1 - B)X_t
\end{align}

}]
</div>

2階差の場合


<div  align="center">
[tex:\displaystyle{


\begin{align}
\nabla^2 X_t &=(X_t - X_{t-1}) - (X_{t-1} - X_{t-2}) \\
&= (1 - B)X_t - (1 - B)X_{t-1}\\
&= (1 - B)(X_t - X_{t-1})\\
&= (1 - B)^2X_t\\

\end{align}

}]
</div>

一般に
<div  align="center">
[tex:\displaystyle{


\nabla^iX_t = (1 - B)^iX_t

}]
</div>



## 後退オペレータは何なのか

ところで後退オペレータの実態は何なのでしょうか。ある関数[tex:\displaystyle{f(t)}]に乗ずることで、[tex:\displaystyle{t}]をシフトさせるような作用素といえば、複素数が思い浮かびます。厳密ではないですが、後退オペレータは複素数そのものと考えて問題なさそうな気がします。

たとえば関数 [tex:\displaystyle{ x(t)}]があるとして、フーリエ級数に展開できるとすると
<div  align="center">
[tex:\displaystyle{


x(t) ＝ \sum_{k=\infty}^{\infty}c_k\mathrm{e}^{jkt}

}]
</div>

等間隔[tex:\displaystyle{d}]でサンプリングされたすると
<div  align="center">
[tex:\displaystyle{


X(n) = \sum_{k=\infty}^{\infty}c_n\mathrm{e}^{jkdn}

}]
</div>

これを[tex:\displaystyle{X(n-1)}]にしたい場合、[tex:\displaystyle{\mathrm{e}^ {-jdn}}] を乗じてあげれば、なんかよさそうです。
<div  align="center">
[tex:\displaystyle{


\begin{align}
\mathrm{e}^{-jdn}X(n) &= \mathrm{e}^{-jdn}\sum_{k=\infty}^{\infty}c_n\mathrm{e}^{jkdn}\\
&= \sum_{k=\infty}^{\infty}c_n\mathrm{e}^{j(k-1)dn}\\
&= X(n - 1)

\end{align}

}]
</div>

なので、この場合[tex:\displaystyle{B = \mathrm{e}^ {-jdn}}]で問題ないかなと思うのですが、どなたかご存知でしたら教えて下さい。



## 参考

* [Lag operator | WIKIPEDIA](https://en.wikipedia.org/wiki/Lag_operator)
* 経済・データの計量時系列分析 (統計ライブラリー)  – 沖本 竜義 
* [Practical Time Series Analysis | Coursera](https://www.coursera.org/learn/practical-time-series-analysis)
* [Appendix B COMPLEX VARIABLES, THE SPECTRUM, AND LAG OPERATOR](https://pdfs.semanticscholar.org/f218/61550731a409b8e22676cc2c6b9b03997a3d.pdf)
* 時系列解析入門  –  北川 源四郎 

