/*******************************************************************************
PROJETO: Desafios de SQL - Business Intelligence (AdventureWorks)
AUTOR: Hugo Mendes
DESCRIÇÃO: Resolução de 5 problemas de negócio focados em extração de KPIs, 
           análise de performance e auditoria de dados.
*******************************************************************************/

-- AGREGAÇÃO
--------------------------------------------------------------------------------
-- QUESTÃO 1: Total de vendas por produto
-- Enunciado: "Qual o valor total vendido por produto?"

-- Objetivo:
-- Somar o valor das vendas associadas a cada produto.

-- Insights:
--  -> JOIN entre vendas e produto
--  -> SUM para cálculo de receita
--  -> GROUP BY por entidade de produto
--  -> Métrica de faturamento individual
--------------------------------------------------------------------------------

	-- CONSULTAS DE ANÁLISE
	SELECT *
	  FROM Sales.SalesOrderDetail 

	SELECT *
	  FROM Production.ProductSubcategory

	SELECT  *
	  FROM Production.Product

--  CONSULTA COM RESULTADO REAL
	SELECT PPD.Name,
	       SUM(SSO.LineTotal) AS [ValorTotal]

	  FROM Sales.SalesOrderDetail AS SSO
	  JOIN Production.Product AS PPD
	    ON SSO.ProductID = PPD.ProductID

	  JOIN Production.ProductSubcategory AS PPS
	    ON PPD.ProductSubcategoryID = PPS.ProductSubcategoryID

	 GROUP BY PPD.Name

	          
-- REGRA DE NÉGOCIO
--------------------------------------------------------------------------------
-- QUESTÃO: 1.1
-- Enunciado: "Qual o total de vendas por categoria de produto?"

-- Objetivo:
-- Consolidar o faturamento agrupando por categoria principal.

-- Insights:
--  -> JOIN encadeado (Produto → Subcategoria → Categoria)
--  -> SUM para receita total
--  -> GROUP BY por categoria
--  -> ORDER BY para ranking de faturamento
--  -> Estrutura dimensional típica de BI
--------------------------------------------------------------------------------

	SELECT PC.Name AS Categoria,
           SUM(SOD.LineTotal) AS TotalVendas

      FROM Production.Product AS P
INNER JOIN Sales.SalesOrderDetail AS SOD 
        ON P.ProductID = SOD.ProductID

INNER JOIN Production.ProductSubcategory AS PSC 
        ON P.ProductSubcategoryID = PSC.ProductSubcategoryID

INNER JOIN Production.ProductCategory AS PC 
        ON PSC.ProductCategoryID = PC.ProductCategoryID

     GROUP BY PC.Name
     ORDER BY TotalVendas DESC;

-- MÉTRICAS REGIONAIS
--------------------------------------------------------------------------------
-- QUESTÃO: 2.0
-- Enunciado: "Quais são os 10 clientes que mais gastaram?"

-- Objetivo:
-- Identificar os clientes com maior volume financeiro acumulado.

-- Insights:
--  -> SUM para consolidar gasto total
--  -> GROUP BY por cliente
--  -> ORDER BY decrescente
--  -> TOP(10) para ranking
--  -> Análise de comportamento de consumo
--------------------------------------------------------------------------------

	-- CONSULTAS DE ANÁLISE
	SELECT *
	  FROM Person.Person

	SELECT *
	  FROM Sales.SalesOrderHeader

	SELECT *
	  FROM Sales.Customer

	-- CONSULTA CONCRETA
	SELECT TOP(10) PP.FirstName,
		   PP.LastName,
	       SUM(SOH.TotalDue) AS [ValorTotal]

	  FROM Sales.SalesOrderHeader AS SOH
	  JOIN Sales.Customer AS SC
	    ON SOH.CustomerID = SC.CustomerID

	  JOIN Person.Person AS PP
	    ON SC.PersonID = PP.BusinessEntityID

	 GROUP BY PP.FirstName,
		      PP.LastName
	 ORDER BY ValorTotal DESC


			 
--------------------------------------------------------------------------------
-- QUESTÃO: 3.0
-- Enunciado: "Qual a quantidade de pedidos e a média de valor por território?"

-- Objetivo:
-- Calcular métricas regionais de desempenho comercial.

-- Insights:
--  -> COUNT para volume de pedidos
--  -> AVG para ticket médio
--  -> JOIN entre pedido e território
--  -> GROUP BY por região
--  -> Indicador de performance geográfica
--------------------------------------------------------------------------------

	-- CONSULTAS DE ANÁLISE
	SELECT *
	  FROM Sales.SalesOrderHeader

	SELECT *
	  FROM Sales.SalesTerritory

	-- CONSULTA COM RESULTADO REAL
	SELECT SOH.TerritoryID,
	       ST.Name,
		   COUNT(SOH.CustomerID) AS [PedidosPorRegiao],
		   AVG(SOH.SubTotal) AS [MediaDosValores]

	  FROM Sales.SalesOrderHeader AS SOH
	  JOIN Sales.SalesTerritory AS ST
	    ON SOH.TerritoryID = ST.TerritoryID
	 GROUP BY SOH.TerritoryID,
	          ST.Name

--------------------------------------------------------------------------------
-- QUESTÃO: 4.0
-- Enunciado: "Qual o total vendido por cada vendedor?"

-- Objetivo:
-- Consolidar o faturamento por profissional de vendas.

-- Insights:
--  -> JOIN entre pedido, vendedor e pessoa
--  -> SUM para receita total
--  -> GROUP BY múltiplo
--  -> Tratamento de NULL com ISNULL
--  -> ORDER BY para ranking
--  -> Filtro para excluir pedidos sem vendedor
--------------------------------------------------------------------------------

	-- CONSULTAS DE ANÁLISE
	SELECT *
	  FROM Person.Person

	SELECT *
	  FROM Sales.SalesPerson

	SELECT *
	  FROM Sales.SalesOrderHeader

	-- CONSULTA COM RESULTADO REAL
	SELECT PP.FirstName + ' ' + ISNULL(PP.MiddleName, ' ') + ' ' + PP.LastName AS [NomeCompleto],
		   SP.BusinessEntityID,
		   SUM(SOH.TotalDue) AS [ValorTotalVendas]

	  FROM Sales.SalesOrderHeader AS SOH

	  JOIN Sales.SalesPerson AS SP 
	    ON SOH.SalesPersonID = SP.BusinessEntityID
	  JOIN Person.Person AS PP
	    ON PP.BusinessEntityID = SP.BusinessEntityID

	 WHERE SOH.SalesPersonID IS NOT NULL

	 GROUP BY SP.BusinessEntityID,
			  PP.FirstName,
			  PP.MiddleName,
			  PP.LastName

	 ORDER BY ValorTotalVendas DESC

-- 5.0 Produtos com mais de 10 Unidades vendidas

	SELECT *
	  FROM Production.Product

	SELECT *
	  FROM Sales.SalesOrderDetail

	SELECT SOD.ProductID,
		   PP.Name,
		   SOD.OrderQty,
		   SUM(SOD.LineTotal) AS [ValorTotal]

	  FROM Sales.SalesOrderDetail AS SOD
	  JOIN Production.Product AS PP 
	    ON SOD.ProductID = PP.ProductID

	 GROUP BY SOD.ProductID,
		   PP.Name,
		   SOD.OrderQty

	HAVING SUM(SOD.OrderQty) > 10
