# 1. Dados e inicializacao -----------------------------------------------
# Em R, o separador decimal e o ponto.

y <- c(2.3, 1.8, 1.5, 1.3, 1.2)
x <- c(2, 4, 6, 9, 10)
X <- cbind(intercepto = 1, x = x)

n <- length(y)
p <- ncol(X)
mu <- y  # Inicializacao solicitada; todos os valores sao positivos.

# 1. Calcula a ligação, sua derivada e a função de variância
eta <- 1 / mu^2
derivada_ligacao <- -2 / mu^3
V <- mu^3

# 2. Constrói a resposta de trabalho e os pesos
z <- eta + (y - mu) * derivada_ligacao
pesos <- mu^3 / 4 
#pesos <- 1 / (V * derivada_ligacao^2)
W <- diag(pesos)

# 3. Monta as equações normais dos mínimos quadrados ponderados
A <- t(X) %*% W %*% X
b <- t(X) %*% W %*% z

#solve(A) %*% b
# Resolve A beta = b para obter os novos coeficientes

beta <- drop(solve(A, b))

# 4. Calcula as novas médias usando a inversa da ligação
eta_novo <- drop(X %*% beta)

mu_novo <- 1 / sqrt(eta_novo)

mu <- mu_novo

n / sum((y - mu)^2/mu^3 )

sum((y - mu)^2/mu^3)

2 / sum((y - mu)^2/mu^3 )

n/sum((y - mu)^2/ (y*mu^2))



# 5. Mede quanto as médias mudaram

mudanca <- max(abs(mu_novo - mu))


qnorm(0.95,39.167,sqrt(32.64))

qnorm(0.99,39.167,sqrt(32.64))

(51-39.167-0.5)/sqrt(32.64)

1- pnorm(1.983672)

51/235 - qnorm(0.995)*sqrt(51/235*(1-51/235)/235)

51/235 + qnorm(0.975)*sqrt(51/235*(1-51/235)/235)

1/6
