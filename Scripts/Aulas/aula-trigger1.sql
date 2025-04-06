CREATE DATABASE EXERCICIOS_TRIGGER;

USE EXERCICIOS_TRIGGER;

-- Criação das tabelas
CREATE TABLE clientes (
    id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    saldo DECIMAL(10, 2) NOT NULL
);

CREATE TABLE pedidos (
    id_pedido INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT,
    valor DECIMAL(10, 2) NOT NULL,
    data_pedido DATE NOT NULL,
    FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente)
);

CREATE TABLE historico_pedidos (
    id_historico INT AUTO_INCREMENT PRIMARY KEY,
    id_pedido INT,
    descricao VARCHAR(255),
    data_historico TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

SELECT * FROM clientes;

SELECT * FROM pedidos;

SELECT * FROM historico_pedidos;

INSERT INTO clientes (nome, saldo) VALUES 
('Alice', 500.00),
('Bob', 300.00),
('Carlos', 1000.00);

INSERT INTO pedidos (id_cliente, valor, data_pedido) VALUES 
(4, 50.00, '2025-03-18'),  -- Alice compra algo de 50
(2, 100.00, '2025-03-18'), -- Bob compra algo de 100
(3, 200.00, '2025-03-18'); -- Carlos compra algo de 200

INSERT INTO pedidos (id_cliente, valor, data_pedido) VALUES 
(2, 100.00, '2025-03-18'); -- Bob compra algo de 100

UPDATE pedidos SET valor = 60.00 WHERE id_pedido = 1;

-- Lista de Exercícios com Triggers
-- 1. Crie um trigger que, ao inserir um novo pedido, subtraia o valor do pedido do saldo do cliente correspondente.

DELIMITER $

CREATE TRIGGER ai_pedidos_subtrai_saldo AFTER INSERT ON pedidos
	FOR EACH ROW BEGIN
		UPDATE clientes 
		SET saldo = saldo - NEW.valor
		WHERE id_cliente = NEW.id_cliente;
	END$
    
DELIMITER ;

DROP TRIGGER ai_pedidos_subtrai_saldo;

-- 2. Crie um trigger que impeça a inserção de pedidos cujo valor seja maior que o saldo disponível do cliente

DELIMITER $

CREATE TRIGGER bi_pedidos_verifica_salda BEFORE INSERT ON pedidos
	FOR EACH ROW BEGIN
		DECLARE saldo_atual DECIMAL(10,2);
		
		-- Obtém o saldo do cliente
		SELECT saldo INTO saldo_atual 
		FROM clientes 
		WHERE id_cliente = NEW.id_cliente;
		
		-- Verifica se o saldo é suficiente
		IF saldo_atual < NEW.valor THEN
			SIGNAL SQLSTATE '45000'
			SET MESSAGE_TEXT = 'Saldo insuficiente para realizar o pedido';
		END IF;
	END$
    
DELIMITER ;

DROP TRIGGER bi_pedidos_verifica_salda;

-- 3. Crie um trigger que registre na tabela `historico_pedidos` uma descrição informando que um novo pedido foi realizado, incluindo o ID do pedido e a data do pedido.

DELIMITER $
    
CREATE TRIGGER ai_pedidos_historico AFTER INSERT ON pedidos
	FOR EACH ROW BEGIN
		INSERT INTO historico_pedidos (id_pedido, descricao, data_historico) 
		VALUES (NEW.id_pedido, CONCAT('Pedido ', NEW.id_pedido, ' realizado em ', NEW.data_pedido), CURRENT_TIMESTAMP());
	END$
    
DELIMITER ;

DROP TRIGGER ai_pedidos_historico;

-- 4. Crie um trigger que, ao excluir um pedido, registre essa ação na tabela `historico_pedidos`, incluindo o ID do pedido e a mensagem "Pedido excluído".

DELIMITER $

CREATE TRIGGER ad_delete_pedidos BEFORE DELETE ON pedidos
	FOR EACH ROW BEGIN
		INSERT INTO historico_pedidos (id_pedido, descricao, data_historico) 
		VALUES (OLD.id_pedido, CONCAT('Pedido ', OLD.id_pedido, ' realizado em ', OLD.data_pedido), CURRENT_TIMESTAMP());
	END$
    
DELIMITER ;

DROP TRIGGER ad_delete_pedidos;

-- 5. Crie um trigger que impeça a atualização do valor de um pedido caso a nova quantia seja maior que 20% do valor original.

DELIMITER $

CREATE TRIGGER bu_pedidos_valor_20 BEFORE UPDATE ON pedidos
	FOR EACH ROW BEGIN
		DECLARE valor_maximo DECIMAL(10,2);
    
		-- Calcula o valor máximo permitido (20% acima do valor original)
		SET valor_maximo = OLD.valor * 1.2;
		
		-- Verifica se o novo valor ultrapassa o limite
		IF NEW.valor > valor_maximo THEN
			SIGNAL SQLSTATE '45000'
			SET MESSAGE_TEXT = 'O novo valor do pedido não pode ser superior a 20% do valor original';
		END IF;
	END$
    
DELIMITER ;

DROP TRIGGER bu_pedidos_valor_20;