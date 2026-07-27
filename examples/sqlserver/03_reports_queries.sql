-- ============================================================
--  ReportsWeb — Exemplo SQL Server
--  03_reports_queries.sql  ·  SQL dos 28 Relatórios
--  Domínio: Vendas e Estoque
--
--  Como usar no ReportsWeb:
--    1. Faça login como admin
--    2. Vá em Administração → Relatórios
--    3. Clique em "Editar" no relatório desejado
--    4. Cole o SQL correspondente no campo "Consulta SQL"
--    5. Clique em "Detectar Colunas" para importar automaticamente
--    6. Configure os filtros e salve
--
--  IMPORTANTE: Parâmetros usam :nome  (dois pontos + nome sem espaço)
--              O sistema converte automaticamente para o formato do banco.
-- ============================================================

USE ReportsWebDemo;
GO

-- ────────────────────────────────────────────────────────────────────────────
-- RELATÓRIO 1 — Resumo de Vendas por Período
-- Categoria: Vendas | Filtros: :data_inicio, :data_fim
-- ────────────────────────────────────────────────────────────────────────────
-- Cole este SQL no Relatório 1:
SELECT
    CAST(v.DATA_VENDA AS DATE)              AS DATA,
    f.NOME                                  AS FILIAL,
    COUNT(DISTINCT v.ID_VENDA)             AS QTD_VENDAS,
    SUM(CASE WHEN v.STATUS = 'FATURADA'  THEN 1 ELSE 0 END) AS FATURADAS,
    SUM(CASE WHEN v.STATUS = 'CANCELADA' THEN 1 ELSE 0 END) AS CANCELADAS,
    SUM(CASE WHEN v.STATUS = 'DEVOLVIDA' THEN 1 ELSE 0 END) AS DEVOLVIDAS,
    SUM(CASE WHEN v.STATUS = 'FATURADA'  THEN v.VALOR_TOTAL ELSE 0 END) AS VALOR_FATURADO,
    SUM(CASE WHEN v.STATUS = 'ABERTA'    THEN v.VALOR_TOTAL ELSE 0 END) AS VALOR_EM_ABERTO
FROM dbo.VENDAS v
JOIN dbo.FILIAIS f ON f.ID_FILIAL = v.ID_FILIAL
WHERE v.DATA_VENDA >= :data_inicio
  AND v.DATA_VENDA <  DATEADD(DAY, 1, CAST(:data_fim AS DATE))
GROUP BY CAST(v.DATA_VENDA AS DATE), f.NOME
ORDER BY CAST(v.DATA_VENDA AS DATE), f.NOME;

-- ────────────────────────────────────────────────────────────────────────────
-- RELATÓRIO 2 — Vendas por Vendedor
-- Categoria: Vendas | Filtros: :data_inicio, :data_fim
-- ────────────────────────────────────────────────────────────────────────────
SELECT
    vend.NOME                              AS VENDEDOR,
    f.NOME                                 AS FILIAL,
    COUNT(DISTINCT v.ID_VENDA)            AS QTD_VENDAS,
    SUM(v.VALOR_TOTAL)                    AS VALOR_TOTAL,
    ROUND(SUM(v.VALOR_TOTAL) * vend.COMISSAO_PERC / 100, 2) AS COMISSAO_ESTIMADA,
    vend.COMISSAO_PERC                    AS PERC_COMISSAO
FROM dbo.VENDAS v
JOIN dbo.VENDEDORES vend ON vend.ID_VENDEDOR = v.ID_VENDEDOR
JOIN dbo.FILIAIS    f    ON f.ID_FILIAL      = v.ID_FILIAL
WHERE v.DATA_VENDA >= :data_inicio
  AND v.DATA_VENDA <  DATEADD(DAY, 1, CAST(:data_fim AS DATE))
  AND v.STATUS NOT IN ('CANCELADA')
GROUP BY vend.NOME, f.NOME, vend.COMISSAO_PERC
ORDER BY SUM(v.VALOR_TOTAL) DESC;

-- ────────────────────────────────────────────────────────────────────────────
-- RELATÓRIO 3 — Vendas por Cliente (Top Clientes)
-- Categoria: Vendas | Filtros: :data_inicio, :data_fim
-- ────────────────────────────────────────────────────────────────────────────
SELECT
    c.RAZAO_SOCIAL                         AS CLIENTE,
    c.CIDADE                               AS CIDADE,
    c.UF                                   AS UF,
    COUNT(DISTINCT v.ID_VENDA)            AS QTD_PEDIDOS,
    SUM(v.VALOR_TOTAL)                    AS VALOR_TOTAL,
    AVG(v.VALOR_TOTAL)                    AS TICKET_MEDIO
FROM dbo.VENDAS v
JOIN dbo.CLIENTES c ON c.ID_CLIENTE = v.ID_CLIENTE
WHERE v.DATA_VENDA >= :data_inicio
  AND v.DATA_VENDA <  DATEADD(DAY, 1, CAST(:data_fim AS DATE))
  AND v.STATUS NOT IN ('CANCELADA')
GROUP BY c.RAZAO_SOCIAL, c.CIDADE, c.UF
ORDER BY SUM(v.VALOR_TOTAL) DESC;

