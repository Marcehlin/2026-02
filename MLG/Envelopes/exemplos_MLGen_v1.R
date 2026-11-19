# EXEMPLO 1: DADOS ENERGIA - Gilberto

# Leitura dos dados
energia <- read.table("G:/Meu Drive/Gustavo3/ufscar/pós-graduação/disciplinas/GLM/201501/dados e programas/dados_energia.txt", head=T, sep="")
energia



# An?lise descritiva

hist(energia$cons_pico)
summary(energia$cons_pico)
plot(energia$cons_mes,energia$cons_pico)
plot(energia$cons_mes,log(energia$cons_pico))

# Ajuste do modelo com fun??o de liga??o log e identidade

aj1_energia <- glm(cons_pico ~ cons_mes, family=Gamma(link="log"), data=energia)
summary(aj1_energia)

aj2_energia <- glm(cons_pico ~ cons_mes, family=inverse.gaussian(link="log"), data=energia)

aj3_energia <- glm(cons_pico ~ cons_mes, family=inverse.gaussian(link="log"), maxit = 50, data=energia)
summary(aj3_energia)

aj4_energia <- glm(cons_pico ~ cons_mes, family=gaussian(link="log"), maxit = 50, data=energia)
summary(aj4_energia)


aj5_energia <- glm(cons_pico ~ cons_mes, family=Gamma(link="identity"), data=energia)
summary(aj5_energia)

aj6_energia <- glm(cons_pico ~ cons_mes, family=inverse.gaussian(link="identity"), maxit = 50, data=energia)
summary(aj6_energia)

aj7_energia <- glm(cons_pico ~ cons_mes, family=gaussian(link="identity"), maxit = 50, data=energia)
summary(aj7_energia)

#(1-pnorm(9.895))*2
#(1-pt(9.895,df=51))*2
#(1-pnorm(2))*2
#(1-pt(2,df=51))*2



# An?lise de diagn?stico

windows()
X <- model.matrix(aj5_energia)
X
w <- aj5_energia$weights
W <- diag(w)

# Pontos alavanca
auxh <- solve(t(X)%*%W%*%X) 
auxh
H <- sqrt(W)%*%X%*%auxh%*%t(X)%*%sqrt(W)
h <- diag(H)
plot(fitted(aj5_energia),h,xlab="Valores ajustados",ylab="Alavanca")
identify(fitted(aj5_energia),h,n=3)

# Res?duo deviance
aux_tdi <- resid(aj5_energia, type = 'deviance')
aux_fi <- summary(aj5_energia)
fi <- 1/aux_fi$dispersion
tdi <- aux_tdi*sqrt(fi/(1-h))

plot(fitted(aj5_energia),tdi,xlab="Valores ajustados",ylab="Res?duo deviance")
identify(fitted(aj5_energia),tdi,n=3)

# Res?duo de Pearson
aux_tsi <- resid(aj5_energia, type = 'pearson')
tsi <- aux_tsi*sqrt(fi/(1-h))
plot(fitted(aj5_energia),tsi,xlab="Valores ajustados",ylab="Res?duo de Pearson")
identify(fitted(aj5_energia),tsi,n=2)
plot(tdi,tsi)

# Dist?ncia de Cook
ldi <- h*(tsi^2)/(1 - h)
ldi
plot(ldi,xlab="?ndice",ylab="Dist?ncia de Cook")
identify(ldi,n=2)

# Envelope
fit.model <- aj5_energia
source("G:/Meu Drive/Gustavo3/ufscar/pós-graduação/disciplinas/GLM/201501/dados e programas/envelope_gama_ident.R")
fit.model <- aj1_energia
source("G:/Meu Drive/Gustavo3/ufscar/pós-graduação/disciplinas/GLM/201501/dados e programas/envelope_gama.R")

# sem 5 e 15

aj5_energia <- glm(cons_pico ~ cons_mes, family=Gamma(link="identity"), data=energia)
summary(aj5_energia)

