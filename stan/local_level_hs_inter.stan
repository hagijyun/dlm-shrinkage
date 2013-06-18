data {
  int n;
  real a1;
  real<lower=0.0> P1;
  real y[n];
  vector[n] Q_a;
  vector<lower=0.0>[n] Q_b;
  vector[n] H_a;
  vector<lower=0.0>[n] H_b;
}
parameters {
  real<lower=0.0> sigma2;
  real<lower=0.0> tau;
  vector<lower=0.0>[n] lambda;
}
transformed parameters {
  vector<lower=0.0>[n] H;
  vector<lower=0.0>[n] Q;
  for (i in 1:n) {
    Q[i] <- Q_a[i] + Q_b[i] * pow(lambda[i], 2) * pow(tau, 2);
    H[i] <- H_a[i] + H_b[i] * sigma2;
  }
}
model {
  real loglik_obs[n];
  {
    real v;
    real K;
    real Finv;
    real a;
    real P;
    real F;
    a <- a1;
    P <- P1;
    for (i in 1:n) {
      v <- y[i] - a;
      F <- P + H[i];
      Finv <- 1 / F;
      K <- P * Finv;
      a <- a + K * v;
      P <- (1 - K ) * P;
      loglik_obs[i] <- -0.5 * (log(2 * pi())
                               + log(F) + Finv * pow(v, 2.0));
      P <- P + Q[i];
    }
  }
  lp__ <- sum(loglik_obs);
  lp__ <- lp__ - log(sigma2);
  tau ~ cauchy(0, sqrt(sigma2));
  lambda ~ cauchy(0, 1);
}
