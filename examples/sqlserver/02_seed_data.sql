-- ============================================================
--  ReportsWeb — Exemplo SQL Server
--  02_seed_data.sql  ·  Carga de dados fictícios
--  Domínio: Vendas e Estoque
--
--  Execute APÓS o script 01_schema.sql.
--  Gera ~5.000 registros de movimentação para demonstração.
-- ============================================================

USE ReportsWebDemo;
GO

SET NOCOUNT ON;
GO

-- ════════════════════════════════════════════════════════════
--  REGIÕES
-- ════════════════════════════════════════════════════════════
INSERT INTO dbo.REGIOES (NOME, UF) VALUES
('São Paulo Capital',   'SP'),
('Interior de SP',      'SP'),
('Rio de Janeiro',      'RJ'),
('Minas Gerais',        'MG'),
('Paraná',              'PR'),
('Rio Grande do Sul',   'RS'),
('Santa Catarina',      'SC'),
('Bahia',               'BA');
GO

-- ════════════════════════════════════════════════════════════
--  FILIAIS
-- ════════════════════════════════════════════════════════════
INSERT INTO dbo.FILIAIS (NOME, CNPJ, ID_REGIAO, ATIVA) VALUES
('Filial São Paulo - Centro',   '12.345.678/0001-01', 1, 'S'),
('Filial São Paulo - Leste',    '12.345.678/0002-82', 1, 'S'),
('Filial Campinas',             '12.345.678/0003-63', 2, 'S'),
('Filial Ribeirão Preto',       '12.345.678/0004-44', 2, 'S'),
('Filial Rio de Janeiro',       '12.345.678/0005-25', 3, 'S'),
('Filial Belo Horizonte',       '12.345.678/0006-06', 4, 'S'),
('Filial Curitiba',             '12.345.678/0007-87', 5, 'S'),
('Filial Porto Alegre',         '12.345.678/0008-68', 6, 'S'),
('Filial Florianópolis',        '12.345.678/0009-49', 7, 'S'),
('Filial Salvador',             '12.345.678/0010-13', 8, 'N');   -- Inativa
GO

-- ════════════════════════════════════════════════════════════
--  VENDEDORES
-- ════════════════════════════════════════════════════════════
INSERT INTO dbo.VENDEDORES (NOME, CPF, EMAIL, TELEFONE, ID_FILIAL, DATA_ADMISSAO, COMISSAO_PERC, ATIVO) VALUES
('Ana Carolina Ferreira',   '111.222.333-01', 'ana.ferreira@empresa.com',   '(11) 99001-0001', 1, '2020-03-01', 4.00, 'S'),
('Bruno Souza Lima',        '111.222.333-02', 'bruno.lima@empresa.com',     '(11) 99001-0002', 1, '2019-07-15', 3.50, 'S'),
('Carla Mendes Silva',      '111.222.333-03', 'carla.silva@empresa.com',    '(11) 99001-0003', 2, '2021-01-10', 3.00, 'S'),
('Diego Alves Costa',       '111.222.333-04', 'diego.costa@empresa.com',    '(11) 99001-0004', 2, '2022-06-20', 3.00, 'S'),
('Eliane Rocha Santos',     '111.222.333-05', 'eliane.santos@empresa.com',  '(19) 99001-0005', 3, '2020-09-01', 3.50, 'S'),
('Fábio Martins Pereira',   '111.222.333-06', 'fabio.pereira@empresa.com',  '(16) 99001-0006', 4, '2018-04-15', 4.00, 'S'),
('Gabriela Nunes Moreira',  '111.222.333-07', 'gabi.moreira@empresa.com',   '(21) 99001-0007', 5, '2021-11-01', 3.50, 'S'),
('Henrique Dias Carvalho',  '111.222.333-08', 'henrique.carvalho@empresa.com','(31) 99001-0008',6, '2020-02-28', 3.00, 'S'),
('Isabela Teixeira Gomes',  '111.222.333-09', 'isabela.gomes@empresa.com',  '(41) 99001-0009', 7, '2022-08-10', 3.50, 'S'),
('João Paulo Barbosa',      '111.222.333-10', 'joao.barbosa@empresa.com',   '(51) 99001-0010', 8, '2019-12-01', 4.00, 'S'),
('Karen Oliveira Freitas',  '111.222.333-11', 'karen.freitas@empresa.com',  '(48) 99001-0011', 9, '2023-01-16', 3.00, 'S'),
('Lucas Fernandes Ribeiro', '111.222.333-12', 'lucas.ribeiro@empresa.com',  '(11) 99001-0012', 1, '2022-03-07', 2.50, 'S'),
('Mariana Castro Lopes',    '111.222.333-13', 'mariana.lopes@empresa.com',  '(11) 99001-0013', 1, '2017-06-01', 5.00, 'S'),
('Nelson Araujo Monteiro',  '111.222.333-14', 'nelson.monteiro@empresa.com','(19) 99001-0014', 3, '2021-09-20', 3.00, 'S'),
('Patrícia Vieira Cunha',   '111.222.333-15', 'patricia.cunha@empresa.com', '(51) 99001-0015', 8, '2020-11-30', 3.50, 'N'); -- Inativa
GO

