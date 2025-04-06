-- 1 – Crie o banco de dados com a estrutura a seguir:
create table canteiro (
	canteiroId int primary key auto_increment,
    nome varchar(20),
    luzdiaria double(4,3),
    aguadiaria double(4,3)
);

create table planta (
	id int primary key auto_increment,
    nome varchar(20),
    luzdiaria double(4,3),
    agua double(4,3),
    peso double(4,3)
);

create table funcionario (
	funcId int primary key auto_increment,
    nome varchar(80),
    idade int
);

create table plantio (
	plantioId int primary key auto_increment,
    plantaId int,
    funcId int,
    canteiroId int,
    data date,
    sementes int,
    foreign key (plantaId) references planta(id),
    foreign key (funcId) references funcionario(funcId),
    foreign key (canteiroId) references canteiro(canteiroId)
);

create table colhido (
	colhidoId int primary key auto_increment,
    plantaId int,
    funcId int,
    canteiroId int,
    data date,
    quantidade int,
    peso double(4,3),
	foreign key (plantaId) references planta(id),
    foreign key (funcId) references funcionario(funcId),
    foreign key (canteiroId) references canteiro(canteiroId)
);

drop table if exists planta;
drop table if exists funcionario;
drop table if exists canteiro;
drop table if exists plantio;
drop table if exists colhido;

-- 2 – Insira 3 conjuntos de dados em cada tabela.
insert into planta (nome, luzdiaria, agua, peso) values 
("Rosa",  5.2, 8.4, 5),
("Margarida", 7, 5.1, 8),
("Azaleia", 4.1, 5, 6);

insert into funcionario (nome, idade) values
("Maria", 20),
("Ana", 21),
("Guilherme", 20);

insert into canteiro (nome, luzdiaria, aguadiaria) values
("Fazenda Feliz", 4, 7),
("Rocinha", 9, 9),
("Mococa", 5, 5.4);
    
insert into plantio (plantaId, funcId, canteiroId, data, sementes) values
(1, 1, 1, "2023-08-15", 100),
(2, 2, 2, '2023-08-20', 121),
(3, 3, 3, '2024-08-15', 600);
    
insert into colhido (plantaId, funcId, canteiroId, data, quantidade, peso) values 
(1, 1, 1, "2023-02-15", 5, 9),
(2, 2, 2, "2023-08-15", 23, 5),
(3, 3, 3, "2026-08-15", 100, 7);

-- 3 – Crie um procedimento para fazer uma transação de inserção de 2 dados na tabela planta que tenha alguma incosistência.
DELIMITER //
CREATE PROCEDURE inserir_plantas_com_erro()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SELECT 'Transação cancelada devido a um erro' AS mensagem;
    END;
    
    START TRANSACTION;
    
    -- Primeira inserção válida
    INSERT INTO planta (nome, luzdiaria, agua, peso) 
    VALUES ('Girassol', 8.2, 6.7, 3.5);
    
    -- Segunda inserção com valor inválido (13.5 excede o limite de double(4,3))
    INSERT INTO planta (nome, luzdiaria, agua, peso) 
    VALUES ('Orquídea', 13.5, 4.2, 0.5);
    
    COMMIT;
END //
DELIMITER ;

-- 4 – Crie um procedimento para fazer uma transação de inserção de 2 dados na tabela plantio que tenha sucesso.
DELIMITER //
CREATE PROCEDURE inserir_plantios_com_sucesso()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SELECT 'Transação cancelada devido a um erro' AS mensagem;
    END;
    
    START TRANSACTION;
    
    -- Primeira inserção 
    INSERT INTO plantio (plantaId, funcId, canteiroId, data, sementes)
    VALUES (1, 3, 2, '2024-04-10', 150);
    
    -- Segunda inserção
    INSERT INTO plantio (plantaId, funcId, canteiroId, data, sementes)
    VALUES (2, 1, 3, '2024-04-12', 200);
    
    COMMIT;
    
    SELECT 'Plantios inseridos com sucesso!' AS mensagem;
END //
DELIMITER ;

-- 5 – Crie um procedimento para fazer um update com sucesso na tabela canteiro.
DELIMITER //
CREATE PROCEDURE atualizar_canteiro()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SELECT 'Transação cancelada devido a um erro' AS mensagem;
    END;
    
    START TRANSACTION;
    
    -- Atualizando valores de luz e água do canteiro "Fazenda Feliz"
    UPDATE canteiro 
    SET luzdiaria = 4.5, aguadiaria = 7.5
    WHERE nome = 'Fazenda Feliz';
    
    COMMIT;
    
    SELECT 'Canteiro atualizado com sucesso!' AS mensagem;
END //
DELIMITER ;

-- 6 – Crie duas views para o banco de dados e justifique a criação delas.
-- View 1: Resumo de eficiência de plantio
CREATE VIEW resumo_plantio AS
SELECT 
    p.nome AS planta,
    f.nome AS funcionario,
    c.nome AS canteiro,
    pl.sementes AS sementes_plantadas,
    col.quantidade AS quantidade_colhida,
    (col.quantidade / pl.sementes) * 100 AS taxa_aproveitamento
FROM 
    plantio pl
JOIN 
    colhido col ON pl.plantaId = col.plantaId AND pl.canteiroId = col.canteiroId
JOIN 
    planta p ON pl.plantaId = p.id
JOIN 
    funcionario f ON pl.funcId = f.funcId
JOIN 
    canteiro c ON pl.canteiroId = c.canteiroId;

-- View 2: Compatibilidade planta-canteiro
CREATE VIEW compatibilidade_canteiro AS
SELECT 
    p.nome AS planta,
    c.nome AS canteiro,
    p.luzdiaria AS luz_necessaria,
    c.luzdiaria AS luz_disponivel,
    p.agua AS agua_necessaria,
    c.aguadiaria AS agua_disponivel,
    CASE 
        WHEN ABS(p.luzdiaria - c.luzdiaria) < 1 AND ABS(p.agua - c.aguadiaria) < 1 THEN 'Ótima'
        WHEN ABS(p.luzdiaria - c.luzdiaria) < 2 AND ABS(p.agua - c.aguadiaria) < 2 THEN 'Boa'
        ELSE 'Inadequada'
    END AS compatibilidade
FROM 
    planta p
CROSS JOIN 
    canteiro c;