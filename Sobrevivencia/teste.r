# Questão 6 - Durabilidade do requeijão (embalagens A e B)
library(survival)

# ---- Dados (status: 1 = falha/fungo, 0 = censura) ----
tempo <- c(31, 40, 43, 44, 46, 46, 47, 48, 48, 49,
           50, 50, 60, 60, 60, 60, 60, 60, 60, 60,   # embalagem A
           48, 48, 49, 49, 49, 49, 50, 50, 50, 50,
           53, 53, 54, 54, 54, 55, 55, 55, 55, 55)   # embalagem B

status <- c(1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
            1, 1, 1, 1, 1, 1, 0, 0, 0, 0,            # A
            1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
            1, 1, 1, 1, 1, 1, 0, 0, 0, 0)            # B

grupo <- rep(c("A", "B"), each = 20)

# ---- (a) Teste logrank ----
survdiff(Surv(tempo, status) ~ grupo)            # logrank (rho = 0)
survdiff(Surv(tempo, status) ~ grupo, rho = 1)   # versão tipo Wilcoxon (Peto-Peto)

# Curvas de Kaplan-Meier por embalagem (para ver o cruzamento)
km_grupos <- survfit(Surv(tempo, status) ~ grupo)
plot(km_grupos, lty = 1:2, xlab = "Tempo (horas)", ylab = "S(t) estimada")
legend("bottomleft", legend = c("A", "B"), lty = 1:2, bty = "n")

# ---- (b) Amostra única: Kaplan-Meier ----
km <- survfit(Surv(tempo, status) ~ 1)
summary(km)   # tabela com n.risk, n.event e S(t)

# Percentil 10: menor tempo com S(t) <= 0,90
min(km$time[km$surv <= 0.90])

# Tempo médio (restrito): área sob a curva de KM até o maior tempo
inicio <- c(0, km$time[-length(km$time)])
altura <- c(1, km$surv[-length(km$surv)])
sum((km$time - inicio) * altura)

# Conferência pelo próprio pacote
print(km, print.rmean = TRUE)