-- ════════════════════════════════════════════════════════════
--  CLIENTES  (50 clientes fictícios)
-- ════════════════════════════════════════════════════════════
INSERT INTO dbo.CLIENTES (RAZAO_SOCIAL, NOME_FANTASIA, CNPJ_CPF, TIPO_PESSOA, EMAIL, TELEFONE, CIDADE, UF, LIMITE_CREDITO, DATA_CADASTRO, ATIVO) VALUES
('Supermercado Bom Preço Ltda',     'Bom Preço',       '10.001.001/0001-01','J','compras@bompreco.com',      '(11) 3001-0001','São Paulo',     'SP', 50000.00,'2022-01-10','S'),
('Padaria Pão Quente Ltda',         'Pão Quente',      '10.002.002/0001-02','J','financeiro@paoquente.com',  '(11) 3001-0002','São Paulo',     'SP', 15000.00,'2022-02-15','S'),
('Restaurante Sabor Caseiro Ltda',  'Sabor Caseiro',   '10.003.003/0001-03','J','admin@saborcaseiro.com',    '(21) 3001-0003','Rio de Janeiro','RJ', 20000.00,'2022-03-01','S'),
('Hortifruti Verde Vida Ltda',      'Verde Vida',      '10.004.004/0001-04','J','compras@verdevida.com',     '(31) 3001-0004','Belo Horizonte','MG', 30000.00,'2022-03-20','S'),
('Mercearia Dona Amélia ME',        'Dona Amélia',     '111.222.333-91',    'F','donaAmelia@gmail.com',      '(19) 99100-0001','Campinas',      'SP',  5000.00,'2022-04-05','S'),
('Distribuidora Rápida Ltda',       'Dist. Rápida',    '10.005.005/0001-05','J','logistica@distrap.com',     '(11) 3001-0005','São Paulo',     'SP', 80000.00,'2022-04-10','S'),
('Lanchonete Sabor & Arte ME',      'Sabor & Arte',    '10.006.006/0001-06','J','saborarte@gmail.com',       '(41) 3001-0006','Curitiba',      'PR', 10000.00,'2022-05-01','S'),
('Café Premium Ltda',               'Café Premium',    '10.007.007/0001-07','J','contato@cafepremium.com',   '(11) 3001-0007','São Paulo',     'SP', 25000.00,'2022-05-15','S'),
('Minimercado Família Feliz',       'Fam. Feliz',      '10.008.008/0001-08','J','famfeliz@gmail.com',        '(48) 3001-0008','Florianópolis', 'SC', 12000.00,'2022-06-01','S'),
('Cantina da Vovó Ltda',            'Cantina Vovó',    '10.009.009/0001-09','J','cantinavovo@gmail.com',     '(51) 3001-0009','Porto Alegre',  'RS',  8000.00,'2022-06-10','S'),
('Hotel São Carlos Ltda',           'Hotel São Carlos', '10.010.010/0001-10','J','compras@hotelsaocarlos.com','(16) 3001-0010','São Carlos',    'SP', 40000.00,'2022-07-01','S'),
('Pousada Brisa do Mar',            'Brisa do Mar',    '10.011.011/0001-11','J','brisa@gmail.com',           '(21) 3001-0011','Búzios',        'RJ', 15000.00,'2022-07-15','S'),
('Escola Municipal Santos Dumont',  'E.M. Santos Dumont','10.012.012/0001-12','J','direcao@emsd.edu.br',     '(11) 3001-0012','Guarulhos',     'SP', 20000.00,'2022-08-01','S'),
('Clínica Saúde Total Ltda',        'Saúde Total',     '10.013.013/0001-13','J','admin@saudetotal.com',      '(11) 3001-0013','São Paulo',     'SP', 18000.00,'2022-08-20','S'),
('Academia Corpo em Forma',         'Corpo em Forma',  '10.014.014/0001-14','J','academia@cef.com',          '(31) 3001-0014','BH',            'MG', 10000.00,'2022-09-01','S'),
('Petshop Amigo Fiel Ltda',         'Amigo Fiel',      '10.015.015/0001-15','J','petshop@amigofiel.com',     '(41) 3001-0015','Curitiba',      'PR',  7000.00,'2022-09-15','S'),
('Farmácia Saúde & Vida',           'Saúde & Vida',    '10.016.016/0001-16','J','compras@saudvida.com',      '(11) 3001-0016','São Paulo',     'SP', 35000.00,'2022-10-01','S'),
('Padaria Artesanal Bella Ltda',    'Padaria Bella',   '10.017.017/0001-17','J','bella@padariaartesanal.com','(48) 3001-0017','Florianópolis', 'SC',  9000.00,'2022-10-15','S'),
('Empório Gourmet Ltda',            'Empório Gourmet', '10.018.018/0001-18','J','emporio@gourmet.com',       '(11) 3001-0018','São Paulo',     'SP', 60000.00,'2022-11-01','S'),
('Bar e Restaurante Canastra',      'Bar Canastra',    '10.019.019/0001-19','J','barcanastra@gmail.com',     '(31) 3001-0019','BH',            'MG', 14000.00,'2022-11-20','S'),
('Buffet Festa & Sabor Ltda',       'Festa & Sabor',   '10.020.020/0001-20','J','buffet@festasabor.com',     '(51) 3001-0020','Porto Alegre',  'RS', 22000.00,'2022-12-01','S'),
('Pizzaria Napolitana Ltda',        'Napolitana',      '10.021.021/0001-21','J','napolitana@pizza.com',      '(21) 3001-0021','Rio de Janeiro','RJ', 11000.00,'2023-01-10','S'),
('Casa de Pães Maria Ltda',         'Casa Maria',      '10.022.022/0001-22','J','casamaria@paes.com',        '(11) 3001-0022','São Paulo',     'SP',  6000.00,'2023-01-20','S'),
('Mercado Central Oliveira',        'M. Central',      '10.023.023/0001-23','J','mercadocentral@ol.com',     '(16) 3001-0023','Ribeirão Preto','SP', 28000.00,'2023-02-01','S'),
('Atacadão do Produtor Ltda',       'Atacadão',        '10.024.024/0001-24','J','atacadao@produtor.com',     '(11) 3001-0024','São Paulo',     'SP',100000.00,'2023-02-15','S'),
('Sorveteria Neve e Nata Ltda',     'Neve e Nata',     '10.025.025/0001-25','J','sorvete@nevenata.com',      '(19) 3001-0025','Campinas',      'SP',  5000.00,'2023-03-01','S'),
('Salgaderia Quero Mais ME',        'Quero Mais',      '10.026.026/0001-26','J','salgados@queromais.com',    '(41) 3001-0026','Curitiba',      'PR',  4500.00,'2023-03-20','S'),
('Confeitaria Doce Mania Ltda',     'Doce Mania',      '10.027.027/0001-27','J','docemania@confeitaria.com', '(11) 3001-0027','São Paulo',     'SP',  8000.00,'2023-04-01','S'),
('Supermercado Econômico Ltda',     'Econômico',       '10.028.028/0001-28','J','compras@economico.com',     '(48) 3001-0028','Florianópolis', 'SC', 45000.00,'2023-04-15','S'),
('Posto de Gasolina Vitória',       'Posto Vitória',   '10.029.029/0001-29','J','vitoria@posto.com',         '(31) 3001-0029','BH',            'MG', 30000.00,'2023-05-01','S'),
('Carlos Eduardo da Silva',         NULL,              '222.333.444-55',    'F','carlos.silva@email.com',    '(11) 99500-0001','São Paulo',     'SP',  2000.00,'2023-05-15','S'),
('Maria Aparecida Oliveira',        NULL,              '333.444.555-66',    'F','maria.oliveira@email.com',  '(21) 99500-0002','Rio de Janeiro','RJ',  1500.00,'2023-06-01','S'),
('José Roberto Fernandes',          NULL,              '444.555.666-77',    'F','jose.fernandes@email.com',  '(31) 99500-0003','BH',            'MG',  2500.00,'2023-06-15','S'),
('Transportadora Norte Sul Ltda',   'Norte Sul',       '10.030.030/0001-30','J','logistica@nortesul.com',    '(51) 3001-0030','Porto Alegre',  'RS', 55000.00,'2023-07-01','S'),
('Cooperativa Agrícola Central',    'CoopAgro',        '10.031.031/0001-31','J','coopagro@central.com',      '(16) 3001-0031','Ribeirão Preto','SP', 90000.00,'2023-07-15','S');
GO

