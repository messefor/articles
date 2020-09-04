data {
  int N;
  vector[N] x;
  vector[N] y;
}

parameters {
  real<lower=0> a;
  real<lower=0> phi;  // variance of gamma
  real<lower=0> b0;
  real<lower=0> b1;
}

transformed parameters {
  vector<lower=0>[N] alpha;  // shape parameter of gamma
  vector<lower=0>[N] beta;  // rate parameter of gamma
  vector<lower=0>[N] mu;  // mean of gamma


  for (n in 1:N) {
    mu[n] = b0 + b1 * pow(x[n], a);
  }

  for (n in 1:N) {
    alpha[n] = pow(mu[n], 2.) / phi;
  }
  beta = mu / phi;

}

model {
  y ~ gamma(alpha, beta); // likelihood
}

generated quantities {
  vector<lower=0>[N] y_new;
  for (n in 1:N) {
    y_new[n] = gamma_rng(alpha[n], beta[n]);
  }
}
