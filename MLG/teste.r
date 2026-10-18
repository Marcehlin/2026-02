# log verossimilhnaça de gamma com parametrização de mu_i e phi
loglik_gamma <- function(y, mu, phi) {
  a <- 1 / phi
  sum(
    (a - 1) * log(y) -
    y / (phi * mu) -
    a * log(phi * mu) -
    lgamma(a)
  )
}
set.seed(1002)



calcula_Qrv <- function(n1, phi) {

  # Gere uma variável aleatória com distribuição de Bernoulli com parâmetro igual a 0,6 (X1) uma variável aleatória com distribuição uniforme no intervalo (0, 1) (X2).
  X1 <- rbinom(n1, size = 1, prob = 0.6)
  X2 <- runif(n1, min = 0, max = 1)
  Y <- rgamma(n1, shape = phi, scale = exp(2.3 + 0.4 * X1) / phi)

  Y_pos <- pmax(Y, 1e-5)  # para evitar problemas com log(0) ou valores muito pequenos

  fit_H1 <- glm(Y ~ X1 + X2, family = Gamma(link = "log"), mustart = Y_pos) # usa Y_pos como chute inicial para mu, serve para não quebrar o algoritmo
  fit_H0 <- glm(Y ~ X1, family = Gamma(link = "log"), mustart = Y_pos)
  
  mu_H1 <- fitted(fit_H1)
  mu_H0 <- fitted(fit_H0)

  #supondo que phi é conhecido e igual a 1, podemos calcular a log-verossimilhança para cada modelo:
  
  ll1 <- loglik_gamma(Y, mu_H1, phi) 
  ll0 <- loglik_gamma(Y, mu_H0, phi)
  
  Qrv <- 2 * (ll1 - ll0)
  
  return(Qrv)
}

# Fixe o tamanho do amostra em n e a semente de aleatorização em um valor qualquer
phi <- 1

Qrv <- numeric(1000)
for (i in 1:1000) {
  Qrv[i] <- calcula_Qrv(n1 = 10, phi)
}
