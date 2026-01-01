# Definir la población ejemplo
n <- 10
R <- 1000

estimaciones_mu <- matrix(NA, nrow = 1000, ncol = 3)
estimaciones_sigma <- matrix(NA, nrow = 1000, ncol = 4)

for (i in 1:R){
  x <- rnorm(n, mean = 10, sd = 20)
  
  # Posibles candidatos a estimadores
  
  estimaciones_mu[i,1] <- mean(x)
  estimaciones_mu[i,2] <- median(x)
  estimaciones_mu[i,3] <- (max(x) + min(x)) / 2
  
  estimaciones_sigma[i,1] <- sd(x)
  estimaciones_sigma[i,2] <- var(x)
  estimaciones_sigma[i,3] <- IQR(x)
  estimaciones_sigma[i,4] <- max(x) - min(x)
  
}

# Define una función sesgo

# b(param_est) = E[param_est] - param_teorico

sesgo <- colMeans(estimaciones_mu) - 10

sesgo_sigma <- colMeans(estimaciones_sigma) - 20


# Varianza

# V(param_est) = E[(param_est - E[param_est])^2]

varianza <- apply(estimaciones_mu, 2, var)

varianza_sigma <- apply(estimaciones_sigma, 2, var)


# Error cuadrático Medio

# V(param_est) + sesgo^2

ecm <- varianza + sesgo^2

ecm_sigma <- varianza_sigma + sesgo_sigma^2

# La media es un estimador insesgado para mu


