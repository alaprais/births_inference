data {
   int<lower=0> N;
   array[N] int<lower=0, upper=1> y;
}
parameters {
   real<lower=0, upper=1> theta;
}
model {
   theta ~ normal(1.0/7,.02); //prior
   y ~ bernoulli(theta);
}

