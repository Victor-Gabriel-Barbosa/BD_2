/* Considere duas tabelas: "clientes" e "pedidos". 
Crie um procedimento armazenado chamado "obter_pedidos_cliente" 
que recebe o ID de um cliente como parâmetro e retorna todos os 
pedidos feitos por esse cliente, exibindo as informações de cada 
pedido (número do pedido, data e valor total).*/

DROP TABLE IF EXISTS pedidos;
DROP TABLE IF EXISTS clientes;

-- Tabela de clientes
CREATE TABLE clientes (
    id_cliente INT PRIMARY KEY,
    nome VARCHAR(255)
);

-- Tabela de pedidos
CREATE TABLE pedidos (
	id_pedido INT PRIMARY KEY,
    id_cliente INT,
    data DATE,
    valor_total DECIMAL(10, 2),
    FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente)
);

-- Inserindo dados na tabela clientes
INSERT INTO clientes (id_cliente, nome) VALUES
(1, 'João Silva'),
(2, 'Maria Oliveira'),
(3, 'Carlos Souza'),
(4, 'Ana Santos'),
(5, 'Pedro Almeida');

-- Inserindo dados na tabela pedidos
INSERT INTO pedidos (id_pedido, id_cliente, data, valor_total) VALUES
(101, 1, '2024-03-01', 150.75),
(102, 2, '2024-03-02', 200.00),
(103, 1, '2024-03-05', 99.90),
(104, 3, '2024-03-06', 350.00),
(105, 4, '2024-03-10', 120.50),
(106, 5, '2024-03-12', 75.25),
(107, 2, '2024-03-15', 300.80),
(108, 3, '2024-03-18', 50.00);

SELECT * FROM clientes;
SELECT * FROM pedidos;

DELIMITER $$

CREATE PROCEDURE obter_pedidos_cliente(IN cliente_id INT)
BEGIN
    -- Seleçiona os pedidos feitos pelo cliente com o ID fornecido
    SELECT 
        id_pedido,       -- Número do pedido
        data,            -- Data do pedido
        valor_total      -- Valor total do pedido
    FROM 
        pedidos          -- Tabela de pedidos
    WHERE 
        id_cliente = cliente_id;  -- Filtra pelo ID do cliente fornecido
END $$

DELIMITER ;

DROP PROCEDURE IF EXISTS obter_pedidos_cliente;

CALL obter_pedidos_cliente(1);