-- ════════════════════════════════════════════════════════════
--  FORNECEDORES
-- ════════════════════════════════════════════════════════════
INSERT INTO dbo.FORNECEDORES (RAZAO_SOCIAL, CNPJ, CONTATO, TELEFONE, EMAIL, PRAZO_ENTREGA, ATIVO) VALUES
('BRF S.A.',                        '01.838.723/0001-27','João Compras',    '(11) 4000-1001','compras@brf.com',          3, 'S'),
('Nestlé Brasil Ltda',              '60.409.075/0001-29','Maria Vendas',    '(11) 4000-1002','vendas@nestle.com',         5, 'S'),
('Ambev S.A.',                      '07.526.557/0001-00','Pedro Comercial', '(11) 4000-1003','comercial@ambev.com',       2, 'S'),
('Unilever Brasil Ltda',            '17.245.943/0001-03','Ana Fornecedor',  '(11) 4000-1004','fornecedor@unilever.com',   7, 'S'),
('JBS S.A.',                        '02.916.265/0001-60','Carlos Carnes',   '(11) 4000-1005','carnes@jbs.com',            1, 'S'),
('Camil Alimentos S.A.',            '64.904.295/0001-03','Lucia Grãos',     '(19) 4000-1006','graos@camil.com',           4, 'S'),
('M. Dias Branco S.A.',             '07.355.042/0001-20','Roberto Trigo',   '(85) 4000-1007','comercial@mdiasbranco.com', 6, 'S'),
('Cargill Agrícola S.A.',           '60.498.706/0001-57','Sandra Óleo',     '(15) 4000-1008','oleos@cargill.com',         5, 'S'),
('Vigor Alimentos Ltda',            '47.235.450/0001-00','Marcos Laticínios','(11) 4000-1009','laticinio@vigor.com',      3, 'S'),
('P&G do Brasil Ltda',              '56.990.540/0001-00','Fernanda Higiene','(11) 4000-1010','higiene@pg.com',            7, 'S');
GO

