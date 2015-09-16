functions {
  {{> dlm}}
}
data {
  int<lower = 1> n;
  vector[n] y;
  real m0;
  real<lower = 0.0> C0;
  real<lower = 0.0> s;
  real<lower = 0.0> nu;
}
transformed data {
  real one_over_n;
  one_over_n <- 1.0 / n;
}
parameters {
  real<lower = 0.0> sigma;
  real<lower = 0.0> tau;
  real<lower = 0.0> lambda2;
}
transformed parameters {
  vector[1] log_lik[n];
  vector[n] W;
  vector[6] dlm;
  
  for (i in 1:n) {
    W[i] <- pow(sigma, 2) * pow(tau, 2) * lambda2;
  }
  {
    vector[n] V;
    V <- rep_vector(pow(sigma, 2), n);
    dlm <- dlm_local_level_filter(n, V, W, m0, c0);
  }
  loglik <- dlm_loglik_filter(n, 1, 1, dlm);
}
model {
  real ll;
  
  sigma ~ cauchy(0.0, s);
  // check what the DE mixting distribution is. need to check precision / variance and scale / rate representations.
  lambda2 ~ exponential(2);
  tau ~ cauchy(0.0, 1.0);
  for (i in 1:n) {
    ll[i] <- log_lik[i, 1];
  }
  increment_log_prob(sum(ll));
}
generated quantities {
  // theta
  // epsilon
  // kalman gain
  
}
