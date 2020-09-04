data {
  int<lower=0> N;  // Number of observations
  int<lower=1> M;  // Number of dimensions
  int<lower=1> K;  // Number of groups
  int<lower=0> y[N];  // Target variables
  int<lower=0> group[N]; // group index for each row
  matrix[N, M] X;  // Data(feature) matrix
}

parameters {
  real<lower=0> mu[M];
  real<lower=0> sigma[M];
  vector<lower=0>[M] b[K];  // coefficients
}

model {
  mu ~ normal(0, 10);
  for (k in 1:K)
    b[k] ~ normal(mu, sigma);

  for (n in 1:N) {
    y[n] ~ poisson(X[n] * b[group[n]]);
  }
}


