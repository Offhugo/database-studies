

-- ATIVIDADES COM FOCO EM JOINS E AGREGAÇÕES

-- 1. VALOR TOTAL EM ESTOQUE POR CATEGORIA DE PRODUTO
-- DESAFIO: CALCULAR O VALOR DE DOS PRODUTOS PARADOS EM ESTOQUE PELO SEU VALOR
	
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

-- 2. CONTAGEM DE FUNCIONÁRIOS POR DEPARTAMENTO
-- DESAFIO: APLICAR CORRETAMENTE A REGRA DE NÉGOCIO
	
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

-- 3. TOTAL GASTO EM COMPRAS POR FORNECEDOR
-- DESAFIO: 

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

-- 4. MÉDIA DE DESPERDÍCIO NA PRODUÇÃO POR PRODUTO

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

-- 5. O MAIOR PEDIDO (VALOR ÚNICO) FEIO EM CADA PAÍS

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
