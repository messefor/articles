# 時系列分析：ホワイトノイズとiid

ホワイトノイズとiid（independent and identically distributed:独立同分布）を混同してしまう事があります。本投稿ではこの2つを整理します。普段の分析ではホワイトノイズとiidをそこまで厳密に区別するケースは少ないと思います。理論を追っていて、前提条件として同一分布を意識するときぐらいでしょうか



## ホワイトノイズとiidの違い（まとめ）

共通点：

ホワイトノイズとiidはどちらも確率変数の列がそれぞれ互いに独立です。なので自己共分散は0となります。

違い：

* ホワイトノイズはノイズの性質なので平均が0。一方で、**iidは独立同分布といっているだけなので、平均値は必ずしも0とは限らない**
* **ホワイトノイズは独立でさえあればいい**けど、一方で**iidの系列は独立かつ同分布の必要がある**

|                | よく使う表記                                         | 平均  | 自己共分散                                                   | 独立     | 同分布       | 定常性     |
| -------------- | ---------------------------------------------------- | ----- | ------------------------------------------------------------ | -------- | ------------ | ---------- |
| ホワイトノイズ | [tex:\displaystyle{\varepsilon\_t \sim \operatorname{W.N.}(\sigma)$     | 0     | $\left\\{\begin{array}{ll}\sigma^ 2,& k = 0 \\0, & k\ne 0\end{array}\right.}] | 必要あり | **必要なし** | **弱定常** |
| iid            | [tex:\displaystyle{\varepsilon\_t \sim \operatorname{iid}(\mu, \sigma)$ | $\mu$ | $\left\\{\begin{array}{ll}\sigma^ 2,& k = 0 \\0, & k\ne 0\end{array}\right.}] | 必要あり | **必要あり** | **強定常** |

iidのように同一分布に従うことは強い仮定なので、それに比べて同一分布を仮定しないホワイトノイズは仮定が弱いです。また定常性という視点では、ホワイトノイズは弱定常、iidは強定常になります。



## ホワイトノイズの定義

沖本本の定義をそのまま引用するとホワイトノイズの定義は以下のようになっています。ホワイトノイズは平均値0、分散[tex:\displaystyle{\sigma^ 2}]、自己相関（共分散）が0です。

> すべての時点[tex:\displaystyle{t}] において
> <div  align="center">
[tex:\displaystyle{


> \begin{array}
> \\
> E(\varepsilon_t) = 0\\
> \gamma_k = E(\varepsilon_t\varepsilon_{t-k}) = \left\{
> \begin{array}{ll}
> \sigma^2,& k = 0 \\
> 0, & k\ne 0
> \end{array}
> \right.
> 
> \end{array}
> 
}]
</div>


## iidの定義

同様にiidの定義は以下です

> 各時点のデータが互いに独立でかつ同一の分布に従う系列
>
> 
>
> 引用：経済・ファイナンスデータの計量時系列分析 - 沖本 竜義 p11



分布が同じで独立な系列であることを要求しているだけなので、そもそもガウシアンのように期待値[tex:\displaystyle{\mu}]と分散[tex:\displaystyle{\sigma^ 2}]のみで決定される分布かどうかも分かりません。



## 一般的な使い分け

我々がシミュレーションなどで誤差項を生成する場合、平均値0の正規分布に従うノイズを発生させることが多いと思います。これらのノイズは独立なのでホワイトノイズですが、同一の分布に従うためiidでもあります。いわゆるガウシアンホワイトノイズと言われるもので、iidになります。



## 各モデル誤差項の設定

沖本本やWikipediaを参考に各モデルの誤差項の仮定を確認してみたいと思います。結論から言うと、MAモデル、ARモデル、ARMAモデルともに撹乱項はホワイトノイズで、iidを仮定していません。ランダムウォークだけなぜかiidを仮定しているみたいです。



|                  | 撹乱項の仮定   |
| ---------------- | -------------- |
| MAモデル         | ホワイトノイズ |
| ARモデル         | ホワイトノイズ |
| ARMAモデル       | ホワイトノイズ |
| ランダムウォーク | iid            |



### MAモデル

沖本本のMA(q)過程の定義では、MA(q)過程はホワイトノイズの線形和になっています。**iidを仮定していません**

> <div  align="center">
[tex:\displaystyle{


> y_t = \mu + \varepsilon_t + \theta_1\varepsilon_{t-1} + \theta_2\varepsilon_{t-2}+ \dots + \theta_q\varepsilon_{t-q}, \hspace{5mm}  \varepsilon_t \sim \operatorname{W.N.}(\sigma^2)
> 
}]
</div>

>
> 
>
> 引用：経済・ファイナンスデータの計量時系列分析 - 沖本 竜義 p24

Wikipediaでも同様に[tex:\displaystyle{\varepsilon\_t}]を`white noise error terms`と記載しています。

### ARモデル

ARモデルの撹乱項[tex:\displaystyle{\varepsilon\_t}]もホワイトノイズです。**iidを仮定していません**

> <div  align="center">
[tex:\displaystyle{


> y_t = c + \phi_1y_{t-1} + \phi_2y_{t-2}+ \dots + \phi_qy_{t-q} + \varepsilon_t, \hspace{5mm}  \varepsilon_t \sim \operatorname{W.N.}(\sigma^2)
> 
}]
</div>

>
> 
>
> 引用：経済・ファイナンスデータの計量時系列分析 - 沖本 竜義 p26

Wikipediaでも同様に[tex:\displaystyle{\varepsilon\_t}]を` white noise`と記載しています。

### ARMAモデル

ARMAモデルの撹乱項[tex:\displaystyle{\varepsilon\_t}]もホワイトノイズです。**iidを仮定していません**



><div  align="center">
[tex:\displaystyle{


>y_t = c + \phi_1y_{t-1} + \phi_2y_{t-2}+ \dots + \phi_qy_{t-q}  + \dots + \varepsilon_t + \theta_1\varepsilon_{t-1} + \theta_2\varepsilon_{t-2}+ \dots + \theta_q\varepsilon_{t-q}, \hspace{5mm}  \varepsilon_t \sim \operatorname{W.N.}(\sigma^2)
>
}]
</div>

>
>引用：経済・ファイナンスデータの計量時系列分析 - 沖本 竜義 p34



### ランダムウォーク

ランダムウォークでは撹乱項[tex:\displaystyle{\varepsilon\_t}]に**iidを仮定しています。**

> <div  align="center">
[tex:\displaystyle{


> y_t = \delta + y_{t-1} + \varepsilon_{t}, \hspace{5mm}  \varepsilon_t \sim \operatorname{iid}(0, \sigma^2)
> 
}]
</div>

>
> 引用：経済・ファイナンスデータの計量時系列分析 - 沖本 竜義 p106

ランダムウォークをAR(1)過程と考えるならホワイトノイズでも良さそうなものですが、このiidの仮定が重要なのでしょうか。Wikipediaでも`独立かつ同分布な Rd 値確率変数族`と書いてあります。



なぜランダムウォークだけiidを仮定しているのか分かってません。どなたかご存知でしたら教えて下さい。日々精進

# 参考文献

* 経済・ファイナンスデータの計量時系列分析 - 沖本 竜義
* [https://ja.wikipedia.org/wiki/%E3%83%A9%E3%83%B3%E3%83%80%E3%83%A0%E3%82%A6%E3%82%A9%E3%83%BC%E3%82%AF](https://ja.wikipedia.org/wiki/ランダムウォーク)
* [https://en.wikipedia.org/wiki/Autoregressive%E2%80%93moving-average_model#:~:text=In%20the%20statistical%20analysis%20of,the%20moving%20average%20(MA).](https://en.wikipedia.org/wiki/Autoregressive–moving-average_model#:~:text=In the statistical analysis of,the moving average (MA).)
* [https://ja.wikipedia.org/wiki/%E3%83%9B%E3%83%AF%E3%82%A4%E3%83%88%E3%83%8E%E3%82%A4%E3%82%BA](https://ja.wikipedia.org/wiki/ホワイトノイズ)
* [https://ja.wikipedia.org/wiki/%E8%87%AA%E5%B7%B1%E5%9B%9E%E5%B8%B0%E7%A7%BB%E5%8B%95%E5%B9%B3%E5%9D%87%E3%83%A2%E3%83%87%E3%83%AB#%E8%AA%A4%E5%B7%AE%E9%A0%85](https://ja.wikipedia.org/wiki/自己回帰移動平均モデル#誤差項)
* [https://ja.wikipedia.org/wiki/%E7%8B%AC%E7%AB%8B%E5%90%8C%E5%88%86%E5%B8%83#:~:text=%E7%8B%AC%E7%AB%8B%E5%90%8C%E5%88%86%E5%B8%83%EF%BC%88%E3%81%A9%E3%81%8F%E3%82%8A,%E5%88%86%E5%B8%83%E3%82%92%E6%8C%81%E3%81%A1%E3%80%81%E3%81%8B%E3%81%A4%E3%80%81%E3%81%9D%E3%82%8C%E3%81%9E%E3%82%8C](https://ja.wikipedia.org/wiki/独立同分布#:~:text=独立同分布（どくり,分布を持ち、かつ、それぞれ)