# 1ª Prova: Modelos Lineares Generalizados
**Data:** 23/10/2018

---

## Exercício 1 (2,0 pontos)

Seja $y$ uma variável aleatória com distribuição cuja função de probabilidade é dada por:

$$f(y; \mu) = \frac{\mu^{y}}{(\mu+1)^{y+1}}$$

para $\mu > 0$ e $y = 0, 1, 2, \dots$

- **(a)** *(1,0 ponto)* Mostre que a distribuição de $y$ pertence à família exponencial linear, apresentando cada um dos termos de sua função de probabilidade no formato da família exponencial linear.
- **(b)** *(1,0 ponto)* Encontre $E(y)$ e $Var(y)$ em função de $\mu$.

---

## Exercício 2 (2,50 pontos)

Um pesquisador está interessado em comparar o número médio de filhos em determinada região em função do grau de escolaridade da mãe observada em apenas 2 níveis: **superior/pós-graduação** e **outros**. Inicialmente ele pegou uma amostra piloto de 6 mulheres com idade entre 40 e 45 anos. 

- Entre as 3 mulheres da amostra com grau de escolaridade superior/pós-graduação, o número de filhos observado na amostra foi $1, 2, 1$.
- Já entre as 3 mulheres com outro grau de escolaridade, o número de filhos observado na amostra foi $3, 1, 2$.

O pesquisador irá considerar um modelo linear generalizado dado por $g(\mu_i) = \beta_0 + \beta_1 x_i$, em que $x_i = 1$ se a mulher $i$ tem grau de escolaridade superior/pós-graduação e $x_i = 0$ caso contrário.

- **(a)** *(0,25 ponto)* Entre as distribuições Normal, Gama, Gaussiana Inversa, Poisson e Binomial, qual delas você escolheria para a distribuição da variável resposta? Justifique sua resposta.
- **(b)** *(1,50 ponto)* Considere o modelo mencionado, sendo que a distribuição da variável resposta é a mais adequada dentre as apresentadas no item (a) e a função de ligação é a canônica. Utilizando o método de mínimos quadrados ponderados iterativos para a estimação de $\beta_0$ e $\beta_1$ a partir da amostra piloto, obtém-se no passo 1 do processo iterativo:
  
  $$\hat{\beta}_0 = 0,7805 \quad \text{e} \quad \hat{\beta}_1 = -0,4339$$
  
  A partir desses valores, apresente a matriz $W$ e o vetor $z$ que são usados para obter $\hat{\beta}_0$ e $\hat{\beta}_1$ no passo seguinte do processo iterativo. Para economizar tempo, se quiser, apresente a matriz $W$ e o vetor $z$ apenas como o produto de outros vetores e matrizes, e apresente os valores em cada posição desses vetores e matrizes usados para obter $W$ e $z$.
- **(c)** *(0,75 ponto)* Para os dados da amostra piloto, para qual valor aproximadamente deverá convergir $\hat{\beta}_0$ e $\hat{\beta}_1$? Justifique sua resposta (não é necessário fazer o processo iterativo até a convergência para responder a essa questão).

---

## Exercício 3 (1,50 ponto)

Suponha que $y_i$ tem distribuição Bernoulli com parâmetro $\mu_i$. Considere o modelo:

$$\log\left(\frac{\mu_i}{1 - \mu_i}\right) = \beta_0 + \beta_1 x_i$$

em que $x_i$ é o valor para a observação $i$ de uma determinada variável preditora quantitativa. Considere que será retirada uma amostra de tamanho $n$ e considere $\bar{y}$ e $\bar{x}$, respectivamente, a média amostral da variável resposta e da variável preditora. 

Considerando-se o teste $H_0: \beta_1 = 0 \times H_1: \beta_1 \neq 0$, pode-se mostrar que, sob $H_0: \beta_1 = 0$, o estimador de máxima verossimilhança de $\beta_0$ é:

$$\hat{\beta}_0 = \log\left(\frac{\bar{y}}{1 - \bar{y}}\right)$$

Sabe-se ainda que a estatística escore para testar $H_0: \beta_1 = 0 \times H_1: \beta_1 \neq 0$ é dada pelo produto de 3 termos. Mostre que o primeiro desses termos é dado por:

$$\sum_{i=1}^{n} x_i (y_i - \bar{y})$$

---

## Exercício 4 (4,0 pontos)

Um pesquisador está estudando a média da distância percorrida em um teste físico de 12 minutos entre homens sedentários com idade entre 30 e 34 anos em função de duas variáveis: **IMC** (Índice de Massa Corporal) e **Grupo de Sedentarismo**:
- **A:** Trabalha predominantemente em pé;
- **B:** Trabalha entre 25% e 50% do tempo em pé;
- **C:** Trabalha menos de 25% do tempo em pé.

Para a realização do estudo, ele coletou uma amostra de 60 indivíduos, sendo 20 de cada grupo de sedentarismo. Considere que será ajustado um modelo assumindo distribuição Gama para a variável resposta e função de ligação logarítmica.

- **(a)** *(0,5 ponto)* Apresente o modelo para este problema considerando interação entre as variáveis preditoras disponíveis. Quais seriam as hipóteses em termos dos parâmetros do modelo para testar se há ou não interação entre as variáveis preditoras?