aj5_energia_sem5_15 <- glm(cons_pico ~ cons_mes, family=Gamma(link="identity"), data=energia,subset=-c(5,15))
summary(aj5_energia_sem5_15)

aj5_energia_sem5 <- glm(cons_pico ~ cons_mes, family=Gamma(link="identity"), data=energia,subset=-c(5))
summary(aj5_energia_sem5)

aj5_energia_sem15 <- glm(cons_pico ~ cons_mes, family=Gamma(link="identity"), data=energia,subset=-c(15))
summary(aj5_energia_sem15)

##########################################################
# EXEMPLO 2: DADOS VIDRO - Gilberto.

vidro <- read.table("G:/Meu Drive/Gustavo3/ufscar/pós-graduação/disciplinas/GLM/201501/dados e programas/dados_vidros.txt", head=T, sep="")
vidro

# An?lise descritiva

hist(vidro$resistencia)

library(doBy)
summaryBy(resistencia~factor(temperatura)+factor(voltagem), data=vidro, FUN=c(mean, sd))

vidro$temp_fat <- factor(vidro$temperatura)
vidro$volt_fat <- factor(vidro$voltagem)
#library(Rcmdr)
#plotMeans(vidro$resistencia,  vidro$volt_fat, vidro$temp_fat, error.bars="se")
#plotMeans(log(vidro$resistencia),  vidro$volt_fat, vidro$temp_fat, error.bars="se")

# Ajuste do modelo com fun??o de liga??o log

aj1_vidro <- glm(resistencia ~ factor(voltagem) + factor(temperatura) + factor(voltagem)*factor(temperatura), family=Gamma(link="log"), data=vidro)
summary(aj1_vidro)

aj1B_vidro <- glm(resistencia ~ factor(voltagem) + factor(temperatura) + factor(voltagem)*factor(temperatura), family=Gamma(link="identity"), data=vidro)
summary(aj1B_vidro)

aj2_vidro <- glm(resistencia ~ factor(voltagem) + factor(temperatura) + factor(voltagem)*factor(temperatura), family=inverse.gaussian(link="log"), data=vidro)
summary(aj2_vidro)

aj3_vidro <- glm(resistencia ~ factor(voltagem) + factor(temperatura) + factor(voltagem)*factor(temperatura), family=gaussian(link="log"), data=vidro)
summary(aj3_vidro)

aj4_vidro <- glm(resistencia ~ factor(voltagem) + factor(temperatura), family=Gamma(link="log"), data=vidro)
summary(aj4_vidro)

# teste da raz?o de verossimilhan?as.
library(lmtest)
lrtest(aj1_vidro,aj4_vidro)


exp(6.78559)
exp(6.78559-0.08363)
coefficients(aj1_vidro)
exp(coefficients(aj1_vidro))
0.05/16


summaryBy(resistencia~factor(temperatura)+factor(voltagem), data=vidro, FUN=c(mean, sd))

# testes de Wald
library(car)
# 200:170x180
linearHypothesis(aj1_vidro,hypothesis.matrix=c(0,0,0,0,1,0,0,0))
# 250:170x180
linearHypothesis(aj1_vidro,hypothesis.matrix=c(0,0,0,0,1,1,0,0))
# 300:170x180
linearHypothesis(aj1_vidro,hypothesis.matrix=c(0,0,0,0,1,0,1,0))
# 350:170x180
linearHypothesis(aj1_vidro,hypothesis.matrix=c(0,0,0,0,1,0,0,1))
# 170:200x250
linearHypothesis(aj1_vidro,hypothesis.matrix=c(0,1,0,0,0,0,0,0))
# 170:200x300
linearHypothesis(aj1_vidro,hypothesis.matrix=c(0,0,1,0,0,0,0,0))
# 170:200x350
linearHypothesis(aj1_vidro,hypothesis.matrix=c(0,0,0,1,0,0,0,0))
# 170:250x300
linearHypothesis(aj1_vidro,hypothesis.matrix=c(0,1,-1,0,0,0,0,0))
# 170:250x350
linearHypothesis(aj1_vidro,hypothesis.matrix=c(0,1,0,-1,0,0,0,0))
# 170:300x350
linearHypothesis(aj1_vidro,hypothesis.matrix=c(0,0,1,-1,0,0,0,0))