-- ────────────────────────────────────────────────────────────────────────────
-- RELATÓRIO 4 — Vendas por Filial e Região
-- Categoria: Vendas | Filtros: :data_inicio, :data_fim
-- ────────────────────────────────────────────────────────────────────────────
SELECT
    r.NOME                                 AS REGIAO,
    r.UF                                   AS UF,
    f.NOME                                 AS FILIAL,
    COUNT(DISTINCT v.ID_VENDA)            AS QTD_VENDAS,
    SUM(v.VALOR_TOTAL)                    AS VALOR_TOTAL,
    SUM(CASE WHEN v.STATUS='FATURADA' THEN v.VALOR_TOTAL ELSE 0 END) AS FATURADO,
    SUM(CASE WHEN v.STATUS='CANCELADA' THEN 1 ELSE 0 END) AS CANCELADAS
FROM dbo.VENDAS v
JOIN dbo.FILIAIS f ON f.ID_FILIAL = v.ID_FILIAL
JOIN dbo.REGIOES r ON r.ID_REGIAO = f.ID_REGIAO
WHERE v.DATA_VENDA >= :data_inicio
  AND v.DATA_VENDA <  DATEADD(DAY, 1, CAST(:data_fim AS DATE))
GROUP BY r.NOME, r.UF, f.NOME
ORDER BY r.NOME, SUM(v.VALOR_TOTAL) DESC;

-- ────────────────────────────────────────────────────────────────────────────
-- RELATÓRIO 5 — Detalhamento de Itens por Venda
-- Categoria: Vendas | Filtros: :num_venda
-- ────────────────────────────────────────────────────────────────────────────
SELECT
    v.NUMERO                               AS NUM_VENDA,
    CAST(v.DATA_VENDA AS DATE)            AS DATA_VENDA,
    c.RAZAO_SOCIAL                         AS CLIENTE,
    p.CODIGO                               AS COD_PRODUTO,
    p.DESCRICAO                            AS PRODUTO,
    p.UNIDADE                              AS UNIDADE,
    iv.QUANTIDADE                          AS QUANTIDADE,
    iv.PRECO_UNITARIO                      AS PRECO_UNIT,
    iv.DESCONTO_PERC                       AS DESCONTO_PCT,
    iv.VALOR_TOTAL                         AS VALOR_ITEM,
    v.STATUS                               AS STATUS_VENDA
FROM dbo.ITENS_VENDA iv
JOIN dbo.VENDAS   v ON v.ID_VENDA   = iv.ID_VENDA
JOIN dbo.CLIENTES c ON c.ID_CLIENTE = v.ID_CLIENTE
JOIN dbo.PRODUTOS p ON p.ID_PRODUTO = iv.ID_PRODUTO
WHERE v.NUMERO = :num_venda
ORDER BY iv.ID_ITEM;

-- ────────────────────────────────────────────────────────────────────────────
-- RELATÓRIO 6 — Produtos Mais Vendidos
-- Categoria: Produtos | Filtros: :data_inicio, :data_fim
-- ────────────────────────────────────────────────────────────────────────────
SELECT
    p.CODIGO                               AS CODIGO,
    p.DESCRICAO                            AS PRODUTO,
    cat.NOME                               AS CATEGORIA,
    p.UNIDADE                              AS UNIDADE,
    SUM(iv.QUANTIDADE)                    AS QTD_VENDIDA,
    SUM(iv.VALOR_TOTAL)                   AS VALOR_TOTAL,
    AVG(iv.PRECO_UNITARIO)                AS PRECO_MEDIO
FROM dbo.ITENS_VENDA iv
JOIN dbo.VENDAS   v   ON v.ID_VENDA      = iv.ID_VENDA
JOIN dbo.PRODUTOS p   ON p.ID_PRODUTO    = iv.ID_PRODUTO
JOIN dbo.CATEGORIAS cat ON cat.ID_CATEGORIA = p.ID_CATEGORIA
WHERE v.DATA_VENDA >= :data_inicio
  AND v.DATA_VENDA <  DATEADD(DAY, 1, CAST(:data_fim AS DATE))
  AND v.STATUS NOT IN ('CANCELADA')
GROUP BY p.CODIGO, p.DESCRICAO, cat.NOME, p.UNIDADE
ORDER BY SUM(iv.QUANTIDADE) DESC;

-- ────────────────────────────────────────────────────────────────────────────
-- RELATÓRIO 7 — Produtos por Categoria
-- Categoria: Produtos | Filtros: :id_categoria (opcional)
-- ────────────────────────────────────────────────────────────────────────────
SELECT
    cat.NOME                               AS CATEGORIA,
    p.CODIGO                               AS CODIGO,
    p.DESCRICAO                            AS PRODUTO,
    p.UNIDADE                              AS UNIDADE,
    p.PRECO_CUSTO                          AS PRECO_CUSTO,
    p.PRECO_VENDA                          AS PRECO_VENDA,
    ROUND((p.PRECO_VENDA - p.PRECO_CUSTO) / NULLIF(p.PRECO_CUSTO,0) * 100, 2) AS MARGEM_PCT,
    p.ESTOQUE_ATUAL                        AS ESTOQUE,
    p.ESTOQUE_MINIMO                       AS ESTOQUE_MIN,
    p.ATIVO                                AS ATIVO
