/* Considere duas tabelas: "alunos" e "notas". 
Crie um procedimento armazenado chamado "obter_media_aluno" 
que recebe o ID de um aluno como parâmetro e calcula a média das notas desse aluno. 
O procedimento deve retornar o nome do aluno e sua média.*/

DROP TABLE IF EXISTS alunos;
DROP TABLE IF EXISTS notas;

CREATE TABLE alunos (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL
);

CREATE TABLE notas (
    id INT PRIMARY KEY AUTO_INCREMENT,
    aluno_id INT,
    nota DECIMAL(5,2),
    FOREIGN KEY (aluno_id) REFERENCES alunos(id)
);

-- Inserindo alunos
INSERT INTO alunos (nome) VALUES 
('Ana Silva'),
('Bruno Souza'),
('Carla Mendes'),
('Daniel Oliveira'),
('Eduarda Lima');

-- Inserindo notas associadas aos alunos
INSERT INTO notas (aluno_id, nota) VALUES 
(1, 8.5),
(1, 7.2),
(2, 9.0),
(2, 6.8),
(3, 7.5),
(3, 8.0),
(4, 5.5),
(4, 6.0),
(5, 9.5),
(5, 9.8);

SELECT * FROM alunos;
SELECT * FROM notas;

DELIMITER $$

CREATE PROCEDURE obter_media_aluno(IN aluno_id INT)
BEGIN
    DECLARE aluno_nome VARCHAR(100);
    DECLARE media DECIMAL(5,2);
    
    -- Obtém o nome do aluno
    SELECT nome INTO aluno_nome FROM alunos WHERE id = aluno_id;
    
    -- Calcula a média das notas do aluno
    SELECT AVG(nota) INTO media FROM notas WHERE aluno_id = aluno_id;
    
    -- Retorna os resultados
    SELECT aluno_nome AS Nome, COALESCE(media, 0) AS Média;
END$$

DELIMITER ;

DROP PROCEDURE IF EXISTS obter_media_aluno;

CALL obter_media_aluno(1);