# 180:200x250
linearHypothesis(aj1_vidro,hypothesis.matrix=c(0,1,0,0,0,1,0,0))
# 180:200x300
linearHypothesis(aj1_vidro,hypothesis.matrix=c(0,0,1,0,0,0,1,0))
# 180:200x350
linearHypothesis(aj1_vidro,hypothesis.matrix=c(0,0,0,1,0,0,0,1))
# 180:250x300
linearHypothesis(aj1_vidro,hypothesis.matrix=c(0,1,-1,0,0,1,-1,0))
# 180:250x350
linearHypothesis(aj1_vidro,hypothesis.matrix=c(0,1,0,-1,0,1,0,-1))
# 180:300x350
linearHypothesis(aj1_vidro,hypothesis.matrix=c(0,0,1,-1,0,0,1,-1))

# Envelope
fit.model <- aj1_vidro
source("G:/Meu Drive/Gustavo3/ufscar/pós-graduação/disciplinas/GLM/201501/dados e programas/envelope_gama.R")
#fit.model <- aj2_vidro
#source("G:/Meu Drive/Gustavo3/ufscar/pós-graduação/disciplinas/GLM/201501/dados e programas/envelope_ginv.R")

#########################################################################
# Exemplo 3 DADOS SIMULADOS GERADOS PARA LEA.

#library(statmod)
#rinvgauss(10,1,1)

# Leitura dos dados
investim <- read.table("G:/Meu Drive/Gustavo3/ufscar/pós-graduação/disciplinas/GLM/201501/dados e programas/investim_posit.txt", head=T, sep="")
investim

aj1_investim <- glm(invest ~ idade + factor(emprego) + factor(receb) + renda, family=Gamma(link="log"), data=investim)
summary(aj1_investim)

aj2_investim <- glm(invest ~ idade + factor(emprego) + factor(receb) + renda, family=inverse.gaussian(link="log"),data=investim)
summary(aj2_investim)

exp(coefficients(aj2_investim))


#########################################################################
# Exemplo 4. Dados reais milho

milho <- read.table("G:/Meu Drive/Gustavo3/ufscar/pós-graduação/disciplinas/GLM/201501/dados e programas/dados_milho.txt", head=T, sep="")
milho

hist(milho$FB1)
summary(milho$FB1)
plot(milho$F_vert,milho$FB1)
plot(milho$F_vert,log(milho$FB1))

aj1_milho <- glm(FB1 ~ F_vert, family=Gamma(link="log"), data=milho)
summary(aj1_milho)

aj2_milho <- glm(FB1 ~  F_vert, family=inverse.gaussian(link="log"), data=milho)
summary(aj2_milho)

aj3_milho <- glm(FB1 ~ F_vert, family=Gamma(link="identity"), data=milho)
summary(aj3_milho)

aj4_milho <- glm(FB1 ~  F_vert, family=inverse.gaussian(link="identity"), data=milho)
summary(aj4_milho)

fit.model <- aj2_milho
source("G:/Meu Drive/Gustavo3/ufscar/pós-graduação/disciplinas/GLM/201501/dados e programas/envelope_ginv.R")
fit.model <- aj4_milho
source("G:/Meu Drive/Gustavo3/ufscar/pós-graduação/disciplinas/GLM/201501/dados e programas/envelope_ginv_ident.R")
fit.model <- aj1_milho
source("G:/Meu Drive/Gustavo3/ufscar/pós-graduação/disciplinas/GLM/201501/dados e programas/envelope_gama.R")

##########################################################
# EXEMPLO 5: DADOS GERIATRA - Exer 5 Cap 4 Gilberto.