-- ════════════════════════════════════════════════════════════
--  CATEGORIAS
-- ════════════════════════════════════════════════════════════
INSERT INTO dbo.CATEGORIAS (NOME, DESCRICAO) VALUES
('Carnes e Aves',       'Carnes bovinas, suínas, frangos e derivados'),
('Laticínios',          'Leite, queijos, iogurtes e derivados'),
('Padaria e Confeitaria','Pães, bolos, massas e doces'),
('Bebidas',             'Refrigerantes, sucos, águas e alcoólicas'),
('Mercearia Seca',      'Arroz, feijão, macarrão, açúcar e farinhas'),
('Higiene e Limpeza',   'Produtos de limpeza e higiene pessoal'),
('Frios e Embutidos',   'Presunto, mortadela, salame e similares'),
('Hortifruti',          'Frutas, legumes e verduras'),
('Congelados',          'Produtos congelados prontos ou semi-prontos'),
('Temperos e Condimentos','Sal, pimenta, ervas e molhos');
GO

-- ════════════════════════════════════════════════════════════
--  PRODUTOS  (40 produtos)
-- ════════════════════════════════════════════════════════════
INSERT INTO dbo.PRODUTOS (CODIGO, DESCRICAO, UNIDADE, ID_CATEGORIA, ID_FORNECEDOR, PRECO_CUSTO, PRECO_VENDA, ESTOQUE_ATUAL, ESTOQUE_MINIMO, ESTOQUE_MAXIMO) VALUES
('CARN001','Frango Inteiro Congelado 1kg',     'KG', 1, 1,  8.50, 14.90, 500.000, 100.000, 2000.000),
('CARN002','Coxinha de Frango 1kg',            'KG', 1, 1,  9.20, 16.50, 300.000,  50.000, 1000.000),
('CARN003','Picanha Bovina por Kg',            'KG', 1, 5, 42.00, 69.90,  80.000,  20.000,  200.000),
('CARN004','Patinho Moído 500g',               'UN', 1, 5, 11.50, 18.99, 200.000,  50.000,  500.000),
('LACT001','Leite Integral 1L',                'UN', 2, 9,  3.20,  5.49,1200.000, 300.000, 5000.000),
('LACT002','Queijo Muçarela 500g',             'UN', 2, 9, 14.50, 24.99, 400.000, 100.000, 1500.000),
('LACT003','Iogurte Natural 170g',             'UN', 2, 9,  2.10,  3.79, 600.000, 150.000, 2000.000),
('LACT004','Requeijão Cremoso 200g',           'UN', 2, 9,  5.80,  9.99, 350.000,  80.000, 1000.000),
('PAD001', 'Pão Francês 50g (unidade)',        'UN', 3, 7,  0.50,  0.99,2000.000, 500.000,10000.000),
('PAD002', 'Bolo de Chocolate 500g',           'UN', 3, 7, 12.00, 22.90,  80.000,  20.000,  200.000),
('PAD003', 'Croissant 80g',                    'UN', 3, 7,  2.50,  4.99, 150.000,  50.000,  500.000),
('BEB001', 'Refrigerante Cola 2L',             'UN', 4, 3,  4.50,  7.99, 800.000, 200.000, 3000.000),
('BEB002', 'Suco de Laranja 1L',               'UN', 4, 2,  5.20,  9.49, 500.000, 100.000, 2000.000),
('BEB003', 'Água Mineral 500ml',               'UN', 4, 3,  0.90,  1.79,3000.000, 500.000,10000.000),
('BEB004', 'Cerveja Lata 350ml',               'UN', 4, 3,  2.80,  4.99,2000.000, 500.000, 8000.000),
('BEB005', 'Vinho Tinto Nacional 750ml',       'UN', 4, 2, 22.00, 39.90, 120.000,  30.000,  400.000),
('MER001', 'Arroz Branco 5kg',                 'UN', 5, 6, 18.50, 29.99, 600.000, 100.000, 2000.000),
('MER002', 'Feijão Carioca 1kg',               'UN', 5, 6,  6.80, 10.99, 800.000, 200.000, 3000.000),
('MER003', 'Açúcar Cristal 1kg',               'UN', 5, 6,  4.20,  6.99,1000.000, 200.000, 4000.000),
('MER004', 'Macarrão Espaguete 500g',          'UN', 5, 7,  3.50,  5.99, 900.000, 200.000, 3000.000),
('MER005', 'Farinha de Trigo 1kg',             'UN', 5, 7,  4.80,  7.99, 700.000, 150.000, 2500.000),
('MER006', 'Azeite Extra Virgem 500ml',        'UN', 5, 8, 18.00, 32.90, 200.000,  50.000,  600.000),
('HIG001', 'Sabonete Líquido 250ml',           'UN', 6,10,  3.80,  6.99, 500.000, 100.000, 2000.000),
('HIG002', 'Detergente 500ml',                 'UN', 6,10,  2.20,  3.99, 700.000, 150.000, 3000.000),
('HIG003', 'Desinfetante 1L',                  'UN', 6,10,  4.50,  7.99, 400.000,  80.000, 1500.000),
('HIG004', 'Papel Higiênico Fardo 12un',       'UN', 6,10, 16.00, 28.90, 250.000,  60.000,  800.000),
('FRI001', 'Presunto Cozido 200g',             'UN', 7, 1,  8.50, 14.99, 300.000,  80.000, 1000.000),
('FRI002', 'Mortadela Bologna 300g',           'UN', 7, 1,  7.20, 12.49, 280.000,  70.000,  900.000),
('FRI003', 'Salame Italiano 200g',             'UN', 7, 5, 12.50, 21.90, 180.000,  50.000,  600.000),
('HORT001','Tomate kg',                        'KG', 8, 4,  4.50,  7.99, 200.000,  50.000,  500.000),
('HORT002','Batata Inglesa kg',                'KG', 8, 4,  3.20,  5.49, 300.000,  80.000,  800.000),
('HORT003','Cebola kg',                        'KG', 8, 4,  4.80,  7.99, 250.000,  60.000,  700.000),
('HORT004','Banana Prata kg',                  'KG', 8, 4,  3.50,  5.99, 400.000, 100.000, 1200.000),
('CONG001','Lasanha Frango/Catupiry 600g',     'UN', 9, 1, 14.50, 24.99, 200.000,  50.000,  600.000),
('CONG002','Pizza Margherita Congelada 460g',  'UN', 9, 1, 12.00, 21.90, 180.000,  40.000,  500.000),
('CONG003','Nuggets Frango 300g',              'UN', 9, 1,  9.80, 16.99, 220.000,  60.000,  700.000),
('TEMP001','Sal Refinado 1kg',                 'UN',10, 6,  1.80,  2.99,1500.000, 300.000, 5000.000),
('TEMP002','Pimenta do Reino Moída 30g',       'UN',10, 2,  3.50,  6.49, 400.000,  80.000, 1200.000),
('TEMP003','Molho de Tomate 340g',             'UN',10, 2,  2.80,  4.99, 600.000, 120.000, 2000.000),
('TEMP004','Caldo de Galinha 114g (6un)',      'UN',10, 2,  4.20,  6.99, 500.000, 100.000, 1800.000);
GO

