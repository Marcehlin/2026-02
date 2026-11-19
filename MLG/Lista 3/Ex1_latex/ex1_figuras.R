#######################################################################
# Lista 3 - Exercício 1 (Paula, Cap. 3, Ex. 20)
# Gera as figuras (ex1_*.png) e imprime os números usados em ex1.tex.
# Rodar com o diretório de trabalho nesta pasta (Lista 3/Ex1_latex/).
#######################################################################

claims <- read.csv("../claims.csv")
claims$cmsinistros <- claims$csin / claims$nsin
for (v in c("tipov", "idadev", "genero", "areac", "idadec"))
  claims[[v]] <- factor(claims[[v]])

# ---- Agrupamentos ----
claims$tipov2 <- factor(ifelse(claims$tipov %in% c("HBACK", "SEDAN", "STNWG", "HDTOP", "MCARA"),
                               "comum", "outros"), levels = c("comum", "outros"))
claims$idadev2 <- factor(ifelse(claims$idadev %in% c("1", "2"), "1-2", "3-4"))
claims$areac2  <- factor(ifelse(claims$areac %in% c("E", "F"), "EF", "A-D"), levels = c("A-D", "EF"))
claims$idadec2 <- factor(ifelse(claims$idadec %in% c("1", "2"), "1-2",
                         ifelse(claims$idadec == "6", "6", "3-5")), levels = c("3-5", "1-2", "6"))

# ---- Funções auxiliares ----
rig <- function(n, mu, lambda) {
  y2 <- rchisq(n, 1); u <- runif(n)
  r1 <- mu / (2 * lambda) * (2 * lambda + mu * y2 - sqrt(4 * lambda * mu * y2 + mu^2 * y2^2))
  ifelse(u < mu / (mu + r1), r1, mu^2 / r1)
}
envelope_bandas <- function(fit, B = 100) {
  X <- model.matrix(fit); n <- nrow(X)
  mu <- fitted(fit); phi <- summary(fit)$dispersion
  td <- sort(rstandard(fit, type = "deviance"))
  e <- matrix(NA, n, B); i <- 0
  while (i < B) {
    resp <- if (fit$family$family == "Gamma") rgamma(n, shape = 1 / phi, scale = mu * phi)
            else rig(n, mu, 1 / phi)
    f <- tryCatch(glm(resp ~ X - 1, family = fit$family, start = coef(fit),
                      control = glm.control(maxit = 100)), error = function(e) NULL)
    if (is.null(f) || !f$converged) next
    i <- i + 1; e[, i] <- sort(rstandard(f, type = "deviance"))
  }
  e <- t(apply(e, 1, sort))
  list(td = td, e1 = (e[, 2] + e[, 3]) / 2, e2 = (e[, B - 3] + e[, B - 2]) / 2, med = rowMeans(e))
}
res_quantilico <- function(fit) {
  y <- fit$y; mu <- fitted(fit)
  if (fit$family$family == "Gamma") {
    phi <- MASS::gamma.dispersion(fit)
    qnorm(pgamma(y, shape = 1 / phi, scale = mu * phi))
  } else {
    lam <- 1 / (deviance(fit) / length(y))
    qnorm(pnorm(sqrt(lam / y) * (y / mu - 1)) + exp(2 * lam / mu) * pnorm(-sqrt(lam / y) * (y / mu + 1)))
  }
}
fig_diag <- function(fit, arquivo, seed = 2026) {
  h <- hatvalues(fit); td <- rstandard(fit, type = "deviance")
  tp <- rstandard(fit, type = "pearson"); ci <- cooks.distance(fit)
  eta <- predict(fit); z <- eta + resid(fit, type = "working")
  set.seed(seed); env <- envelope_bandas(fit); rq <- res_quantilico(fit)
  png(arquivo, width = 2400, height = 1500, res = 220)
  par(mfrow = c(2, 3), mar = c(4.2, 4.2, 2, 1))
  plot(fitted(fit), h, pch = 16, cex = .5, log = "x", xlab = "Valor ajustado", ylab = "Alavanca", main = "Alavanca")
  plot(fitted(fit), td, pch = 16, cex = .5, log = "x", xlab = "Valor ajustado", ylab = "Resíduo deviance padronizado",
       main = "Resíduo deviance"); abline(h = 0, lty = 2)
  plot(ci, pch = 16, cex = .5, type = "h", xlab = "Índice", ylab = "Distância de Cook", main = "Cook")
  plot(eta, z, pch = 16, cex = .5, xlab = expression(hat(eta)), ylab = "z", main = "Variável dependente ajustada")
  abline(0, 1, col = "red")
  q <- qnorm(ppoints(length(env$td))); faixa <- range(env$td, env$e1, env$e2)
  plot(q, env$td, pch = 16, cex = .5, ylim = faixa, xlab = "Percentis da N(0,1)", ylab = "Componente do desvio",
       main = "Envelope simulado")
  lines(q, env$e1); lines(q, env$e2); lines(q, env$med, lty = 2)
  qqnorm(rq, pch = 16, cex = .5, main = "Resíduo quantílico", xlab = "Percentis da N(0,1)", ylab = "Resíduo quantílico")
  qqline(rq, col = "red")
  dev.off()
  fora <- mean(env$td < env$e1 | env$td > env$e2)
  cat(arquivo, ": fora do envelope =", round(100 * fora, 1), "% | max h =", round(max(h), 3),
      "| max Cook =", round(max(ci), 4), "| rq média/dp/assim =", round(mean(rq), 3), round(sd(rq), 3),
      round(mean((rq - mean(rq))^3) / sd(rq)^3, 3), "\n")
  invisible(list(h = h, td = td, ci = ci))
}

