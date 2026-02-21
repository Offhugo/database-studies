/*******************************************************************************
PROJETO: Desafios de SQL - Business Intelligence (AdventureWorks)
AUTOR: Hugo Mendes
DESCRIÇÃO: Resolução de desafios práticos em SQL aplicados a cenários
           de Business Intelligence e análise de dados.
*******************************************************************************/

-- AGREGAÇÃO COM JOIN
--------------------------------------------------------------------------------
-- QUESTÃO 1: Categorias de produtos
-- Enunciado: "Quantos produtos existem em cada subcategoria, inclusive as que não têm produto?".

-- Objetivo: Realizar uma consulta que retorne o número de procutos em cada subcategoria, inclusive os sem valor.
-- Insights: -> GROUP BY em múltiplas colunas
--			 -> COUNT com relacionamento
--------------------------------------------------------------------------------
	SELECT PPS.ProductSubcategoryID,
		   PPS.Name AS [NomeDaCategoria],
		   COUNT(PP.ProductID) AS [NomeProduto]

	  FROM Production.ProductSubcategory AS PPS
	  LEFT JOIN Production.Product AS PP
	    ON PPS.ProductSubCategoryID = PP.ProductSubcategoryID
	 GROUP BY PPS.Name,
			  PPS.ProductSubcategoryID

-- Regra de négocio
--------------------------------------------------------------------------------
-- QUESTÃO 2: Melhor vendedor
-- Enunciado: "Qual vendedor vendeu mais e qual o volume total?".

-- Objetivo: Fazer uma consulta que mostre quem vendeu mais e o volume das vendas.
-- Insights: -> Group by múltiplo
--			 -> Métrica por vendedor
--------------------------------------------------------------------------------
	SELECT PP.FirstName,
	       SSO.SalesPersonID,
		   COUNT(*) AS [QtdCompras],
		   SUM(SSO.TotalDue) AS [ValorTotal]

	  FROM Sales.SalesOrderHeader AS SSO
	  JOIN Person.Person AS PP
	    ON PP.BusinessEntityID = SSO.SalesPersonID
	 GROUP BY PP.FirstName,
	          SSO.SalesPersonID

-- TRATAMENTO DE DADOS
--------------------------------------------------------------------------------
-- QUESTÃO 3: consulta simples
-- Enunciado: "Retornar cada pessoa associada a um pedido e a data do pedido".

-- Objetivo: Fazer um JOIN entre pessoa e pedido,
--		     exibindo o nome completo do cliente e a data da compra.
-- Insights: -> Consulta relacional 
--			 -> Concatenação com tratamento de NULL
--			 -> Tratamento de NULL com ISNULL
--------------------------------------------------------------------------------

	-- CONSULTAS DE ANÁLISE 
    SELECT *
	  FROM Person.Person

	SELECT *
	  FROM Sales.SalesOrderHeader

	-- CONSULTA REAL 
	SELECT PP.FirstName + ' ' + ISNULL(PP.MiddleName, ' ') + ' ' + PP.LastName AS [Nome Completo],
	       SSO.CustomerID,
		   SSO.OrderDate
	  FROM Person.Person AS PP 
	  JOIN Sales.SalesOrderHeader AS SSO
	    ON PP.BusinessEntityID = SSO.CustomerID

-- CONSULTA HIERARQUICA 
--------------------------------------------------------------------------------
-- QUESTÃO 4: Funcionários e seus respectivos gerentes
-- Enunciado: "Retornar cada funcionário e o nome do seu respectivo gerente".

-- Objetivo: Identificar a relação funcionário -> gerente
--			 utilizando a estrutura hierárquica armazenada no banco 
-- Insights: -> Self JOIN (tabela ligada a ela mesma) 
--			 -> Uso do método GetAncestor(1)
--			 -> JOIN encadeado (múltiplas tabelas)
--------------------------------------------------------------------------------

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

-- AGREGAÇÕES
--------------------------------------------------------------------------------
-- QUESTÃO 5: agregação com filtro condicional
-- Enunciado: "Contar quantos produtos são vermelhos e quantos não possuem cor".
--
-- Contexto do problema:
-- A tabela de produtos possui um atributo opcional chamado Color.
-- Alguns produtos têm cor definida, outros não.
--
-- Objetivo:
-- Agrupar os produtos por cor (apenas 'red' e NULL)
-- e contar quantos existem em cada grupo.
--
-- Insights:
--  -> GROUP BY
--  -> COUNT
--  -> Filtro com OR
--  -> Agrupamento incluindo valores NULL
--  -> Análise simples de distribuição de atributo
--------------------------------------------------------------------------------

	SELECT Color,
		   COUNT(ProductID) AS [TotalCores]

	  FROM Production.Product
	 WHERE Color = 'red' OR Color IS NULL
	 GROUP BY Color

/* 
CONCEITOS CONSOLIDADOS NESTE DESAFIO:
- LEFT JOIN
- GROUP BY
- SUM e COUNT
- Tratamento de NULL
- Hierarquia com GetAncestor
- Métricas de negócio
*/