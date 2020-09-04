# Simulate exponential data / gamma distribution with stan

# library(ggplot2)
library(rstan)
library(tidyverse)

options(mc.cores = parallel::detectCores())
rstan_options(auto_write = TRUE)

set.seed(1234)

a <- 1.7
b0 <- 0.3
b1 <- 1.5
b2 <- 0.8
phi <- 10.


a <- 0.3
b0 <- 0.3
b1 <- 1.5
b2 <- 1.0
phi <- 0.5


pop.set <- seq(0, 10, by=0.05)
N <- length(pop.set)
x1 <- sample(pop.set, N)
x2 <- sample(c(0, 1), N, replace=T)

mu <- b0 + b1 * x1 ^ a + b2 * x2

shape <- mu ^ 2 / phi
rate <- mu / phi

# y <- sapply(shape, function(x){rgamma(n = 1, shape = x, rate = rate)})
y <- rgamma(n = N, shape = shape, rate = rate)

g <-list(x1 = x1, x2 = x2, y = y, mu = mu) %>% data.frame() %>% ggplot()
g <- g + geom_point(aes(x=x1, y=y, color=factor(x2)))
g <- g + geom_line(aes(x=x1, y=mu, color=factor(x2)), linetype = 'dashed')
g <- g + ggtitle('Toy data')
g
ggsave('toy_data_exp2.png', plot=g)


data <- list(N = N, x1 = x1, x2 = x2, y = y)
fit <- stan(file='example02.stan',
              data=data, seed=1234, iter=2000)

# -----------------------------------------------------------

par <- c('a', 'b0', 'b1', 'b2', 'phi')

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
data$x1 <- x1
data$x2 <- x2
data$y <- y
data$mu <- mu


g <- ggplot(data=data, aes(group=factor(x2), color=factor(x2), fill=factor(x2)))
g <- g + geom_line(aes(x=x1, y=mean)) +
      geom_line(aes(x=x1, y=mu), linetype = 'dashed') +
      geom_point(aes(x=x1, y=y))
# g <- g + geom_ribbon(aes(x=x1, ymin=p25,ymax=p75), alpha=0.2) +
#       geom_ribbon(aes(x=x1, ymin=p2.5,ymax=p97.5), alpha=0.2)
g <- g + ggtitle('True and Predicted') + labs(y='y')
g
ggsave('pred_exp2.png')