FROM dbo.PRODUTOS p
JOIN dbo.CATEGORIAS cat ON cat.ID_CATEGORIA = p.ID_CATEGORIA
WHERE (:id_categoria IS NULL OR p.ID_CATEGORIA = :id_categoria)
ORDER BY cat.NOME, p.DESCRICAO;

-- ────────────────────────────────────────────────────────────────────────────
-- RELATÓRIO 8 — Posição de Estoque Atual
-- Categoria: Estoque | Sem filtros
-- ────────────────────────────────────────────────────────────────────────────
SELECT
    cat.NOME                               AS CATEGORIA,
    p.CODIGO                               AS CODIGO,
    p.DESCRICAO                            AS PRODUTO,
    p.UNIDADE                              AS UNIDADE,
    p.ESTOQUE_ATUAL                        AS ESTOQUE_ATUAL,
    p.ESTOQUE_MINIMO                       AS MINIMO,
    p.ESTOQUE_MAXIMO                       AS MAXIMO,
    CASE
        WHEN p.ESTOQUE_ATUAL <= 0               THEN 'SEM ESTOQUE'
        WHEN p.ESTOQUE_ATUAL < p.ESTOQUE_MINIMO THEN 'ABAIXO DO MÍNIMO'
        WHEN p.ESTOQUE_ATUAL > p.ESTOQUE_MAXIMO THEN 'ACIMA DO MÁXIMO'
        ELSE 'NORMAL'
    END                                    AS SITUACAO,
    ROUND(p.ESTOQUE_ATUAL * p.PRECO_CUSTO, 2) AS VALOR_ESTOQUE
FROM dbo.PRODUTOS p
JOIN dbo.CATEGORIAS cat ON cat.ID_CATEGORIA = p.ID_CATEGORIA
WHERE p.ATIVO = 'S'
ORDER BY cat.NOME, p.DESCRICAO;

-- ────────────────────────────────────────────────────────────────────────────
-- RELATÓRIO 9 — Produtos Abaixo do Estoque Mínimo
-- Categoria: Estoque | Sem filtros
-- ────────────────────────────────────────────────────────────────────────────
SELECT
    cat.NOME                               AS CATEGORIA,
    p.CODIGO                               AS CODIGO,
    p.DESCRICAO                            AS PRODUTO,
    p.UNIDADE                              AS UNIDADE,
    p.ESTOQUE_ATUAL                        AS ESTOQUE_ATUAL,
    p.ESTOQUE_MINIMO                       AS MINIMO,
    p.ESTOQUE_MINIMO - p.ESTOQUE_ATUAL    AS FALTA_PARA_MINIMO,
    f.RAZAO_SOCIAL                         AS FORNECEDOR,
    f.TELEFONE                             AS TEL_FORNECEDOR,
    f.PRAZO_ENTREGA                        AS PRAZO_ENTREGA_DIAS
FROM dbo.PRODUTOS p
JOIN dbo.CATEGORIAS  cat ON cat.ID_CATEGORIA  = p.ID_CATEGORIA
LEFT JOIN dbo.FORNECEDORES f ON f.ID_FORNECEDOR = p.ID_FORNECEDOR
WHERE p.ATIVO = 'S'
  AND p.ESTOQUE_ATUAL < p.ESTOQUE_MINIMO
ORDER BY (p.ESTOQUE_MINIMO - p.ESTOQUE_ATUAL) DESC;

-- ────────────────────────────────────────────────────────────────────────────
-- RELATÓRIO 10 — Movimentação de Estoque por Período
-- Categoria: Estoque | Filtros: :data_inicio, :data_fim, :id_produto
-- ────────────────────────────────────────────────────────────────────────────
SELECT
    CAST(me.DATA_MOVIMENTO AS DATE)       AS DATA,
    p.CODIGO                               AS COD_PRODUTO,
    p.DESCRICAO                            AS PRODUTO,
    me.TIPO                                AS TIPO_MOVIMENTO,
    me.QUANTIDADE                          AS QUANTIDADE,
    me.CUSTO_UNITARIO                      AS CUSTO_UNIT,
    me.QUANTIDADE * me.CUSTO_UNITARIO     AS VALOR_TOTAL,
    me.DOCUMENTO                           AS DOCUMENTO,
    me.OBSERVACAO                          AS OBSERVACAO
FROM dbo.MOVIMENTO_ESTOQUE me
JOIN dbo.PRODUTOS p ON p.ID_PRODUTO = me.ID_PRODUTO
WHERE me.DATA_MOVIMENTO >= :data_inicio
  AND me.DATA_MOVIMENTO <  DATEADD(DAY, 1, CAST(:data_fim AS DATE))
  AND (:id_produto IS NULL OR me.ID_PRODUTO = :id_produto)
ORDER BY me.DATA_MOVIMENTO DESC;

