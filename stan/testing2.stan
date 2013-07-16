data {
  int r;
  int n;
  int T;
  matrix[r, T] y;
  matrix[n, r] F;
  matrix[r, r] V;
  matrix[n, n] G;
  matrix[n, n] W;
  vector[n] m0;
  matrix[n, n] C0;
}
parameters {
  real foo;
}
transformed parameters {
  real lp;
  {
    real LL;
    vector[n] m;
    matrix[n, n] C;
    vector[n] a;
    matrix[n, n] R;
    vector[r] f;
    matrix[r, r] Q;
    matrix[r, r] Q_inv;
    vector[r] err;
    matrix[n, r] A;
    m <- m0;
    C <- C0;
    for (i in 1:T) {
      a <- G * m;
      R <- G * C * G ' + W;
      R <- 0.5 * (R + R');
      f <- F ' * a;
      Q <- F ' * R * F + V;
      Q <- 0.5 * (Q + Q');
      Q_inv <- inverse(Q);
      err <- col(y, i) - f;
      A <- R * F * Q_inv;
      m <- a + A * err;
      C <- R - A * Q * A '; 
      C <- 0.5 * (C + C');
      LL <- (-0.5
             * (log_determinant(Q)
                + err' * Q_inv * err));
      lp <- lp + LL;
    }
  }
}
model {
  foo ~ normal(0, 1);
}
