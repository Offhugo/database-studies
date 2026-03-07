/*******************************************************************************
PROJETO: Desafios de SQL - Business Intelligence (AdventureWorks)
AUTOR: Hugo Mendes
DESCRIÇÃO: Resolução de 5 desafios de SQl envolvendo modelagem relacional
		   Regras de négocio e SQL analítico.
*******************************************************************************/

--------------------------------------------------------------------------------
-- QUESTÃO 1: agregação com múltiplos joins
-- Enunciado: "Calcular o valor total dos produtos que estão parados em estoque
-- agrupado por categoria de produto."

-- Objetivo: Descobrir quanto capital está imobilizado em estoque para cada
-- categoria de produto.

-- Insights:
-- -> Cadeia de joins hierárquica (Inventory → Product → Subcategory → Category)
-- -> Uso de cálculo dentro da agregação (Quantity * StandardCost)
-- -> SUM para consolidar o valor total
-- -> Consulta analítica de inventário
--------------------------------------------------------------------------------
	
	SELECT TOP(100) *
	  FROM Production.ProductInventory

	SELECT *
	  FROM Production.Product

	SELECT TOP(100) *
	  FROM Production.ProductSubcategory

	SELECT TOP(100) *
	  FROM Production.ProductCategory

	SELECT PC.Name,
		   SUM(PI.Quantity * P.StandardCost) AS [ValorTotal]

	  FROM Production.ProductInventory AS PI
	  JOIN Production.Product AS P
	    ON PI.ProductID = P.ProductID
	  JOIN Production.ProductSubcategory AS PS
	    ON P.ProductSubcategoryID = PS.ProductSubcategoryID
	  JOIN Production.ProductCategory AS PC
	    ON PS.ProductCategoryID = PC.ProductCategoryID

	 GROUP BY PC.Name

--------------------------------------------------------------------------------
-- QUESTÃO 2: agregação com regra de negócio (filtro de estado atual)
-- Enunciado: "Contar quantos funcionários estão atualmente em cada departamento."

-- Objetivo: Retornar a quantidade de funcionários ativos por departamento.

-- Insights:
-- -> JOIN entre histórico de departamentos e tabela de departamentos
-- -> Uso de COUNT para contagem de funcionários
-- -> Regra de negócio: considerar apenas registros ativos (EndDate IS NULL)
-- -> Consulta de análise organizacional
--------------------------------------------------------------------------------

	SELECT TOP(100) *
	  FROM HumanResources.Department

	SELECT TOP(100) *
	  FROM HumanResources.EmployeeDepartmentHistory

	SELECT TOP(100) *
	  FROM HumanResources.Employee

	SELECT D.Name,
	       COUNT(EDH.BusinessEntityID) AS [NumeroFuncionarios]

	  FROM HumanResources.EmployeeDepartmentHistory AS EDH
	  JOIN HumanResources.Department AS D
	    ON EDH.DepartmentID = D.DepartmentID
	  JOIN HumanResources.Employee AS E
	    ON EDH.BusinessEntityID = E.BusinessEntityID

	 WHERE EDH.EndDate IS NULL -- AQUI A REGRA

	 GROUP BY D.Name

--------------------------------------------------------------------------------
-- QUESTÃO 3: agregação financeira por entidade
-- Enunciado: "Calcular o valor total gasto em compras para cada fornecedor."

-- Objetivo: Somar todos os pedidos de compra realizados para cada fornecedor.

-- Insights:
-- -> JOIN entre pedidos de compra e fornecedores
-- -> Uso de SUM para consolidar valores financeiros
-- -> GROUP BY por fornecedor
-- -> Consulta analítica de relacionamento com fornecedores
--------------------------------------------------------------------------------

	SELECT TOP(100) *
	  FROM Purchasing.Vendor

	SELECT TOP(100) * 
	  FROM Purchasing.PurchaseOrderHeader

	SELECT V.Name,
	       SUM(PO.TotalDue) AS [TotalComprasporFornecedor]

	  FROM Purchasing.PurchaseOrderHeader AS PO
	  JOIN Purchasing.Vendor AS V
	    ON PO.VendorID = V.BusinessEntityID

     GROUP BY V.Name

--------------------------------------------------------------------------------
-- QUESTÃO 4: agregação com filtro HAVING
-- Enunciado: "Calcular a quantidade total de peças desperdiçadas na produção
-- por produto e mostrar apenas os produtos com desperdício relevante."

-- Objetivo: Identificar produtos com alto nível de desperdício na produção.

-- Insights:
-- -> JOIN entre produtos e ordens de produção
-- -> Uso de SUM para consolidar desperdício
-- -> HAVING para filtrar agregações
-- -> Consulta analítica de eficiência produtiva
--------------------------------------------------------------------------------

	SELECT TOP(100) *
	  FROM Production.Product

	SELECT TOP(100) *
	  FROM Production.WorkOrder
		 
	SELECT P.Name,
		   SUM(WO.ScrappedQty) AS [QuantidadeQuebras]

	  FROM Production.Product AS P
	  JOIN Production.WorkOrder AS WO
	    ON P.ProductID = WO.ProductID

	 GROUP BY P.Name
	HAVING SUM(WO.ScrappedQty) > 50

--------------------------------------------------------------------------------
-- QUESTÃO 5: agregação com ranking implícito (MAX)
-- Enunciado: "Encontrar o maior pedido realizado em cada país."

-- Objetivo: Identificar o pedido de maior valor dentro de cada país.

-- Insights:
-- -> JOIN entre pedidos, territórios de vendas e países
-- -> Uso de MAX para encontrar o maior valor
-- -> GROUP BY por país
-- -> Consulta analítica de desempenho de vendas por região
--------------------------------------------------------------------------------
	SELECT TOP(100) *
	  FROM Sales.SalesOrderHeader

	SELECT TOP(100) *
	  FROM Sales.SalesTerritory

	SELECT TOP(100) *
	  FROM Person.CountryRegion

	SELECT ST.CountryRegionCode,
		   CR.Name,
		   MAX(SO.TotalDue) AS [ValorTotal]

	  FROM Sales.SalesOrderHeader AS SO
	  JOIN Sales.SalesTerritory AS ST
	    ON SO.TerritoryID = ST.TerritoryID
	  JOIN Person.CountryRegion AS CR
	    ON ST.CountryRegionCode = CR.CountryRegionCode

	 GROUP BY ST.CountryRegionCode,
		      CR.Name
