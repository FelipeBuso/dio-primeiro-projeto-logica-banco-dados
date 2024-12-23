USE ecommerce;

-- Cliente
INSERT INTO
	cliente (tipo, email, telefone, celular)
VALUES
	('PF', 'joaocesar@teste.com', NULL, '11999991234'),
	(
		'PF',
		'mariliaperez@teste.com',
		NULL,
		'33987216587'
	),
	('PJ', 'primeira@teste.com', NULL, '11999991234'),
	('PJ', 'segunda@teste.com', NULL, '11999991234'),
	('PF', 'carlasouza@teste.com', NULL, '45912397598');

INSERT INTO
	pessoa_fisica (
		nome_completo,
		cpf,
		data_nascimento,
		sexo,
		id_cliente
	)
VALUES
	('João Cesar', '28359135053', '2000-05-08', 'M', 1),
	(
		'Marília Perez',
		'98514312065',
		'1986-12-05',
		'F',
		2
	),
	(
		'Carla Souza',
		'36851363054',
		'2002-09-19',
		'F',
		5
	);

INSERT INTO
	pessoa_juridica (
		razao_social,
		cnpj,
		inscricao_estadual,
		nome_fantasia,
		contato_nome,
		id_cliente
	)
VALUES
	(
		'Empresa Primeira Ltda',
		'89763265000155',
		'123456789',
		'Primeira Fantasia',
		'José Aldo',
		3
	),
	(
		'Empresa Segunda Ltda',
		'67213140000119',
		'987654321',
		'Segunda Fantasia',
		'Arlete Gomes',
		4
	);

INSERT INTO
	endereco (
		tipo_endereco,
		logradouro,
		numero,
		complemento,
		bairro,
		cidade,
		uf,
		cep
	)
VALUES
	(
		'Entrega',
		'Rua Principal',
		'5',
		'Apto 2',
		'Mooca',
		'São Paulo',
		'SP',
		'09510002'
	),
	(
		'Entrega',
		'Rua que Sobe',
		'1000',
		'Casa 1',
		'Palheiros',
		'Uberaba',
		'MG',
		'33512012'
	),
	(
		'Entrega',
		'Rua Um',
		'21',
		NULL,
		'Centro',
		'São Paulo',
		'SP',
		'09510001'
	),
	(
		'Faturamento',
		'Rua Marginal',
		'150',
		'2° andar',
		'Mooca',
		'São Paulo',
		'SP',
		'09510002'
	),
	(
		'Entrega',
		'Rua Dois',
		'5A',
		NULL,
		'Brás',
		'São Paulo',
		'SP',
		'09510002'
	),
	(
		'Entrega',
		'Rua Trẽs',
		'221',
		NULL,
		'Centro',
		'Cascavle',
		'PR',
		'45236036'
	);

INSERT INTO
	cliente_endereco
VALUES
	(1, 1),
	(2, 2),
	(3, 3),
	(3, 4),
	(4, 5),
	(5, 6);

INSERT INTO
	cartao (
		nome_impresso_cartao,
		numero_cartao,
		data_expiracao,
		apelido_cartao,
		id_cliente
	)
VALUES
	(
		'João Cesar',
		'1234567891234567',
		'2027-05',
		'dia a dia',
		1
	),
	(
		'Marília Perez',
		'5502789624315897',
		'2031-02',
		NULL,
		2
	),
	(
		'Carla Souza',
		'5684825612345678',
		'2029-11',
		'nu principla',
		5
	);

-- Fornecedor/Vendedor
INSERT INTO
	pj_externo (razao_social, cnpj, email, telefone, tipo)
VALUES
	(
		'Fornecedor Um Ltda',
		'12212078000159',
		'fornecedorum@email.com',
		'1142289988',
		'F'
	),
	(
		'Fornecedor Dois Ltda',
		'92977136000174',
		'fornecedordois@email.com',
		'11991234321',
		'F'
	),
	(
		'Vendedor Ltda',
		'72927260000118',
		'vendedor@email.com',
		'1141140000',
		'V'
	),
	(
		'Outro Vendedor Ltda',
		'95659803000169',
		'outrovendedor@email.com',
		'11912349876',
		'V'
	);

INSERT INTO
	pj_externo_endereco
VALUES
	(1, 1),
	(2, 2),
	(3, 3),
	(4, 4);

