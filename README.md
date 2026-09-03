# Perda da Certificação de Erradicação do Sarampo em 2019
Banco de dados relacional (MySQL)  voltado para  cruzar dados de notificações de Sarampo, índices de cobertura vacinal e o fluxo de imigração por município e ano. O objetivo principal é fornecer inteligência de dados para identificar correlações entre vulnerabilidade vacinal, movimentação migratória, para  chegar na causa raiz do porquê da perda da Certificação de Erradicação do Sarampo em 2019.
Os dados irão vir do DATASUS  Tecnologia da Informação a Serviço do SUS e https://www.datamigra.unb.br

## Integrantes da Equipe
* Marcelo Theodoro de Aguiar

## 🚀 Funcionalidades e Análises Suportadas
O modelo de dados foi planejado para responder a perguntas críticas de saúde pública, tais como:
*   **Análise de Vulnerabilidade:** Identificar se municípios que não atingiram as metas de vacinação registraram um aumento subsequente no número de casos notificados.
*   **Impacto Migratório:** Monitorar o volume de imigrantes por país de origem e avaliar sua correlação com o cenário epidemiológico local.
*   **Cálculo de Proporção:** Gerar relatórios que calculam automaticamente a taxa de casos notificados por habitante imigrante.
   
## 📐 Estrutura do Banco de Dados (Modelagem)
Os requisitos pensandos para iniciar a modelagem de dados:
•	Coleta de dados de Agravo de Notificação (Comunicação obrigatória de uma doença) FEV2016/FEV2024
•	Coleta de dados de Cobertura Vacinal (Cobertura vacinal é o percentual de pessoas de um determinado grupo ou população que recebeu as doses recomendadas de uma vacina específica) FEV2016/FEV2024
•	Fluxo Migratório e Reintrodução do Vírus

O banco é composto por 4 tabelas principais interconectadas, aplicando restrições rígidas de integridade referencial e travas contra duplicidade através de chaves únicas compostas:

1.  **`municipios`**: Cadastro oficial dos municípios com sigla da Unidade Federativa (UF), região geográfica e código oficial de 7 dígitos do IBGE.
##### Tabela: `municipios`

| Atributo | Tipo de Dado | Chave | Nulo? | Descrição / Finalidade | Observações & Boas Práticas |
| :--- | :--- | :---: | :---: | :--- | :--- |
| **id_municipio** | INT | PK | Não | Identificador único e exclusivo de cada município no sistema. | Chave primária gerada sequencialmente via auto-incremento. |
| **nome_municipio** | VARCHAR(100) | - | Não | Nome oficial do município. | Armazena o texto completo do nome da cidade. |
| **estado** | CHAR(2) | - | Não | Sigla da Unidade Federativa (UF) do município. | O uso de CHAR(2) garante economia de espaço e padronização (ex: SP, RJ). |
| **regiao** | VARCHAR(20) | - | Não | Região geográfica à qual o município pertence. | Padronizado via validação ou interface (ex: Sudeste, Nordeste). |
| **codigo_ibge** | VARCHAR(7) | - | Não | Código oficial de 7 dígitos do IBGE que identifica o município. | Configurado como UNIQUE para evitar cadastros duplicados do mesmo município. |

  
2.  **`notificacoes`**: Registro anual consolidado do número de casos notificados por município. Possui trava de valor não-negativo.

##### Tabela: `notificacoes`

| Atributo | Tipo de Dado | Chave | Nulo? | Descrição / Finalidade | Observações & Boas Práticas |
| :--- | :--- | :---: | :---: | :--- | :--- |
| **id_notificacao** | INT | PK | Não | Código identificador único do registro de notificação. | Chave primária de auto-incremento. |
| **id_municipio** | INT | FK | Não | Código do município onde as notificações foram registradas. | Chave Estrangeira conectada a `municipios(id_municipio)`. |
| **ano_notificacao** | INT | - | Não | Ano civil em que os casos foram notificados. | Armazena apenas o ano em formato YYYY (ex: 2026). |
| **numero_casos** | INT | - | Não | Quantidade consolidada de casos notificados para o município e ano. | Possui restrição `CHECK` para garantir valores maior ou igual a zero. |

