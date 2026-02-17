/*******************************************************************************
PROJETO: Desafios de SQL - Business Intelligence (AdventureWorks)
AUTOR: Hugo Mendes
DESCRIÇÃO: Resolução de 5 problemas de negócio focados em extração de KPIs, 
           análise de performance e auditoria de dados.
*******************************************************************************/

--------------------------------------------------------------------------------
-- QUESTÃO 1: Ranking de Clientes (Faturamento)
-- Enunciado: "A equipe de Marketing deseja identificar os 10 clientes que geraram o 
--             maior volume de receita para a empresa para uma campanha de fidelidade."

-- Objetivo: Identificar os 10 clientes com maior volume financeiro de compras.
-- Insights: -> Fidelização de clientes VIP e análise de share de faturamento.
--------------------------------------------------------------------------------
	-- CONSULTA DE ANÁLISE PRÉVIA
	SELECT TOP(100) *
	  FROM Person.Person

	SELECT TOP(100) *
	  FROM Sales.Customer
	 WHERE PersonID IS NOT NULL

	SELECT TOP(100) *
	  FROM Sales.SalesOrderHeader

	-- TABELA COM O RESULTADO FINAL
	SELECT TOP(10)  
	       PP.FirstName + ' ' + ISNULL(PP.MiddleName, ' ') + ' ' + PP.LastName AS [Nome completo],
		   SUM(SOH.TotalDue) AS [Valor total]

	  FROM Person.Person AS PP
	  JOIN Sales.Customer AS SC
	    ON PP.BusinessEntityID = SC.PersonID
	  JOIN Sales.SalesOrderHeader AS SOH
	    ON SC.CustomerID = SOH.CustomerID

     GROUP BY PP.FirstName,
			  PP.MiddleName,
			  PP.LastName

	 ORDER BY [Valor total] DESC;

--------------------------------------------------------------------------------
-- QUESTÃO 2: Volume de vendas por categoria
-- Enunciado: "Qual categoria de produto possui o maior giro de estoque (unidades vendidas) no histórico da empresa?"
-- Objetivo: Cruzar a hierarquia de produtos(4 tabelas) para chegar ao volume de itens vendidos.
-- Insights: -> Navegação em joins múltiplos(SnowFlake Schema), conectando categorias a subcategorias, Produtos e,
--			 Finalmente, Detalhes de vendas.
--			 -> Diferenciação entre Valor Financeiro (TotalDue) e Volume de Itens (OrderQty).
--------------------------------------------------------------------------------

	-- CONSULTA DE ANÁLISE PRÉVIA
	SELECT TOP(100) *
	  FROM Production.ProductCategory

	SELECT TOP(100) *
	  FROM Production.ProductSubCategory

	SELECT TOP(100) *
	  FROM Production.Product

	 SELECT TOP(100) *
	  FROM Sales.SalesOrderDetail

	-- TABELA COM O RESULTADO FINAL

	SELECT PC.Name AS [Nome],
		   SUM(SOD.OrderQty) AS [Quantidade Total]

	  FROM Production.ProductCategory AS PC
	  JOIN Production.ProductSubCategory AS PSC
	    ON PC.ProductCategoryID = PSC.ProductCategoryID 
	  JOIN Production.Product AS P
	    ON PSC.ProductSubcategoryID = P.ProductSubcategoryID
	  JOIN Sales.SalesOrderDetail AS SOD
	    ON SOD.ProductID = P.ProductID

	 GROUP BY PC.Name

--------------------------------------------------------------------------------
-- QUESTÃO 3: KPI de Eficiência Logística (Atrasos)
-- Enunciado: "Quantos pedidos por ano levaram mais de 7 dias entre a data do pedido e a data efetiva de envio?"
-- Objetivo: Monitorar o desempenho do setor de expedição ao longo do tempo.
-- Insights: -> Aplicação da função DATEDIFF como filtro (WHERE) para isolar apenas as exceções (atrasos).
--			 -> Uso de funções de data (YEAR) para criar uma série temporal simples e identificar tendências de piora ou melhora anual.
--------------------------------------------------------------------------------
	-- CONSULTA DE ANÁLISE PRÉVIA
	SELECT *
	  FROM Sales.SalesOrderHeader

	-- TABELA COM O RESULTADO REAL

	SELECT YEAR(OrderDate) AS [Ano],
	       COUNT(SalesOrderID) AS [TotalPedidosAtrasado]

	  FROM Sales.SalesOrderHeader
	 WHERE DATEDIFF(day, OrderDate, ShipDate) > 7
	 GROUP BY YEAR(OrderDate)
	 ORDER BY Ano DESC

--------------------------------------------------------------------------------
-- QUESTÃO 4: Ticket Médio por Território
-- Enunciado: "Qual o valor médio gasto por pedido em cada território de vendas?"
-- Objetivo: Identificar as regiões com maior poder aquisitivo ou maior propensão a compras de alto valor.
-- Insights: -> Utilização da função AVG para cálculo de métrica de média aritmética.
--			 -> Aplicação de CAST ou DECIMAL para garantir que o resultado financeiro seja legível para stakeholders (2 casas decimais).
--			 -> Agrupamento geográfico para suporte à decisão de expansão de mercado.
--------------------------------------------------------------------------------

	-- CONSULTA DE ANÁLISE PRÉVIA
	SELECT TOP(100) *
	  FROM Sales.SalesOrderHeader

	SELECT TOP(100) *
	  FROM Sales.SalesTerritory

	-- CONSULTA COM RESULTADO FINAL

	SELECT ST.CountryRegionCode AS [Regiao],
		   ST.Name AS [Territorio],
		   CAST(AVG(SOH.TotalDue) AS DECIMAL(10,2)) AS [Ticket medio]

	  FROM Sales.SalesTerritory AS ST
	  JOIN Sales.SalesOrderHeader AS SOH
	    ON ST.TerritoryID = SOH.TerritoryID
	 GROUP BY ST.Name,
	          ST.CountryRegionCode
	 ORDER BY [Ticket medio] DESC

--------------------------------------------------------------------------------
-- QUESTÃO 5: Auditoria de Base (Data Quality)
-- Enunciado: "Identificar clientes que estão com o cadastro incompleto (sem endereço de e-mail) para higienização da base."
-- Objetivo: Encontrar lacunas de informação que prejudicam as campanhas de marketing.
-- Insights: -> Uso estratégico do LEFT JOIN para manter todos os registros da tabela principal (Pessoas)
--              e identificar a ausência de registros na tabela secundária.
--			 -> Filtro de exclusão com IS NULL para isolar apenas os "órfãos" de dados.		 
--------------------------------------------------------------------------------

	-- CONSULTA DE ANÁLISE PRÉVIA
	SELECT  *

	  FROM Person.Person

	 SELECT *

	   FROM Person.EmailAddress

	-- CONSULTA COM RESULTADO FINAL

	SELECT PP.FirstName + ' ' + PP.LastName AS [Nome Completo]
		   
	  FROM Person.Person AS PP
	   LEFT JOIN Person.EmailAddress AS PE
	    ON PP.BusinessEntityID = PE.BusinessEntityID
	
	 WHERE PE.EmailAddress IS NULL