-- ────────────────────────────────────────────────────────────────────────────
-- RELATÓRIO 11 — Curva ABC de Produtos
-- Categoria: Produtos | Filtros: :data_inicio, :data_fim
-- ────────────────────────────────────────────────────────────────────────────
WITH ranked AS (
    SELECT
        p.CODIGO,
        p.DESCRICAO,
        cat.NOME                           AS CATEGORIA,
        SUM(iv.VALOR_TOTAL)               AS VALOR_TOTAL,
        SUM(SUM(iv.VALOR_TOTAL)) OVER ()  AS TOTAL_GERAL,
        SUM(SUM(iv.VALOR_TOTAL)) OVER (ORDER BY SUM(iv.VALOR_TOTAL) DESC
                                        ROWS UNBOUNDED PRECEDING) AS ACUMULADO
    FROM dbo.ITENS_VENDA iv
    JOIN dbo.VENDAS    v   ON v.ID_VENDA      = iv.ID_VENDA
    JOIN dbo.PRODUTOS  p   ON p.ID_PRODUTO    = iv.ID_PRODUTO
    JOIN dbo.CATEGORIAS cat ON cat.ID_CATEGORIA = p.ID_CATEGORIA
    WHERE v.DATA_VENDA >= :data_inicio
      AND v.DATA_VENDA <  DATEADD(DAY, 1, CAST(:data_fim AS DATE))
      AND v.STATUS NOT IN ('CANCELADA')
    GROUP BY p.CODIGO, p.DESCRICAO, cat.NOME
)
SELECT
    CODIGO,
    DESCRICAO                              AS PRODUTO,
    CATEGORIA,
    ROUND(VALOR_TOTAL, 2)                 AS VALOR_TOTAL,
    ROUND(VALOR_TOTAL / TOTAL_GERAL * 100, 2) AS PARTICIPACAO_PCT,
    ROUND(ACUMULADO / TOTAL_GERAL * 100, 2)   AS ACUMULADO_PCT,
    CASE
        WHEN ACUMULADO / TOTAL_GERAL <= 0.80 THEN 'A'
        WHEN ACUMULADO / TOTAL_GERAL <= 0.95 THEN 'B'
        ELSE 'C'
    END                                    AS CURVA_ABC
FROM ranked
ORDER BY VALOR_TOTAL DESC;

-- ────────────────────────────────────────────────────────────────────────────
-- RELATÓRIO 12 — Vendas Canceladas e Devolvidas
-- Categoria: Vendas | Filtros: :data_inicio, :data_fim
-- ────────────────────────────────────────────────────────────────────────────
SELECT
    v.NUMERO                               AS NUM_VENDA,
    CAST(v.DATA_VENDA AS DATE)            AS DATA_VENDA,
    v.STATUS                               AS STATUS,
    c.RAZAO_SOCIAL                         AS CLIENTE,
    vend.NOME                              AS VENDEDOR,
    f.NOME                                 AS FILIAL,
    v.VALOR_TOTAL                          AS VALOR,
    v.FORMA_PAGAMENTO                      AS FORMA_PAG,
    v.OBSERVACAO                           AS MOTIVO
FROM dbo.VENDAS v
JOIN dbo.CLIENTES   c    ON c.ID_CLIENTE   = v.ID_CLIENTE
JOIN dbo.VENDEDORES vend ON vend.ID_VENDEDOR = v.ID_VENDEDOR
JOIN dbo.FILIAIS    f    ON f.ID_FILIAL    = v.ID_FILIAL
WHERE v.DATA_VENDA >= :data_inicio
  AND v.DATA_VENDA <  DATEADD(DAY, 1, CAST(:data_fim AS DATE))
  AND v.STATUS IN ('CANCELADA','DEVOLVIDA')
ORDER BY v.DATA_VENDA DESC;

-- ────────────────────────────────────────────────────────────────────────────
-- RELATÓRIO 13 — Margem de Lucro por Produto
-- Categoria: Financeiro | Filtros: :data_inicio, :data_fim
-- ────────────────────────────────────────────────────────────────────────────
SELECT
    p.CODIGO                               AS CODIGO,
    p.DESCRICAO                            AS PRODUTO,
    cat.NOME                               AS CATEGORIA,
    SUM(iv.QUANTIDADE)                    AS QTD_VENDIDA,
    SUM(iv.QUANTIDADE * p.PRECO_CUSTO)   AS CUSTO_TOTAL,
    SUM(iv.VALOR_TOTAL)                   AS RECEITA_TOTAL,
    SUM(iv.VALOR_TOTAL) - SUM(iv.QUANTIDADE * p.PRECO_CUSTO) AS LUCRO_BRUTO,
    ROUND(
        (SUM(iv.VALOR_TOTAL) - SUM(iv.QUANTIDADE * p.PRECO_CUSTO))
        / NULLIF(SUM(iv.VALOR_TOTAL), 0) * 100, 2
    )                                      AS MARGEM_PCT
FROM dbo.ITENS_VENDA iv
JOIN dbo.VENDAS    v   ON v.ID_VENDA      = iv.ID_VENDA
JOIN dbo.PRODUTOS  p   ON p.ID_PRODUTO    = iv.ID_PRODUTO
JOIN dbo.CATEGORIAS cat ON cat.ID_CATEGORIA = p.ID_CATEGORIA
WHERE v.DATA_VENDA >= :data_inicio
  AND v.DATA_VENDA <  DATEADD(DAY, 1, CAST(:data_fim AS DATE))
  AND v.STATUS NOT IN ('CANCELADA')
GROUP BY p.CODIGO, p.DESCRICAO, cat.NOME
ORDER BY LUCRO_BRUTO DESC;