# ---- Figura 1: resposta ----
png("ex1_resposta.png", width = 2400, height = 900, res = 220)
par(mfrow = c(1, 2), mar = c(4.2, 4.2, 2, 1))
hist(claims$cmsinistros, breaks = 40, main = "", xlab = "cmsinistros (AUD)", ylab = "Frequência")
hist(log(claims$cmsinistros), breaks = 40, main = "", xlab = "log(cmsinistros)", ylab = "Frequência")
dev.off()

# ---- Figura 2: preditoras ----
png("ex1_preditoras.png", width = 2400, height = 1500, res = 220)
par(mfrow = c(2, 3), mar = c(4.5, 4.2, 2, 1))
plot(claims$valorv, log(claims$cmsinistros), pch = 16, cex = .5, col = rgb(0, 0, 0, .35),
     xlab = "valorv (10 mil AUD)", ylab = "log(cmsinistros)")
lines(lowess(claims$valorv, log(claims$cmsinistros)), col = "red", lwd = 2)
plot(claims$expos, log(claims$cmsinistros), pch = 16, cex = .5, col = rgb(0, 0, 0, .35),
     xlab = "expos", ylab = "log(cmsinistros)")
lines(lowess(claims$expos, log(claims$cmsinistros)), col = "red", lwd = 2)
boxplot(log(cmsinistros) ~ tipov, data = claims, las = 2, xlab = "", ylab = "log(cmsinistros)", main = "tipov", cex = .5)
boxplot(log(cmsinistros) ~ idadev, data = claims, xlab = "idadev", ylab = "log(cmsinistros)", cex = .5)
boxplot(log(cmsinistros) ~ areac, data = claims, xlab = "areac", ylab = "log(cmsinistros)", cex = .5)
boxplot(log(cmsinistros) ~ idadec, data = claims, xlab = "idadec", ylab = "log(cmsinistros)", cex = .5)
dev.off()

# ---- Descritiva numérica ----
print(summary(claims$cmsinistros)); cat("CV:", sd(claims$cmsinistros) / mean(claims$cmsinistros),
    " y==200:", sum(claims$cmsinistros == 200), "\n"); print(table(claims$nsin))
for (v in c("tipov", "idadev", "genero", "areac", "idadec", "tipov2", "idadev2", "areac2", "idadec2"))
  print(data.frame(n = tapply(claims$cmsinistros, claims[[v]], length),
                   media = tapply(claims$cmsinistros, claims[[v]], mean),
                   mlog = tapply(log(claims$cmsinistros), claims[[v]], mean)))