INSERT INTO
	produto (sku, descricao, categoria, preco, venda_propria)
values
	(
		'00000001',
		'Mouse bluetooth',
		'informatica',
		20.99,
		1
	),
	(
		'00000002',
		'Teclado bluetooth',
		'informatica',
		49.99,
		1
	),
	(
		'00000003',
		'Pendrive 1GB',
		'informatica',
		199.99,
		0
	),
	(
		'90000001',
		'Monitor LED',
		'informatica',
		599.99,
		0
	),
	(
		'90000002',
		'Hub usb 3.0',
		'informatica',
		60.00,
		1
	);

INSERT INTO
	estoque (localizacao)
VALUES
	('Central'),
	('Bahia'),
	('São Paulo');

INSERT INTO
	produto_estoque (id_produto, id_estoque, quantidade)
VALUES
	(1, 1, 100),
	(2, 1, 48),
	(5, 2, 200),
	(1, 3, 50);

INSERT INTO
	produto_pj_externo (id_produto, id_pj_externo, quantidade)
VALUES
	(3, 3, 15),
	(4, 4, 35);

INSERT INTO
	pedido (
		total_pedido,
		total_frete,
		data_pedido,
		id_cliente
	)
VALUES
	(61.98, 1.99, "2024-12-01 08:04:32", 1),
	(359.98, 0, "2024-12-01 08:36:42", 2),
	(599.99, 0, "2024-12-02 09:07:44", 3),
	(599.99, 0, "2024-12-02 14:36:51", 1),
	(120, 8.79, "2024-12-02 16:01:01", 4),
	(41.98, 9.99, "2024-12-03 07:14:32", 5),
	(20.99, 0, "2024-12-04 10:04:12", 3),
	(20.99, 4.99, "2024-12-05 11:14:25", 1),
	(20.99, 1.99, "2024-12-06 12:04:32", 2),
	(60, 1.99, "2024-12-11 06:04:32", 3);

INSERT INTO
	produto_pedido
VALUES
	(1, 1, 2, 20.99),
	(1, 2, 3, 40.99),
	(2, 3, 2, 179.99),
	(3, 4, 1, 599.99),
	(4, 4, 1, 599.99),
	(5, 5, 2, 60),
	(6, 1, 3, 20.99),
	(7, 1, 1, 20.99),
	(8, 1, 1, 20.99),
	(9, 1, 1, 20.99),
	(10, 5, 1, 60);

UPDATE
	produto_pedido
SET
	quantidade = 3
where
	id_pedido = 1
	and id_produto = 2;

INSERT INTO
	movimentacao_pedido (movimentacao, data_movimentacao, id_pedido)
values
	('PGTO', "2024-12-01 08:06:17", 1),
	('SEPARACAO', "2024-12-01 08:15:42", 1),
	('TRANSPORTADOR', "2024-12-01 16:56:33", 1),
	('ENTREGUE', "2024-12-03 11:44:32", 1);

INSERT INTO
	rastreamento (codigo_rastreamento, id_movimentacao_pedido)
values
	('BR02125475252SE', 3);

INSERT INTO
	avaliacao_produto (nota, id_produto, id_pedido)
VALUES
	(5, 1, 1),
	(4, 2, 1),
	(5, 3, 2),
	(5, 4, 3),
	(4, 4, 4),
	(4, 5, 5),
	(5, 1, 6),
	(4, 1, 7),
	(5, 1, 8),
	(3, 1, 9),
	(5, 5, 10);

INSERT INTO
	avaliacao_vendedor (nota, id_pj_externo, id_pedido)
VALUES
	(5, 3, 2),
	(5, 4, 3),
	(2, 4, 4);

INSERT INTO
	movimentacao_pedido (movimentacao, data_movimentacao, id_pedido)
values
	('PGTO', "2024-12-01 08:06:17", 2),
	('SEPARACAO', "2024-12-01 08:15:42", 3),
	('TRANSPORTADOR', "2024-12-01 16:56:33", 4),
	('ENTREGUE', "2024-12-03 11:44:32", 5),
	('PGTO', "2024-12-01 08:06:17", 6),
	('SEPARACAO', "2024-12-01 08:15:42", 7),
	('TRANSPORTADOR', "2024-12-15 16:56:33", 8),
	('ENTREGUE', "2024-12-012 11:44:32", 9),
	('ENTREGUE', "2024-12-04 11:44:32", 10);