-- ────────────────────────────────────────────────────────────────────────────
-- RELATÓRIO 14 — Clientes Inativos (sem compras)
-- Categoria: Clientes | Filtros: :dias_sem_compra
-- ────────────────────────────────────────────────────────────────────────────
SELECT
    c.RAZAO_SOCIAL                         AS CLIENTE,
    c.CNPJ_CPF                             AS CNPJ_CPF,
    c.TIPO_PESSOA                          AS TIPO,
    c.CIDADE                               AS CIDADE,
    c.UF                                   AS UF,
    c.TELEFONE                             AS TELEFONE,
    c.EMAIL                                AS EMAIL,
    MAX(v.DATA_VENDA)                     AS ULTIMA_COMPRA,
    DATEDIFF(DAY, MAX(v.DATA_VENDA), GETDATE()) AS DIAS_SEM_COMPRA,
    ISNULL(SUM(v.VALOR_TOTAL), 0)         AS TOTAL_HISTORICO
FROM dbo.CLIENTES c
LEFT JOIN dbo.VENDAS v ON v.ID_CLIENTE = c.ID_CLIENTE
    AND v.STATUS NOT IN ('CANCELADA')
WHERE c.ATIVO = 'S'
GROUP BY c.RAZAO_SOCIAL, c.CNPJ_CPF, c.TIPO_PESSOA, c.CIDADE, c.UF, c.TELEFONE, c.EMAIL
HAVING MAX(v.DATA_VENDA) < DATEADD(DAY, -:dias_sem_compra, GETDATE())
    OR MAX(v.DATA_VENDA) IS NULL
ORDER BY DIAS_SEM_COMPRA DESC;

-- ────────────────────────────────────────────────────────────────────────────
-- RELATÓRIO 15 — Caderno de Clientes (Cadastro Completo)
-- Categoria: Clientes | Filtros: :ativo, :uf
-- ────────────────────────────────────────────────────────────────────────────
SELECT
    c.ID_CLIENTE                           AS ID,
    c.RAZAO_SOCIAL                         AS RAZAO_SOCIAL,
    c.NOME_FANTASIA                        AS FANTASIA,
    c.CNPJ_CPF                             AS CNPJ_CPF,
    CASE c.TIPO_PESSOA WHEN 'J' THEN 'Jurídica' ELSE 'Física' END AS TIPO,
    c.EMAIL                                AS EMAIL,
    c.TELEFONE                             AS TELEFONE,
    c.CIDADE                               AS CIDADE,
    c.UF                                   AS UF,
    c.LIMITE_CREDITO                       AS LIMITE_CREDITO,
    c.DATA_CADASTRO                        AS CADASTRO,
    CASE c.ATIVO WHEN 'S' THEN 'Ativo' ELSE 'Inativo' END AS SITUACAO
FROM dbo.CLIENTES c
WHERE (:ativo IS NULL OR c.ATIVO = :ativo)
  AND (:uf    IS NULL OR c.UF    = :uf)
ORDER BY c.RAZAO_SOCIAL;

-- ────────────────────────────────────────────────────────────────────────────
-- RELATÓRIO 16 — Ranking de Vendedores por Período
-- Categoria: Vendas | Filtros: :data_inicio, :data_fim
-- ────────────────────────────────────────────────────────────────────────────
SELECT
    ROW_NUMBER() OVER (ORDER BY SUM(v.VALOR_TOTAL) DESC) AS POSICAO,
    vend.NOME                              AS VENDEDOR,
    f.NOME                                 AS FILIAL,
    COUNT(DISTINCT v.ID_VENDA)            AS QTD_VENDAS,
    SUM(v.VALOR_TOTAL)                    AS VALOR_TOTAL,
    AVG(v.VALOR_TOTAL)                    AS TICKET_MEDIO,
    MAX(v.VALOR_TOTAL)                    AS MAIOR_VENDA,
    COUNT(DISTINCT v.ID_CLIENTE)          AS CLIENTES_ATENDIDOS
FROM dbo.VENDAS v
JOIN dbo.VENDEDORES vend ON vend.ID_VENDEDOR = v.ID_VENDEDOR
JOIN dbo.FILIAIS    f    ON f.ID_FILIAL      = v.ID_FILIAL
WHERE v.DATA_VENDA >= :data_inicio
  AND v.DATA_VENDA <  DATEADD(DAY, 1, CAST(:data_fim AS DATE))
  AND v.STATUS NOT IN ('CANCELADA')
  AND vend.ATIVO = 'S'
GROUP BY vend.NOME, f.NOME
ORDER BY SUM(v.VALOR_TOTAL) DESC;

-- ────────────────────────────────────────────────────────────────────────────
-- RELATÓRIO 17 — Vendedores Ativos
-- Categoria: Cadastro | Sem filtros
-- ────────────────────────────────────────────────────────────────────────────
SELECT
    vend.NOME                              AS VENDEDOR,
    vend.CPF                               AS CPF,
    vend.EMAIL                             AS EMAIL,
    vend.TELEFONE                          AS TELEFONE,
    f.NOME                                 AS FILIAL,
    vend.DATA_ADMISSAO                     AS ADMISSAO,
    DATEDIFF(YEAR, vend.DATA_ADMISSAO, GETDATE()) AS ANOS_EMPRESA,
    vend.COMISSAO_PERC                     AS COMISSAO_PCT,
    CASE vend.ATIVO WHEN 'S' THEN 'Ativo' ELSE 'Inativo' END AS SITUACAO
