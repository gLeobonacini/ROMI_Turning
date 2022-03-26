##############################################################################
#                   REGRESSÃO LOGÍSTICA MULTINOMIAL                          #
##############################################################################

# Leitura da base de dados
df <- read.csv("ROMI_Turning_Data.csv")

# Gerando dados de amplitude
df$amp.x <- df$aceleracaoMaxima - df$aceleracaoMinima
df$amp.mu <- df$audioMaximo - df$audioMinimo
df$experimento <- as.factor(df$experimento)

# Data frame com variáveis no domínio do tempo
df.t <- df[,c(33,9,34,10,31,32)]
colnames(df.t) <- c('amp.x','rms.x','amp.mu','rms.mu','theta',
                    'experimento')

# Data frame com variáveis no domínio da frequência
df.f <- df[,c(16,17,18,26,27,28,32)]
colnames(df.f) <- c('f1.x','f2.x','f3.x','f1.mu','f2.mu','f3.mu',
                    'experimento')

# Data frame com variáveis no domínio do tempo e da frequência
df.tf <- df[,c(33,9,34,10,31,16,17,18,26,27,28,32)]
colnames(df.tf) <- c('amp.x','rms.x','amp.mu','rms.mu','theta',
                    'f1.x','f2.x','f3.x','f1.mu','f2.mu','f3.mu',
                    'experimento')

# Matriz de correlação de Pearson entre variáveis
chart.Correlation(df.tf[1:11], histogram=TRUE, pch=19)

# Matriz de correlação de Pearson entre variáveis por grupo de experimento
ggpairs(df.tf, columns = colnames(df.tf)[1:11], aes(colour = experimento)) + 
  scale_colour_manual(values = c('#fde725','#a0da39',
                                 '#4ac16d','#1fa187',
                                 '#277f8e','#365c8d',
                                 '#46327e','#440154')) + 
  scale_fill_manual(values = c('#fde725','#a0da39',
                               '#4ac16d','#1fa187',
                               '#277f8e','#365c8d',
                               '#46327e','#440154')) +
  theme_bw()

# Colocando como referência o experimento 'f025 ap100 ac'
df.t$experimento <- relevel(df.t$experimento, 
                            ref = "f025 ap100 ac")
df.f$experimento <- relevel(df.f$experimento, 
                            ref = "f025 ap100 ac")
df.tf$experimento <- relevel(df.tf$experimento, 
                             ref = "f025 ap100 ac")

## Estimação dos modelos

# Tempo Total
modelo.t <- multinom(formula = experimento ~ ., 
                     data = df.t)
# Tempo Stepwise
modelo.step.t <- step(modelo.t,
                      k = qchisq(p = 0.05, df = 1, lower.tail = FALSE))

# Frequência Total
modelo.f <- multinom(formula = experimento ~ ., 
                    data = df.f)
# Frequência Stepwise
modelo.step.f <- step(modelo.f,
                      k = qchisq(p = 0.05, df = 1, lower.tail = FALSE))

# Tempo-Frequência Total
modelo.tf <- multinom(formula = experimento ~ ., 
                      data = df.tf)
# Tempo-Frequência Stepwise
modelo.step.tf <- step(modelo.tf,
                       k = qchisq(p = 0.05, df = 1, lower.tail = FALSE))

# Comparando os modelos no domínio do tempo
export_summs(modelo.t,modelo.step.t)
logLik(modelo.t)
logLik(modelo.step.t)

# Comparando os modelos no domínio da frequência
export_summs(modelo.f,modelo.step.f)
logLik(modelo.f)
logLik(modelo.step.f)

# Comparando os modelos no domínio do tempo
export_summs(modelo.tf,modelo.step.tf)
logLik(modelo.tf)
logLik(modelo.step.tf)

# Teste de Hipótese de Razão de Verossimilhança
lrtest(modelo.t,modelo.step.t)
lrtest(modelo.f,modelo.step.f)
lrtest(modelo.tf,modelo.step.tf)

## Intercepto e coeficientes para
# Domínio do tempo
summary(modelo.step.t)$coefficients
# Domínio da frequência
summary(modelo.step.f)$coefficients
# Domínio do tempo-frequência
summary(modelo.step.tf)$coefficients

