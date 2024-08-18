library(ggplot2)
library(dplyr)

N  <- 19
y <- 7

###how rare?
x <- rbinom(1e5, N, prob = 1 / 7 ) %>% as_tibble()
setnames(x, "gen")
x %>% colnames()

ggplot(x, aes(gen)) +
geom_histogram(aes(y = after_stat(density))) +
geom_vline(xintercept = 7, color = "red")

# "p" value
## probability of seeing something as or more extreme
sum(x$gen >= y) / length(x$gen)



###### repeat experiment
x <- rbinom(N, N, 1/7)
qplot(x) +
geom_histogram() +
geom_vline(xintercept = y)

#######################
###### bayes with stan as a bernouilli process
########################
setwd("~/stan_sandbox")
library(cmdstanr)
library(posterior)
library(bayesplot)

# check_cmdstan_toolchain()
# install_cmdstan(cores = 4)

cmdstan_path()
cmdstan_version()

# choice of prior
x <- seq(0,1, length.out = 1000)
plot(x, dbeta(x, 2, 9),
      type = "l")
plot(x, dnorm(x, 1/7, .02),
      type = "l")

model <- cmdstan_model("births.stan")

data_list <- list(N = N, y = c(rep(1,7), rep(0,N-7)))

fit <- model$sample(
  data = data_list,
  seed = 345,
  chains = 4,
  parallel_chains = 4,
  refresh = 500
)

fit$diagnostic_summary()
fit$summary()

# mcmc_hist(fit$draws("theta"))
mcmc_dens(fit$draws("theta")) +
  geom_vline(xintercept = 1/7, lty = 2, color = "red") +
  labs(title = "Posterior", 
       x = expression(paste(theta, ": Probability of being born on Sunday")))



# compare to t-test and prop.test
?t.test
N  <- 19
y <- c(rep(1, 7), rep(0, N - 7))

t.test(y, mu = 1/7) # doesnt reject
t.test(y, mu = 1 / 7, alternative = "greater") # rejects null

prop.test(sum(y), N, p = 1 / 7) # rejects null