geriatra <- read.table("G:/Meu Drive/Gustavo3/ufscar/pós-graduação/disciplinas/GLM/201501/dados e programas/dados_geriatra.txt", head=T, sep="")
geriatra

# An?lise descritiva
plot(geriatra$balanco,geriatra$quedas)
plot(geriatra$forca,geriatra$quedas)

library(doBy)
summaryBy(quedas~factor(interv)+factor(sexo), data=geriatra, FUN=c(mean, sd))

# Ajustes
aj1_geriatra <- glm(quedas ~ interv + sexo + balanco + forca, family=poisson(link="log"), data=geriatra)
summary(aj1_geriatra)

aj1b_geriatra <- glm(quedas ~ interv + sexo + balanco + forca, family=poisson(link="identity"), data=geriatra)
summary(aj1b_geriatra)

aj1c_geriatra <- glm(quedas ~ interv + sexo + balanco + forca, family=poisson(link="sqrt"), data=geriatra)
summary(aj1c_geriatra)

aj1d_geriatra <- glm(quedas ~ interv + sexo + log(balanco) + log(forca), family=poisson(link="log"), data=geriatra)
summary(aj1d_geriatra)

aj2_geriatra <- glm(quedas ~ interv + balanco + forca, family=poisson(link="log"), data=geriatra)
summary(aj2_geriatra)

#diagn?stico

X <- model.matrix(aj2_geriatra)
X
w <- aj2_geriatra$weights
W <- diag(w)

# Pontos alavanca
auxh <- solve(t(X)%*%W%*%X) 
H <- sqrt(W)%*%X%*%auxh%*%t(X)%*%sqrt(W)
h <- diag(H)
plot(fitted(aj2_geriatra),h,xlab="Valores ajustados",ylab="Alavanca")
#identify(fitted(aj2_geriatra),h,n=1)

# Res?duo deviance
aux_tdi <- resid(aj2_geriatra, type = 'deviance')
tdi <- aux_tdi*sqrt(1/(1-h))
plot(fitted(aj2_geriatra),tdi,xlab="Valores ajustados",ylab="Res?duo deviance")
#identify(fitted(aj5_energia),tdi,n=3)

# Res?duo de Pearson
aux_tsi <- resid(aj2_geriatra, type = 'pearson')
tsi <- aux_tsi*sqrt(1/(1-h))
plot(fitted(aj2_geriatra),tsi,xlab="Valores ajustados",ylab="Res?duo de Pearson")
identify(fitted(aj2_geriatra),tsi,n=2)
#plot(tdi,tsi)

# Dist?ncia de Cook
ldi <- h*(tsi^2)/(1 - h)
ldi
plot(ldi,xlab="?ndice",ylab="Dist?ncia de Cook")
identify(ldi,n=3)

# modelos sem o 37,42,52.

aj2_geriatra <- glm(quedas ~ interv + balanco + forca, family=poisson(link="log"), data=geriatra)
summary(aj2_geriatra)

aj2_geriatra_sem37_42_52 <- glm(quedas ~ interv + balanco + forca, family=poisson(link="log"), 
data=geriatra,subset=-c(37,42,52))
summary(aj2_geriatra_sem37_42_52)

aj2_geriatra_sem37 <- glm(quedas ~ interv + balanco + forca, family=poisson(link="log"), 
                                data=geriatra,subset=-c(37))
summary(aj2_geriatra_sem37)

aj2_geriatra_sem42 <- glm(quedas ~ interv + balanco + forca, family=poisson(link="log"), 
                                data=geriatra,subset=-c(42))
summary(aj2_geriatra_sem42)

aj2_geriatra_sem52 <- glm(quedas ~ interv + balanco + forca, family=poisson(link="log"), 
                                data=geriatra,subset=-c(52))
summary(aj2_geriatra_sem52)

aj3_geriatra <- glm(quedas ~ interv + balanco, family=poisson(link="log"), data=geriatra)
summary(aj3_geriatra)

