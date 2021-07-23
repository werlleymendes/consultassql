SELECT * FROM consinco.map_produto

select f.seqfamilia, f.familia as DESCRICAO_FAMILIA, p.seqproduto, p.desccompleta as produto, f.pesavel,
f.pmtdecimal as PERMITE_DECIMAL, f.pmtmultiplicacao, 
p.seqfamilia as codigo_familial,to_char(f.DTAHORINCLUSAO,'DD/MM/YYYY') as DATA_INCL_familial, 
to_char(p.DTAHORINCLUSAO,'DD/MM/YYYY') as DATA_INCL_PRODUTO, 
f.usuarioinclusao AS USUAR_INC_FAMILIA,p.usuarioinclusao AS USUAR_INC_PRODUTO,
c.comprador, cat.categoria, t.tributacao, to_char(f.codnbmsh, '00000000') as ncm, f.situacaonfpis as PIS_ENTRADA, 
f.situacaonfcofins as COFINS_ENTRADA,
f.codnatrec as NATUREZA_RECEITA, f.situacaonfpissai AS PIS_SAIDA, f.situacaonfcofinssai AS COFINS_SAIDA,
f.codcest FROM consinco.map_familia f 
LEFT JOIN consinco.map_produto p ON f.seqfamilia = p.seqfamilia
LEFT JOIN consinco.map_famdivisao fd ON f.seqfamilia = fd.seqfamilia
LEFT JOIN consinco.max_comprador c ON fd.seqcomprador = c.seqcomprador
LEFT JOIN consinco.map_tributacao t ON fd.nrotributacao = t.nrotributacao
LEFT JOIN consinco.MAP_FAMDIVCATEG fdc ON f.seqfamilia = fdc.seqfamilia
JOIN consinco.map_categoria cat ON fdc.seqcategoria = cat.seqcategoria
WHERE f.familia NOT LIKE '%EXCLUIR%'
ORDER BY 1 DESC;

select * from consinco.map_categoria order by seqcategoria;

select * from consinco.map_familia;
select * from consinco.map_prodcodigo;

SELECT tablespace_name, table_name, owner FROM dba_tables;

select * from consinco.map_famdivisao

select * from consinco.MAP_FAMDIVCATEG



SELECT * FROM MAD_GNRERECEITA;

select * from consinco.max_comprador;

select * from consinco.map_tributacao;


select * from consinco.MRLX_PEFAMILIA






