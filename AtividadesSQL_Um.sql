
--	1.QUESTÃO

	SELECT BusinessEntityID,
		   FirstName + ' ' + MiddleName + ' ' + LastName AS [NomeCompleto]

	  FROM Person.Person
	 WHERE MiddleName IS NOT NULL

	 ORDER BY NomeCompleto

-- 2.QUESTÃO

	SELECT COUNT(SalesOrderID) AS [NumeroTotalPedidos2014]
      FROM Sales.SalesOrderHeader
     WHERE YEAR(OrderDate) = 2014;

-- 3.QUESTÃO



	SELECT *
	  FROM Sales.CountryRegionCurrency

	SELECT COUNT(*) AS [VendasTotalPorRegiao],
		   TerritoryID,
		   TotalDue

	  FROM Sales.SalesOrderHeader
	 WHERE TotalDue > 100000
	 GROUP BY TerritoryID,
		      TotalDue

-- FORMA CORRETA DE SE FAZER
	SELECT TerritoryID, 
		   SUM(TotalDue) AS [ValorTotalVendido]
		   
	  FROM Sales.SalesOrderHeader 
	 GROUP BY TerritoryID 
	HAVING SUM(TotalDue) > 1000000.00 -- Filtrando o resultado agregado
	 ORDER BY ValorTotalVendido

-- 4.QUESTÃO


 
	SELECT MAX(ListPrice) AS [ValorMax],
		   MIN(ListPrice) AS [ValorMin]

	  FROM Production.Product
	 WHERE ListPrice > 0
	 
-- 5.QUESTÃO -> EXIBA O NOME DOS PRODUTOS E AS SUAS SUBCATEGORIAS(SOMENTE PRODUTOS COM SUBCATEGORIA)	

	SELECT PP.ProductID,
		   PP.Name AS [Produto],
		   PPS.Name AS [subcategoria],
		   PPS.ProductCategoryID
		  
	  FROM Production.Product AS PP
	  JOIN Production.ProductSubcategory AS PPS
	    ON PP.ProductSubcategoryID = PPS.ProductSubcategoryID


-- RESPOSTA CORRETA

	SELECT PP.Name AS NomeProduto,
           PPS.Name AS NomeSubcategoria 

      FROM Production.Product AS PP
     INNER JOIN Production.ProductSubcategory AS PPS
        ON PP.ProductSubcategoryID = PPS.ProductSubcategoryID;

	  SELECT *
	  FROM Production.Product

-- 6.QUESTÃO
	SELECT PPS.ProductSubcategoryID,
		   PPS.Name AS [NomeDaCategoria],
		   COUNT(PP.Name) AS [NomeProduto]

	  FROM Production.ProductSubcategory AS PPS
	  LEFT JOIN Production.Product AS PP
	    ON PPS.ProductSubCategoryID = PP.ProductSubcategoryID
	 GROUP BY PPS.Name,
			  PPS.ProductSubcategoryID

-- X.QUESTÃO EXTRA

	SELECT PP.FirstName,
	       SSO.SalesPersonID,
		   COUNT(*) AS [QtdCompras],
		   SUM(SSO.TotalDue) AS [ValorTotal]

	  FROM Sales.SalesOrderHeader AS SSO
	  JOIN Person.Person AS PP
	    ON PP.BusinessEntityID = SSO.SalesPersonID
	 GROUP BY PP.FirstName,
	          SSO.SalesPersonID

-- 7.QUESTÃO

    SELECT *
	  FROM Person.Person

	SELECT *
	  FROM Sales.SalesOrderHeader

	SELECT PP.FirstName + ' ' + ISNULL(PP.MiddleName, ' ') + ' ' + PP.LastName AS [Nome Completo],
	       SSO.CustomerID,
		   SSO.OrderDate
	  FROM Person.Person AS PP 
	  JOIN Sales.SalesOrderHeader AS SSO
	    ON PP.BusinessEntityID = SSO.CustomerID

-- 8.QUESTÂO

    SELECT *
      FROM HumanResources.Employee


	SELECT PP_func.FirstName + ' ' + PP_func.LastName AS [funcionario],
		   PP_ger.FirstName + ' ' + PP_ger.LastName AS [gerente]

	  FROM HumanResources.Employee AS funcionario
	  -- JOIN para ligar o nome do funcionario
	  JOIN Person.Person AS PP_func
	    ON funcionario.BusinessEntityID = PP_func.BusinessEntityID

	  -- JOIN para ligar o funcionário ao id do seu gerente(que também é um ID de funcionário)
	  JOIN HumanResources.Employee AS gerente
	    ON funcionario.OrganizationNode.GetAncestor(1) = gerente.OrganizationNode

	  -- JOIN para ligar o ID de gerente ao ID que tem o seu nome
	  JOIN Person.Person AS PP_ger
	    ON PP_ger.BusinessEntityID = gerente.BusinessEntityID

-- F1.QUESTÃO

	SELECT Color,
		   COUNT(ProductID) AS [TotalCores]

	  FROM Production.Product
	 WHERE Color = 'red' OR Color IS NULL
	 GROUP BY Color



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








	
