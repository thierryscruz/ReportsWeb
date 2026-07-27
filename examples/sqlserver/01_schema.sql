-- ============================================================
--  ReportsWeb — Exemplo SQL Server
--  01_schema.sql  ·  Criação do banco de demonstração
--  Domínio: Vendas e Estoque
--
--  Execute este script como administrador no SQL Server.
--  Compatível com: SQL Server 2014+ e Azure SQL Database
-- ============================================================

-- ─── Cria o banco de dados ────────────────────────────────
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = 'ReportsWebDemo')
BEGIN
    CREATE DATABASE ReportsWebDemo
        COLLATE Latin1_General_CI_AS;
END
GO

USE ReportsWebDemo;
GO

-- ─── Remove tabelas (se existirem) para recriar limpo ────
IF OBJECT_ID('dbo.ITENS_VENDA',      'U') IS NOT NULL DROP TABLE dbo.ITENS_VENDA;
IF OBJECT_ID('dbo.VENDAS',           'U') IS NOT NULL DROP TABLE dbo.VENDAS;
IF OBJECT_ID('dbo.MOVIMENTO_ESTOQUE','U') IS NOT NULL DROP TABLE dbo.MOVIMENTO_ESTOQUE;
IF OBJECT_ID('dbo.PRODUTOS',         'U') IS NOT NULL DROP TABLE dbo.PRODUTOS;
IF OBJECT_ID('dbo.CATEGORIAS',       'U') IS NOT NULL DROP TABLE dbo.CATEGORIAS;
IF OBJECT_ID('dbo.FORNECEDORES',     'U') IS NOT NULL DROP TABLE dbo.FORNECEDORES;
IF OBJECT_ID('dbo.CLIENTES',         'U') IS NOT NULL DROP TABLE dbo.CLIENTES;
IF OBJECT_ID('dbo.VENDEDORES',       'U') IS NOT NULL DROP TABLE dbo.VENDEDORES;
IF OBJECT_ID('dbo.FILIAIS',          'U') IS NOT NULL DROP TABLE dbo.FILIAIS;
IF OBJECT_ID('dbo.REGIOES',          'U') IS NOT NULL DROP TABLE dbo.REGIOES;
GO

-- ════════════════════════════════════════════════════════════
--  REGIÕES
-- ════════════════════════════════════════════════════════════
CREATE TABLE dbo.REGIOES (
    ID_REGIAO   INT           NOT NULL IDENTITY(1,1),
    NOME        VARCHAR(80)   NOT NULL,
    UF          CHAR(2)       NOT NULL,
    CONSTRAINT PK_REGIOES PRIMARY KEY (ID_REGIAO)
);
GO

-- ════════════════════════════════════════════════════════════
--  FILIAIS
-- ════════════════════════════════════════════════════════════
CREATE TABLE dbo.FILIAIS (
    ID_FILIAL   INT           NOT NULL IDENTITY(1,1),
    NOME        VARCHAR(120)  NOT NULL,
    CNPJ        VARCHAR(18)   NOT NULL,
    ID_REGIAO   INT           NOT NULL,
    ATIVA       CHAR(1)       NOT NULL DEFAULT 'S',
    CONSTRAINT PK_FILIAIS    PRIMARY KEY (ID_FILIAL),
    CONSTRAINT FK_FIL_REG    FOREIGN KEY (ID_REGIAO) REFERENCES dbo.REGIOES(ID_REGIAO),
    CONSTRAINT CK_FIL_ATIVA  CHECK (ATIVA IN ('S','N'))
);
GO

-- ════════════════════════════════════════════════════════════
--  VENDEDORES
-- ════════════════════════════════════════════════════════════
CREATE TABLE dbo.VENDEDORES (
    ID_VENDEDOR     INT          NOT NULL IDENTITY(1,1),
    NOME            VARCHAR(120) NOT NULL,
    CPF             VARCHAR(14)  NOT NULL,
    EMAIL           VARCHAR(120) NULL,
    TELEFONE        VARCHAR(20)  NULL,
    ID_FILIAL       INT          NOT NULL,
    DATA_ADMISSAO   DATE         NOT NULL,
    DATA_DEMISSAO   DATE         NULL,
    COMISSAO_PERC   DECIMAL(5,2) NOT NULL DEFAULT 3.00,
    ATIVO           CHAR(1)      NOT NULL DEFAULT 'S',
    CONSTRAINT PK_VENDEDORES   PRIMARY KEY (ID_VENDEDOR),
    CONSTRAINT FK_VEND_FIL     FOREIGN KEY (ID_FILIAL) REFERENCES dbo.FILIAIS(ID_FILIAL),
    CONSTRAINT CK_VEND_ATIVO   CHECK (ATIVO IN ('S','N'))
);
GO

