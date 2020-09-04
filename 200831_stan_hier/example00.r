# -----------------------------------------------
#
#
# Nを100以上にすると収束するが、70程度だと発散する
# 説明変数のデータの分布（レンジが狭い）
# 事前分布の設定で大きく変わらない
# -----------------------------------------------
suppressMessages(library(tidyverse))
suppressMessages(library(rstan))

rstan_options(auto_write = TRUE)
options(mc.cores = parallel::detectCores())

logistic <- function(x) { 1 / (1 + exp(-x))}

seed <- 1234
set.seed(seed)

N <- 100

mu1 <- 1.0
sd1 <- 3.8

mu2 <- 0
sd2 <- 2.5

x0 <- rep(1., N)
x1 <- rnorm(mean = mu1, sd = sd1, n = N)
x2 <- rnorm(mean = mu2, sd = sd2, n = N)
x3 <- rbinom(size = 1, prob = 0.5, n = N)

X <- cbind(x0, x1, x2, x3)
M <- ncol(X)

beta <- c(-1.2, 0.8, 2.0, -1.7)

z <- X %*% beta

p <- logistic(z)
colnames(p) <- 'p'

y <- sapply(p, function(p){rbinom(size=1, p=p, n=1)})

y.nmd <- matrix(y, ncol=1)
colnames(y.nmd) <- 'y'

pairs(cbind(y.nmd, p, X))

data <- list(N = N, M = M, y = y, X = X)
stan.file <- '200831_stan_hier/example00_fit.stan'

fit <- stan(data=data, file=stan.file, seed=seed, iter=2000)

summary(fit)$summary

stan_trace(fit)

stan_plot(fit, show_density=T, par=c('b'))


# ----------------------------------------------------------------------


















# ----------------------------------------------------------------------