-- ════════════════════════════════════════════════════════════
--  MOVIMENTO DE ESTOQUE (entradas iniciais)
-- ════════════════════════════════════════════════════════════
-- Gera entradas para todos os produtos com base no estoque atual
INSERT INTO dbo.MOVIMENTO_ESTOQUE (ID_PRODUTO, TIPO, QUANTIDADE, CUSTO_UNITARIO, DATA_MOVIMENTO, OBSERVACAO, DOCUMENTO)
SELECT
    ID_PRODUTO,
    'ENTRADA',
    ESTOQUE_ATUAL,
    PRECO_CUSTO,
    DATEADD(DAY, -90, GETDATE()),
    'Estoque inicial de abertura',
    'NF-INICIAL-' + CAST(ID_PRODUTO AS VARCHAR(10))
FROM dbo.PRODUTOS;
GO

-- ════════════════════════════════════════════════════════════
--  VENDAS — Geração de ~300 vendas nos últimos 90 dias
-- ════════════════════════════════════════════════════════════
-- Utiliza um loop para criar vendas com datas variadas
DECLARE @i INT = 1;
DECLARE @data_venda DATETIME;
DECLARE @id_cliente INT;
DECLARE @id_vendedor INT;
DECLARE @id_filial INT;
DECLARE @num_venda VARCHAR(20);
DECLARE @status VARCHAR(20);
DECLARE @forma VARCHAR(30);
DECLARE @prazo INT;
DECLARE @desconto DECIMAL(5,2);
DECLARE @total DECIMAL(12,2);

