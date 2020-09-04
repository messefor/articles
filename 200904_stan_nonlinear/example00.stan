data {
  int N;
  vector[N] x;
  vector[N] y;
}

transformed data {
  real<lower=0> beta = 1;  // inverse scale parameter of gamma
}

parameters {
  real<lower=0> b0;
  real<lower=0> b1;
}

transformed parameters {
  vector<lower=0>[N] alpha;  // shape parameter of gamma
  vector<lower=0>[N] mu;  // mean of gamma

  mu = b0 + b1 * x;
  // mu = alpha / beta
  alpha = mu * beta;

}

model {
  y ~ gamma(alpha, beta);
}

