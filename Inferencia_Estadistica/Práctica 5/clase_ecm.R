# Definir la población
n <- 10
R <- 10000

estimaciones_mu <- matrix(NA, nrow = R, ncol = 3)
estimaciones_sigma <- matrix(NA, nrow = R, ncol = 4)

for(i in 1:R){
  x <- rnorm(n, mean = 10, sd = 20)
  
  estimaciones_mu[i,1] <- mean(x)
  estimaciones_mu[i,2] <- median(x)
  estimaciones_mu[i,3] <- (max(x)+min(x))/2
  
  estimaciones_sigma[i,1] <- sd(x)
  estimaciones_sigma[i,2] <- var(x)
  estimaciones_sigma[i,3] <- IQR(x)
  estimaciones_sigma[i,4] <- max(x) - min(x)
}

sesgo_theta <- colMeans(estimaciones_mu) - 10

var_theta <- apply(estimaciones_mu, 2, var)

ecm_theta <- var_theta + sesgo_theta^2

sesgo_sigma <- colMeans(estimaciones_sigma) - 20

var_sigma <- apply(estimaciones_sigma, 2, var)

ecm_sigma <- var_sigma + sesgo_sigma^2



# Crear una funcion de maxima verosimilitud

n <- 10
x <- rnorm(10,mean = 0, sd = 1)
y <- rexp(10 ,rate = 10)

# Caluclar la log-verosimilitud para una normal de mean 0 y var 1

sigma <- 1
mu <- 0

logvero <- function(x, mu, sigma){
  n <- length(x)
  logverosimilitud <- -n/2*log(2*pi*sigma^2) - (1/(2*sigma^2))*sum((x-mu)^2)
  return(logverosimilitud)
}

logvero(x, mu = mu, sigma = sigma)

# Calcular la log-verosimilitud para una exponencial de lambda 10

lambda <- 10

logvero_exp <- function(x, lambda){
  n <- length(x)
  logverosimilitud <- n*log(lambda) - lambda*sum(x)
  return(logverosimilitud)
}

logvero_exp(x, lambda = lambda)