fit.model <- aj2_geriatra
source("G:/Meu Drive/Gustavo3/ufscar/pós-graduação/disciplinas/GLM/201501/dados e programas/envelope_poisson.R")

fit.model <- aj3_geriatra
source("G:/Meu Drive/Gustavo3/ufscar/pós-graduação/disciplinas/GLM/201501/dados e programas/envelope_poisson.R")

#exp(coefficients(aj2_geriatra))
exp(coefficients(aj3_geriatra))

#cor(geriatra$balanco,geriatra$forca)

##########################################################
# EXEMPLO 6: DADOS CANCER - Exemplo Gilberto Cap 4 p?g 294.

cancer <- read.table("G:/Meu Drive/Gustavo3/ufscar/pós-graduação/disciplinas/GLM/201501/dados e programas/dados_cancer.txt", head=T, sep="")
cancer

cancer$morte_ano = 1000*cancer$mortes/cancer$pessoas_ano

cancer

aj1_cancer <- glm(mortes ~ offset(log(pessoas_ano)) + factor(cigarros) + factor(idade), family=poisson(link="log"), data=cancer)
summary(aj1_cancer)


fit.model <- aj1_cancer
source("G:/Meu Drive/Gustavo3/ufscar/pós-graduação/disciplinas/GLM/201501/dados e programas/envelope_poisson.R")

# para justificar que log(pessoas_ano) deve ser offset e n?o vari?vel preditora
aj2_cancer <- glm(mortes ~ log(pessoas_ano) + factor(cigarros) + factor(idade), family=poisson(link="log"), data=cancer)
summary(aj2_cancer)

(1.8388 - 1)/0.6098   

#interpreta??o
exp(coefficients(aj1_cancer))

#######################################################################
# EXEMPLO 7: DADOS TV Cabo - Exemplo Gilberto Cap 4 p?g 317.

tvcabo <- read.table("G:/Meu Drive/Gustavo3/ufscar/pós-graduação/disciplinas/GLM/201501/dados e programas/dados_tvcabo.txt", head=T, sep="")
tvcabo
tvcabo$nass1000 <- tvcabo$nass*1000

aj1_cabo <- glm(nass1000 ~ domic + taxa + custo + ncabo + ntv, family=poisson(link="log"), data=tvcabo)
summary(aj1_cabo)

fit.model <- aj1_cabo
source("G:/Meu Drive/Gustavo3/ufscar/pós-graduação/disciplinas/GLM/201501/dados e programas/envelope_poisson.R")

aj2_cabo <- glm(nass ~ domic + taxa + custo + ncabo + ntv, family=poisson(link="log"), data=tvcabo)
summary(aj2_cabo)

fit.model <- aj2_cabo
source("G:/Meu Drive/Gustavo3/ufscar/pós-graduação/disciplinas/GLM/201501/dados e programas/envelope_poisson.R")

library(MASS)
aj3_cabo <- glm.nb(nass1000 ~ domic + taxa + custo + ncabo + ntv, link="log", data=tvcabo)
summary(aj3_cabo)

fit.model <- aj3_cabo
source("G:/Meu Drive/Gustavo3/ufscar/pós-graduação/disciplinas/GLM/201501/dados e programas/envelope_negbin.R")

#cor(tvcabo$custo,tvcabo$taxa)

aj4_cabo <- glm.nb(nass1000 ~ domic + taxa, link="log", data=tvcabo)
summary(aj4_cabo)

aj5_cabo <- glm.nb(nass1000 ~ domic + custo, link="log", data=tvcabo)
summary(aj5_cabo)

aj6_cabo <- glm.nb(nass1000 ~ domic + ncabo, link="log", data=tvcabo)
summary(aj6_cabo)

aj7_cabo <- glm.nb(nass1000 ~ domic + ntv, link="log", data=tvcabo)
summary(aj7_cabo)

aj8_cabo <- glm.nb(nass1000 ~ domic, link="log", data=tvcabo)
summary(aj8_cabo)

