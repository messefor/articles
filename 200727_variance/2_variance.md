## 定義



### 分散の定義

分散は変数の平均（重心）からの距離の期待値で定義される。散らばり具合を表すような統計量。
 変数$X$ の分散は


```math
\begin{align}
\operatorname{Var}_{X}[X] &=E_{X}\left[X-E_{X}[X]^{2}\right]\\
&=E_{X} \left[ \left(X-\mu_{X}\right)^{2}\right] \\
&=\int_{\mathbb{R}}\left(X-\mu_{x}\right)^{2} p(x)dx
\end{align}
```
$E_{X}[\cdot]$は$X$に関して期待値をとる操作。以降何に関して期待値を取るかが明確な場合、省略して$E[\cdot]$とかく

###  共分散の定義

中心化された2変数の積の期待値で定義される。共分散は2変数の類似度を表すような統計量。
変数 $X, Y$の共分散は
```math
\begin{align}
\operatorname{Cov}(X, Y) &=E_{XY}[(X-E_{X}[X])(Y-E_{Y}[Y])] \\
&=E_{XY}\left[\left(X-\mu_{X}\right)\left(Y-\mu_{Y}\right)\right] \\
&=\iint_{\mathbb{R}}\left(x-\mu_{x}\right)\left(y-\mu_{y}\right) p(x, y) d x d y
\end{align}
```
なおこれを$X$と$Y$の標準偏差で正規化すると相関係数になる。分散は共分散の$X=Y$のケースといえる



## よく使う性質

### 1. 定数倍

変数$X$を定数した変数$kX$の分散は、$X$の分散の$k^2$倍になる。つまり$k$を定数とすると次が成り立つ
```math
\operatorname{Var}[kX]  =k^2\operatorname{Var}[X]
```


### 2. 分散公式

分散は**二乗の期待値ひく期待値の二乗** で計算できる。分散公式と呼ばれているらしい
```math
\operatorname{Var}[X]  =E\left[X^{2}\right]-E[X]^{2}
```
次の展開を行えば導ける
```math
\begin{align}
\operatorname{Var}[X] &=E \left[X-E[X]^{2}\right] \\
&=E \left[ \left(X-\mu_{X}\right)^{2}\right] \\
&=E\left[X^{2}-2 X \mu_{X}+\mu_{X}^{2}\right] \\
&=E\left[X^{2}\right]-2 \mu E[X]+\mu_{X}^{2} \\
&=E\left[X^{2}\right]-E[X]^{2}
\end{align}
```


### 2. 独立な2変数の共分散は0

変数$X$ と$Y$が独立なとき、$\operatorname{Cov}(X, Y) = 0$ となる


```math
\begin{aligned}
\operatorname{Cov}(X, Y) &=E_{XY}[(X-E_{X}[X])(Y-E_{Y}[Y])] \\
&=E_{XY}\left[\left(X-\mu_{X}\right)\left(Y-\mu_{Y}\right)\right] \\
&=E_{XY}\left[\left(XY - X\mu_{Y} - Y\mu_{X} + \mu_{X}\mu_{Y}\right)\right] \\
&=E_{XY}\left[XY\right] - E_{X}\left[X\right]\mu_{Y} - E_{Y}\left[Y\right]\mu_{X} + \mu_{X}\mu_{Y} \\
&=E_{XY}\left[XY\right] - \mu_{X}\mu_{Y} \\
&=E_{XY}\left[XY\right] - E_{X}\left[X\right]E_{Y}\left[Y\right]
\end{aligned}
```


ここで、$X, Y$が互いに独立のとき$p(x, y) = p(x)p(y)$が成立するため
```math
\begin{aligned}
E_{XY}\left[XY\right] &= \iint{xyp(x, y)}dxdy \\
&=\iint{xyp(x)p(y)}dxdy \\
&=\int{y\left[\int{xp(x)}dx\right]p(y)}dy \\
&=\mu_{X}\int{yp(y)}dy \\
&=\mu_{X}\mu_{Y} \\

\end{aligned}
```
 $E_{XY}[XY] = E_{X}[X]E_{Y}[Y]$ となり、$\operatorname{Cov}(X, Y) = 0$



### 3.分散の和

和の変数$X+Y$の分散は、分散の和$Var[X] + Var[Y]$ から共分散の2倍を引いたものになる
```math
\begin{align}
\operatorname{Var}_{XY}[X+Y] &=E_{XY}\left[(X+Y)^{2}\right]-E_{XY}[X+Y]^{2} \\
&=E_{XY}\left[X^{2}+2 XY+Y^{2}\right]-(E_{X}[X]+E_{Y}[Y])^{2} \\
&=E_{X}\left[X^{2}\right]+2 E_{XY}[X Y]+E_{Y}\left[Y^{2}\right]-E_{X}[X]^{2}-2E_{X}[X] E_{Y}[Y] \\
&=(E_{X}\left[X^{2}\right]-E_{X}[X]^{2})+(E_{Y}\left[Y^{2}\right]-E_{Y}[Y]^{2}) -2(E_{XY}[XY]-E_{X}[X]E_{Y}[Y])\\
&=\operatorname{Var}[X]+\operatorname{Var}[Y]-2 \operatorname{Cov}(X, Y)
\end{align}
```math


ここで$X, Y$が互いに独立のとき$\operatorname{Cov}(X, Y) = 0$となるため


```math
\operatorname{Var}[X+Y] = \operatorname{Var}[X] + \operatorname{Var}[Y]
```math
が成り立つ

分散の和の式展開では、1行目の分散公式を、その他は期待値の線形性を使って展開している。また$E_{XY}[X] = E_{X}[X]$も利用