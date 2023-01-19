----- Criação da view Potencial

create view vw_Potencial as
select
	a.codcliente,
	a.Ano,
	a.Area_Comercial,
	a.Area_Hibrida,
	a.Area_Residencial,
	a.Area_Industrial,
	ValorPotencial, sum(valor) as ValorVendas
from tbPotencial_final a
left join tbVendas_final b
on a.CodCliente = b.CodCliente
and a.Ano = b.Ano
group by
	a.codcliente,
	a.Ano,
	a.Area_Comercial,
	a.Area_Hibrida,
	a.Area_Residencial,
	a.Area_Industrial,
	ValorPotencial
go

select * from vw_Potencial