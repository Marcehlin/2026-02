# Exercicio 7: gaussiana inversa por MQP iterativos
# Ligacao: 1 / mu^2 = beta_0 + beta_1 * x
# Precisao: Var(Y_i) = mu_i^3 / phi
# Usa somente funcoes que acompanham o R.

# 1. Dados e inicializacao -----------------------------------------------
# Em R, o separador decimal e o ponto.
y <- c(2.3, 1.8, 1.5, 1.3, 1.2)
x <- c(2, 4, 6, 9, 10)
X <- cbind(intercepto = 1, x = x)

n <- length(y)
p <- ncol(X)
mu <- y  # Inicializacao solicitada; todos os valores sao positivos.

tolerancia <- 1e-10
max_iteracoes <- 100
convergiu <- FALSE
historico <- data.frame()
detalhes <- list()

eta <- 1 / mu^2
derivada_ligacao <- -2 / mu^3
V <- mu^3

z <- eta + (y - mu) * derivada_ligacao
pesos <- mu^3 / 4  # Equivale a 1 / (V * derivada_ligacao^2).
pesos <- 1 / (V * derivada_ligacao^2)  # Equivale a mu^3 / 4.
W <- diag(pesos)


# 2. Minimos quadrados ponderados iterativos ----------------------------
for (iteracao in seq_len(max_iteracoes)) {

  # Ligacao, derivada da ligacao e funcao de variancia.
  eta <- 1 / mu^2
  derivada_ligacao <- -2 / mu^3
  V <- mu^3

  # Resposta de trabalho z e matriz diagonal de pesos W.
  z <- eta + (y - mu) * derivada_ligacao
  pesos <- 1 / (V * derivada_ligacao^2)  # Equivale a mu^3 / 4.
  W <- diag(pesos)

  # Equacoes normais: A %*% beta = b.
  # t(X) e a transposta; %*% representa multiplicacao matricial.
  A <- t(X) %*% W %*% X
  b <- t(X) %*% W %*% z
  beta <- drop(solve(A, b))

  # Volta dos coeficientes para as medias ajustadas.
  eta_novo <- drop(X %*% beta)
  if (any(!is.finite(eta_novo)) || any(eta_novo <= 0)) {
    stop("Preditor invalido: a ligacao 1/mu^2 exige X beta > 0.")
  }
  mu_novo <- 1 / sqrt(eta_novo)

  # Criterio de parada: maior mudanca absoluta entre as medias.
  mudanca <- max(abs(mu_novo - mu))

  # Guarda as contas para consultar qualquer iteracao depois.
  detalhes[[iteracao]] <- list(
    tabela = data.frame(x, y, mu_usado = mu, z, pesos, mu_novo),
    W = W, A = A, b = b, beta = beta
  )
  historico <- rbind(historico, data.frame(
    iteracao = iteracao,
    beta_0 = unname(beta[1]),
    beta_1 = unname(beta[2]),
    maior_mudanca_mu = mudanca
  ))

  mu <- mu_novo
  if (mudanca < tolerancia) {
    convergiu <- TRUE
    break
  }
}

if (!convergiu) stop("O algoritmo atingiu o limite sem convergir.")

# 3. Estimativas finais de beta e das medias -----------------------------
beta_estimado <- beta
mu_estimado <- mu
residuos <- y - mu_estimado

# 4. Precisao phi por momentos e maxima verossimilhanca ------------------
contribuicao_pearson <- residuos^2 / mu_estimado^3
contribuicao_desvio <- residuos^2 / (y * mu_estimado^2)

Q_Pearson <- sum(contribuicao_pearson)
D_estrela <- sum(contribuicao_desvio)

# Pearson/momentos com correcao por n - p, usual em MLGs.
n/Q_Pearson
phi_momentos <- (n - p) / Q_Pearson

# Equacao de momentos sem correcao por graus de liberdade.
phi_momentos_sem_correcao <- n / Q_Pearson

# Maxima verossimilhanca usa o desvio, e nao a soma de Pearson.
phi_MV <- n / D_estrela

# 5. Resultados e contas para conferencia --------------------------------
cat("\nHistorico das iteracoes:\n")
print(historico, digits = 10, row.names = FALSE)

cat("\nContas da primeira iteracao (mu inicial = y):\n")
print(detalhes[[1]], digits = 10)
# Para consultar a segunda iteracao, por exemplo: detalhes[[2]]

cat("\nCoeficientes estimados:\n")
print(beta_estimado, digits = 10)

cat("\nMedias e contribuicoes individuais:\n")
print(data.frame(
  x, y, mu_estimado, residuos,
  contribuicao_pearson, contribuicao_desvio
), digits = 10, row.names = FALSE)

cat("\nSoma de Pearson e desvio:\n")
print(c(Q_Pearson = Q_Pearson, D_estrela = D_estrela), digits = 10)

cat("\nEstimativas de phi (precisao):\n")
print(c(
  momentos_com_correcao = phi_momentos,
  momentos_sem_correcao = phi_momentos_sem_correcao,
  maxima_verossimilhanca = phi_MV
), digits = 10)

# Se a ligacao adotada for -1/(2*mu^2), os coeficientes sao:
# -beta_estimado / 2
# As medias e as estimativas de precisao permanecem iguais.
