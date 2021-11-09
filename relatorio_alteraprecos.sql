SELECT * FROM notaentrada LIMIT 10;
SELECT * FROM notaentradaitem LIMIT 10;

SELECT nei.id_produto as "Código", p.descricaocompleta as produto, 
sum(nei.quantidade * nei.qtdembalagem) as "quantidade total",  
sum(nei.valortotal) as "valor total", 
round((sum(nei.valortotal)/sum(nei.quantidade * nei.qtdembalagem)),2) as "custo médio"
FROM notaentrada as ne
JOIN notaentradaitem as nei
ON nei.id_notaentrada = ne.id
JOIN produto as p
ON nei.id_produto = p.id
JOIN (SELECT nei.id_produto as id, count(nei.id_produto) as notas FROM
	 	notaentradaitem as nei
	  	JOIN notaentrada as ne ON nei.id_notaentrada = ne.id
	  	WHERE ne.dataentrada = '2021-10-30'
	  	AND ne.id_loja = 1
	  	GROUP BY 1
	 ) as c
	 ON c.id = nei.id_produto
WHERE ne.dataentrada = '2021-10-30'
AND p.mercadologico1 = 36
AND ne.id_loja = 1
AND c.notas > 1
GROUP by 1,2;

select * from mercadologico where descricao like 'FRUTA%';