*Para fazer os demais itens, considere que testou-se inicialmente se havia ou não interação e concluiu-se não haver evidências de que haja interação. Ajustou-se assim um modelo sem interação. Gráficos de diagnóstico para o modelo sem interação são apresentados em anexo, bem como resultados do modelo com todas as variáveis preditoras e do modelo sem a variável qualitativa.*

- **(b)** *(0,75 ponto)* Parece haver pontos de alavanca? Justifique sua resposta. Parece haver observações discrepantes? Justifique sua resposta. Parece haver observações influentes? Justifique sua resposta. Caso tenha respondido sim em pelo menos uma das perguntas deste item, o que você faria em relação a esses pontos?
- **(c)** *(0,4 ponto)* Baseado nos gráficos apresentados, parece haver algum problema com as suposições do modelo? Justifique sua resposta.
- **(d)** *(0,35 ponto)* Interprete em termos do problema em questão a exponencial da estimativa que foi igual a -0,52 no problema em questão.
- **(e)** *(0,9 ponto)* Teste a hipótese de que a média da variável distância percorrida no teste de 12 minutos varia em função do grupo de sedentarismo considerando um nível de significância de 1%.
- **(f)** *(0,75 ponto)* Construa um intervalo de confiança com 90% de confiança para a exponencial do parâmetro cuja estimativa foi igual a -0,06 e interprete o intervalo obtido em termos do problema em questão.
- **(g)** *(0,35 ponto)* De forma geral (não apenas para esse conjunto de dados), suponha que você já identificou que uma das distribuições da família exponencial é adequada para a variável resposta que você está trabalhando. Para decidir entre algumas possíveis funções de ligação, você decide usar o AIC. A função de ligação que você escolher baseada no AIC é a mesma que você escolheria caso usasse o BIC? Justifique sua resposta.

---

## Anexos: Gráficos e Saídas de Software (Exercício 4)

### Descrição dos Gráficos de Diagnóstico (Dispostos em uma grade 2x2)

1. **Gráfico Superior Esquerdo (Alavancagem / H-values):**
   - **Eixo X:** Valores ajustados (variando de 1000 a 2500).
   - **Eixo Y:** Alavanca (h-values, variando de 0.05 a 0.11).
   - **Descrição:** Mostra a medida de alavancagem de cada ponto em relação aos valores ajustados. A maioria dos pontos está concentrada abaixo de 0.09, mas há alguns pontos isolados na parte superior com valores próximos a 0.11.

2. **Gráfico Superior Direito (Resíduos Pearson):**
   - **Eixo X:** Valores ajustados (1000 a 2500).
   - **Eixo Y:** Resíduo de Pearson (variando de -2 a 4).
   - **Descrição:** Gráfico de dispersão dos resíduos de Pearson versus valores ajustados. A maioria dos resíduos está distribuída de forma homogênea entre -2 e 2, porém destaca-se uma observação discrepante (outlier) na parte superior do gráfico, atingindo o valor de resíduo próximo a 4 (para um valor ajustado perto de 1500).

3. **Gráfico Inferior Esquerdo (Resíduos Deviance / Desvio):**
   - **Eixo X:** Valores ajustados (1000 a 2500).
   - **Eixo Y:** Resíduo Deviance (variando de -2 a 2).
   - **Descrição:** Gráfico dos resíduos deviance versus valores ajustados, acompanhado de linhas de tendência (curvas envelope/loess). Os pontos estão espalhados simetricamente ao redor do zero, sem padrão de funil visível.

4. **Gráfico Inferior Direito (Normal Q-Q Plot dos Resíduos):**
   - **Eixo X:** Percentis da $N(0,1)$ (de -2 a 2).
   - **Eixo Y:** Componente do Desvio (de -3 a 3).
   - **Descrição:** Gráfico QQ para checagem de normalidade dos resíduos de desvio com bandas de confiança. Os pontos alinham-se muito bem sobre a linha diagonal central, caindo quase em sua totalidade dentro do envelope simulado, exceto por um ponto discrepante na extremidade inferior esquerda.

---

### Saídas de Ajuste do Modelo (R Output)

#### Modelo 1: Modelo Completo (IMC + Grupo de Sedentarismo)

```text
Coefficients:
            Estimate  Std. Error  t value  Pr(>|t|)    
(Intercept)  9.280626    0.093663    99.08   < 2e-16 ***
imc         -0.062597    0.003456   -18.11   < 2e-16 ***
grupoB      -0.251589    0.023247   -10.82  2.41e-15 ***
grupoC      -0.523534    0.023374   -22.40   < 2e-16 ***
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

(Dispersion parameter for Gamma family taken to be 0.005363563)

    Null deviance: 5.33990  on 59  degrees of freedom
Residual deviance: 0.29304  on 56  degrees of freedom
AIC: 739.19
```

#### Modelo 2: Modelo Reduzido (Apenas IMC)

```text
Coefficients:
            Estimate  Std. Error  t value  Pr(>|t|)    
(Intercept)  9.29380     0.28687   32.398  < 2e-16 ***
imc         -0.07176     0.01050   -6.836 5.53e-09 ***
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

(Dispersion parameter for Gamma family taken to be 0.05044265)

    Null deviance: 5.3399  on 59  degrees of freedom
Residual deviance: 2.9726  on 58  degrees of freedom
AIC: 874.65
```