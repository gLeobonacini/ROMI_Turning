# Regressão Logística Multinomial Utilizada para Identificação de Condição de Usinagem

Este repositório contém os arquivos utilizados para o artigo intitulado "Cutting Parameters and Material Classification Using Multinomial Logistic Regression".

Para coleta dos dados, realizou-se experimentos na máquina CNC ROMI Centur 30D e com a ferramenta de corte da empresa Tungaloy cujo código é TNMG160408R-C
NS530.

O diagrama de blocos do sistema de monitoramento utilizado nos experimentos está apresentado ao término deste parágrafo. Para maior detalhamento deste sistema, acessar a dissertação intitulada "Sistema dedicado de aquisição de dados para obtenção de assinaturas de processo em torno CNC" disponível em: https://www.teses.usp.br/teses/disponiveis/18/18145/tde-04122019-143055/pt-br.php.

![fig2_art](https://user-images.githubusercontent.com/70539330/160392804-7a7cc871-de73-4894-add2-7be941f71b67.png)

A Regressão Logística Multinomial é utilizada para obter probabilidade de eventos, conforme a equação descrita a seguir:

![equation](https://user-images.githubusercontent.com/70539330/160395369-b5b8dbc8-26b2-41d2-be0b-6e3f007bd40c.gif)
