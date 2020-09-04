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
K <- 30
N_K <- sample(50:60, K, replace=T)
N <- sum(N_K)

min1 <- 0.0
max1 <- 2.0

mu2 <- 2.
sd2 <- 0.4

gs <- c()
for (k in 1:length(N_K)) {
  n <- N_K[k]
  gs <- c(gs, rep(k, n))
}

X <- NULL
for (Np in N_K) {
  x1 <- runif(min = min1, max = max1, n = Np)
  x2 <- rnorm(mean = mu2, sd = sd2, n = Np)
  x3 <- rbinom(size = 1, prob = 0.5, n = Np)
  if (is.null(X)) {
    X <- cbind(x1, x2, x3)
  } else {
    X <- rbind(X, cbind(x1, x2, x3))
  }
}
M <- ncol(X)

b0 <- 0.3
b3 <- 1.7

mu_beta <- c(0.5, 1.2)
mu_sigma <- c(0.1, 0.3)
B <- mvrnorm(K, mu_beta, diag(mu_sigma ^ 2))
B

lamb <- c()
for (k in 1:length(N_K)) {
  isin.g <- gs == k
  lamb_ <- b0 + X[isin.g, 1:2] %*% B[k,] + b3 * X[isin.g,3]
  lamb <- c(lamb, lamb_)
}

all(lamb > 0)

y <- sapply(lamb, function(x){rpois(lambda=x, n=1)})

lamb.nmd <- matrix(lamb, ncol = 1)
y.nmd <- matrix(y, ncol = 1)
colnames(lamb.nmd) <- 'lambda'
colnames(y.nmd) <- 'y'


pairs(cbind(y.nmd, lamb.nmd, X))


data <- list(N = N, M = M, K = K, y = y, group = gs,
            x1 = X[,1], x2 = X[,2], x3 = X[,3])

stan.file <- '200831_stan_hier/example03_fit.stan'

# fit <- stan(data = data, file = stan.file, seed = seed, iter = 10000,
#           control = list(adapt_delta = 0.99))
fit <- stan(data = data, file = stan.file, seed = seed, iter = 2000)
# fit <- stan(data = data, file = stan.file, seed = seed, iter = 2000, chain=1)
# fit <- stan(data = data, file = stan.file, seed = seed, iter = 000,
#            control = list(adapt_delta = 0.99))

pairs(fit, par=c('b1', 'b2'))

sum(get_elapsed_time(fit)) / 60
summary(fit)$summary

stan_trace(fit, par=c('b0','b1', 'b2', 'b3'))

stan_plot(fit, par=c('b0', 'mu_b1',  'sigma_b1', 'b1',
                      'mu_b2', 'sigma_b2','b2', 'b3'))


# ----------------------------------------------------------------------


















# ----------------------------------------------------------------------
