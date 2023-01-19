----- Tabela Vendas

create table tbVendas_final(
CodCliente int,
Categoria varchar(50),
SubCategoria varchar(50),
Produto varchar(50),
Ano int,
Mes int,
Cidade varchar(50),
Valor float,
Volume float
);

truncate table tbVendas_final

---- carrega dados massivos csv

BULK INSERT tbVendas_final
	FROM 'C:\BaseDados\Vendas.csv'
	WITH
	(
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	ROWTERMINATOR = '0x0a'
	)

select * from tbVendas_final


----- Tabela Potencial

create table tbPotencial_final(
CodCliente int,
Ano int,
Area_Comercial float,
Area_Hibrida float,
Area_Residencial float,
Area_Industrial float,
ValorPotencial float
);

BULK INSERT tbPotencial_final
	FROM 'C:\BaseDados\potencial.csv'
	WITH
	(
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	ROWTERMINATOR = '0x0a'
	)

select * from tbPotencial_final


----- Criando INDEX

CREATE INDEX index_potencial ON tbPotencial_final (CodCliente);
CREATE INDEX index_vendas ON tbVendas_final (CodCliente);