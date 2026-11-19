# Prova 1 - Análise de Sobrevivência e Confiabilidade

**OBSERVAÇÕES:** 
1. A prova é individual e aqueles que colarem terão **NOTA ZERO**; 
2. Todas as respostas devem ser justificadas.

---

## Exercício 1

Considere um estudo em que mulheres foram acompanhadas após a cirurgia de remoção de câncer de ovário. As variáveis utilizadas são: 
* **ID:** Identificação; 
* $V_1$: tempo do início do tratamento até a morte do paciente (em dias); 
* $V_2$: identificação de falha (censura); 
* $V_3$: tipo de tratamento (tratamento 1 ou 2); 
* $V_4$: idade (em anos); 
* $V_5$: 1 se o resíduo da doença foi parcialmente removido ou 2 se o resíduo da doença foi completamente removido; 
* $V_6$: Condição do paciente no início do estudo (1: boa ou 2: ruim).

Relate como deve ser feita a análise descritiva detalhada de forma adequada.

---

## Exercício 2

Um estudo realizado na *Mayo Clinic* com pacientes diagnosticados com carcinoma de ovário nos estágios II e IIIA teve como objetivo determinar se o grau da doença estava associado ao tempo até a progressão do tumor. As seguintes tabelas exibem os referidos tempos para os pacientes com câncer de baixo grau ou bem diferenciado e para os demais de alto grau ou indiferenciado. O símbolo $+$ indica censura.

### Dados

* **Baixo:** 
  28, 89, 175, 195, 309, $377^+$, $393^+$, $421^+$, $447^+$, 462, $709^+$, $744^+$, $770^+$, $1.106^+$, $1.206^+$

* **Alto:** 
  34, 88, 137, 199, 280, 291, $299^+$, $300^+$, 309, 351, 358, 369, 369, 370, 375, 382, 392, $429^+$, 451, $1.119^+$

---

### Questões

* **(a)** Compare os grupos utilizando a função de sobrevivência, interpretando-a.
* **(b)** Compare os grupos utilizando a função de risco acumulada, interpretando-a.
* **(c)** Foram aplicados os testes logrank, Gehan-Breslow e Tarone-Ware para a comparação das funções de sobrevivência estimadas, cujos p-valores são $0,01942$; $0,1336$ e $0,05518$, respectivamente. Explique a razão da diferença entre os resultados.

---

## Exercício 3

Um estudo foi realizado para comparar a eficácia do transplante autólogo (ou autotransplante) com a do transplante alogênico para tratamento da leucemia mieloblástica aguda. Para tal, pretendeu-se comparar o tempo livre de doença após o transplante, ou seja, o tempo até a ocorrência de recaída ou morte, aquilo que acontecer primeiro.

Ao comparar o tempo de sobrevivência livre de doença, isto é, o tempo em remissão correspondente a regimes diferentes em transplantes de medula óssea no tratamento de leucemia, é frequentemente dado um peso menor a diferenças que ocorram no início, que se devem frequentemente à toxicidade dos regimes preparatórios e dado um maior peso às diferenças que ocorrem mais tarde e que serão realmente devidas a diferenças na cura da leucemia.

Além disso, sabe-se que pacientes a quem foi feito um transplante alogênico tendem a ter mais complicações na fase inicial, sendo a mais grave a doença do enxerto contra o hospedeiro, que ocorre nos primeiros 100 dias após o transplante e é frequentemente mortal. Os pacientes a quem foi feito o outro tipo de transplante não estão obviamente em risco para esta doença e tendem a ter uma taxa de sobrevivência mais alta neste período.

Os dados do estudo referem-se a 101 pacientes com leucemia mieloblástica aguda, em que 51 pacientes receberam um autotransplante e os restantes um transplante alogênico. A Figura 1 mostra a curva de sobrevivência estimada nos dois grupos de pacientes.

---

### Figura 1: Função de Sobrevivência estimada pelo método de Kaplan-Meier

![Gráfico de Curvas de Kaplan-Meier comparando Transplante Alogênico e Autotransplante](figura1.png)

#### Descrição Acessível da Figura 1:
* **Eixo X:** Tempo (em meses), variando de 0 a 60.
* **Eixo Y:** $\hat{S}(t)$ estimada (probabilidade de sobrevivência), variando de 0,0 a 1,0.
* **Linha Tracejada (Transplante Alogênico):** Apresenta uma queda inicial mais acentuada nos primeiros meses (entre 0 e 10 meses, caindo de 1,0 para cerca de 0,55), mas estabiliza-se após aproximadamente 20 meses, mantendo um patamar constante de sobrevivência ao redor de 0,5 até o fim do acompanhamento (60 meses).
* **Linha Contínua (Autotransplante):** Apresenta queda inicial mais suave nos primeiros meses, mantendo maior taxa de sobrevivência até por volta dos 15 meses. Contudo, continua em declínio constante ao longo de todo o tempo, cruzando para baixo da curva alogênica por volta dos 20-25 meses e terminando perto de 0,2 em 60 meses.

