caminho <- "C:/Users/Marcelo/Downloads/uns pdfs/ufscar/2026 02/MLG/"
envelopes <- paste0(caminho, "Envelopes/")

claims <- read.table(paste0(caminho, "claims.txt"), head=F, sep="",
                     col.names=c("valorv","expos","nsinistros","csinistros",
                                 "tipov","idadev","sexoc","areac","idadec"))

 
# Variável resposta: custo médio por sinistro
claims$cmsinistros <- claims$csinistros/claims$nsinistros



#######################################################################
# 2. ANÁLISE DESCRITIVA
#######################################################################
 
# Distribuição da resposta: espera-se forte assimetria à direita,
# o que justifica modelos para resposta positiva assimétrica (gama, NI)
hist(claims$cmsinistros)
summary(claims$cmsinistros)
 
# Na escala log a distribuição fica mais simétrica
hist(log(claims$cmsinistros))
 
# Variáveis contínuas
summary(claims$valorv)
summary(claims$expos)
 
# Relação da resposta com as contínuas (escala log, pois usaremos liga log)
plot(claims$valorv,log(claims$cmsinistros))
plot(claims$expos,log(claims$cmsinistros))
 
# Médias, desvios padrão e tamanhos por categoria.
# Estas tabelas guiam o agrupamento: categorias com poucas observações
# ou com médias parecidas são candidatas a serem juntadas.
library(doBy)
summaryBy(cmsinistros~factor(tipov), data=claims, FUN=c(mean, sd, length))
summaryBy(cmsinistros~factor(idadev), data=claims, FUN=c(mean, sd, length))
summaryBy(cmsinistros~factor(sexoc), data=claims, FUN=c(mean, sd, length))
summaryBy(cmsinistros~factor(areac), data=claims, FUN=c(mean, sd, length))
summaryBy(cmsinistros~factor(idadec), data=claims, FUN=c(mean, sd, length))
 
# Boxplots na escala log (mais fáceis de comparar)
boxplot(log(cmsinistros) ~ tipov, data=claims)
boxplot(log(cmsinistros) ~ idadev, data=claims)
boxplot(log(cmsinistros) ~ areac, data=claims)
boxplot(log(cmsinistros) ~ idadec, data=claims)
 
 


#######################################################################
# 3. AGRUPAMENTO DE CATEGORIAS
#######################################################################
 
# ATENÇÃO: os agrupamentos abaixo são uma proposta inicial. Confira com
# as tabelas do item 2 e mude se a sua amostra indicar outro agrupamento.
# O teste da razão de verossimilhanças do item 4 verifica se o
# agrupamento é aceitável.
 
# tipov: as 4 categorias mais frequentes ficam separadas, o resto vira OUTROS
claims$tipov2 <- ifelse(claims$tipov %in% c("SEDAN","HBACK","STNWG","UTE"),
                        as.character(claims$tipov), "OUTROS")
claims$tipov2 <- relevel(factor(claims$tipov2), ref="SEDAN")   # SEDAN = referência
table(claims$tipov2)
 
# idadev: 1, 2 e 3-4
claims$idadev2 <- factor(ifelse(claims$idadev >= 3, "3-4", as.character(claims$idadev)))
table(claims$idadev2)
 
# areac: A-C, D-E e F
claims$areac2 <- factor(ifelse(claims$areac %in% c("A","B","C"), "ABC",
                        ifelse(claims$areac %in% c("D","E"), "DE", "F")))
table(claims$areac2)
 
# idadec: 1-2 (jovens), 3-4 (intermediários) e 5-6 (mais velhos)
claims$idadec2 <- factor(ifelse(claims$idadec <= 2, "1-2",
                         ifelse(claims$idadec <= 4, "3-4", "5-6")))
table(claims$idadec2)
 
# Descritiva das categorias agrupadas
summaryBy(cmsinistros~tipov2, data=claims, FUN=c(mean, sd, length))
summaryBy(cmsinistros~idadev2, data=claims, FUN=c(mean, sd, length))
summaryBy(cmsinistros~areac2, data=claims, FUN=c(mean, sd, length))
summaryBy(cmsinistros~idadec2, data=claims, FUN=c(mean, sd, length))


#######################################################################
# 4. AJUSTE DOS MODELOS (phi constante, liga log)
#######################################################################
 
# --- Gama ---
 
# Modelo com as categorias originais
aj0_claims <- glm(cmsinistros ~ valorv + expos + factor(tipov) + factor(idadev) +
                    factor(sexoc) + factor(areac) + factor(idadec),
                  family=Gamma(link="log"), data=claims)
summary(aj0_claims)
 
# Modelo com as categorias agrupadas
aj1_claims <- glm(cmsinistros ~ valorv + expos + tipov2 + idadev2 + factor(sexoc) +
                    areac2 + idadec2, family=Gamma(link="log"), data=claims)
summary(aj1_claims)
 
# Teste da razão de verossimilhanças. H0: o agrupamento é adequado.
# p-valor grande -> podemos usar as categorias agrupadas.
library(lmtest)
lrtest(aj0_claims, aj1_claims)
 
# Seleção de variáveis: drop1 testa a retirada de cada variável.
# Usamos o teste F porque phi é estimado.
drop1(aj1_claims, test="F")
 
# Modelo reduzido: aqui retiramos expos como exemplo. Retire as
# variáveis que o drop1 apontar como não significativas na sua amostra
# e repita até todas ficarem significativas.
aj2_claims <- glm(cmsinistros ~ valorv + tipov2 + idadev2 + factor(sexoc) +
                    areac2 + idadec2, family=Gamma(link="log"), data=claims)
summary(aj2_claims)
lrtest(aj1_claims, aj2_claims)
drop1(aj2_claims, test="F")
 
# --- Normal inversa ---
 
# Mesmo preditor do modelo gama reduzido. Os coeficientes da gama servem
# de valores iniciais (start) e aumentamos maxit, pois a normal inversa
# costuma ter mais dificuldade para convergir.
aj3_claims <- glm(cmsinistros ~ valorv + tipov2 + idadev2 + factor(sexoc) +
                    areac2 + idadec2, family=inverse.gaussian(link="log"),
                  start=coefficients(aj2_claims), maxit=100, data=claims)
summary(aj3_claims)
drop1(aj3_claims, test="F")
 
# Comparação gama x normal inversa: menor AIC indica melhor ajuste
AIC(aj2_claims, aj3_claims)
 
 

