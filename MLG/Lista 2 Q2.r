# log verossimilhnaça de gamma com parametrização de mu_i e phi
loglik_gamma <- function(y, mu, phi) {
  a <- 1 / phi
  sum ((a - 1) * log(y) - y / (phi * mu) - a * log(phi * mu) - lgamma(a))
}

set.seed(1002)

calcula_Qrv <- function(n1, phi) {

  # Gere uma variável aleatória com distribuição de Bernoulli com parâmetro igual a 0,6 (X1) uma variável aleatória com distribuição uniforme no intervalo (0, 1) (X2).
  X1 <- rbinom(n1, size = 1, prob = 0.6)
  X2 <- runif(n1, min = 0, max = 1)
  Y <- rgamma(n1, shape = phi, scale = exp(2.3 + 0.4 * X1) / phi)

  Y_pos <- pmax(Y, 1e-6)  # para evitar problemas com log(0) ou valores muito pequenos

  fit_H1 <- glm(Y ~ X1 + X2, family = Gamma(link = "log"), mustart = Y_pos) # usa Y_pos como chute inicial para mu, serve para não quebrar o algoritmo
  fit_H0 <- glm(Y ~ X1, family = Gamma(link = "log"), mustart = Y_pos)
  
  mu_H1 <- fitted(fit_H1)
  mu_H0 <- fitted(fit_H0)

  #supondo que phi é conhecido e igual a 1, podemos calcular a log-verossimilhança para cada modelo:

  # ======== 1) Razão de verossimilhança ========
  ll1 <- loglik_gamma(Y, mu_H1, phi) 
  ll0 <- loglik_gamma(Y, mu_H0, phi)
  Qrv <- 2 * (ll1 - ll0)

  # ======== 2) Wald ========
  beta_H1  <- coef(fit_H1)                # (b0, b1, b2)
  X_H1     <- model.matrix(fit_H1)
  I_H1     <- crossprod(X_H1) / phi       # = X'X / phi
  I_inv_H1 <- solve(I_H1)
  Qw <- beta_H1["X2"]^2 / I_inv_H1["X2", "X2"]


  # ======== 3) Score ========
  X_H0   <- model.matrix(fit_H0)          # (1, X1)
  X_full <- cbind(X_H0, X2 = X2)          # matriz completa sob H0

  # U(beta) = X' (y - mu) / (phi * mu)
  U_H0 <- as.numeric(crossprod(X_full,
                               (Y - mu_H0) / (phi * mu_H0)))

  I_H0     <- crossprod(X_full) / phi
  I_inv_H0 <- solve(I_H0)

  # Forma geral: Qs = U' I^{-1} U
  Qs <- as.numeric(t(U_H0) %*% I_inv_H0 %*% U_H0)

  # ======== 4) Gradiente ========
  U_til_b <- U_H0[3] # O escore restrito para X2
beta_hat_b <- coef(fit_H1)["X2"] # O beta irrestrito para X2
beta_til_b <- 0 # O beta restrito (hipótese nula)

Qg <- U_til_b * (beta_hat_b - beta_til_b)

  return(c(Qrv = Qrv, Qw = Qw, Qs = Qs, Qg = Qg))
}

#Qrv <- numeric(1000)
#for (i in 1:1000) {
#  Qrv[i] <- calcula_Qrv(n1 = 10, phi)
#}

# Calcular a proporção de Qrv que excedem o quantil da distribuição qui-quadrado com 1 grau de liberdade e nível de significância de 0,05

#1 - (sum(Qrv > qchisq(0.95, df = 1))) / length(Qrv)

B <- 1000
n1 <- 20

# Fixe o tamanho do amostra em n e a semente de aleatorização em um valor qualquer
phi <- 1
resultados <- t(replicate(1000,calcula_Qrv(n1,phi)))
colnames(resultados) <- c("RV", "Wald", "Score", "Gradiente")

round(colMeans(resultados), 3)
round(apply(resultados, 2, var), 3)

round(colMeans(resultados > qchisq(0.95, df = 1)), 3)

set.seed(1002)
n_s <- c (30, 40, 50, 100, 500, 1000)

for (i in 1:length(n_s)) {
  n1 <- n_s[i]
  resultados <- t(replicate(1000, calcula_Qrv(n1, phi)))
  colnames(resultados) <- c("RV", "Wald", "Score", "Gradiente")
  cat("\nTamanho da amostra:", n1, "\n")
  print(round(colMeans(resultados > qchisq(0.95, df = 1)), 3))
}
