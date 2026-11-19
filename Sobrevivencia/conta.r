#cap3 ex1
exp(-9/100)
exp(-(9/20)^2)

integrate(function(x) 1 - pweibull(x,shape = 2, scale = 100), lower = 0, upper = Inf)

gamma(1 + 1/2) * 100

50 * sqrt(pi)

100 * (-log(0.5))^(1/2)

S <- function(t) 1 - pweibull(t, 2, 100)
# (d) taxa de falha h(t) = f(t)/S(t)
h <- function(t) dweibull(t, 2, 100) / S(t)
h(c(30, 45, 60))                               # 0.006 0.009 0.012

# gráfico da taxa de falha
curve(h, 0, 10000, xlab = "t (dias)", ylab = "h(t)", main = "Taxa de falha Weibull")


#cap2 e2 

(1-1/25)*(1-1/24)* (1-1/23)* (1-1/22)* (1-1/21)* (1-1/20)* (1-1/19)* (1-1/18)* (1-1/17)* (1-1/16)* (1-1/15)* (1-1/14)* (1-1/13)* (1-1/12)* (1-1/11)* (1-1/10)* (1-1/9)* (1-1/8)* (1-1/7)* (1-1/6)* (1-1/5) * 0.5

0.84 - (1.31-2)/(2-2.78)*0.04

#cap3 e3

library(survival)

tempo  <- c(0.19, 0.78, 0.96, 1.31, 2.78, 3.16, 4.67, 4.85, 6.50, 7.35,
            8.27, 12.07, 32.52, 33.91, 36.71, rep(36.71, 10))
status <- c(rep(1, 15), rep(0, 10))

# --- ajustes ---
km   <- survfit(Surv(tempo, status) ~ 1)
fexp <- survreg(Surv(tempo, status) ~ 1, dist = "exponential")
fwei <- survreg(Surv(tempo, status) ~ 1, dist = "weibull")
fln  <- survreg(Surv(tempo, status) ~ 1, dist = "lognormal")

c(exp = fexp$loglik[1], wei = fwei$loglik[1], ln = fln$loglik[1])

# TRV exponencial x Weibull (H0: gama = 1)
TRV <- 2 * (fwei$loglik[1] - fexp$loglik[1])
c(TRV = TRV, p = 1 - pchisq(TRV, 1))

# --- gráficos de linearização ---
s  <- km$surv[km$n.event > 0]; tt <- km$time[km$n.event > 0]
par(mfrow = c(1, 3))
plot(tt, -log(s), main = "Exponencial")
plot(log(tt), log(-log(s)), main = "Weibull")
plot(log(tt), qnorm(1 - s), main = "Log-normal")

# --- parâmetros da Weibull ---
# survreg: log(T) = mu + sigma*W  ->  alpha = exp(mu), gama = 1/sigma
alpha <- exp(coef(fwei)); gama <- 1 / fwei$scale
c(alpha = alpha, gama = gama)            # 40.94  0.593

# (a) mediana
alpha * log(2)^(1/gama)                  # 22.07
# (b) F(2)
pweibull(2, shape = gama, scale = alpha) # 0.154
# (c) média
alpha * gamma(1 + 1/gama)                # 62.5
# (d) t com F = 0.20
qweibull(0.2, shape = gama, scale = alpha)  # 3.27

# KM x Weibull ajustada
par(mfrow = c(1, 1))
plot(km, conf.int = FALSE, xlab = "Tempo (min)", ylab = "S(t)")
curve(pweibull(x, gama, alpha, lower.tail = FALSE), add = TRUE, col = 2)

exp(-(10/21.33)^1.54)

log(2)^(1/1.54)*21.33

(10/21.33)^1.54

(1.54/21.33)*(10/21.33)^(1.54-1)
