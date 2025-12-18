-- EXERCICIO 1
	CREATE OR ALTER PROC dbo.Pr_AplicarDescontoPorCategoria
	AS

	BEGIN
		SELECT *
		 INTO dbo.ProdutosTest
	     FROM dbo.Produtos AS PR	
	END
	BEGIN
		UPDATE dbo.ProdutosTest
		   SET preco = preco - (preco * 25 / 100) -- 25% de desconto
	     WHERE categoria LIKE 'Eletrônicos'

		 UPDATE dbo.ProdutosTest
		   SET preco = preco - (preco * 20 / 100) -- 20% de desconto
	     WHERE categoria LIKE 'Livros'

		 UPDATE dbo.ProdutosTest
		   SET preco = preco - (preco * 30 / 100) -- 30% de desconto
	     WHERE categoria LIKE '	Eletrodomésticos' 
	END
	BEGIN
		SELECT P.*,
		       PT.preco AS [preco/Cdesconto]

		  FROM dbo.Produtos AS P
		  JOIN dbo.ProdutosTest AS PT
		    ON P.idProduto = PT.idProduto

		  DROP TABLE dbo.ProdutosTest
	END


	EXEC dbo.Pr_AplicarDescontoPorCategoria -- Execurtando procedure

	/* 
		PROBLEMAS ENCONTRADOS
		1 - Inicialmente o desconto atualizava os dados originais --> criar uma tabela clone 
		2 - O primeiro begin me retornava uma tabela e o ultimo outra --> por algum motivo ao colocar o 'P' no * so veio a tabela desejada
		3 - Quantos Begins realmente usar e como saber
		4 - é performatico criar e dropar uma tabela para uma pesquisa como essa
	*/

	  UPDATE dbo.Produtos
	     SET preco = 40
	   WHERE nomeProduto LIKE 'produto C'
