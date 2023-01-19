---- Oportunidade de crescimento para clientes

select  
	a.Ano,
	a.CodCliente,
	sum(distinct b.Valorpotencial) as ValorPotencial,
	sum(a.valor) as ValorVendas
into #temp1 ---- Tabela temporaria
from tbVendas_final a
inner join tbPotencial_final b
on a.CodCliente = b.CodCliente
and a.Ano = b.Ano
group by a.Ano, a.CodCliente

select * from #temp1

----- Formatação

select Ano,
	FORMAT(sum(ValorPotencial),'###,##0.00','pt-br') as ValorPotencial,
	FORMAT(sum(ValorVendas),'###,##0.00','pt-br') as ValorVendas,
	FORMAT(sum(ValorPotencial) - SUM(ValorVendas),'###,##0.00','pt-br') as Oportunidade,
	abs(((sum(ValorVendas)/sum(ValorPotencial))*100)-100) [Oportunidade%]
from #temp1
group by Ano
order by Ano

----- Formatação 2

select Ano,
		round(abs(((sum(ValorVendas)/sum(ValorPotencial))*100)-100),1) as [Oportunidade%],
		round(abs(abs(((sum(ValorVendas)/sum(ValorPotencial))*100)-100)-100),1) as [Alcançado%]
from #temp1
group by Ano
order by Ano

---- Entendendo a Perda de Clientes
select	* 
from(
	select Ano,
		   Categoria,
		   Valor
	from tbvendas_final 
	where mes <= 8
		) t 
pivot (sum(Valor) for Categoria in ([X],[XTZ250],[XT660],[CB750])) p
order by ano

---- Quantidade de Clientes

select Ano,
		count(distinct codcliente)as [#Clientes]
from tbVendas_final
where mes <= 8
group by Ano
order by Ano


----Tabela #tmp_nc
select	Ano, 
		sum(Area_Comercial) as Area_Comercial, 
		sum(Area_Hibrida) as Area_Hibrida, 
		sum(Area_residencial) as Area_residencial, 
		sum(Area_industrial) as Area_industrial, 

		sum(Area_Comercial)+
		sum(Area_Hibrida)+
		sum(Area_residencial)+
		sum(Area_industrial) as AreaTotal,

		sum(ValorPotencial) as ValorVendasPotencial
into	#tmp_nc
from	tbPotencial_final  a
where	not exists (select	1 
					from	tbVendas_final b
					where	a.CodCliente = b.CodCliente 
					and		a.Ano = b.Ano )
group	by Ano

select * from #tmp_nc

----Transformar em percentual
select	* from	#tmp_nc order by ano

select	Ano,
		Area_Comercial/AreaTotal*100 as [Area_Comercial%],
		Area_Hibrida/AreaTotal*100 as [Area_Hibrida%],
		Area_residencial/AreaTotal*100 as [Area_residencial%],
		Area_industrial/AreaTotal*100 as [Area_industrial%],
		ValorVendasPotencial
from	#tmp_nc order by ano

----Total de clientes
select	a.ano, count(distinct codcliente) as Qtde
from	tbPotencial_final  a
where	not exists (select	1 
					from	tbVendas_final b
					where	a.CodCliente = b.CodCliente 
					and		a.Ano = b.Ano )
group by a.ano
with rollup

---- Analise por cidade

---- Ranking

select	top 10 
		Cidade, 
		sum(valor) as Valor 
from	tbVendas_final
Group	by Cidade 
order	by 2 desc

select *
---into	#tmp_cidade
from	(
select	top 10 
		Cidade, 
		sum(valor) as Valor 
from	tbVendas_final
Group	by Cidade 
order	by 2 desc
) x order by 2

--Total das Top10 Cidades
select SUM(valor) from #tmp_cidade

--Quantidade de cidades
select count(distinct cidade) from tbVendas_final

--Percetual das 10 cidades
Declare @total_top10 as float
select @total_top10 = SUM(valor) from #tmp_cidade
select round(@total_top10/SUM(valor)*100,2) as Perc from tbVendas_final

select count(distinct codcliente) from tbVendas_final where cidade in (select cidade from #tmp_cidade)
--Quantidade de transações
select count(codcliente) from tbVendas_final where cidade in (select cidade from #tmp_cidade)
--Total transações
select count(codcliente) from tbVendas_final


---- Clientes que consomem apenas 1 produto

With Clientes AS
    (
            select	CodCliente,
					produto
			from	tbVendas_final 
			group	by produto, CodCliente
    )
    SELECT *
	into	#tmp_produto1
    FROM	Clientes
--##	Grafico de rosca
	select	Categoria, sum(Valor) as Valor
	from	(select codcliente, 
					count(codcliente) as Qtde 
			from	#tmp_produto1 
			group	by codcliente 
			having	count(codcliente) =1 ) as X
	inner	join tbVendas_final b
	on		x.CodCliente = b.CodCliente
	group	by Categoria
	order by 1
--##
	select distinct codcliente from tbVendas_final

	select distinct Produto
		from	(select codcliente, 
					count(codcliente) as Qtde 
			from	#tmp_produto1 
			group	by codcliente 
			having	count(codcliente) =1 ) as X
	inner	join tbVendas_final b
	on		x.CodCliente = b.CodCliente