fit.model <- aj8_cabo
source("G:/Meu Drive/Gustavo3/ufscar/pós-graduação/disciplinas/GLM/201501/dados e programas/envelope_negbin.R")

#interpreta??o
exp(coefficients(aj8_cabo))

# An?lise descritiva
plot(tvcabo$domic,tvcabo$nass1000)
plot(tvcabo$domic,log(tvcabo$nass1000))

aj9_cabo <- glm.nb(nass1000 ~ domic, link="identity", data=tvcabo)
summary(aj9_cabo)

fit.model <- aj9_cabo
source("G:/Meu Drive/Gustavo3/ufscar/pós-graduação/disciplinas/GLM/201501/dados e programas/envelope_negbin_ident.R")

aj10_cabo <- glm.nb(nass1000 ~ domic + taxa, link="identity", data=tvcabo)
summary(aj10_cabo)

aj11_cabo <- glm.nb(nass1000 ~ domic + custo, link="identity", data=tvcabo)
summary(aj11_cabo)

aj12_cabo <- glm.nb(nass1000 ~ domic + ncabo, link="identity", data=tvcabo)
summary(aj12_cabo)

aj13_cabo <- glm.nb(nass1000 ~ domic + ntv, link="identity", data=tvcabo)
summary(aj13_cabo)

aj14_cabo <- glm.nb(nass1000 ~ domic + custo + ntv, link="identity", data=tvcabo)
summary(aj14_cabo)

aj15_cabo <- glm.nb(nass1000 ~ domic + custo, link="identity", data=tvcabo)
summary(aj15_cabo)

fit.model <- aj15_cabo
source("G:/Meu Drive/Gustavo3/ufscar/pós-graduação/disciplinas/GLM/201501/dados e programas/envelope_negbin_ident.R")



#######################################################################
# EXEMPLO 8: DADOS Dengue - Exerc?cio Cap 3 Gilberto.

dengue <- read.table("G:/Meu Drive/Gustavo3/ufscar/pós-graduação/disciplinas/GLM/201501/dados e programas/dados_dengue.txt", head=T, sep="")
dengue

#An?lise descritiva
summary(factor(dengue$dengue))
tab1 <- table(dengue$nivel,dengue$dengue)
tab1
prop.table(tab1,1)
tab2 <- table(dengue$setor,dengue$dengue)
tab2
prop.table(tab2,1)

library(doBy)
summaryBy(idade~factor(dengue), data=dengue, FUN=c(mean, sd))


aj1_dengue <- glm(dengue ~ idade + factor(nivel) + factor(setor), family=binomial(link="logit"), data=dengue)
summary(aj1_dengue)

aj2_dengue <- glm(dengue ~ idade + factor(nivel) + factor(setor), family=binomial(link="probit"), data=dengue)
summary(aj2_dengue)

aj3_dengue <- glm(dengue ~ idade + factor(nivel) + factor(setor), family=binomial(link="cloglog"), data=dengue)
summary(aj3_dengue)

aj4_dengue <- glm(dengue ~ idade + factor(nivel) + factor(setor) + factor(nivel)*factor(setor) + idade*factor(nivel) + idade*factor(setor), family=binomial(link="logit"), data=dengue)
summary(aj4_dengue)

library(lmtest)
lrtest(aj1_dengue, aj4_dengue)

#aj5_dengue <- glm(dengue ~ idade + factor(nivel) + factor(setor) + factor(nivel)*factor(setor), family=binomial(link="logit"), data=dengue)
#summary(aj5_dengue)

#aj6_dengue <- glm(dengue ~ idade + factor(nivel) + factor(setor) + idade*factor(nivel), family=binomial(link="logit"), data=dengue)
#summary(aj6_dengue)

#aj7_dengue <- glm(dengue ~ idade + factor(nivel) + factor(setor) + idade*factor(setor), family=binomial(link="logit"), data=dengue)
#summary(aj7_dengue)

