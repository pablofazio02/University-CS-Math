# Vamos a realizar la definición de todas las funciones de log-verosimilitud de distribuciones conocidas.

# Distribución Exponencial

logLik_exp <- function(lambda, x) {
  n <- length(x)
  n*log(lambda)-lambda*sum(x)
}

# Distribución Normal

logLik_normal <- function(mu, sigma, x) {
  n <- length(x)
  -n/2*log(sigma^2*2*pi) - 1/(2*sigma^2)*sum((x-mu)^2)
}

# Distribución Uniforme 

logLik_uniform <- function(a, b, x) {
  n <- length(x)
  if (a >= b) {
    return(-Inf)
  }
  if (any(x < a) || any(x > b)) {
    return(-Inf)
  }
  n*log(1/(b-a)) # o lo que es lo mismo, -n*log(b-a)
}

# Distribución Cauchy

logLik_cauchy <- function(m, s, x) {
  n <- length(x)
  -n*log(pi*s) - sum(log(1 + ((x-m)/s)^2))
}

# Distribución Gamma

logLik_gamma <- function(alpha, beta, x) {
  n <- length(x)
  if (alpha <= 0 || beta <= 0) {
    return(-Inf)
  }
  n*alpha*log(beta) - n*lgamma(alpha) + (alpha-1)*sum(log(x)) - (beta)*sum(x)
}

# Distribución Xi^2

logLik_chi2 <- function(k, x) {
  n <- length(x)
  if (k <= 0) {
    return(-Inf)
  }
  -n*k*log(2)/2 - n*lgamma(k/2) + ((k/2) - 1)*sum(log(x)) - sum(x)/2
}

# Distribución T-Student

logLik_tstudent <- function(nu, x) {
  n <- length(x)
  if (nu <= 0) {
    return(-Inf)
  }
  (-n/2)*log(nu*pi) + n*lgamma((nu+1)/2) - n*lgamma(nu/2) - ((nu + 1)/2)*sum(log(1 + (x^2/nu)))
}