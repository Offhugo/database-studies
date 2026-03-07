/*
PROJETO: Análise de Dados AdventureWorks2022
AUTOR: Hugo Mendes Ferreira Junior
DATA: Dezembro/2025
LINKEDIN: www.linkedin.com/in/offhugo
DESCRIÇÃO: Conjunto de queries focadas em responder perguntas de negócio 
sobre Vendas, RH e Produção, evoluindo de Joins simples para Agregações Complexas.
*/

--------------------------------------------------------------------------------
-- QUESTÃO 1: análise logística com cálculo de tempo
-- Enunciado: "Calcular o tempo médio de envio dos pedidos por território."

-- Objetivo: Medir a eficiência logística em cada região de vendas.

-- Insights:
-- -> Função de data DATEDIFF
-- -> Cálculo derivado dentro de AVG
-- -> Análise de performance logística
--------------------------------------------------------------------------------

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

--------------------------------------------------------------------------------
-- QUESTÃO 2: detecção de ausência de relacionamento
-- Enunciado: "Identificar produtos cadastrados que nunca apareceram em pedidos."

-- Objetivo: Descobrir produtos que nunca foram vendidos.

-- Insights:
-- -> LEFT JOIN para manter todos os produtos
-- -> Filtro com IS NULL para identificar ausência de vendas
-- -> Consulta de análise de catálogo
--------------------------------------------------------------------------------

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

--------------------------------------------------------------------------------
-- QUESTÃO 3: classificação de dados
-- Enunciado: "Classificar pedidos em categorias de valor."

-- Objetivo: Criar categorias de vendas baseadas no valor do pedido.

-- Insights:
-- -> Uso de CASE para lógica condicional
-- -> Transformação de dados quantitativos em categorias
-- -> Consulta de categorização analítica
--------------------------------------------------------------------------------

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

--------------------------------------------------------------------------------
-- QUESTÃO 4: análise temporal de vendas
-- Enunciado: "Calcular o total de vendas por ano e mês."

-- Objetivo: Identificar evolução das vendas ao longo do tempo.

-- Insights:
-- -> Extração de componentes da data
-- -> Agregação temporal
-- -> Análise de tendência de vendas
--------------------------------------------------------------------------------

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

-- --------------------------------------------------------------------------------
-- QUESTÃO 5: análise de causa de vendas
-- Enunciado: "Calcular a receita gerada por cada motivo de venda."

-- Objetivo: Entender quais fatores motivam as vendas.

-- Insights:
-- -> JOIN em tabela associativa
-- -> Relacionamento muitos-para-muitos
-- -> Agregação de receita por categoria
--------------------------------------------------------------------------------

--	TABELAS DE CONSULTA PRÉVIA
	SELECT TOP(100) *
	  FROM Sales.SalesReason

	SELECT *
	  FROM Sales.SalesOrderHeader

	SELECT TOP(100) *
	  FROM Sales.SalesOrderHeaderSalesReason

--  TABELA COM RESULTADO FINAL
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