aj8_dengue <- glm(dengue ~ idade + factor(setor), family=binomial(link="logit"), data=dengue)
summary(aj8_dengue)

lrtest(aj1_dengue, aj8_dengue)

#diagn?stico

X <- model.matrix(aj8_dengue)
X
w <- aj8_dengue$weights
W <- diag(w)


# Pontos alavanca
auxh <- solve(t(X)%*%W%*%X) 
auxh
H <- sqrt(W)%*%X%*%auxh%*%t(X)%*%sqrt(W)
h <- diag(H)
plot(fitted(aj8_dengue),h,xlab="Valores ajustados",ylab="Alavanca")
#identify(fitted(aj8_dengue),h,n=3)

# Res?duo deviance
aux_tdi <- resid(aj8_dengue, type = 'deviance')
aux_fi <- summary(aj8_dengue)
fi <- 1/aux_fi$dispersion
tdi <- aux_tdi*sqrt(fi/(1-h))
plot(fitted(aj8_dengue),tdi,xlab="Valores ajustados",ylab="Res?duo deviance")
#identify(fitted(aj8_dengue),tdi,n=3)

# Res?duo de Pearson
aux_tsi <- resid(aj8_dengue, type = 'pearson')
tsi <- aux_tsi*sqrt(fi/(1-h))
plot(fitted(aj8_dengue),tsi,xlab="Valores ajustados",ylab="Res?duo de Pearson")
identify(fitted(aj8_dengue),tsi,n=3)
#plot(tdi,tsi)

# Dist?ncia de Cook
ldi <- h*(tsi^2)/(1 - h)
ldi
plot(ldi,xlab="?ndice",ylab="Dist?ncia de Cook")
identify(ldi,n=1)

#ajuste com e sem o 157
aj8_dengue <- glm(dengue ~ idade + factor(setor), family=binomial(link="logit"), data=dengue)
summary(aj8_dengue)
aj9_dengue <- glm(dengue ~ idade + factor(setor), family=binomial(link="logit"), subset=-c(157), data=dengue)
summary(aj9_dengue)

# Envelope
fit.model <- aj8_dengue
source("G:/Meu Drive/Gustavo3/ufscar/pós-graduação/disciplinas/GLM/201501/dados e programas/envelope_binom.R")

# Teste de Hosmer-Lemeshow

dengue$ajust <- fitted(aj8_dengue)

hosmerlem = function(y, yhat, g) {
  cutyhat = cut(yhat,
                breaks = quantile(yhat, probs=seq(0,
                                                  1, 1/g)), include.lowest=TRUE)
  obs = xtabs(cbind(1 - y, y) ~ cutyhat)
  expect = xtabs(cbind(1 - yhat, yhat) ~ cutyhat)
  chisq = sum((obs - expect)^2/expect)
  P = 1 - pchisq(chisq, g - 2)
  return(list(chisq=chisq,p.value=P))
}

hosmerlem(dengue$dengue,dengue$ajust,g=10)

#interpreta??o
exp(coefficients(aj8_dengue))


#######################################################################
# EXEMPLO 9: Dados Amendoim.

amendoim <- read.table("G:/Meu Drive/Gustavo3/ufscar/pós-graduação/disciplinas/GLM/201501/dados e programas/dados_amendoim.txt", head=T, sep="")
amendoim

amendoim$qt_flavus <- with(amendoim, cbind(qtd_flavus,qtdn_flavus))

aj1_amend <- glm(qt_flavus ~ factor(regi) + duinst + Aa_cascap + flavus_cascap, family=binomial(link="logit"), data=amendoim)
summary(aj1_amend)

aj2_amend <- glm(qt_flavus ~ factor(regi) + duinst + Aa_cascap + flavus_cascap, family=binomial(link="probit"), data=amendoim)
summary(aj2_amend)

aj3_amend <- glm(qt_flavus ~ factor(regi) + duinst + Aa_cascap + flavus_cascap, family=binomial(link="cloglog"), data=amendoim)
summary(aj3_amend)