WHILE @i <= 300
BEGIN
    SET @data_venda = DATEADD(DAY, -(ABS(CHECKSUM(NEWID())) % 90), GETDATE());
    SET @id_cliente  = (ABS(CHECKSUM(NEWID())) % 35) + 1;
    SET @id_vendedor = (ABS(CHECKSUM(NEWID())) % 14) + 1;
    SET @id_filial   = (ABS(CHECKSUM(NEWID())) %  9) + 1;
    SET @num_venda   = 'VND-' + RIGHT('000000' + CAST(@i AS VARCHAR), 6);
    SET @desconto    = CASE WHEN @i % 5 = 0 THEN 5.00 WHEN @i % 3 = 0 THEN 2.50 ELSE 0.00 END;
    SET @forma       = CASE (@i % 4) WHEN 0 THEN 'Boleto' WHEN 1 THEN 'PIX'
                                     WHEN 2 THEN 'Cartão Crédito' ELSE 'Cartão Débito' END;
    SET @prazo       = CASE (@i % 3) WHEN 0 THEN 30 WHEN 1 THEN 15 ELSE 0 END;
    SET @status      = CASE WHEN @i % 20 = 0 THEN 'CANCELADA'
                            WHEN @i % 10 = 0 THEN 'DEVOLVIDA'
                            WHEN @data_venda < DATEADD(DAY,-15,GETDATE()) THEN 'FATURADA'
                            ELSE 'ABERTA' END;
    SET @total       = 0.00;

    INSERT INTO dbo.VENDAS (NUMERO, DATA_VENDA, ID_CLIENTE, ID_VENDEDOR, ID_FILIAL,
                            STATUS, FORMA_PAGAMENTO, PRAZO_DIAS, DESCONTO_PERC, VALOR_TOTAL)
    VALUES (@num_venda, @data_venda, @id_cliente, @id_vendedor, @id_filial,
            @status, @forma, @prazo, @desconto, @total);

    SET @i = @i + 1;
