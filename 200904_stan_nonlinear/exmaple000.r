# Simulate exponential data / gamma distribution with stan

# library(ggplot2)
library(rstan)

options(mc.cores = parallel::detectCores())
rstan_options(auto_write = TRUE)

b0 <- 1.3
b1 <- 0.5

x <- seq(0, 10, by=0.2)
mu <- b0 + b1 * x

scale <- 1
# mu = shape / rate
rate <- 1
shape <- mu

y <- sapply(shape, function(x){rgamma(n = 1, shape = x, rate = rate)})

plot(x, y, xlim=c(0, 10), ylim=c(0, 20), ylab='', xlab='')
par(new = T)
plot(x, mu, xlim=c(0, 10), ylim=c(0, 20), type='l')

N <- length(x)
data <- list(N = N, x = x, y = y)

fit <- stan(file='200904_stan_nonlinear/example00.stan',
              data=data, seed=1234, iter=2000)

summary(fit)$summary

stan_plot(fit, par=c('b0', 'b1'), show_density=T)


