data {
  int<lower=0> N;  // Number of observations
  int<lower=1> M;  // Number of dimensions
  int<lower=1> K;  // Number of groups
  int<lower=0> y[N];  // Target variables
  int<lower=0> group[N]; // group index for each row
  vector[N] x1;  // Data(feature) matrix
  vector[N] x2;  // Data(feature) matrix
  vector[N] x3;  // Data(feature) matrix
}

parameters {
  real<lower=0> b0;
  vector<lower=0>[K] b1;
  vector<lower=0>[K] b2;
  real<lower=0> b3;

  real<lower=0> mu_b0;
  real<lower=0> sigma_b0;

  real<lower=0> mu_b1;
  real<lower=0> sigma_b1;

  real<lower=0> mu_b2;
  real<lower=0> sigma_b2;

  real<lower=0> mu_b3;
  real<lower=0> sigma_b3;
}

model {

  mu_b0 ~ normal(0, 10);
  mu_b1 ~ normal(0, 10);
  mu_b2 ~ normal(0, 10);
  mu_b3 ~ normal(0, 10);

  sigma_b0 ~ normal(0, 5);
  sigma_b3 ~ normal(0, 5);

  for (k in 1:K) {
    b1[k] ~ normal(mu_b1, sigma_b1);
    b2[k] ~ normal(mu_b2, sigma_b2);
  }

  b0 ~ normal(mu_b0, sigma_b0);
  b3 ~ normal(mu_b3, sigma_b3);

  for (n in 1:N) {
    y[n] ~ poisson(b0 + x1[n] * b1[group[n]] + x2[n] * b2[group[n]] + b3 * x3[n]);
  }

}


