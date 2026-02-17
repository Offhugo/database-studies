/*
PROJETO: Análise de Dados AdventureWorks2022
AUTOR: Hugo Mendes Ferreira Junior
DATA: Dezembro/2025
LINKEDIN: www.linkedin.com/in/offhugo
DESCRIÇÃO: Conjunto de queries focadas em responder perguntas de negócio 
sobre Vendas, RH e Produção, evoluindo de Joins simples para Agregações Complexas.
*/

-- 1.0 Tempo Médio de Envio por Território (Em Dias)

	SELECT TOP(1000) *
	  FROM Sales.SalesOrderHeader 

	SELECT TOP(100) *
	  FROM Sales.SalesTerritory

	SELECT SOH.TerritoryID,
		   ST.Name,
		   ST.CountryRegionCode,
		   AVG(DATEDIFF(DAY, SOH.OrderDate, SOH.ShipDate)) AS [Média]

	  FROM Sales.SalesOrderHeader AS SOH
	  JOIN Sales.SalesTerritory AS ST
	    ON SOH.TerritoryID = ST.TerritoryID

	 GROUP BY SOH.TerritoryID,
	          ST.Name,
			  ST.CountryRegionCode

/*
	SOLUÇÃO:
	Primeiro foquei na junção correta entre as duas tabelas
	Depois verificar quais as colunas corretas a serem agregadas
	E por fim o foco final foi o de realizar o cálculo correto
*/

-- 2.0 Produtos que NUNCA foram vendidos

	SELECT TOP(100) *
	  FROM Production.Product

	SELECT *
	  FROM Sales.SalesOrderDetail

	SELECT OD.SalesOrderDetailID,
		   P.ProductID,
	       P.Name,
		   P.SafetyStockLevel

	  FROM Production.Product AS P
	  LEFT JOIN Sales.SalesOrderDetail AS OD
	    ON OD.ProductID = P.ProductID
	
	 WHERE OD.SalesOrderDetailID IS NULL

/*
	SOLUÇÃO:
	Primeiramente analisei as tabelas pra entender suas estruturas
	Logo em seguida identifiquei a chaves que conectavam a tabela
	selecionei qual a tabela que eu iria manter a esquerda com os dados que cumprem com o que foi pedido
	Por fim foi selecionar as colunas adequadas a serem mostradas e alicar o filtro correto

*/

-- 3.0 Classificação de Pedidos

	SELECT SalesOrderID,
		   TotalDue,
		   CASE 
			   WHEN TotalDue >= 10000 THEN 'Venda Alta'
			   WHEN TotalDue < 10000 AND TotalDue >= 1000 THEN 'Venda Média'
			   WHEN TotalDue < 1000 THEN 'Venda Baixa'
		   END AS [Vendas]

	  FROM Sales.SalesOrderHeader

/*
	SOLUÇÃO:
	Aqui foi como fazer um if-else simples porém aplicado a uma query
*/

-- 4.0 Total de Vendas por Ano e Mês

	SELECT YEAR(OrderDate) AS [Ano],
		   MONTH(OrderDate) AS [Meses],
		   SUM(TotalDue) AS [ValorTotalPorMes]

	  FROM Sales.SalesOrderHeader

	 GROUP BY YEAR(OrderDate),
			  MONTH(Orderdate)

	 ORDER BY Ano,
		      Meses

/*
	SOLUÇÃO:
	O importante aqui foi delimitar bem o que eu quero das datas
	específicando o ano e o mês, o restante foi aplicar o agrupamento correto
	e a ordenação afim de ter uma melhor vizualização
*/

-- 5.0 receita por motivo de venda

	SELECT TOP(100) *
	  FROM Sales.SalesReason

	SELECT *
	  FROM Sales.SalesOrderHeader

	SELECT TOP(100) *
	  FROM Sales.SalesOrderHeaderSalesReason

	SELECT SR.SalesReasonID,
	       SR.Name,
		   SUM(SOH.TotalDue) AS [ValorPorMotivos]

	  FROM Sales.SalesOrderHeader AS SOH
	  JOIN Sales.SalesOrderHeaderSalesReason AS SHRS
	    ON SOH.SalesOrderID = SHRS.SalesOrderID
	  JOIN Sales.SalesReason AS SR
	    ON SR.SalesReasonID = SHRS.SalesReasonID

	 GROUP BY SR.SalesReasonID,
			  SR.Name

	 ORDER BY ValorPorMotivos

/*
	SOLUÇÃO:
	Primeiro identifiquei quais seriam as tabelas necessárias 
	Depois vi quais seriam as colunas corretar para obter a ligação correta entre elas
	e pra finalizar foi mais uma questão de ordenar tudo da forma correta e agregar a informação necessária 
*/


