### Exercício 1. Faça o Exercício 5 do Capítulo 5 livro de Gilberto Paula versão 2025.
Fazer uma análise de diagnóstico completa e não somente o que ele solicita.

5. Os dados do arquivo **nasal.txt** (Breslow e Day, 1987, pgs. 140-142) são provenientes de um estudo de seguimento para estudar a associação entre a taxa anual de câncer nasal em trabalhadores de uma refinaria de níquel no País de Gales e algumas variáveis explicativas: idade no primeiro emprego (4 níveis), ano do primeiro emprego (4 níveis) e tempo decorrido desde o primeiro emprego (5 níveis). São também apresentados o número de casos de câncer nasal e o total de pessoas-anos para cada combinação desses três fatores.

Para ler o arquivo no R use os comandos

`nasal = read.table("nasal.txt", header=TRUE)`

Informar que as variáveis explicativas idade, ano e tempo são fatores

`nasal$idade = factor(nasal$idade)`

Ajustar um modelo log-linear de Poisson no GAMLSS com pessoas-anos como offset

`require(gamlss)`  
`fit1.nasal = gamlss(casos ~ idade + ano + tempo + offset(log(panos)), family=PO)`  
`summary(fit1.nasal)`

Verificar através de análise de resíduos se o modelo está bem ajustado.

`plot(fit1.nasal)`  
`rqres.plot(fit1.nasal, howmany=50, plot="all")`

Se o modelo estiver bem ajustado verifique se é possível fazer agrupamentos dos níveis de alguns dos fatores. Segue abaixo exemplo de possíveis agrupamentos dos fatores tempo e ano.

`ntempo = tempo`  
`levels(ntempo) = c("0-39,9", "0-39,9", "0-39,9", "40-49,9", "50+")`

`nano = ano`  
`levels(nano) = c("1902-1919", "1902-1919", "1902-1919", "1920-1924")`

Ajustar novamente o modelo no GAMLSS com os fatores agrupados

`fit2.nasal = gamlss(casos ~ idade + nano + ntempo + offset(log(panos)), family=PO)`  
`summary(fit2.nasal)`

Verificar através de análise de resíduos se o modelo está bem ajustado.

`plot(fit2.nasal)`  
`rqres.plot(fit2.nasal, howmany=50, plot="all")`

Interpretar os resultados através do `term.plot` e das estimativas pontuais e intervalares de 95% para as razões de taxas entre os níveis de cada novo fator.

`term.plot(fit2.nasal, terms=1)`  
`term.plot(fit2.nasal, terms=2)`  
`term.plot(fit2.nasal, terms=3).`


### Exercício 2. Faça o Exercício 22 do Capítulo 5 livro de Gilberto Paula versão 2025.

22. No arquivo nitrofen.txt (Lang et al., 1994) estão descritos os dados de um experimento com uma amostra de 50 C. dubia (pequeno animal invertebrado aquático de água doce), que foram submetidos a dosagens diferentes do herbicida Nitrofen: 0, 80, 160, 235 e 310 mg/l. Para cada nível de Nitrofen 10 animais ficaram expostos e foi observado o total de ovos eclodidos após 3 ninhadas. Faça inicialmente uma análise descritiva dos dados, por exemplo um diagrama de dispersão entre o número de ovos eclodidos (tovos) contra o nível de exposição do herbicida (dose). Compare os ajustes de alguns modelos com resposta de Poisson para explicar o total de ovos eclodidos dado o nível de exposição. Escolha o melhor ajuste através de métodos de diagnóstico. Para o modelo selecionado faça uma interpretação dos coeficientes estimados.


### Exercício 3. Faça o Exercício 7 do Capítulo 5 livro de Gilberto Paula versão 2025.

Não é necessário ajustar o modelo de quase-verossimilhança.

7. No arquivo rolos.txt (Hinde, 1982) são apresentados os dados referentes à produção de peças de tecido numa determinada fábrica. Na primeira coluna tem-se o comprimento da peça (em metros) e na segunda coluna o número de falhas. Faça inicialmente um gráfico do número de falhas contra o comprimento da peça. Ajuste um modelo log-linear de Poisson apropriado. Faça uma análise de resíduos e verifique se há indícios de sobredispersão. Em caso afirmativo ajuste um modelo de quase-verossimilhança e um modelo log-linear com distribuição binomial negativa. Interprete os resultados pelas razões de médias \(\mu(x + 1)/\mu(x)\), em que \(x\) denota o comprimento da peça.

