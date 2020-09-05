Stanでガンマ回帰（動かす編）

目的変数が正の連続値をとる場合、ガンマ回帰は選択肢の一つになります。個人的に適用シーンは多いと思うのですが比較的情報が少ない気がしたので、本投稿ではトイデータとStanでサクッと動かしてみたいと思います。なお、ガンマ回帰はGLM（一般化線形モデル）の枠組みの一部なのでRの`glm()`でも簡単にfitできます。シンプルにモデリングしたいだけであれば、あえてStanでやる意味はないかもしれません

# 設定

今回の設定として、目的変数$y_i$の期待値$\mu_i$が、説明変数$x_i$のべき乗の線形和 $b_{0} + b_{1}x_{i}^{a}$ で表現できるとします。
$$
E[y_i] = \mu_{i} = b_{0} + b_{1}x_{i}^{a}
$$
推定するパラメタは$b_0, b_1, a$です。あえて$a$を入れたのは、Stanなら冪乗の対数をとるなどの工夫せずに直接推定できそうだと思ったからです。またGLMでいうリンク関数は`identity`（恒等リンク関数）です。そのため$\mu_i \leq 0$とならないように説明変数の範囲を注意しないといけません。

期待値$\mu_i$でガンマ分布に従う$y_i$を考えたいのですが、ガンマ分布は`shape`パラメタ:$\alpha$と`rate`パラメタ:$\beta$によって次のように決まります。（$y, \alpha, \beta$は正の実数）
$$
\operatorname{Gamma}(y|\alpha, \beta) = \frac{\beta^{\alpha}}{\Gamma(\alpha)}y^{\alpha-1}\operatorname{exp}^{-\beta y}
$$
ここで期待値$\mu$と分散$\phi$は、$\alpha, \beta$で次のように表現できます。正規分布と違って$\mu$と$\phi$は互いに強く依存しています。
$$
\begin{align}
\mu &= \frac{\alpha}{\beta} \tag{1} \\

\phi &= \frac{\alpha}{\beta^2} \tag{2}
\end{align}
$$
分布を決めるためには$\alpha$と$\beta$を決める必要があるため、$(1)(2)$より$\alpha$と$ \beta$を $\mu$と$\phi$で表します。
$$
\begin{align}
\alpha &= \frac{\mu^2}{\phi} \\
\beta &= \frac{\mu}{\phi} \\
\end{align}
$$
$\phi$は定数と仮定するのが一般的なようです（GLMの枠組み）。モデリングでは、以上の関係性をStanには直接表現すれば推定できそうです。まずはトイデータを生成しましょう。

## データ生成

Rを使って学習データを生成します。$a = 0.3, b_0 = 1.0, b_1 = 1.5, \phi = 0.1$としています。

```r
set.seed(1234)

N <- 150

# 推定したいパラメタ
a <- 0.3
b0 <- 1.0
b1 <- 1.5
phi <- 0.1

# 一様分布からxを生成
x <- runif(n=N, 0.1, 20)

# 期待値と線形予測子
mu <- b0 + b1 * x ^ a

# パラメタの変換
shape <- mu ^ 2 / phi
rate <- mu / phi

# ガンマ分布に従う乱数生成
y <- rgamma(n = length(x), shape = shape, rate = rate)

```

生成したデータをプロットします。$x$と$y$の散布図です。

```r
library(tidyverse)

# x vs. y の散布図プロット
g <-list(x = x, y = y, mu = mu) %>% data.frame() %>% ggplot()
g <- g + geom_point(aes(x=x, y=y))
g <- g + geom_line(aes(x=x, y=mu, color='mu'))
g <- g + ggtitle('Toy data $mu = 0.2 + 1.5 * x ^ 0.3'))
g
```

![toy_data_exp](/Users/daisuke/prj/900_analysis/articles/200904_stan_nonlinear/toy_data_exp.png)

## Stanファイル

データ生成過程をそのままStanファイルに記載するだけです。これを`example01.stan`とします。

```stan
data {
  int N;  // 観測数
  vector[N] x;  // 説明変数x
  vector[N] y; // 目的変数y
}

parameters {
	// 推定したいパラメタ
  real<lower=0> a;
  real<lower=0> b0;
  real<lower=0> b1;
  real<lower=0> phi;  // variance of gamma
}

transformed parameters {
  vector<lower=0>[N] alpha;  // ガンマ分布のshapeパラメタ
  vector<lower=0>[N] beta;  // ガンマ分布のratioパラメタ
  vector<lower=0>[N] mu;  // 期待値

  for (n in 1:N) {
    mu[n] = b0 + b1 * pow(x[n], a);
  }

  for (n in 1:N) {
    alpha[n] = pow(mu[n], 2.) / phi;
  }
  
  beta = mu / phi;
}

model {
  y ~ gamma(alpha, beta); // likelihood
}

generated quantities {
  vector<lower=0>[N] y_new;
  for (n in 1:N) {
    y_new[n] = gamma_rng(alpha[n], beta[n]);
  }
}

```



