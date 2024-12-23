CREATE DATABASE IF NOT EXISTS ecommerce;

-- DROP DATABASE ecommerce;
USE ecommerce;

CREATE TABLE IF NOT EXISTS cliente(
  id_cliente INT PRIMARY KEY AUTO_INCREMENT,
  tipo ENUM('PJ', 'PF') NOT NULL DEFAULT 'PF',
  email VARCHAR(100),
  telefone CHAR(10),
  celular CHAR(11)
);

CREATE TABLE IF NOT EXISTS pessoa_fisica(
  id_pessoa_fisica INT PRIMARY KEY AUTO_INCREMENT,
  nome_completo VARCHAR(120) NOT NULL,
  cpf CHAR(11) UNIQUE NOT NULL,
  data_nascimento CHAR(10) NOT NULL,
  sexo ENUM('M', 'F', 'O') NOT NULL,
  id_cliente INT UNIQUE NOT NULL,
  CONSTRAINT fk_cliente_pf FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS pessoa_juridica(
  id_pessoa_juridica INT PRIMARY KEY AUTO_INCREMENT,
  razao_social VARCHAR(150) NOT NULL,
  cnpj CHAR(14) UNIQUE NOT NULL,
  inscricao_estadual VARCHAR(20),
  nome_fantasia VARCHAR(150),
  contato_nome VARCHAR(120),
  id_cliente INT NOT NULL,
  CONSTRAINT fk_cliente_pj FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS endereco(
  id_endereco INT PRIMARY KEY AUTO_INCREMENT,
  tipo_endereco VARCHAR(30) NOT NULL,
  logradouro VARCHAR(130) NOT NULL,
  numero VARCHAR(6) NOT NULL,
  complemento VARCHAR(65),
  bairro VARCHAR(100) NOT NULL,
  cidade VARCHAR(100) NOT NULL,
  uf CHAR(2) NOT NULL,
  cep CHAR(8) NOT NULL
);

CREATE TABLE IF NOT EXISTS cartao(
  id_cartao INT PRIMARY KEY AUTO_INCREMENT,
  nome_impresso_cartao VARCHAR(120) NOT NULL,
  numero_cartao CHAR(16) NOT NULL,
  data_expiracao CHAR(7) NOT NULL,
  apelido_cartao VARCHAR(30),
  id_cliente INT NOT NULL,
  CONSTRAINT fk_cartao_cliente_id FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS cliente_endereco(
  id_cliente INT NOT NULL,
  id_endereco INT NOT NULL,
  CONSTRAINT fk_cliente_endereco_cliente_id FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente) ON DELETE CASCADE,
  CONSTRAINT fk_cliente_endereco_endereco_id FOREIGN KEY (id_endereco) REFERENCES endereco(id_endereco) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS pj_externo(
  id_pj_externo INT PRIMARY KEY AUTO_INCREMENT,
  razao_social VARCHAR(150) NOT NULL,
  cnpj CHAR(14) UNIQUE NOT NULL,
  email VARCHAR(100),
  telefone VARCHAR(11),
  tipo ENUM('F', 'V') NOT NULL DEFAULT 'F'
);

CREATE TABLE IF NOT EXISTS pj_externo_endereco(
  pj_externo INT NOT NULL,
  id_endereco INT NOT NULL,
  CONSTRAINT fk_pj_externo_endereco_pj_externo_id FOREIGN KEY (pj_externo) REFERENCES pj_externo(id_pj_externo) ON DELETE CASCADE,
  CONSTRAINT fk_pj_externo_endereco_endereco_id FOREIGN KEY (id_endereco) REFERENCES endereco(id_endereco) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS produto(
  id_produto INT UNIQUE PRIMARY KEY AUTO_INCREMENT,
  sku CHAR(8) NOT NULL,
  descricao VARCHAR(100) NOT NULL,
  categoria VARCHAR(40) NOT NULL,
  preco FLOAT NOT NULL,
  venda_propria TINYINT DEFAULT 1
);

CREATE TABLE IF NOT EXISTS estoque(
  id_estoque INT UNIQUE PRIMARY KEY AUTO_INCREMENT,
  localizacao VARCHAR(50) NOT NULL
);

CREATE TABLE IF NOT EXISTS produto_estoque(
  id_produto INT NOT NULL,
  id_estoque INT NOT NULL,
  quantidade INT NOT NULL DEFAULT 0,
  CONSTRAINT fk_produto_estoque_produto_id FOREIGN KEY (id_produto) REFERENCES produto(id_produto) ON DELETE CASCADE,
  CONSTRAINT fk_produto_estoque_estoque_id FOREIGN KEY (id_estoque) REFERENCES estoque(id_estoque) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS produto_pj_externo(
  id_produto INT NOT NULL,
  id_pj_externo INT NOT NULL,
  quantidade INT NOT NULL DEFAULT 0,
  CONSTRAINT fk_produto_pj_externo_produto_id FOREIGN KEY (id_produto) REFERENCES produto(id_produto) ON DELETE CASCADE,
  CONSTRAINT fk_produto_pj_externo_pj_externo_id FOREIGN KEY (id_pj_externo) REFERENCES pj_externo(id_pj_externo) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS pedido(
  id_pedido INT PRIMARY KEY AUTO_INCREMENT,
  total_pedido FLOAT NOT NULL DEFAULT 0,
  total_frete FLOAT NOT NULL DEFAULT 0,
  data_pedido DATETIME NOT NULL DEFAULT NOW(),
  id_cliente INT NOT NULL,
  CONSTRAINT fk_pedido_cliente_id FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente)
);

CREATE TABLE IF NOT EXISTS produto_pedido(
  id_pedido INT NOT NULL,
  id_produto INT NOT NULL,
  quantidade INT NOT NULL DEFAULT 1,
  valor_unitario_produto FLOAT NOT NULL,
  CONSTRAINT fk_produto_pedido_pedido_id FOREIGN KEY (id_pedido) REFERENCES pedido(id_pedido),
  CONSTRAINT fk_produto_pedido_produto_id FOREIGN KEY (id_produto) REFERENCES produto(id_produto)
);

CREATE TABLE IF NOT EXISTS movimentacao_pedido(
  id_movimentacao_pedido INT PRIMARY KEY AUTO_INCREMENT,
  movimentacao ENUM('PGTO', 'SEPARACAO', 'TRANSPORTADOR', 'ENTREGUE') NOT NULL DEFAULT 'PGTO',
  data_movimentacao DATETIME DEFAULT NOW(),
  id_pedido INT NOT NULL,
  CONSTRAINT fk_movimentacao_pedido_pedido_id FOREIGN KEY (id_pedido) REFERENCES pedido(id_pedido) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS rastreamento(
  id_rastreamento INT PRIMARY KEY AUTO_INCREMENT,
  codigo_rastreamento VARCHAR(40) NOT NULL,
  id_movimentacao_pedido INT NOT NULL,
  CONSTRAINT fk_rastreamento_movimentacao_pedido_id FOREIGN KEY (id_movimentacao_pedido) REFERENCES movimentacao_pedido(id_movimentacao_pedido) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS avaliacao_produto(
  id_avaliacao_produto INT UNIQUE PRIMARY KEY AUTO_INCREMENT,
  nota INT NOT NULL,
  id_produto INT NOT NULL,
  id_pedido INT NOT NULL,
  CONSTRAINT fk_avaliacao_produto_produto_id FOREIGN KEY (id_produto) REFERENCES produto(id_produto) ON DELETE CASCADE,
  CONSTRAINT fk_avaliacao_produto_pedido_id FOREIGN KEY (id_pedido) REFERENCES pedido(id_pedido) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS avaliacao_vendedor(
  id_avaliacao_vendedor INT UNIQUE PRIMARY KEY AUTO_INCREMENT,
  nota INT NOT NULL,
  id_pj_externo INT NOT NULL,
  id_pedido INT NOT NULL,
  CONSTRAINT fk_avaliacao_vendedor_pj_externo_id FOREIGN KEY (id_pj_externo) REFERENCES pj_externo(id_pj_externo) ON DELETE CASCADE,
  CONSTRAINT fk_avaliacao_vendedor_pedido_id FOREIGN KEY (id_pedido) REFERENCES pedido(id_pedido) ON DELETE CASCADE
);