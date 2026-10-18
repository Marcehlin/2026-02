# Fixe o tamanho do amostra em n e a semente de aleatorização em um valor qualquer.
from matplotlib.pylab import exp, seed

seed(1002)
n1 = 10

# Gere uma variável aleatória com distribuição de Bernoulli com parâmetro igual a 0,6 (X1) uma variável aleatória com distribuição uniforme no intervalo (0, 1) (X2).

from numpy.random import binomial, uniform

X1 = binomial(n=1, p=0.6, size=n1)
X2 = uniform(low=0, high=1, size=n1)

# Gere a variável resposta a partir da distribuição Gama com parâmetros µi = exp(2,3 + 0, 4xi1) e phi = 1

from numpy.random import gamma

phi = 1
mu = exp(2.3 + 0.4 * X1)

Y = gamma(shape = phi, scale = mu / phi, size = n1)

# Repita o passos anterior 1000 vezes
# para uma das 1000 amostras de tamanho n, obtenha o valor das estatísticas da razão de verossimilhanças, escore, 
# Wald e gradiente para testar beta2 = 0 e verifique se rejeitamos ou não a hipótese nula de acordo com cada uma das estatísticas (use α = 5%).

for i in range(1000):
    X1 = binomial(n=1, p=0.6, size=n1)
    X2 = uniform(low=0, high=1, size=n1)
    mu = exp(2.3 + 0.4 * X1)
    Y = gamma(shape = phi, scale = mu / phi, size = n1)
    # Calcule as estatísticas para cada amostra
    Qrv = 1# Calcule a estatística da razão de verossimilhanças
    Qsc = 1# Calcule a estatística do escore
    Qwd = 1# Calcule a estatística de Wald
    Qgd = 1# Calcule a estatística do gradiente

