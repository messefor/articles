data {
  int<lower=0> N;  // Number of observations
  int<lower=1> M;  // Number of dimensions
  int<lower=0, upper=1> y[N];  // Target variables
  matrix[N, M] X;  // Data(feature) matrix
}

parameters {
  vector[M] b;  // coefficients
}

// transformed parameters {
//   vector<lower=0, upper=1>[N] p; // probs
//   p = inv_logit(X * b);
// }

model {
  // b ~ normal(0, 10);
  // y ~ bernoulli(p);
  // y ~ bernoulli(inv_logit(X * b));
  y ~ bernoulli_logit(X * b);
}