# Predições utilizando todos os modelos
# Modelo Total - Tempo
df.t$pred.model.total <- predict(modelo.t, 
                         newdata = df.t, 
                         type = "class")
# Modelo Stepwise - Tempo
df.t$pred.model.stepwise <- predict(modelo.step.t, 
                           newdata = df.t, 
                           type = "class")

# Modelo Total - Frequência
df.f$pred.model.total <- predict(modelo.f, 
                           newdata = df.f, 
                           type = "class")
# Modelo Stepwise - Frequência
df.f$pred.model.stepwise <- predict(modelo.step.f, 
                           newdata = df.f, 
                           type = "class")

# Modelo Total - Tempo-Frequência
df.tf$pred.model.total <- predict(modelo.tf, 
                           newdata = df.tf, 
                           type = "class")
# Modelo Stepwise - Tempo-Frequência
df.tf$pred.model.stepwise <- predict(modelo.step.tf, 
                            newdata = df.tf, 
                            type = "class")

## Matriz de Confusão de cada modelo
# Modelo Tempo
MC.Total.t <- as.data.frame.matrix(table(df.t$experimento,df.t$pred.model.total))
MC.Stepwise.t <- as.data.frame.matrix(table(df.t$experimento,df.t$pred.model.stepwise))

# Modelo Frequência
MC.Total.f <- as.data.frame.matrix(table(df.f$experimento,df.f$pred.model.total))
MC.Stepwise.f <- as.data.frame.matrix(table(df.f$experimento,df.f$pred.model.stepwise))

# Modelo Tempo-Frequência
MC.Total.tf <- as.data.frame.matrix(table(df.tf$experimento,df.tf$pred.model.total))
MC.Stepwise.tf <- as.data.frame.matrix(table(df.tf$experimento,df.tf$pred.model.stepwise))

# Apresentando a matriz de confusão
# Modelo Tempo
MC.Total.t %>%
  kable() %>%
  kable_styling(bootstrap_options = "striped", 
                full_width = F, 
                font_size = 22)
MC.Stepwise.t %>%
  kable() %>%
  kable_styling(bootstrap_options = "striped", 
                full_width = F, 
                font_size = 22)

# Modelo Frequência
MC.Total.f %>%
  kable() %>%
  kable_styling(bootstrap_options = "striped", 
                full_width = F, 
                font_size = 22)
MC.Stepwise.f %>%
  kable() %>%
  kable_styling(bootstrap_options = "striped", 
                full_width = F, 
                font_size = 22)

# Modelo Tempo-Frequência
MC.Total.tf %>%
  kable() %>%
  kable_styling(bootstrap_options = "striped", 
                full_width = F, 
                font_size = 22)
MC.Stepwise.tf %>%
  kable() %>%
  kable_styling(bootstrap_options = "striped", 
                full_width = F, 
                font_size = 22)

## Acurácia dos modelos:
# Data frame com as acurácias
acuracia <- data.frame(Total.t = round((sum(diag(table(df.t$experimento, df.t$pred.model.total))) / 
                                          sum(table(df.t$experimento, df.t$pred.model.total))), 4),
                       Stepwise.t = round((sum(diag(table(df.t$experimento, df.t$pred.model.stepwise))) / 
                                              sum(table(df.t$experimento, df.t$pred.model.stepwise))), 4),
                       Total.f = round((sum(diag(table(df.f$experimento, df.f$pred.model.total))) / 
                                             sum(table(df.f$experimento, df.f$pred.model.total))), 4),
                       Stepwise.f = (round((sum(diag(table(df.f$experimento, df.f$pred.model.stepwise))) / 
                                           sum(table(df.f$experimento, df.f$pred.model.stepwise))), 4)),
                       
                       Total.tf = round((sum(diag(table(df.tf$experimento, df.tf$pred.model.total))) / 
                                           sum(table(df.tf$experimento, df.tf$pred.model.total))), 4),
                       Stepwise.tf = round((sum(diag(table(df.tf$experimento, df.tf$pred.model.stepwise))) / 
                                              sum(table(df.tf$experimento, df.tf$pred.model.stepwise))), 4),
                       row.names = c('Modelos'))