FROM dbo.VENDEDORES vend
JOIN dbo.FILIAIS f ON f.ID_FILIAL = vend.ID_FILIAL
ORDER BY f.NOME, vend.NOME;

-- ────────────────────────────────────────────────────────────────────────────
-- RELATÓRIO 18 — Vendedores com Data de Demissão
-- Categoria: Cadastro | Sem filtros
-- ────────────────────────────────────────────────────────────────────────────
SELECT
    vend.NOME                              AS VENDEDOR,
    f.NOME                                 AS FILIAL,
    vend.DATA_ADMISSAO                     AS ADMISSAO,
    vend.DATA_DEMISSAO                     AS DEMISSAO,
    DATEDIFF(DAY, vend.DATA_ADMISSAO, vend.DATA_DEMISSAO) AS DIAS_ATIVO,
    vend.COMISSAO_PERC                     AS COMISSAO_PCT
FROM dbo.VENDEDORES vend
JOIN dbo.FILIAIS f ON f.ID_FILIAL = vend.ID_FILIAL
WHERE vend.DATA_DEMISSAO IS NOT NULL
ORDER BY vend.DATA_DEMISSAO DESC;

-- ────────────────────────────────────────────────────────────────────────────
-- RELATÓRIO 19 — Posição de Estoque por Fornecedor
-- Categoria: Estoque | Sem filtros
-- ────────────────────────────────────────────────────────────────────────────
SELECT
    ISNULL(f.RAZAO_SOCIAL, '(Sem fornecedor)') AS FORNECEDOR,
    f.TELEFONE                             AS TEL_FORNECEDOR,
    cat.NOME                               AS CATEGORIA,
    p.CODIGO                               AS CODIGO,
    p.DESCRICAO                            AS PRODUTO,
    p.ESTOQUE_ATUAL                        AS ESTOQUE,
    p.ESTOQUE_MINIMO                       AS MINIMO,
    ROUND(p.ESTOQUE_ATUAL * p.PRECO_CUSTO, 2) AS VALOR_ESTOQUE,
    CASE WHEN p.ESTOQUE_ATUAL < p.ESTOQUE_MINIMO THEN 'REPOR' ELSE 'OK' END AS STATUS_REPOSICAO
FROM dbo.PRODUTOS p
JOIN dbo.CATEGORIAS cat ON cat.ID_CATEGORIA  = p.ID_CATEGORIA
LEFT JOIN dbo.FORNECEDORES f ON f.ID_FORNECEDOR = p.ID_FORNECEDOR
WHERE p.ATIVO = 'S'
ORDER BY f.RAZAO_SOCIAL, cat.NOME, p.DESCRICAO;

-- ────────────────────────────────────────────────────────────────────────────
-- RELATÓRIO 20 — Faturamento Mensal
-- Categoria: Financeiro | Filtros: :ano
-- ────────────────────────────────────────────────────────────────────────────
SELECT
    YEAR(v.DATA_VENDA)                     AS ANO,
    MONTH(v.DATA_VENDA)                    AS MES_NUM,
    DATENAME(MONTH, v.DATA_VENDA)          AS MES_NOME,
    COUNT(DISTINCT v.ID_VENDA)            AS QTD_VENDAS,
    SUM(v.VALOR_TOTAL)                    AS FATURAMENTO,
    SUM(CASE WHEN v.STATUS = 'DEVOLVIDA' THEN v.VALOR_TOTAL ELSE 0 END) AS DEVOLVIDO,
    SUM(v.VALOR_TOTAL) - SUM(CASE WHEN v.STATUS = 'DEVOLVIDA' THEN v.VALOR_TOTAL ELSE 0 END) AS LIQUIDO
FROM dbo.VENDAS v
WHERE YEAR(v.DATA_VENDA) = :ano
  AND v.STATUS != 'CANCELADA'
GROUP BY YEAR(v.DATA_VENDA), MONTH(v.DATA_VENDA), DATENAME(MONTH, v.DATA_VENDA)
ORDER BY MONTH(v.DATA_VENDA);

-- ────────────────────────────────────────────────────────────────────────────
-- RELATÓRIO 21 — Vendas em Aberto (a Faturar)
-- Categoria: Vendas | Sem filtros
-- ────────────────────────────────────────────────────────────────────────────
SELECT
    v.NUMERO                               AS NUM_VENDA,
    CAST(v.DATA_VENDA AS DATE)            AS DATA_VENDA,
    DATEDIFF(DAY, v.DATA_VENDA, GETDATE()) AS DIAS_AGUARDANDO,
    c.RAZAO_SOCIAL                         AS CLIENTE,
    vend.NOME                              AS VENDEDOR,
    f.NOME                                 AS FILIAL,
    v.FORMA_PAGAMENTO                      AS FORMA_PAG,
    v.VALOR_TOTAL                          AS VALOR_TOTAL
