/* Criar um stored procedure que calcule o salário líquido de um
funcionário com base no salário bruto, descontando os impostos (monte a(s)
tabela(s) da forma que achar adequada). */

create table funcionario (
	id int primary key auto_increment,
    salarioBruto double not null
);

delimiter {}

create procedure salarioLiquido(in idFuncionario int, in imposto double, out salarioLiq double) 
	begin
		declare salario double;
	
		-- Busca o salário bruto do funcionário
		select salarioBruto 
		into salario
		from funcionario 
		where id = idFuncionario;
		
		-- Calcula o salário líquido (bruto - imposto)
		set salarioLiq = salario * (1 - imposto);
	end {}
        
delimiter ;

-- Insere um funcionário de exemplo
insert into funcionario (salarioBruto) values (5000.00);

-- Declara um variável de saída
set @liquido = 0;

-- Chama o procedure
call salarioLiquido(1, 0.15, @liquido);  -- 15% de imposto

-- Exibe o resultado
select @liquido as Salario_Liquido;