## MCMC実行

`rstan`を使って事後分布からのランダムサンプリングを実行します。

```r
library(rstan)

options(mc.cores = parallel::detectCores())
rstan_options(auto_write = TRUE)

data <- list(N = N, x = x, y = y)
fit <- stan(file='example01.stan', data=data, seed=1234, iter=2000)
```

`divergent transitions`の警告が出ますが、数が少ないのでここでは無視します。

> Warning message:
> “There were 2 divergent transitions after warmup. Increasing adapt_delta above 0.8 may help. See
> http://mc-stan.org/misc/warnings.html#divergent-transitions-after-warmup”
> Warning message:
> “Examine the pairs() plot to diagnose sampling problems

収束も問題なさそうです。

![trace01](/Users/daisuke/prj/900_analysis/articles/200904_stan_nonlinear/trace01.png)

## パラメタ推定結果

どのパラメタも真の値$a = 0.3, b_0 = 1.0, b_1 = 1.5, \phi = 0.1$ を分布の25-75%の間に含んでいるので、大きく外していないようです。

|      | mean      | se_mean      | sd         | 2.5%       | 25%        | 50%       | 75%       | 97.5%     | n_eff     | Rhat      |
| :--- | :-------- | :----------- | :--------- | :--------- | :--------- | :-------- | :-------- | :-------- | :-------- | :-------- |
| a    | 0.2643425 | 0.0018063278 | 0.04469031 | 0.20230515 | 0.22890738 | 0.2563850 | 0.2925427 | 0.3675151 | 612.1158  | 1.0053146 |
| b0   | 0.6953202 | 0.0173214550 | 0.43094516 | 0.02972518 | 0.33524315 | 0.6733556 | 1.0266480 | 1.5374601 | 618.9781  | 1.0035314 |
| b1   | 1.8591395 | 0.0164183020 | 0.40759706 | 1.06712580 | 1.54369900 | 1.8705854 | 2.1966878 | 2.5121268 | 616.3191  | 1.0038491 |
| phi  | 0.1051311 | 0.0003396671 | 0.01246250 | 0.08323707 | 0.09635969 | 0.1042309 | 0.1122532 | 0.1334601 | 1346.1805 | 0.9992741 |



![stan_plot01](/Users/daisuke/prj/900_analysis/articles/200904_stan_nonlinear/stan_plot01.png)



## 推定したパラメタからのサンプリング

推定したパラメタからのサンプリングを行って、生成したデータから乖離していないか確認します。

```r
# 推定パラメタからのサンプリングを抽出
is.pred <- str_detect(rownames(result.summay), 'y_new.')
data <- data.frame(result.summay[is.pred,])

colnames(data) <-
  c('mean', 'se_mean', 'sd', 'p2.5', 'p25', 'p50',
      'p75', 'p97.5', 'n_eff', 'Rhat')
data$x <- x
data$y <- y
data$mu <- mu

# 図示
g <- ggplot(data=data)
g <- g + geom_line(aes(x=x, y=mean, color='post_mean')) +
      geom_line(aes(x=x, y=mu, color='mu')) +
      geom_point(aes(x=x, y=y))

g <- g + geom_ribbon(aes(x=x, ymin=p25,ymax=p75), fill="blue", alpha=0.2) +
      geom_ribbon(aes(x=x, ymin=p2.5,ymax=p97.5), fill="blue", alpha=0.2)
g <- g + ggtitle('True and Predicted') + labs(y='y')
g
```



大きな乖離はなさそうです。

![pred_exp](/Users/daisuke/prj/900_analysis/articles/200904_stan_nonlinear/pred_exp.png)

# まとめ

Stanを使ってガンマ回帰を早足で行いました。正規分布を過程した線形回帰での推定は、目的変数の分布の対称性が仮定されていることや負の値がどうしても出てきてしまうため、ガンマ回帰の方が自然なことがあります。不確実性やモデルを柔軟に構築したい場合はStanを使うのも手かもしれません。

---

統計モデリングでは確率分布の知識が要求されますね。理解が足りません。日々精進