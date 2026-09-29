set.seed(0928)
n <- 100

amostras <- matrix(nrow = n, ncol = 20)

for (i in 1:n){
    amostra <- rnorm(20, mean = 1, sd = 1)
    amostras[i, ] <- amostra
}

medias <- rowMeans(amostras)

#bootstrap nao parametrico
B <- 1000
boot_np_var_de_medias <- numeric(n)
boot_np_quantis <- matrix(nrow = n, ncol = 2)
boot_np_vicio <- numeric(n)
for (i in 1:n){
    amostra <- amostras[i, ]
    medias_boot <- numeric(B)
    for (j in 1:B){
        amostra_boot <- sample(amostra, 20, replace = TRUE)
        medias_boot[j] <- mean(amostra_boot)
    }
    boot_np_var_de_medias[i] <- var(medias_boot)
    boot_np_vicio[i] <- mean(medias_boot) - 1
    boot_np_quantis[i,] <- quantile(medias_boot, c(0.025, 0.975))
}

mean(boot_np_var_de_medias)
mean(boot_np_vicio)
mean(ifelse(boot_np_quantis[,1] <= 1 & boot_np_quantis[,2] >= 1, 1, 0)))

#jackknife
jack_var_de_medias <- numeric(n)
jack_vicio <- numeric(n)
jack_quantis <- matrix(nrow = n, ncol = 2)
for (i in 1:n){
    amostra <- amostras[i, ]
    medias_jack <- numeric(20)
    for (j in 1:20){
        amostra_jack <- amostra[-j]
        medias_jack[j] <- mean(amostra_jack)
    }
    jack_var_de_medias[i] <- (19/20) * var(medias_jack)
    jack_vicio[i] <- mean(medias_jack) - 1
    jack_quantis[i,] <- quantile(medias_jack, c(0.025, 0.975))
}

mean(jack_var_de_medias)
mean(jack_vicio)
mean(ifelse(jack_quantis[,1] <= 1 & jack_quantis[,2] >= 1, 1, 0))

#bootstrap paramétrico
boot_p_var_de_medias <- numeric(n)
boot_p_vicio <- numeric(n)
boot_p_quantis <- matrix(nrow = n, ncol = 2)
for (i in 1:n){
    amostra <- amostras[i, ]
    medias_boot <- numeric(B)
    for (j in 1:B){
        amostra_boot <- rnorm(20, mean = mean(amostra), sd = sd(amostra))
        medias_boot[j] <- mean(amostra_boot)
    }
    boot_p_var_de_medias[i] <- var(medias_boot)
    boot_p_vicio[i] <- mean(medias_boot) - 1
    boot_p_quantis[i,] <- quantile(medias_boot, c(0.025, 0.975))
}

mean(boot_p_var_de_medias)
mean(boot_p_vicio)
mean(ifelse(boot_p_quantis[,1] <= 1 & boot_p_quantis[,2] >= 1, 1, 0))