END
GO

-- ════════════════════════════════════════════════════════════
--  ITENS DE VENDA — 3 a 8 itens por venda
-- ════════════════════════════════════════════════════════════
DECLARE @vid INT;
DECLARE @prod_id INT;
DECLARE @qtd DECIMAL(12,3);
DECLARE @preco DECIMAL(12,2);
DECLARE @item_total DECIMAL(12,2);
DECLARE @n_itens INT;
DECLARE @j INT;

DECLARE cur_vendas CURSOR FOR
    SELECT ID_VENDA FROM dbo.VENDAS;

OPEN cur_vendas;
FETCH NEXT FROM cur_vendas INTO @vid;

WHILE @@FETCH_STATUS = 0
BEGIN
    SET @n_itens = (ABS(CHECKSUM(NEWID())) % 6) + 3;
    SET @j = 1;
    SET @item_total = 0.00;

    WHILE @j <= @n_itens
    BEGIN
        SET @prod_id = (ABS(CHECKSUM(NEWID())) % 40) + 1;
        SET @qtd     = CAST((ABS(CHECKSUM(NEWID())) % 10) + 1 AS DECIMAL(12,3));
        SELECT @preco = PRECO_VENDA FROM dbo.PRODUTOS WHERE ID_PRODUTO = @prod_id;
        SET @item_total = @item_total + (@qtd * @preco);

        INSERT INTO dbo.ITENS_VENDA (ID_VENDA, ID_PRODUTO, QUANTIDADE, PRECO_UNITARIO, DESCONTO_PERC, VALOR_TOTAL)
        VALUES (@vid, @prod_id, @qtd, @preco, 0.00, @qtd * @preco);

        SET @j = @j + 1;
    END;

    UPDATE dbo.VENDAS SET VALOR_TOTAL = @item_total WHERE ID_VENDA = @vid;

    FETCH NEXT FROM cur_vendas INTO @vid;
