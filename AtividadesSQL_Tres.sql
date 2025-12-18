-- Exercicios AdvetureWorks2022 baseados em funções de agregação e joins 
-- 1.Total de vendas por categoria de produto

	SELECT *
	  FROM Sales.SalesOrderDetail 

	SELECT *
	  FROM Production.ProductSubcategory

	SELECT  *
	  FROM Production.Product

-- 1.0 COLETA VENDAS POR SUBCATEGORIA
	SELECT PPD.Name,
	       SUM(SSO.UnitPrice) AS [ValorTotal]

	  FROM Sales.SalesOrderDetail AS SSO
	  JOIN Production.Product AS PPD
	    ON SSO.ProductID = PPD.ProductID

	  JOIN Production.ProductSubcategory AS PPS
	    ON PPD.ProductSubcategoryID = PPS.ProductSubcategoryID

	 GROUP BY PPD.Name

	          
-- 1.1 COLETA VENDAS POR CATEGORIA(SE LIGA DEPOIS DO VERMOS SUBCATEGORIAS)
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


-- 2.0 TOP 10 CLIENTES COM MAIOR VALOR GASTO

	SELECT *
	  FROM Person.Person

	SELECT *
	  FROM Sales.SalesOrderHeader

	SELECT *
	  FROM Sales.Customer

	SELECT TOP(10) PP.FirstName,
		   PP.LastName,
	       SUM(SOH.TotalDue) AS [ValorTotal]

	  FROM Sales.SalesOrderHeader AS SOH
	  JOIN Sales.Customer AS SC
	    ON SOH.CustomerID = SC.CustomerID
	  JOIN Person.Person AS PP
	    ON SOH.SalesPersonID = PP.BusinessEntityID
	 GROUP BY PP.FirstName,
		      PP.LastName
	 ORDER BY ValorTotal DESC


			 
--- 3.0 Quantidade de Pedidos e média de valor por territorio

	SELECT *
	  FROM Sales.SalesOrderHeader

	SELECT *
	  FROM Sales.SalesTerritory

	SELECT SOH.TerritoryID,
	       ST.Name,
		   COUNT(SOH.CustomerID) AS [PedidosPorRegiao],
		   AVG(SOH.SubTotal) AS [MediaDosValores]

	  FROM Sales.SalesOrderHeader AS SOH
	  JOIN Sales.SalesTerritory AS ST
	    ON SOH.TerritoryID = ST.TerritoryID
	 GROUP BY SOH.TerritoryID,
	          ST.Name

-- 4.0 Total de Vendas Por vendedor

	SELECT *
	  FROM Person.Person

	SELECT *
	  FROM Sales.SalesPerson

	SELECT *
	  FROM Sales.SalesOrderHeader

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
