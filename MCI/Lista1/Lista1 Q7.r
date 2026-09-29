set.seed(0928)

n <- c(15, 50, 100, 500, 1000)
B <- 1000

s2n <- NULL
s2 <- NULL
s2_boot_corrigido <- NULL
s2_jackknife <- NULL

for (i in 1:5){
    amostra <- rnorm(n[i], 0, sd = sqrt(10))
    s2n[i] <- var(amostra) * (n[i] - 1) / n[i]
    s2[i] <- var(amostra)
    s2_boot <- NULL
    for (j in 1:B){
        amostra_boot <- sample(amostra, n[i], replace = TRUE)
        s2_boot[j] <- var(amostra_boot)
    }
    s2_boot_corrigido[i] <- 2 * s2[i] - mean(s2_boot)

    s2_jack <- NULL
    for (j in 1:n[i]){
        amostra_jack <- amostra[-j]
        s2_jack[j] <- var(amostra_jack)
    }
    s2_jackknife[i] <- mean(s2_jack) - (n[i] - 1) * (mean(s2_jack) - s2[i])
}

s2n
s2
s2_boot_corrigido
s2_jackknife

dados <- data.frame(n, s2n, s2, s2_boot_corrigido, s2_jackknife)
dados
