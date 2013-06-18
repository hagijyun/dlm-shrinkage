data {
  int n;
  real a1;
  real<lower=0.0> P1;
  real y[n];
  int missing[n];
}
parameters {
  real<lower=0.0> H;
  real<lower=0.0> tau;
}
transformed parameters {
  real<lower=0.0> Q;
  Q <- pow(tau, 2.0);
}
model {
  {
    real loglik_obs[n];
    real v;
    real K;
    real Finv;
    real a;
    real P;
    real F;
    a <- a1;
    P <- P1;
    for (i in 1:n) {
      if (! missing[i]) {
        v <- y[i] - a;
        F <- P + H;
        Finv <- 1 / F;
        K <- P * Finv;
        a <- a + K * v;
        P <- (1 - K) * P;
        loglik_obs[i] <- -0.5 * (log(2 * pi())
                                 + log(F) + Finv * pow(v, 2.0));
      } else {
        loglik_obs[i] <- 0.0;
      }
      P <- P + Q;
    }
    lp__ <- lp__ + sum(loglik_obs);
  }
  lp__ <- lp__ - log(H);
  tau ~ cauchy(0, sqrt(H));
}
