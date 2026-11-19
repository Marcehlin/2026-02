# 1. Fixando os parâmetros verdadeiros
mu_true <- 5.0
alpha_true <- 2.0
n_simulations <- 1000
sample_sizes <- c(30, 100, 500, 1000)

# Fixando a semente para reprodutibilidade (equivalente a não ter no Python, mas boa prática no R)
set.seed(123) 

# Função para estimar alpha dado mu (usando uniroot)
estimate_alpha <- function(x, mu_hat) {
  x_bar <- mean(x)
  log_x_bar <- mean(log(x))
  
  # Resolver: ln(alpha) - digamma(alpha) - (ln(mu) - 1 - log_x_bar + x_bar/mu) = 0
  target <- log(mu_hat) - 1 - log_x_bar + x_bar / mu_hat
  
  func <- function(a) log(a) - digamma(a) - target
  
  # A função uniroot busca a raiz em um intervalo. 
  # O Python usou bracket=[1e-5, 1000], então fazemos o mesmo aqui.
  res <- uniroot(func, interval = c(1e-5, 1000))
  return(res$root)
}

# Simulação de Monte Carlo
# Criando listas para armazenar os resultados (equivalente ao dicionário do Python)
results_mu <- list()
results_alpha <- list()

for (n in sample_sizes) {
  # Pré-alocando vetores para performance
  mu_estimates <- numeric(n_simulations)
  alpha_estimates <- numeric(n_simulations)
  
  for (i in 1:n_simulations) {
    # Gerar dados (scale = mu/alpha para a parametrização do R)
    x <- rgamma(n, shape = alpha_true, scale = mu_true / alpha_true)
    
    # Estimação
    mu_hat <- mean(x)
    alpha_hat <- estimate_alpha(x, mu_hat)
    
    mu_estimates[i] <- mu_hat
    alpha_estimates[i] <- alpha_hat
  }
  
  # Armazenando os resultados usando o tamanho amostral 'n' como nome (string)
  results_mu[[as.character(n)]] <- mu_estimates
  results_alpha[[as.character(n)]] <- alpha_estimates
}

# Avaliação de performance (Viés e MSE)
cat(sprintf("%-6s | %-10s | %-10s | %-12s | %-10s\n", "n", "Viés mu", "MSE mu", "Viés alpha", "MSE alpha"))
cat(paste(rep("-", 60), collapse = ""), "\n")

for (n in sample_sizes) {
  mu_arr <- results_mu[[as.character(n)]]
  alpha_arr <- results_alpha[[as.character(n)]]
  
  bias_mu <- mean(mu_arr) - mu_true
  mse_mu <- mean((mu_arr - mu_true)^2)
  
  bias_alpha <- mean(alpha_arr) - alpha_true
  mse_alpha <- mean((alpha_arr - alpha_true)^2)
  
  # Imprimindo formatado com sprintf (equivalente ao f-string do Python)
  cat(sprintf("%-6d | %-10.4f | %-10.4f | %-12.4f | %-10.4f\n", 
              n, bias_mu, mse_mu, bias_alpha, mse_alpha))
}
