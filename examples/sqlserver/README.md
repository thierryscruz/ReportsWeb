# Exemplos SQL Server — Vendas e Estoque

Guia passo a passo para configurar o banco de demonstração do **ReportsWeb** usando SQL Server.

---

## 📋 Pré-requisitos

- SQL Server 2014+ (ou SQL Server Express / Azure SQL)
- SSMS (SQL Server Management Studio) ou Azure Data Studio
- Permissão para criar bancos de dados e tabelas

---

## 🚀 Passo 1 — Criar o banco e o schema

Abra o **SSMS**, conecte-se à sua instância e execute:

```
01_schema.sql
```

Este script irá:
- Criar o banco `ReportsWebDemo`
- Criar as tabelas: `REGIOES`, `FILIAIS`, `VENDEDORES`, `CLIENTES`, `FORNECEDORES`, `CATEGORIAS`, `PRODUTOS`, `VENDAS`, `ITENS_VENDA`, `MOVIMENTO_ESTOQUE`
- Criar os índices de performance

**Estrutura das tabelas:**

```
REGIOES ──< FILIAIS ──< VENDEDORES
                │
                └──< VENDAS ──< ITENS_VENDA ──> PRODUTOS ──> CATEGORIAS
                                                    │
                                                    └──> FORNECEDORES
                                                    └──< MOVIMENTO_ESTOQUE
CLIENTES ──< VENDAS
```

---

## 🌱 Passo 2 — Carregar dados fictícios

Execute o script de carga:

```
02_seed_data.sql
```

Serão gerados:

| Tabela | Registros |
|---|---|
| Regiões | 8 |
| Filiais | 10 |
| Vendedores | 15 |
| Clientes | 35 |
| Fornecedores | 10 |
| Categorias | 10 |
| Produtos | 40 |
| Vendas | ~300 |
| Itens de Venda | ~1.500 |
| Movimento de Estoque | ~600+ |

---

## ⚙️ Passo 3 — Configurar o ReportsWeb

Edite o arquivo `web.config` na pasta do executável:

```xml
<environmentVariable name="DB_TYPE"        value="sqlserver" />
<environmentVariable name="MSSQL_SERVER"   value=".\SQLEXPRESS" />
<environmentVariable name="MSSQL_DATABASE" value="ReportsWebDemo" />
<environmentVariable name="MSSQL_USER"     value="sa" />
<environmentVariable name="MSSQL_PASSWORD" value="SUA_SENHA" />
```

> **Dica:** Para autenticação Windows (sem usuário/senha), use `Trusted_Connection`:
> ```xml
> <environmentVariable name="MSSQL_TRUSTED" value="yes" />
> ```

---

## 📊 Passo 4 — Importar os SQLs dos Relatórios

Cada relatório do ReportsWeb precisa ter seu SQL configurado na área de administração.
O arquivo `03_reports_queries.sql` contém os SQLs prontos para os 28 relatórios.

**Como importar:**

1. Acesse o ReportsWeb com `admin` / `admin123`
2. Vá em **Administração → Relatórios**
3. Clique em **Editar** no relatório desejado (ex: Relatório 1)
4. Cole o SQL correspondente do arquivo `03_reports_queries.sql`
5. Clique em **Detectar Colunas** — o sistema importa automaticamente
6. Configure os **filtros** conforme a tabela abaixo
7. Salve e teste

---

## 🔍 Mapa de Relatórios e Filtros

| # | Nome | Categoria | Filtros |
|---|---|---|---|
| 1 | Resumo de Vendas por Período | Vendas | `data_inicio`, `data_fim` |
| 2 | Vendas por Vendedor | Vendas | `data_inicio`, `data_fim` |
| 3 | Vendas por Cliente (Top) | Vendas | `data_inicio`, `data_fim` |
| 4 | Vendas por Filial e Região | Vendas | `data_inicio`, `data_fim` |
| 5 | Detalhamento de Itens por Venda | Vendas | `num_venda` |
| 6 | Produtos Mais Vendidos | Produtos | `data_inicio`, `data_fim` |
| 7 | Produtos por Categoria | Produtos | `id_categoria` (opcional) |
| 8 | Posição de Estoque Atual | Estoque | — |
| 9 | Produtos Abaixo do Mínimo | Estoque | — |
| 10 | Movimentação de Estoque | Estoque | `data_inicio`, `data_fim`, `id_produto` |
| 11 | Curva ABC de Produtos | Produtos | `data_inicio`, `data_fim` |
| 12 | Vendas Canceladas e Devolvidas | Vendas | `data_inicio`, `data_fim` |
| 13 | Margem de Lucro por Produto | Financeiro | `data_inicio`, `data_fim` |
| 14 | Clientes Inativos | Clientes | `dias_sem_compra` |
| 15 | Caderno de Clientes | Clientes | `ativo`, `uf` |
| 16 | Ranking de Vendedores | Vendas | `data_inicio`, `data_fim` |
| 17 | Vendedores Ativos | Cadastro | — |
| 18 | Vendedores Demitidos | Cadastro | — |
| 19 | Posição de Estoque por Fornecedor | Estoque | — |
| 20 | Faturamento Mensal | Financeiro | `ano` |
| 21 | Vendas em Aberto (a Faturar) | Vendas | — |
| 22 | Valor Total do Estoque | Estoque | — |
| 23 | Produtos sem Movimento | Estoque | `dias_sem_movimento` |
| 24 | Comissões por Filial/Vendedor | Financeiro | `data_inicio`, `data_fim` |
| 25 | Vendas por Forma de Pagamento | Financeiro | `data_inicio`, `data_fim` |
| 26 | Vendas por Dia da Semana | Vendas | `data_inicio`, `data_fim` |
| 27 | Comparativo Anual de Vendas | Financeiro | `ano_atual` |
| 28 | Filiais e Regiões | Cadastro | — |

---

## 💡 Dicas

- **Parâmetros opcionais**: Para tornar um filtro opcional, o SQL usa `(:param IS NULL OR coluna = :param)`. Configure o filtro como não-obrigatório no ReportsWeb.
- **Datas**: O SQL aceita formato `YYYY-MM-DD` que os campos de data do ReportsWeb enviam automaticamente.
- **Exportação**: Todos os relatórios suportam export para Excel com um clique.
- **Impressão**: Use o botão "Imprimir" para uma versão formatada com logo e rodapé da empresa.

---

## 🔗 Recursos

- [Documentação do ReportsWeb](../../README.md)
- [Download do HttpPlatformHandler](https://www.iis.net/downloads/microsoft/httpplatformhandler)
- [SQL Server Express (gratuito)](https://www.microsoft.com/pt-br/sql-server/sql-server-downloads)
