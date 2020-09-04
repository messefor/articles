# -----------------------------------------------
#
#
# Nを100以上にすると収束するが、70程度だと発散する
# 説明変数のデータの分布（レンジが狭い）
# 事前分布の設定で大きく変わらない
# -----------------------------------------------

suppressMessages(library(tidyverse))
suppressMessages(library(rstan))
library(MASS)

rstan_options(auto_write = TRUE)
options(mc.cores = parallel::detectCores())

logistic <- function(x) { 1 / (1 + exp(-x))}

seed <- 1234
set.seed(seed)

# N <- 100
K <- 15
N_K <- sample(50:70, K, replace=T)
N <- sum(N_K)

mu1 <- 1.0
sd1 <- 3.8

mu2 <- 0
sd2 <- 2.5

gs <- c()
for (k in 1:length(N_K)) {
  n <- N_K[k]
  gs <- c(gs, rep(k, n))
}

X <- NULL
for (Np in N_K) {
  x0 <- rep(1., Np)
  x1 <- rnorm(mean = mu1, sd = sd1, n = Np)
  x2 <- rnorm(mean = mu2, sd = sd2, n = Np)
  x3 <- rbinom(size = 1, prob = 0.5, n = Np)
  if (is.null(X)) {
    X <- cbind(x0, x1, x2, x3)
  } else {
    X <- rbind(X, cbind(x0, x1, x2, x3))
  }
}
M <- ncol(X)

mu_beta <- c(-1.2, 0.8, 2.0, -1.7)
mu_sigma <- c(2, 1.5, 2.5, 1)
B <- mvrnorm(K, mu_beta, diag(mu_sigma ^ 2))
B

p <- c()
for (k in 1:length(N_K)) {
  isin.g <- gs == k
  z_ <- X[isin.g,] %*% B[k,]
  p_ <- logistic(as.vector(z_))
  p <- c(p, p_)
}
y <- sapply(p, function(p){rbinom(size=1, p=p, n=1)})


p.nmd <- matrix(p, ncol = 1)
y.nmd <- matrix(y, ncol = 1)
colnames(p.nmd) <- 'p'
colnames(y.nmd) <- 'y'


pairs(cbind(y.nmd, p, X))


data <- list(N = N, M = M, K = K, y = y, group = gs, X = X)
stan.file <- '200831_stan_hier/example01_fit.stan'

fit <- stan(data = data, file = stan.file, seed = seed, iter = 2000)

# fit <- stan(data = data, file = stan.file, seed = seed, iter = 10000,
#           control = list(adapt_delta = 0.99))
# it <- stan(data = data, file = stan.file, seed = seed, iter = 2000)
# fit <- stan(data = data, file = stan.file, seed = seed, iter = 4000,
#            control = list(adapt_delta = 0.99))

pairs(fit, par=c('b'))

sum(get_elapsed_time(fit)) / 60
summary(fit)$summary

stan_trace(fit, par=c('b', 'sigma', 'mu'))

stan_plot(fit, show_density=T, par=c('b', 'sigma', 'mu'))


stan_plot(fit, show_density=T, par=c('b'))

# ----------------------------------------------------------------------


















# ----------------------------------------------------------------------
