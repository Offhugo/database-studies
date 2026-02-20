/*******************************************************************************
PROJETO: Desafios de SQL - Business Intelligence (AdventureWorks)
AUTOR: Hugo Mendes
DESCRIÇÃO: Resolução de 5 problemas voltados aos fundamentos 
		   do que se entende por fundamentos em SQL
*******************************************************************************/

-- FUNDAMENTOS
--------------------------------------------------------------------------------
-- QUESTÃO 1: Nomes concatenados
-- Enunciado: "identificar todos os nomes completos dos associados".

-- Objetivo: Realizar uma consulta que retorne todos os nomes.
-- Insights: -> Fazer a concatenação de colunas com aliases posicionados de forma correta
--------------------------------------------------------------------------------

	SELECT BusinessEntityID,
		   FirstName + ' ' + MiddleName + ' ' + LastName AS [NomeCompleto]

	  FROM Person.Person
	 WHERE MiddleName IS NOT NULL

	 ORDER BY NomeCompleto

-- AGREGAÇOES
--------------------------------------------------------------------------------
-- QUESTÃO 2: Total de pedidos
-- Enunciado: "Exibir a contagem total de pedidos do ano de 2014".

-- Objetivo: Fazer uma consulta que retorne o número total de pedidos do ano espécificado .
-- Insights: -> Uma agregção simples com o uso da função COUNT
--------------------------------------------------------------------------------

	SELECT COUNT(SalesOrderID) AS [NumeroTotalPedidos2014]
      FROM Sales.SalesOrderHeader

     WHERE Orderdate >= '2014-01-01'
	   AND OrderDate < '2015-01-01';

-- REGRA DE NÉGOCIO
--------------------------------------------------------------------------------
-- QUESTÃO 3: Vendas por terrritório
-- Enunciado: "Quais terriórios venderam mais de 1 milhão".

-- Objetivo: Fazer uma consulta que retorne o valor total das vendas para cada território registrado .
-- Insights: -> Usar funções de agreggação para uma filtragem mais específica dos dados
--------------------------------------------------------------------------------

	-- CONSULTA DE ANÁLISE PRÉVIA 
	SELECT *
	  FROM Sales.CountryRegionCurrency

	-- CONSULTA COM RESULTADO REAL (e eu tinha errado de inicio)
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


--------------------------------------------------------------------------------
-- QUESTÃO 4: Máximo e mínimo
-- Enunciado: "exibir qual o produto mais barato e o mais caro".

-- Objetivo: Fazer uma consulta simples que se utiliza de estatística básica .
-- Insights: -> Utitizar funções de agregação
--------------------------------------------------------------------------------

	SELECT MAX(ListPrice) AS [ValorMax],
		   MIN(ListPrice) AS [ValorMin]

	  FROM Production.Product
	 WHERE ListPrice > 0
	 
--------------------------------------------------------------------------------
-- QUESTÃO 5: Máximo e mínimo
-- Enunciado: "exibir qual o produto mais barato e o mais caro".

-- Objetivo: Fazer uma consulta simples que se utiliza de estatística básica .
-- Insights: -> Utitizar funções de agregação
--------------------------------------------------------------------------------

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