# ---- Modelos gama ----
aj0 <- glm(cmsinistros ~ valorv + expos + tipov + idadev + genero + areac + idadec,
           family = Gamma(link = "log"), data = claims)
aj1 <- glm(cmsinistros ~ valorv + expos + tipov2 + idadev2 + genero + areac2 + idadec2,
           family = Gamma(link = "log"), data = claims)
print(anova(aj1, aj0, test = "F"))
print(drop1(aj1, test = "F"))
aj2 <- update(aj1, . ~ . - genero); print(drop1(aj2, test = "F"))
aj3 <- update(aj2, . ~ . - valorv); print(drop1(aj3, test = "F"))
print(anova(aj3, aj1, test = "F")); print(summary(aj3))
dg <- fig_diag(aj3, "ex1_diag_gama.png")

# ---- Normal inversa ----
aj_ni <- glm(formula(aj3), family = inverse.gaussian(link = "log"),
             start = coef(aj3), control = glm.control(maxit = 100), data = claims)
print(summary(aj_ni)); print(drop1(aj_ni, test = "F")); print(AIC(aj3, aj_ni))
dn <- fig_diag(aj_ni, "ex1_diag_ni.png")

# Tabela de coeficientes do modelo final (IC pela t)
gl <- df.residual(aj_ni); s <- summary(aj_ni)$coef
tab <- data.frame(est = s[, 1], ep = s[, 2], t = s[, 3], p = s[, 4], expb = exp(s[, 1]),
                  li = exp(s[, 1] - qt(.975, gl) * s[, 2]), ls = exp(s[, 1] + qt(.975, gl) * s[, 2]))
print(round(tab, 5)); cat("gl =", gl, " phi =", summary(aj_ni)$dispersion, "\n")

# ---- Pontos destacados ----
idx <- order(dn$ci, decreasing = TRUE)[1:3]
print(data.frame(linha = idx, claims[idx, c("cmsinistros", "tipov", "idadev", "areac", "idadec")],
                 ajustado = fitted(aj_ni)[idx], h = dn$h[idx], td = dn$td[idx], cook = dn$ci[idx]))
cat("Ordem de h (maiores):\n"); print(round(head(sort(dn$h, decreasing = TRUE), 5), 4))
aj_sem <- update(aj_ni, data = claims[-idx, ])
print(round(data.frame(com = coef(aj_ni), sem = coef(aj_sem),
                       var = 100 * (coef(aj_sem) - coef(aj_ni)) / abs(coef(aj_ni)),
                       p_com = summary(aj_ni)$coef[, 4], p_sem = summary(aj_sem)$coef[, 4]), 5))

# Figura dos pontos destacados
png("ex1_pontos.png", width = 2400, height = 1500, res = 220)
par(mfrow = c(1, 2), mar = c(4.2, 4.2, 2, 1))
plot(fitted(aj_ni), claims$cmsinistros, pch = 16, cex = .5, col = rgb(0, 0, 0, .35), log = "xy",
     xlab = "Valor ajustado", ylab = "cmsinistros")
points(fitted(aj_ni)[idx], claims$cmsinistros[idx], col = "red", pch = 16)
text(fitted(aj_ni)[idx], claims$cmsinistros[idx], idx, pos = 4, col = "red")
abline(0, 1, lty = 2)
plot(dn$ci, type = "h", xlab = "Índice", ylab = "Distância de Cook")
text(idx, dn$ci[idx], idx, pos = 3, col = "red", cex = .8)
dev.off()

# ---- Pseudo R2 ----
cat("pseudo R2 deviance  gama:", 1 - deviance(aj3) / aj3$null.deviance,
    " NI:", 1 - deviance(aj_ni) / aj_ni$null.deviance, "\n")
cat("pseudo R2 cor^2 (escala log) NI:", cor(predict(aj_ni), log(claims$cmsinistros))^2, "\n")

# ---- Perfis ----
perfis <- expand.grid(expos = median(claims$expos), tipov2 = levels(claims$tipov2), idadev2 = "1-2",
                      areac2 = levels(claims$areac2), idadec2 = levels(claims$idadec2))
perfis$prev <- predict(aj_ni, newdata = perfis, type = "response"); print(range(perfis$prev))