# Envelope
fit.model <- aj1_amend
source("G:/Meu Drive/Gustavo3/ufscar/pós-graduação/disciplinas/GLM/201501/dados e programas/envelope_binom.R")

library(gamlss)
aj4_amend <- gamlss(qt_flavus ~ factor(regi) + duinst + Aa_cascap + flavus_cascap, family=BI, data=amendoim)
summary(aj4_amend)
plot(aj4_amend)

aj5_amend <- gamlss(qt_flavus ~ factor(regi) + duinst + Aa_cascap + flavus_cascap, family=BB, data=amendoim)
summary(aj5_amend)
plot(aj5_amend)

aj6_amend <- gamlss(qt_flavus ~ factor(regi) + Aa_cascap + flavus_cascap, family=BB, data=amendoim)
summary(aj6_amend)
plot(aj6_amend)

#interpreta??o
exp(coefficients(aj6_amend))

#######################################################################
# EXEMPLO 10: VOLTANDO AOS DADOS ENERGIA - Gilberto

# Leitura dos dados
energia <- read.table("G:/Meu Drive/Gustavo3/ufscar/pós-graduação/disciplinas/GLM/201501/dados e programas/dados_energia.txt", head=T, sep="")
energia

# Modelo final no exemplo 1
aj5_energia <- glm(cons_pico ~ cons_mes, family=Gamma(link="identity"), data=energia)
summary(aj5_energia)

library(gamlss)
aj10_energia <- gamlss(cons_pico ~ cons_mes, family=GA(mu.link="identity"), data=energia)
summary(aj10_energia)
plot(aj10_energia)

aj11_energia <- gamlss(cons_pico ~ cons_mes, sigma.formula =~ cons_mes, family=NO(mu.link="identity"), data=energia)
summary(aj11_energia)
plot(aj11_energia)

aj12_energia <- gamlss(cons_pico ~ cons_mes, sigma.formula =~ cons_mes, family=GA(mu.link="identity"), data=energia)
summary(aj12_energia)
plot(aj12_energia)

#######################################################################
# EXEMPLO 11: Outo banco de dados de fungo no milho.

# Leitura dos dados
fungos <- read.table("G:/Meu Drive/Gustavo3/ufscar/pós-graduação/disciplinas/GLM/201501/dados e programas/dados_fb2.txt", head=T, sep="")
fungos

# Ajuste do modelo
library(gamlss)
ajuste1a <- gamlss(FB2 ~ dias_flor + F_vert + Aa, sigma.formula =~ 1, 
                   nu.formula =~ dias_flor + F_vert + Aa, family=ZAIG,
                   data=fungos)
summary(ajuste1a)
plot(ajuste1a)

ajuste1b <- gamlss(FB2 ~ dias_flor + F_vert + Aa, sigma.formula =~ 1, 
                   nu.formula =~ dias_flor + F_vert + Aa, family=ZAGA,
                   data=fungos)
summary(ajuste1b)
plot(ajuste1b)


ajuste2 <- gamlss(FB2 ~ dias_flor + F_vert + Aa, sigma.formula =~ 1, 
                  nu.formula =~ dias_flor + F_vert + Aa, family=ZAGA,
                  data=fungos)
summary(ajuste2)
plot(ajuste2)

ajuste3 <- gamlss(FB2 ~ dias_flor + F_vert + Aa, sigma.formula =~ 1, 
                  nu.formula =~ dias_flor + F_vert, family=ZAGA,
                  data=fungos)
summary(ajuste3)


ajuste4 <- gamlss(FB2 ~ dias_flor + F_vert, sigma.formula =~ 1, 
                  nu.formula =~ dias_flor + F_vert, family=ZAGA,
                  data=fungos)
summary(ajuste4)
plot(ajuste4)

exp(ajuste4$mu.coefficients)
exp(ajuste4$nu.coefficients)