*Nota de consistência: Possui uma restrição `UNIQUE (id_municipio, ano_notificacao)` para evitar duplicidade de anos no mesmo município.*


3.  **`imigracao`**: Histórico volumétrico anual de indivíduos imigrantes recebidos por município, detalhado por país de origem.
##### Tabela: `imigracao`

| Atributo | Tipo de Dado | Chave | Nulo? | Descrição / Finalidade | Observações & Boas Práticas |
| :--- | :--- | :---: | :---: | :--- | :--- |
| **id_imigracao** | INT | PK | Não | Código identificador único do registro imigratório. | Chave primária de auto-incremento. |
| **id_municipio** | INT | FK | Não | Código do município de destino do fluxo de imigrantes. | Chave Estrangeira conectada a `municipios(id_municipio)`. |
| **ano_imigracao** | INT | - | Não | Ano do registro de fluxo migratório. | Armazena apenas o ano em formato YYYY. |
| **pais_origem** | VARCHAR(50) | - | Não | Nome do país de origem dos imigrantes. | Identifica a nacionalidade do fluxo de entrada. |
| **quantidade_imigrantes** | INT | - | Não | Quantidade de indivíduos imigrantes registrados daquela origem. | Possui restrição `CHECK` para garantir valores estritamente maiores que zero. |

*Nota de consistência: Possui uma restrição `UNIQUE (id_municipio, ano_imigracao, pais_origem)` para evitar registros redundantes do mesmo país no mesmo ano e cidade.*


4.  **`cobertura_vacinal`**: Índices percentuais de vacinação da 1ª dose (D1) e 2ª dose (D2), com validação de limite (0.00% a 100.00%) e indicador lógico de cumprimento de meta.

##### Tabela: `cobertura_vacinal`

| Atributo | Tipo de Dado | Chave | Nulo? | Descrição / Finalidade | Observações & Boas Práticas |
| :--- | :--- | :---: | :---: | :--- | :--- |
| **id_cobertura** | INT | PK | Não | Código identificador único do registro de cobertura vacinal. | Chave primária de auto-incremento. |
| **id_municipio** | INT | FK | Não | Código do município ao qual os dados de cobertura pertencem. | Chave Estrangeira conectada a `municipios(id_municipio)`. |
| **ano_cobertura** | INT | - | Não | Ano de referência dos índices vacinais cadastrados. | Armazena apenas o ano em formato YYYY. |
| **cobertura_d1** | DECIMAL(5,2) | - | Não | Percentual de cobertura alcançado para a 1ª Dose (D1). | Restrição `CHECK` garante valores válidos apenas entre 0.00 e 100.00. |
| **cobertura_d2** | DECIMAL(5,2) | - | Não | Percentual de cobertura alcançado para a 2ª Dose (D2). | Restrição `CHECK` garante valores válidos apenas entre 0.00 e 100.00. |
| **atingiu_meta** | BOOLEAN | - | Não | Indicador lógico se o município alcançou a meta estipulada. | Armazena de forma binária (True/False) o sucesso da campanha. |

*Nota de consistência: Possui uma restrição `UNIQUE (id_municipio, ano_cobertura)` para garantir um único histórico de imunização por ano para cada localidade.*

### Regras de Negócio Implementadas (Restrições)
*   **Consistência Temporal:** Uso de chaves compostas para garantir que cada município possua apenas um registro de notificação e um registro de cobertura vacinal por ano, evitando dados duplicados.
*   **Qualidade do Dado:** Validações via restrição `CHECK` para impedir a inserção de dados impossíveis (ex: quantidade de imigrantes menor ou igual a zero ou coberturas vacinais acima de 100%).

## 🛠️ Tecnologias Utilizadas

*   **Linguagem:** SQL (Structured Query Language)
*   **Padrão de Modelagem:** Modelo Relacional (Chaves Primárias e Estrangeiras)
*   **Compatibilidade:** Desenvolvido seguindo padrões amplamente aceitos por SGBDs como MySQL, MariaDB e PostgreSQL.