END;

CLOSE cur_vendas;
DEALLOCATE cur_vendas;
GO

-- ─── Atualiza movimentos de saída com base nas vendas faturadas ───────────────
INSERT INTO dbo.MOVIMENTO_ESTOQUE (ID_PRODUTO, TIPO, QUANTIDADE, CUSTO_UNITARIO, DATA_MOVIMENTO, OBSERVACAO, DOCUMENTO)
SELECT
    iv.ID_PRODUTO,
    'SAIDA',
    SUM(iv.QUANTIDADE),
    p.PRECO_CUSTO,
    v.DATA_VENDA,
    'Saída por venda ' + v.NUMERO,
    v.NUMERO
FROM dbo.ITENS_VENDA iv
JOIN dbo.VENDAS    v ON v.ID_VENDA   = iv.ID_VENDA
JOIN dbo.PRODUTOS  p ON p.ID_PRODUTO = iv.ID_PRODUTO
WHERE v.STATUS IN ('FATURADA','DEVOLVIDA')
GROUP BY iv.ID_PRODUTO, p.PRECO_CUSTO, v.DATA_VENDA, v.NUMERO;
GO

-- ─── Estatísticas finais ──────────────────────────────────
PRINT '';
PRINT '====== Carga de dados concluída! ======';
PRINT '';
SELECT 'REGIOES'            AS TABELA, COUNT(*) AS REGISTROS FROM dbo.REGIOES      UNION ALL
SELECT 'FILIAIS',                       COUNT(*)             FROM dbo.FILIAIS       UNION ALL
SELECT 'VENDEDORES',                    COUNT(*)             FROM dbo.VENDEDORES    UNION ALL
SELECT 'CLIENTES',                      COUNT(*)             FROM dbo.CLIENTES      UNION ALL
SELECT 'FORNECEDORES',                  COUNT(*)             FROM dbo.FORNECEDORES  UNION ALL
SELECT 'CATEGORIAS',                    COUNT(*)             FROM dbo.CATEGORIAS    UNION ALL
SELECT 'PRODUTOS',                      COUNT(*)             FROM dbo.PRODUTOS      UNION ALL
SELECT 'VENDAS',                        COUNT(*)             FROM dbo.VENDAS        UNION ALL
SELECT 'ITENS_VENDA',                   COUNT(*)             FROM dbo.ITENS_VENDA   UNION ALL
SELECT 'MOVIMENTO_ESTOQUE',             COUNT(*)             FROM dbo.MOVIMENTO_ESTOQUE;
GO