-- ════════════════════════════════════════════════════════════
--  CLIENTES
-- ════════════════════════════════════════════════════════════
CREATE TABLE dbo.CLIENTES (
    ID_CLIENTE      INT          NOT NULL IDENTITY(1,1),
    RAZAO_SOCIAL    VARCHAR(150) NOT NULL,
    NOME_FANTASIA   VARCHAR(150) NULL,
    CNPJ_CPF        VARCHAR(18)  NOT NULL,
    TIPO_PESSOA     CHAR(1)      NOT NULL DEFAULT 'F',   -- F=Física, J=Jurídica
    EMAIL           VARCHAR(120) NULL,
    TELEFONE        VARCHAR(20)  NULL,
    CIDADE          VARCHAR(80)  NULL,
    UF              CHAR(2)      NULL,
    LIMITE_CREDITO  DECIMAL(12,2) NOT NULL DEFAULT 0.00,
    DATA_CADASTRO   DATE         NOT NULL DEFAULT GETDATE(),
    ATIVO           CHAR(1)      NOT NULL DEFAULT 'S',
    CONSTRAINT PK_CLIENTES     PRIMARY KEY (ID_CLIENTE),
    CONSTRAINT CK_CLI_TIPO     CHECK (TIPO_PESSOA IN ('F','J')),
    CONSTRAINT CK_CLI_ATIVO    CHECK (ATIVO IN ('S','N'))
);
GO

-- ════════════════════════════════════════════════════════════
--  FORNECEDORES
-- ════════════════════════════════════════════════════════════
CREATE TABLE dbo.FORNECEDORES (
    ID_FORNECEDOR   INT          NOT NULL IDENTITY(1,1),
    RAZAO_SOCIAL    VARCHAR(150) NOT NULL,
    CNPJ            VARCHAR(18)  NOT NULL,
    CONTATO         VARCHAR(80)  NULL,
    TELEFONE        VARCHAR(20)  NULL,
    EMAIL           VARCHAR(120) NULL,
    PRAZO_ENTREGA   INT          NOT NULL DEFAULT 7,   -- dias
    ATIVO           CHAR(1)      NOT NULL DEFAULT 'S',
    CONSTRAINT PK_FORNECEDORES PRIMARY KEY (ID_FORNECEDOR)
);
GO

-- ════════════════════════════════════════════════════════════
--  CATEGORIAS DE PRODUTOS
-- ════════════════════════════════════════════════════════════
CREATE TABLE dbo.CATEGORIAS (
    ID_CATEGORIA    INT         NOT NULL IDENTITY(1,1),
    NOME            VARCHAR(80) NOT NULL,
    DESCRICAO       VARCHAR(250) NULL,
    CONSTRAINT PK_CATEGORIAS PRIMARY KEY (ID_CATEGORIA)
);
GO

-- ════════════════════════════════════════════════════════════
--  PRODUTOS
-- ════════════════════════════════════════════════════════════
CREATE TABLE dbo.PRODUTOS (
    ID_PRODUTO      INT          NOT NULL IDENTITY(1,1),
    CODIGO          VARCHAR(30)  NOT NULL,
    DESCRICAO       VARCHAR(200) NOT NULL,
    UNIDADE         VARCHAR(10)  NOT NULL DEFAULT 'UN',
    ID_CATEGORIA    INT          NOT NULL,
    ID_FORNECEDOR   INT          NULL,
    PRECO_CUSTO     DECIMAL(12,2) NOT NULL DEFAULT 0.00,
    PRECO_VENDA     DECIMAL(12,2) NOT NULL DEFAULT 0.00,
    ESTOQUE_ATUAL   DECIMAL(12,3) NOT NULL DEFAULT 0.000,
    ESTOQUE_MINIMO  DECIMAL(12,3) NOT NULL DEFAULT 0.000,
    ESTOQUE_MAXIMO  DECIMAL(12,3) NOT NULL DEFAULT 0.000,
    ATIVO           CHAR(1)       NOT NULL DEFAULT 'S',
    DATA_CADASTRO   DATE          NOT NULL DEFAULT GETDATE(),
    CONSTRAINT PK_PRODUTOS      PRIMARY KEY (ID_PRODUTO),
    CONSTRAINT UQ_PROD_COD      UNIQUE (CODIGO),
    CONSTRAINT FK_PROD_CAT      FOREIGN KEY (ID_CATEGORIA)  REFERENCES dbo.CATEGORIAS(ID_CATEGORIA),
    CONSTRAINT FK_PROD_FOR      FOREIGN KEY (ID_FORNECEDOR) REFERENCES dbo.FORNECEDORES(ID_FORNECEDOR)
);
GO

