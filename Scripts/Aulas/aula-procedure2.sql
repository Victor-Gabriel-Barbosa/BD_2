/*Considere três tabelas: "produtos", "categorias" e "estoque". 
Crie um procedimento armazenado chamado "obter_estoque_categoria" 
que recebe o nome de uma categoria como parâmetro e 
retorna todos os produtos dessa categoria junto com as informações 
de estoque de cada produto (nome do produto, quantidade em estoque).*/

DROP TABLE IF EXISTS categorias;
DROP TABLE IF EXISTS produtos;
DROP TABLE IF EXISTS estoque;

-- Tabela que armazena as categorias dos produtos
CREATE TABLE categorias (
    id INT AUTO_INCREMENT PRIMARY KEY,  
    nome VARCHAR(255) UNIQUE NOT NULL 
);

-- Tabela que armazena os produtos
CREATE TABLE produtos (
    id INT AUTO_INCREMENT PRIMARY KEY,  
    nome VARCHAR(255) NOT NULL,  
    categoria_id INT, 
    FOREIGN KEY (categoria_id) REFERENCES categorias(id)  -- Chave estrangeira para categorias
);

-- Tabela que armazena o estoque dos produtos
CREATE TABLE estoque (
    id INT AUTO_INCREMENT PRIMARY KEY,
    produto_id INT, 
    quantidade INT NOT NULL, 
    FOREIGN KEY (produto_id) REFERENCES produtos(id)  -- Chave estrangeira para produtos
);

-- Insere categorias
INSERT INTO categorias (nome) VALUES 
('Eletrônicos'),
('Roupas'),
('Alimentos');

-- Insere produtos
INSERT INTO produtos (nome, categoria_id) VALUES 
('Smartphone', 1), 
('Notebook', 1), 
('Camiseta', 2), 
('Calça Jeans', 2), 
('Chocolate', 3), 
('Arroz', 3);

-- Insere estoque
INSERT INTO estoque (produto_id, quantidade) VALUES 
(1, 50),  -- Smartphone
(2, 30),  -- Notebook
(3, 100), -- Camiseta
(4, 75),  -- Calça Jeans
(5, 200), -- Chocolate
(6, 500); -- Arroz

SELECT * FROM categorias;
SELECT * FROM produtos;
SELECT * FROM estoque;

DELIMITER $$
-- Procedimento armazenado para obter o estoque de produtos por categoria
CREATE PROCEDURE obter_estoque_categoria(IN nome_categoria VARCHAR(255))
BEGIN
    -- Retorna o nome do produto e a quantidade em estoque filtrando pela categoria informada
    SELECT p.nome AS produto, e.quantidade AS estoque
    FROM produtos p
    JOIN categorias c ON p.categoria_id = c.id
    JOIN estoque e ON p.id = e.produto_id
    WHERE c.nome = nome_categoria;
END $$
DELIMITER ;

DROP PROCEDURE IF EXISTS obter_estoque_categoria;

CALL obter_estoque_categoria('Eletrônicos');