FROM dbo.VENDAS v
JOIN dbo.CLIENTES   c    ON c.ID_CLIENTE    = v.ID_CLIENTE
JOIN dbo.VENDEDORES vend ON vend.ID_VENDEDOR = v.ID_VENDEDOR
JOIN dbo.FILIAIS    f    ON f.ID_FILIAL     = v.ID_FILIAL
WHERE v.STATUS = 'ABERTA'
ORDER BY v.DATA_VENDA;

-- ────────────────────────────────────────────────────────────────────────────
-- RELATÓRIO 22 — Valor Total do Estoque por Categoria
-- Categoria: Estoque | Sem filtros
-- ────────────────────────────────────────────────────────────────────────────
SELECT
    cat.NOME                               AS CATEGORIA,
    COUNT(p.ID_PRODUTO)                   AS QTD_PRODUTOS,
    SUM(p.ESTOQUE_ATUAL)                  AS QTDE_TOTAL,
    ROUND(SUM(p.ESTOQUE_ATUAL * p.PRECO_CUSTO),  2) AS VALOR_CUSTO,
    ROUND(SUM(p.ESTOQUE_ATUAL * p.PRECO_VENDA),  2) AS VALOR_VENDA,
    ROUND(SUM(p.ESTOQUE_ATUAL * p.PRECO_VENDA)
        - SUM(p.ESTOQUE_ATUAL * p.PRECO_CUSTO), 2)  AS LUCRO_POTENCIAL
FROM dbo.PRODUTOS p
JOIN dbo.CATEGORIAS cat ON cat.ID_CATEGORIA = p.ID_CATEGORIA
WHERE p.ATIVO = 'S'
GROUP BY cat.NOME
ORDER BY SUM(p.ESTOQUE_ATUAL * p.PRECO_CUSTO) DESC;

-- ────────────────────────────────────────────────────────────────────────────
-- RELATÓRIO 23 — Produtos sem Movimento
-- Categoria: Estoque | Filtros: :dias_sem_movimento
-- ────────────────────────────────────────────────────────────────────────────
SELECT
    cat.NOME                               AS CATEGORIA,
    p.CODIGO                               AS CODIGO,
    p.DESCRICAO                            AS PRODUTO,
    p.ESTOQUE_ATUAL                        AS ESTOQUE,
    ROUND(p.ESTOQUE_ATUAL * p.PRECO_CUSTO, 2) AS VALOR_PARADO,
    MAX(me.DATA_MOVIMENTO)                AS ULTIMO_MOVIMENTO,
    DATEDIFF(DAY, MAX(me.DATA_MOVIMENTO), GETDATE()) AS DIAS_PARADO
FROM dbo.PRODUTOS p
JOIN dbo.CATEGORIAS cat ON cat.ID_CATEGORIA = p.ID_CATEGORIA
LEFT JOIN dbo.MOVIMENTO_ESTOQUE me ON me.ID_PRODUTO = p.ID_PRODUTO
WHERE p.ATIVO = 'S'
GROUP BY cat.NOME, p.CODIGO, p.DESCRICAO, p.ESTOQUE_ATUAL, p.PRECO_CUSTO
HAVING MAX(me.DATA_MOVIMENTO) < DATEADD(DAY, -:dias_sem_movimento, GETDATE())
    OR MAX(me.DATA_MOVIMENTO) IS NULL
ORDER BY DIAS_PARADO DESC;

-- ────────────────────────────────────────────────────────────────────────────
-- RELATÓRIO 24 — Comissões por Filial e Vendedor
-- Categoria: Financeiro | Filtros: :data_inicio, :data_fim
-- ────────────────────────────────────────────────────────────────────────────
SELECT
    f.NOME                                 AS FILIAL,
    vend.NOME                              AS VENDEDOR,
    vend.COMISSAO_PERC                     AS COMISSAO_PCT,
    COUNT(DISTINCT v.ID_VENDA)            AS QTD_VENDAS,
    SUM(v.VALOR_TOTAL)                    AS VALOR_VENDAS,
    ROUND(SUM(v.VALOR_TOTAL) * vend.COMISSAO_PERC / 100, 2) AS COMISSAO_VALOR
FROM dbo.VENDAS v
JOIN dbo.VENDEDORES vend ON vend.ID_VENDEDOR = v.ID_VENDEDOR
JOIN dbo.FILIAIS    f    ON f.ID_FILIAL      = v.ID_FILIAL
WHERE v.DATA_VENDA >= :data_inicio
  AND v.DATA_VENDA <  DATEADD(DAY, 1, CAST(:data_fim AS DATE))
  AND v.STATUS NOT IN ('CANCELADA')
GROUP BY f.NOME, vend.NOME, vend.COMISSAO_PERC
ORDER BY f.NOME, COMISSAO_VALOR DESC;

-- ────────────────────────────────────────────────────────────────────────────
-- RELATÓRIO 25 — Quantidade de Vendas por Forma de Pagamento
-- Categoria: Financeiro | Filtros: :data_inicio, :data_fim
-- ────────────────────────────────────────────────────────────────────────────
SELECT
    v.FORMA_PAGAMENTO                      AS FORMA_PAGAMENTO,
    COUNT(DISTINCT v.ID_VENDA)            AS QTD_VENDAS,
    SUM(v.VALOR_TOTAL)                    AS VALOR_TOTAL,
    ROUND(SUM(v.VALOR_TOTAL) / SUM(SUM(v.VALOR_TOTAL)) OVER () * 100, 2) AS PARTICIPACAO_PCT