-- ════════════════════════════════════════════════════════════
--  MOVIMENTO DE ESTOQUE
-- ════════════════════════════════════════════════════════════
CREATE TABLE dbo.MOVIMENTO_ESTOQUE (
    ID_MOVIMENTO    INT           NOT NULL IDENTITY(1,1),
    ID_PRODUTO      INT           NOT NULL,
    TIPO            VARCHAR(10)   NOT NULL,   -- ENTRADA, SAIDA, AJUSTE
    QUANTIDADE      DECIMAL(12,3) NOT NULL,
    CUSTO_UNITARIO  DECIMAL(12,2) NOT NULL DEFAULT 0.00,
    DATA_MOVIMENTO  DATETIME      NOT NULL DEFAULT GETDATE(),
    OBSERVACAO      VARCHAR(250)  NULL,
    DOCUMENTO       VARCHAR(50)   NULL,
    CONSTRAINT PK_MOVIMENTO       PRIMARY KEY (ID_MOVIMENTO),
    CONSTRAINT FK_MOV_PROD        FOREIGN KEY (ID_PRODUTO) REFERENCES dbo.PRODUTOS(ID_PRODUTO),
    CONSTRAINT CK_MOV_TIPO        CHECK (TIPO IN ('ENTRADA','SAIDA','AJUSTE'))
);
GO

-- ════════════════════════════════════════════════════════════
--  VENDAS (cabeçalho)
-- ════════════════════════════════════════════════════════════
CREATE TABLE dbo.VENDAS (
    ID_VENDA        INT           NOT NULL IDENTITY(1,1),
    NUMERO          VARCHAR(20)   NOT NULL,
    DATA_VENDA      DATETIME      NOT NULL DEFAULT GETDATE(),
    ID_CLIENTE      INT           NOT NULL,
    ID_VENDEDOR     INT           NOT NULL,
    ID_FILIAL       INT           NOT NULL,
    STATUS          VARCHAR(20)   NOT NULL DEFAULT 'ABERTA',
    -- ABERTA, FATURADA, CANCELADA, DEVOLVIDA
    FORMA_PAGAMENTO VARCHAR(30)   NULL,
    PRAZO_DIAS      INT           NOT NULL DEFAULT 30,
    DESCONTO_PERC   DECIMAL(5,2)  NOT NULL DEFAULT 0.00,
    VALOR_FRETE     DECIMAL(12,2) NOT NULL DEFAULT 0.00,
    VALOR_TOTAL     DECIMAL(12,2) NOT NULL DEFAULT 0.00,
    OBSERVACAO      VARCHAR(500)  NULL,
    CONSTRAINT PK_VENDAS        PRIMARY KEY (ID_VENDA),
    CONSTRAINT UQ_VENDA_NUM     UNIQUE (NUMERO),
    CONSTRAINT FK_VND_CLI       FOREIGN KEY (ID_CLIENTE)  REFERENCES dbo.CLIENTES(ID_CLIENTE),
    CONSTRAINT FK_VND_VEND      FOREIGN KEY (ID_VENDEDOR) REFERENCES dbo.VENDEDORES(ID_VENDEDOR),
    CONSTRAINT FK_VND_FIL       FOREIGN KEY (ID_FILIAL)   REFERENCES dbo.FILIAIS(ID_FILIAL),
    CONSTRAINT CK_VND_STATUS    CHECK (STATUS IN ('ABERTA','FATURADA','CANCELADA','DEVOLVIDA'))
);
GO

-- ════════════════════════════════════════════════════════════
--  ITENS DA VENDA
-- ════════════════════════════════════════════════════════════
CREATE TABLE dbo.ITENS_VENDA (
    ID_ITEM         INT           NOT NULL IDENTITY(1,1),
    ID_VENDA        INT           NOT NULL,
    ID_PRODUTO      INT           NOT NULL,
    QUANTIDADE      DECIMAL(12,3) NOT NULL,
    PRECO_UNITARIO  DECIMAL(12,2) NOT NULL,
    DESCONTO_PERC   DECIMAL(5,2)  NOT NULL DEFAULT 0.00,
    VALOR_TOTAL     DECIMAL(12,2) NOT NULL,
    CONSTRAINT PK_ITENS_VENDA   PRIMARY KEY (ID_ITEM),
    CONSTRAINT FK_ITEM_VND      FOREIGN KEY (ID_VENDA)   REFERENCES dbo.VENDAS(ID_VENDA)   ON DELETE CASCADE,
    CONSTRAINT FK_ITEM_PROD     FOREIGN KEY (ID_PRODUTO) REFERENCES dbo.PRODUTOS(ID_PRODUTO)
);
GO

-- ─── Índices de performance ───────────────────────────────
CREATE INDEX IX_VENDAS_DATA       ON dbo.VENDAS          (DATA_VENDA);
CREATE INDEX IX_VENDAS_CLIENTE    ON dbo.VENDAS          (ID_CLIENTE);
CREATE INDEX IX_VENDAS_VENDEDOR   ON dbo.VENDAS          (ID_VENDEDOR);
CREATE INDEX IX_ITENS_VENDA       ON dbo.ITENS_VENDA     (ID_VENDA);
CREATE INDEX IX_ITENS_PRODUTO     ON dbo.ITENS_VENDA     (ID_PRODUTO);
CREATE INDEX IX_MOV_PRODUTO       ON dbo.MOVIMENTO_ESTOQUE (ID_PRODUTO);
CREATE INDEX IX_MOV_DATA          ON dbo.MOVIMENTO_ESTOQUE (DATA_MOVIMENTO);
GO

PRINT 'Schema criado com sucesso no banco ReportsWebDemo!';
GO
