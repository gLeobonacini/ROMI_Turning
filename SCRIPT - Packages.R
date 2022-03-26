#Pacotes utilizados
pacotes <- c('nnet','jtools','lmtest','kableExtra', 'GGally','PerformanceAnalytics')

# Verificação e Instalação dos pacotes
if(sum(as.numeric(!pacotes %in% installed.packages())) != 0){
  instalador <- pacotes[!pacotes %in% installed.packages()]
  for(i in 1:length(instalador)) {
    install.packages(instalador, dependencies = T)
    break()}
  sapply(pacotes, require, character = T) 
} else {
  sapply(pacotes, require, character = T) 
}

# Exluir objeto com os pacotes necessários
#rm(pacotes)
# Exluir objeto com os pacotes instalados
#rm(instalador)
