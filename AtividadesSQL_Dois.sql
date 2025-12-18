-- Atividades que reforçam meus conhecimentos em SQL e com um foco específico em funções de agregação e join aninhados

-- 1.QUESTÃO
	SELECT PPS.ProductSubcategoryID,
		   PPS.Name AS [NomeDaCategoria],
		   COUNT(PP.Name) AS [NomeProduto]

	  FROM Production.ProductSubcategory AS PPS
	  LEFT JOIN Production.Product AS PP
	    ON PPS.ProductSubCategoryID = PP.ProductSubcategoryID
	 GROUP BY PPS.Name,
			  PPS.ProductSubcategoryID

-- 2.QUESTÃO EXTRA

	SELECT PP.FirstName,
	       SSO.SalesPersonID,
		   COUNT(*) AS [QtdCompras],
		   SUM(SSO.TotalDue) AS [ValorTotal]

	  FROM Sales.SalesOrderHeader AS SSO
	  JOIN Person.Person AS PP
	    ON PP.BusinessEntityID = SSO.SalesPersonID
	 GROUP BY PP.FirstName,
	          SSO.SalesPersonID

-- 3.QUESTÃO

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

-- 4.QUESTÂO

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

-- 5.QUESTÃO

	SELECT Color,
		   COUNT(ProductID) AS [TotalCores]

	  FROM Production.Product
	 WHERE Color = 'red' OR Color IS NULL
	 GROUP BY Color