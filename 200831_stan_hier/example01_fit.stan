data {
  int<lower=0> N;  // Number of observations
  int<lower=1> M;  // Number of dimensions
  int<lower=1> K;  // Number of groups
  int<lower=0, upper=1> y[N];  // Target variables
  int<lower=0> group[N]; // group index for each row
  matrix[N, M] X;  // Data(feature) matrix
}

parameters {
  real mu[M];
  real<lower=0> sigma[M];
  vector[M] b[K];  // coefficients
}


model {
  mu ~ normal(0, 5);
  for (k in 1:K)
    b[k] ~ normal(mu, sigma);

  for (n in 1:N) {
    y[n] ~ bernoulli_logit(X[n] * b[group[n]]);
  }
}


