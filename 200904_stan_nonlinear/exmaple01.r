# Simulate exponential data / gamma distribution with stan

library(rstan)
library(tidyverse)

options(mc.cores = parallel::detectCores())
rstan_options(auto_write = TRUE)


# -----------------------------------------------------------
# Build toy data
# -----------------------------------------------------------
# a <- 1.7
# b0 <- 0.3
# b1 <- 1.5
# phi <- 10.

set.seed(1234)

a <- 0.3
b0 <- 1.0
b1 <- 1.5
phi <- 0.1


# pop.set <- seq(0, 10, by=0.05)
# x <- sample(pop.set, N)
N <- 150
x <- runif(n=N, 0.1, 20)

mu <- b0 + b1 * x ^ a

shape <- mu ^ 2 / phi
rate <- mu / phi

y <- rgamma(n = length(x), shape = shape, rate = rate)

# Plot toy data
g <-list(x = x, y = y, mu = mu) %>% data.frame() %>% ggplot()
g <- g + geom_point(aes(x=x, y=y))
g <- g + geom_line(aes(x=x, y=mu, color='mu'))
g <- g + ggtitle('Toy data: mu = 0.2 + 1.5 * x ^ 0.3')
g
ggsave('toy_data_exp.png', plot=g)


# -----------------------------------------------------------
# Fit stan
# -----------------------------------------------------------

# Fit
data <- list(N = N, x = x, y = y)
fit <- stan(file='example01.stan',
              data=data, seed=1234, iter=2000)


# Diagnose sampling result
par <- c('a', 'b0', 'b1', 'phi')
result.summay <- summary(fit)$summary
result.summay[par, ]

stan_rhat(fit)

png("trace01.png", width = 1200, height = 1200, res = 150)
stan_trace(fit, par=par)
dev.off()

png("stan_plot01.png", width = 1200, height = 1200, res = 150)
stan_plot(fit, par=par, show_density=T)
dev.off()


# Predicted
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
g
ggsave('pred_exp01.png')