FROM dbo.VENDAS v
WHERE v.DATA_VENDA >= :data_inicio
  AND v.DATA_VENDA <  DATEADD(DAY, 1, CAST(:data_fim AS DATE))
  AND v.STATUS NOT IN ('CANCELADA')
GROUP BY v.FORMA_PAGAMENTO
ORDER BY SUM(v.VALOR_TOTAL) DESC;

-- ────────────────────────────────────────────────────────────────────────────
-- RELATÓRIO 26 — Vendas por Dia da Semana
-- Categoria: Vendas | Filtros: :data_inicio, :data_fim
-- ────────────────────────────────────────────────────────────────────────────
SELECT
    DATEPART(WEEKDAY, v.DATA_VENDA)        AS DIA_SEMANA_NUM,
    DATENAME(WEEKDAY, v.DATA_VENDA)        AS DIA_SEMANA,
    COUNT(DISTINCT v.ID_VENDA)            AS QTD_VENDAS,
    SUM(v.VALOR_TOTAL)                    AS VALOR_TOTAL,
    AVG(v.VALOR_TOTAL)                    AS TICKET_MEDIO
FROM dbo.VENDAS v
WHERE v.DATA_VENDA >= :data_inicio
  AND v.DATA_VENDA <  DATEADD(DAY, 1, CAST(:data_fim AS DATE))
  AND v.STATUS NOT IN ('CANCELADA')
GROUP BY DATEPART(WEEKDAY, v.DATA_VENDA), DATENAME(WEEKDAY, v.DATA_VENDA)
ORDER BY DATEPART(WEEKDAY, v.DATA_VENDA);

-- ────────────────────────────────────────────────────────────────────────────
-- RELATÓRIO 27 — Comparativo Mensal de Vendas (Ano Atual vs. Ano Anterior)
-- Categoria: Financeiro | Filtros: :ano_atual
-- ────────────────────────────────────────────────────────────────────────────
SELECT
    MONTH(v.DATA_VENDA)                    AS MES_NUM,
    DATENAME(MONTH, v.DATA_VENDA)          AS MES_NOME,
    SUM(CASE WHEN YEAR(v.DATA_VENDA) = :ano_atual     THEN v.VALOR_TOTAL ELSE 0 END) AS ANO_ATUAL,
    SUM(CASE WHEN YEAR(v.DATA_VENDA) = :ano_atual - 1 THEN v.VALOR_TOTAL ELSE 0 END) AS ANO_ANTERIOR,
    SUM(CASE WHEN YEAR(v.DATA_VENDA) = :ano_atual     THEN v.VALOR_TOTAL ELSE 0 END)
    - SUM(CASE WHEN YEAR(v.DATA_VENDA) = :ano_atual - 1 THEN v.VALOR_TOTAL ELSE 0 END) AS VARIACAO,
    CASE
        WHEN SUM(CASE WHEN YEAR(v.DATA_VENDA) = :ano_atual - 1 THEN v.VALOR_TOTAL ELSE 0 END) = 0 THEN NULL
        ELSE ROUND(
            (SUM(CASE WHEN YEAR(v.DATA_VENDA) = :ano_atual     THEN v.VALOR_TOTAL ELSE 0 END)
           - SUM(CASE WHEN YEAR(v.DATA_VENDA) = :ano_atual - 1 THEN v.VALOR_TOTAL ELSE 0 END))
           / SUM(CASE WHEN YEAR(v.DATA_VENDA) = :ano_atual - 1 THEN v.VALOR_TOTAL ELSE 0 END) * 100
        , 2)
    END                                    AS VARIACAO_PCT
FROM dbo.VENDAS v
WHERE YEAR(v.DATA_VENDA) IN (:ano_atual, :ano_atual - 1)
  AND v.STATUS != 'CANCELADA'
GROUP BY MONTH(v.DATA_VENDA), DATENAME(MONTH, v.DATA_VENDA)
ORDER BY MONTH(v.DATA_VENDA);

-- ────────────────────────────────────────────────────────────────────────────
-- RELATÓRIO 28 — Filiais e Regiões (Cadastro)
-- Categoria: Cadastro | Sem filtros
-- ────────────────────────────────────────────────────────────────────────────
SELECT
    r.NOME                                 AS REGIAO,
    r.UF                                   AS UF,
    f.NOME                                 AS FILIAL,
    f.CNPJ                                 AS CNPJ,
    CASE f.ATIVA WHEN 'S' THEN 'Ativa' ELSE 'Inativa' END AS SITUACAO,
    COUNT(v.ID_VENDEDOR)                  AS QTD_VENDEDORES
FROM dbo.FILIAIS f
JOIN dbo.REGIOES r ON r.ID_REGIAO = f.ID_REGIAO
LEFT JOIN dbo.VENDEDORES v ON v.ID_FILIAL = f.ID_FILIAL AND v.ATIVO = 'S'
GROUP BY r.NOME, r.UF, f.NOME, f.CNPJ, f.ATIVA
ORDER BY r.NOME, f.NOME;
GO

PRINT 'Todos os 28 SQLs de relatório estão prontos para importar no ReportsWeb!';
GO
