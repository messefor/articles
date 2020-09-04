# Simulate exponential data / gamma distribution with stan

# library(ggplot2)
library(rstan)
library(tidyverse)

options(mc.cores = parallel::detectCores())
rstan_options(auto_write = TRUE)

b0 <- 1.3
b1 <- 0.5

pop.set <- seq(0, 10, by=0.05)
N <- 100
x <- sample(pop.set, N)

mu <- b0 + b1 * x

phi <- 2.3
shape <- mu ^ 2 / phi
rate <- mu / phi

# y <- sapply(shape, function(x){rgamma(n = 1, shape = x, rate = rate)})
y <- rgamma(n = length(x), shape = shape, rate = rate)

g <-list(x = x, y = y, mu = mu) %>% data.frame() %>% ggplot()
g <- g + geom_point(aes(x=x, y=y))
g <- g + geom_line(aes(x=x, y=mu, color='mu'))
g <- g + ggtitle('Toy data')
ggsave('toy_data.png', plot=g)


data <- list(N = N, x = x, y = y)
fit <- stan(file='200904_stan_nonlinear/example00.stan',
              data=data, seed=1234, iter=2000)
# -----------------------------------------------------------

par <- c('b0', 'b1', 'phi')

result.summay <- summary(fit)$summary
result.summay[par, ]

stan_rhat(fit)

stan_trace(fit)

stan_plot(fit, par=par, show_density=T)


# -----------------------------------------------------------

is.pred <- str_detect(rownames(result.summay), 'y_new.')
data <- data.frame(result.summay[is.pred,])

colnames(data) <-
  c('mean', 'se_mean', 'sd', 'p2.5', 'p25', 'p50',
      'p75', 'p97.5', 'n_eff', 'Rhat')
data$x <- x
data$y <- y
data$mu <- mu


g <- ggplot(data=data)
g <- g + geom_line(aes(x=x, y=mean, color='post_mean')) +
      geom_line(aes(x=x, y=mu, color='mu')) +
      geom_point(aes(x=x, y=y))

g <- g + geom_ribbon(aes(x=x, ymin=p25,ymax=p75), fill="blue", alpha=0.2) +
      geom_ribbon(aes(x=x, ymin=p2.5,ymax=p97.5), fill="blue", alpha=0.2)
g <- g + ggtitle('True and Predicted') + labs(y='y')
ggsave('pred.png')