---

Para a comparação das curvas de sobrevivência, obteve-se os seguintes resultados: 
* p-valor = $0,5368$ para o Teste log-rank;
* p-valor = $0,7556$ para o Teste de Gehan;
* p-valor = $0,9501$ para o Teste de Tarone-Ware;
* p-valor = $0,0404$ para o Teste de Fleming-Harrington com $p = 0$ e $q = 1$.

Qual é o teste adequado para ser utilizado neste problema? Justifique e interprete o seu resultado.

---

## Exercício 4

Considere que os tempos de falha são exponencialmente distribuídos com parâmetro $\lambda$.

* **(a)** Considerando censuras do tipo I à direita, obtenha o EMV ($\hat{\lambda}$) e o intervalo de confiança de nível $\gamma = 95\%$ para as funções de sobrevivência e de risco.
* **(b)** Considerando censuras do tipo II com $r$ falhas, obtenha o EMV ($\hat{\lambda}$) e o intervalo de confiança de nível $\gamma = 95\%$ para as funções de sobrevivência e de risco.

---

## Exercício 5

Um estudo foi realizado com vinte pacientes com câncer de bexiga submetidos à cirurgia de ressecção transuretral. Foram observados o tempo, em meses, desde a ressecção até a reincidência do tumor. As Figuras 2 e 3 mostram os resultados obtidos para a escolha de um modelo paramétrico.

---

### Figura 2: Resultados 1 (Gráficos Diagnósticos para Ajuste Paramétrico)

![Três gráficos de dispersão lado a lado para diagnóstico de distribuições](figura2.png)

#### Descrição Acessível da Figura 2:
A figura consiste em três gráficos de dispersão alinhados horizontalmente para avaliação da linearidade:
1. **Gráfico Esquerdo ($-\log[\hat{S}(t)]$ vs. Tempo):** Avalia a adequação da distribuição Exponencial.
   * *Eixo X:* Tempo.
   * *Eixo Y:* $-\log[\hat{S}(t)]$.
   * *Aparência:* Mostra pontos que sobem de forma aproximadamente linear a partir da origem.
2. **Gráfico Central ($\log[-\log[\hat{S}(t)]]$ vs. $\log(\text{Tempo})$):** Avalia a adequação da distribuição Weibull.
   * *Eixo X:* $\log(\text{Tempo})$.
   * *Eixo Y:* $\log[-\log[\hat{S}(t)]]$.
   * *Aparência:* Os pontos formam uma linha reta bastante clara com inclinação positiva constante.
3. **Gráfico Direito ($\Phi^{-1}[1 - \hat{S}(t)]$ vs. $\log(\text{Tempo})$):** Avalia a adequação da distribuição Log-normal.
   * *Eixo X:* $\log(\text{Tempo})$.
   * *Eixo Y:* $\Phi^{-1}[\hat{S}(t)]$.
   * *Aparência:* Apresenta pontos com tendência linear descendente bem definida.

---

### Tabela de Log-Verossimilhança

| Modelo | $\log[L(\hat{\boldsymbol{\theta}})]$ | Parâmetros Adicionais |
| :--- | :---: | :--- |
| **Gama generalizada** | $-65,69$ | |
| **Exponencial** | $-68,27$ | $\text{alpha} = 20,41176$ |
| **Weibull** | $-66,13$ | $\text{alpha} = 21,33985$; $\text{gama} = 1,549396$ |
| **Log-normal** | $-65,74$ | |

---

### Figura 3: Resultados 2 (Comparação das Curvas Ajustadas com Kaplan-Meier)

![Gráficos comparativos de Kaplan-Meier com Weibull e Log-normal](figura3.png)

#### Descrição Acessível da Figura 3:
Dois gráficos comparativos mostrando a curva em degraus de Kaplan-Meier (linha contínua) contra modelos paramétricos (linhas pontilhadas):
1. **Gráfico da Esquerda (Kaplan-Meier vs. Weibull):** 
   * A linha pontilhada da curva de sobrevivência estimada pelo modelo Weibull acompanha muito de perto toda a trajetória em degraus do estimador não paramétrico de Kaplan-Meier desde o tempo 0 até 40 meses.
2. **Gráfico da Direita (Kaplan-Meier vs. Log-normal):** 
   * A linha pontilhada do modelo Log-normal começa um pouco abaixo nos tempos iniciais e suaviza a curva ao longo do tempo, mantendo-se também próxima ao estimador de Kaplan-Meier.

---

### Questões

* **(a)** Qual(is) modelo(s) se adequa(m) aos dados? Justifique a(s) sua(s) escolha(s).
* **(b)** Utilizando o Modelo Weibull, obtenha a probabilidade estimada do paciente sobreviver aos primeiros dez meses, o tempo mediano estimado e a taxa de falha estimada aos dez meses, interpretando-os.