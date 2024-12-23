USE ecommerce;

-- Cliente
SELECT
    CASE
        WHEN c.tipo = 'PJ' THEN pj.cnpj
        WHEN c.tipo = 'PF' THEN pf.cpf
    END AS documento_identificacao,
    CASE
        WHEN c.tipo = 'PJ' THEN pj.razao_social
        WHEN c.tipo = 'PF' THEN pf.nome_completo
    END AS nome,
    CASE
        WHEN c.tipo = 'PJ' THEN 'Pessoa Física'
        WHEN c.tipo = 'PF' THEN 'Pessoa Jurídica'
    END AS tipo_cliente,
    c.email,
    c.telefone,
    c.celular,
    e.logradouro,
    e.numero,
    e.complemento,
    e.bairro,
    e.cidade,
    e.uf,
    e.cep
FROM
    cliente c
    LEFT JOIN pessoa_fisica pf ON c.id_cliente = pf.id_cliente
    AND c.tipo = 'PF'
    LEFT JOIN pessoa_juridica pj ON c.id_cliente = pj.id_cliente
    AND c.tipo = 'Pj'
    INNER JOIN cliente_endereco ce ON c.id_cliente = ce.id_cliente
    INNER JOIN endereco e ON e.id_endereco = ce.id_endereco
    AND e.tipo_endereco = 'Entrega';

-- Produto com estoque superior a 20 unidades
SELECT
    p.id_produto,
    p.sku,
    p.descricao,
    CASE
        WHEN p.venda_propria = 0 THEN ppj.quantidade
        WHEN p.venda_propria = 1 THEN pe.quantidade
    END AS quantidade,
    CASE
        WHEN p.venda_propria = 0 THEN pj.razao_social
        WHEN p.venda_propria = 1 THEN e.localizacao
    END AS 'estoque_ou_vendedor'
FROM
    produto p
    LEFT JOIN produto_pj_externo ppj ON p.id_produto = ppj.id_produto
    AND p.venda_propria = 0
    LEFT JOIN produto_estoque pe ON p.id_produto = pe.id_produto
    AND p.venda_propria = 1
    LEFT JOIN pj_externo pj ON pj.id_pj_externo = ppj.id_pj_externo
    AND p.venda_propria = 0
    LEFT JOIN estoque e ON e.id_estoque = pe.id_estoque
    AND p.venda_propria = 1
HAVING
    quantidade > 20;

-- Quantidade de pedidos por cliente
SELECT
    p.id_cliente,
    CASE
        WHEN c.tipo = 'PJ' THEN pj.razao_social
        WHEN c.tipo = 'PF' THEN pf.nome_completo
    END AS nome,
    c.email,
    COUNT(*) AS total_pedidos
FROM
    pedido p
    JOIN cliente c ON p.id_cliente = c.id_cliente
    LEFT JOIN pessoa_fisica pf ON c.id_cliente = pf.id_cliente
    AND c.tipo = 'PF'
    LEFT JOIN pessoa_juridica pj ON c.id_cliente = pj.id_cliente
    AND c.tipo = 'Pj'
GROUP BY
    p.id_cliente,
    c.email,
    pj.razao_social,
    pf.nome_completo;

-- movimentação de pedidos
SELECT
    p.id_pedido,
    mp.movimentacao AS status,
    date_format(mp.data_movimentacao, "%d/%m/%Y %H:%i") as 'data_hora'
FROM
    pedido p
    LEFT JOIN (
        SELECT
            id_pedido,
            MAX(id_movimentacao_pedido) AS max_id_movimentacao_pedido
        FROM
            movimentacao_pedido
        GROUP BY
            id_pedido
    ) AS max_mp ON p.id_pedido = max_mp.id_pedido
    LEFT JOIN movimentacao_pedido mp ON max_mp.max_id_movimentacao_pedido = mp.id_movimentacao_pedido
ORDER BY
    p.id_pedido DESC;

-- produtos, quantidades e valore de pedido por id do pedido
SELECT
    pp.id_pedido,
    p.sku,
    p.descricao,
    quantidade as qtde,
    valor_unitario_produto as "preco_unitario",
    round((quantidade * valor_unitario_produto), 2) 'total_produto'
FROM
    produto_pedido as pp
    JOIN produto p on p.id_produto = pp.id_produto
where
    id_pedido = 1;

SELECT
    id_pedido,
    SUM(round((quantidade * valor_unitario_produto), 2))
FROM
    produto_pedido
GROUP BY
    id_pedido;

-- detalhes do pedido
SELECT
    p.id_pedido,
    CASE
        WHEN c.tipo = 'PJ' THEN pj.razao_social
        WHEN c.tipo = 'PF' THEN pf.nome_completo
    END AS nome,
    tp.soma as total_pedido,
    mp.movimentacao AS status,
    date_format(mp.data_movimentacao, "%d/%m/%Y %H:%i") as 'data_hora'
FROM
    pedido p
    LEFT JOIN (
        SELECT
            id_pedido as id_total_pedido,
            SUM(round((quantidade * valor_unitario_produto), 2)) AS soma
        FROM
            produto_pedido
        GROUP BY
            id_pedido
    ) AS tp ON p.id_pedido = id_total_pedido
    LEFT JOIN (
        SELECT
            id_pedido,
            MAX(id_movimentacao_pedido) AS max_id_movimentacao_pedido
        FROM
            movimentacao_pedido
        GROUP BY
            id_pedido
    ) AS max_mp ON p.id_pedido = max_mp.id_pedido
    JOIN cliente c ON p.id_cliente = c.id_cliente
    LEFT JOIN pessoa_fisica pf ON c.id_cliente = pf.id_cliente
    AND c.tipo = 'PF'
    LEFT JOIN pessoa_juridica pj ON c.id_cliente = pj.id_cliente
    AND c.tipo = 'Pj'
    LEFT JOIN movimentacao_pedido mp ON max_mp.max_id_movimentacao_pedido = mp.id_movimentacao_pedido
where
    p.id_pedido = 1;