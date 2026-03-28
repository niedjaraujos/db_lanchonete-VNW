CREATE TABLE clientes (
    id_cliente SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    telefone VARCHAR(20),
    data_cadastro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE produtos (
    id_produto SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    descricao TEXT,
    preco DECIMAL(10,2) NOT NULL,
    categoria VARCHAR(50)
);

CREATE TABLE pedidos (
    id_pedido SERIAL PRIMARY KEY,
    id_cliente INT NOT NULL,
    data_pedido TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status_pedido VARCHAR(30) NOT NULL DEFAULT 'recebido'
        CHECK (status_pedido IN ('recebido', 'preparando', 'saiu pra entrega', 'pronto', 'entregue', 'cancelado')),
	observacoes TEXT,
	valor_total DECIMAL(10,2) DEFAULT 0 CHECK (valor_total >= 0),
    tipo_entrega VARCHAR(30)NOT NULL CHECK (tipo_entrega IN ('local', 'retirada')),
	CONSTRAINT fk_pedidos_clientes
        FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente)
);

CREATE TABLE itens_pedido (
    id_item SERIAL PRIMARY KEY,
    id_pedido INT NOT NULL,
    id_produto INT NOT NULL,
    quantidade INT NOT NULL CHECK (quantidade > 0),
    preco_unitario DECIMAL(10,2) NOT NULL CHECK (preco_unitario >= 0),
    subtotal DECIMAL(10,2) NOT NULL CHECK (subtotal >= 0),
    CONSTRAINT fk_itens_pedido_pedidos
        FOREIGN KEY (id_pedido) REFERENCES pedidos(id_pedido) ON DELETE CASCADE,
    CONSTRAINT fk_itens_pedido_produtos
        FOREIGN KEY (id_produto) REFERENCES produtos(id_produto)
);

INSERT INTO clientes (nome, telefone) VALUES
('Ana Souza', '(81) 99254-1011'),
('Carla Pereira', '(81) 99234-5678');


INSERT INTO produtos (nome, descricao, preco, categoria) VALUES
('Burguer-Elite', 'Pão, blend carne 100g, queijo e salada, molho da casa', 20.00, 'Hamburguer'),
('Burguer-Bacon', 'Pão, carne 100g, queijo, tiras de bacon, molho verde', 22.00, 'Hamburguer'),
('Batata Frita', 'Porção média de batata frita', 12.00, 'Acompanhamento'),
('Refrigerante Lata', '350ml', 4.00, 'Bebida'),
('Refrigerante Pet', '1000ml', 10.00, 'Bebida');

INSERT INTO pedidos (id_cliente, tipo_entrega, status_pedido, observacoes)
VALUES
(1, 'retirada', 'recebido', 'Sem cebola'),
(2, 'local', 'preparando', NULL);



-- pedido Ana
INSERT INTO itens_pedido (id_pedido, id_produto, quantidade, preco_unitario, subtotal)
VALUES
(1, 1, 2, 20.00, 40.00),
(1, 4, 2, 4.00, 8.00);


-- pedido Carla
INSERT INTO itens_pedido (id_pedido, id_produto, quantidade, preco_unitario, subtotal)
VALUES 
(2, 2, 1, 22.00, 22.00),
(2, 1, 1, 20.00, 20.00),
(2, 3, 1, 12.00, 12.00),
(2, 5, 1, 10.00, 10.00);

-- lista clientes
SELECT * FROM clientes;

SELECT
    pedidos.id_pedido,
    clientes.nome,
    pedidos.data_pedido,
    pedidos.valor_total
FROM pedidos
JOIN clientes ON pedidos.id_cliente = clientes.id_cliente;   

-- todos os pedidos
SELECT 
    pedidos.id_pedido,
    clientes.nome AS cliente,
    pedidos.data_pedido,
    pedidos.tipo_entrega,
    pedidos.status_pedido,
    pedidos.valor_total
FROM pedidos 
JOIN clientes ON pedidos.id_cliente = clientes.id_cliente
ORDER BY pedidos.data_pedido DESC;