### Exercício 4. Faça o Exercício 10 do Capítulo 4 livro de Gilberto Paula versão 2025.

10. Os dados abaixo (Collett, 1991, p.127) são provenientes de um experimento desenvolvido para avaliar a germinação de um determinado tipo de semente segundo três condições experimentais: nível da temperatura (21°C, 42°C e 62°C); nível da umidade (baixo, médio e alto) e temperatura da germinação (11°C e 21°C). A tabela abaixo apresenta o número de sementes que germinaram após cinco dias para cada 100 sementes submetidas a cada condição experimental.

Assume um modelo logístico para explicar o número de sementes que germinaram. Aplique o método AIC para selecionar um modelo considerando interações de 1ª ordem. Interprete os resultados. Faça uma análise de resíduos com o modelo selecionado. Esses dados estão descritos no arquivo sementes.txt.

| Temperatura da Germinação | Nível da Umidade | Nível da 21°C | Nível da 42°C | Nível da 62°C |
| :--- | :--- | :--- | :--- | :--- |
| 11°C | baixo | 98 | 96 | 62 |
| 11°C | médio | 94 | 79 | 3 |
| 11°C | alto | 92 | 41 | 1 |
| 21°C | baixo | 94 | 93 | 65 |
| 21°C | médio | 94 | 71 | 2 |
| 21°C | alto | 91 | 30 | 1 |

#### Exercício 5. Faça o Exercício 21 do Capítulo 4 livro de Gilberto Paula versão 2025.

Usar AIC ao invés de teste de hipóteses como critério no Stepwise.

21. Os dados do arquivo leuce.txt (Everitt, 1994) referem-se a um estudo com 51 pacientes adultos, previamente diagnosticados com um tipo agudo de leucemia, que receberam um tipo de tratamento e foi verificado após um certo período a eficiência ou não do tratamento. Algumas variáveis explicativas pré-tratamento foram também observadas. As variáveis em estudo são as seguintes: (i) idade do paciente na época do diagnóstico (em anos), (ii) mancha diferencial da doença (em %), (iii) infiltração na medula (em %), (iv) células com leucemia na medula (em %), (v) malignidade da doença (×10³), (vi) temperatura máxima antes do tratamento (×10°F), (vii) tratamento (1: satisfatório, 0: não satisfatório), (viii) tempo de sobrevivência após o diagnóstico (em meses) e (ix) situação (1: sobrevivente, 0: não sobrevivente). Considere um modelo logístico linear para explicar a probabilidade de eficiência do tratamento dadas as seis variáveis explicativas. Selecionar as variáveis explicativas bem como as interações de primeira ordem através do método *stepwise*. Usar \(P_E = P_S = 0,20\). Fazer uma análise de diagnóstico com o modelo selecionado e interpretar algumas razões de chances.

#### Exercício 6. Faça o Exercício 24 do Capítulo 4 livro de Gilberto Paula versão 2025.

Não é preciso fazer o Anodev.

Além do que está descrito no exercício fazer adicionalmente os itens abaixo.

d) Faça uma análise de diagnóstico completa. O modelo parece adequado?

e) Indepedente da sua resposta no item anterior, ajuste um modelo de regressão beta binomial, obtenha um modelo final, faça uma análise de diagnóstico oompleta e interprete as estimativas dos parâmetros do modelo.

24. No arquivo **grahani.txt** (McCullagh e Nelder, 1989, pgs. 128-135) estão os dados referentes à distribuição de duas espécies de lagarto (grahani e opalinus) segundo quatro fatores: (i) período do dia (manhã, meio-dia, tarde), (ii) comprimento da madeira (curta, comprida), (iii) largura da madeira (estreita, larga) e (iv) local de ocupação (claro, escuro). Supor que o número de lagartos encontrados da espécie grahani tenha distribuição binomial. Responda às seguintes questões: (i) proponha um modelo logístico (sem interação) para explicar a proporção de lagartos da espécie grahani. Ajuste o modelo e verifique através do teste da razão de verossimilhanças quais efeitos são significativos ao nível de 10%. (ii) Verifique separadamente se cada interação de primeira ordem pode ser incluída no modelo ao nível de 5%. Construa o ANODEV. (iii) Interprete os resultados tentando falar de uma forma não técnica sobre as preferências dos dois tipos de lagarto.