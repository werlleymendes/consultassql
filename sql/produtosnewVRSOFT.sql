/*Query com os principais campos do cadastro de produtos do ERP VRSoftware, utilizado para cadastro em migração para 
novo ERP*/
SELECT p.id, p.descricaocompleta, m.descricao AS mercadologico, p.validade, p.tiponaturezareceita, 
/*replace feito para remover a vírgula para facilitar a importação no excel(o separador que é exportado é ','*/
replace(regexp_replace(tn.descricao, E'[\n\r]+', ' - ', 'g' ), ',', '.') as "natureza da receita", mxf.ncm, replace(ct.descricao, ',', '.') as cest,
tpc.cst as "cst pis/cofins cred", tp.cst as "cst pis/cofins deb", tp.descricao "pis e cofins", mxf.icms_cst_e, mxf.icms_cst_s,
CASE mxf.icms_cst_e
	WHEN '060' THEN 'SUBSTITUIDO'
	WHEN '040' THEN 'ISENTO'
	WHEN '090' THEN 'OUTROS'
	WHEN '020' THEN 'REG EFETIVO 61.11/REG EFETIVO 33.33'
	/*CST 000 PODE SER TANTO REGIME EFETIVO 18(CARGA LIQUIDA) QUANTO ANTECIPADO, COMO PODE SER 
	TAMBÉM REGIME EFETIVO 28%(CARGA LÍQUIDA, BEBIDAS)*/ 
	WHEN '000' THEN 'REG EFETIVO 18/18%/30%'
	ELSE 'VERIFICAR O TIPO DO PRODUTO'
	END,
pf.cadastro_fornecedor,
/*String que armazena todos os códigos de barras que o produto tem em um única tupla separado por ;*/
string_agg(pa.codigobarras::text, ';') AS codigo_barras
/*Não existe um foreign key da tabela mercadológico dentro da tabela produto, por isso é preciso utilizar todos os níveis 
do mercadológico ao mesmo tempo como foreign key*/
FROM produto as p JOIN mercadologico as m ON p.mercadologico1 = m.mercadologico1 AND p.mercadologico2 = m.mercadologico2 AND p.mercadologico3 = m.mercadologico3 AND p.mercadologico4 = m.mercadologico4
LEFT JOIN tipopiscofins AS tp ON p.id_tipopiscofins = tp.id
LEFT JOIN tipopiscofins AS tpc ON p.id_tipopiscofinscredito = tpc.id
/*Existem naturezas da receita com o mesmo código, sendo diferenciado pelo pis e cofins,
exemplo: 108 para o pis e cofins aliquota zero é  farinha, grumos e semolas... Para o pis e cofins 
supensão a natureza da receita é Naftap petroquimica, pois isso é necessário adicionar o tipo de cest para validar*/
LEFT JOIN tiponaturezareceita as tn ON p.tiponaturezareceita = tn.codigo and tp.cst = tn.cst
LEFT JOIN cest as ct ON p.id_cest = ct.id
JOIN mxf_vw_produtos as mxf ON p.id = mxf.codigo_produto 
JOIN produtocomplemento AS pc ON p.id = pc.id_produto 
JOIN produtoautomacao AS pa ON p.id = pa.id_produto
/*Nessa consulta é adicionado o código do fornecedor e o código do produto que vem do fornecedor, armazenado como um 
array separado por espaço, e separando cada tupla do array por ';'
*/
LEFT JOIN (SELECT id_produto, array_to_string(array_agg(id_fornecedor || ' ' || codigoexterno), ';') as cadastro_fornecedor
	 FROM produtofornecedor
		  	WHERE id_fornecedor IN (SELECT f.id
				FROM fornecedor as f 
				JOIN notaentrada as ne ON f.id = ne.id_fornecedor
				WHERE f.id_situacaocadastro = 1
				AND ne.dataentrada > '2020-07-15'
				GROUP BY f.id
				ORDER BY f.id)
		  	GROUP BY id_produto) as pf on p.id = pf.id_produto 
WHERE pc.id_produto IN(SELECT pc.id_produto FROM produtocomplemento as pc
					   WHERE pc.id_situacaocadastro = 1 and
					   (pc.dataultimaentrada >= '2020/07/15' or pc.dataultimavenda >= '2020/07/15' or pc.estoque <> 0))
					   and pc.id_loja = 1
GROUP BY p.id, m.descricao, tn.descricao, mxf.ncm, ct.descricao, tpc.cst, tp.cst, tp.descricao, pf.cadastro_fornecedor,
			mxf.icms_cst_e, mxf.icms_cst_s
order by p.id;


/* Query auxiliares para entender o funcionamento da query principal*/

/*
SELECT * FROM produtofornecedor LIMIT 10;

SELECT f.id
FROM fornecedor as f 
JOIN notaentrada as ne ON f.id = ne.id_fornecedor
WHERE f.id_situacaocadastro = 1
AND ne.dataentrada > '2021-01-01'
GROUP BY f.id
ORDER BY f.id
;

SELECT pa.id_produto, string_agg(pa.codigobarras, ',') FROM produtoautomacao 
GROUP BY pa.id_produto;

select  from tiponaturezareceita WHERE descricao LIKE 'RECEITA DECORRENTE DA VENDA%'

select REPLACE(descr, CHAR(13) + Char(10) ,' ') FROM TABELA

SELECT pf.id_produto, array_agg(pf.id_fornecedor || ',' || pf.codigoexterno) as "cadastro de fornecedor" 
FROM produtofornecedor as pf
GROUP by pf.id_produto;

SELECT pf.id_produto, string_agg((pa_1.codigobarras)::character varying)::text as "cadastro de fornecedor" 
FROM produtofornecedor as pf
GROUP by pf.id_produto;

select * from produtocomplemento where id_produto = 213820;
SELECT * FROM produto as p JOIN tipoembalagem as t 
ON p.id_tipoembalagem =  t.id 
order by p.id
limit 100;

SELECT * FROM aliquotacredito;

SELECT * FROM

select * from situacaocadastro;


SELECT * FROM pg_tables where tablename LIKE '%cest';

select * from mxf_vw_produtos WHERE descritivo_produto like 'FARINHA DE TRIGO FINNA 5KG%'

SELECT
   TABLE_NAME AS TABELA,
   COLUMN_NAME AS CAMPO 
FROM
   INFORMATION_SCHEMA.COLUMNS  
WHERE
   COLUMN_NAME LIKE '%icms%' 
ORDER BY TABELA ASC
   
SELECT * FROM produtocomplemento LIMIT 10;

select * from produtofornecedor order by id_produto;

SELECT * FROM aliquota;

SELECT * FROM mxf_vw_icms

select * from aliquotadebito

SELECT * FROM tipopiscofins

select * from tiponaturezareceita

SELECT * FROM cest;

select * from ncm;

SELECT * FROM tabcest;

SELECT * FROM associadoitem;

SELECT * FROM administracaopreco;

SELECT * FROM transacoes limit 30;

SELECT * FROM pg_tables ORDER by tablename DESC;

SELECT * FROM marketscience.transacoes LIMIT 30;

select * from simix_item_principal limit 10000;



show views;

SELECT * FROM pg_views  
ORDER BY viewname

SELECT id_produto, to_char(custocomimposto, '9G999D999') FROM produtocomplemento
where id_loja = 1;












SELECT * FROM produtoautomacao ORDER BY id_produto LIMIT 100;

 SELECT id_produto, string_agg(codigobarras::text, ',') AS codigo_barras
 SELECT * FROM produtoautomacao GROUP BY id_produto ORDER BY id_produto DESC LIMIT 1000; 
 
 
  WITH codigo AS (
         SELECT pa_1.id_produto AS id,
            btrim(string_agg(
                CASE
                    WHEN (length(((pa_1.codigobarras)::character varying)::text) = 13) THEN ((pa_1.codigobarras)::character varying)::text
                    WHEN (length(((pa_1.codigobarras)::character varying)::text) = 14) THEN ((pa_1.codigobarras)::character varying)::text
                    ELSE to_char(pa_1.codigobarras, '0000000000000'::text)
                END, ','::text)) AS barras
           FROM produtoautomacao pa_1
          GROUP BY pa_1.id_produto
        )
 SELECT to_char(p.id, '0000000'::text) AS "Código interno",
    pc.id_loja AS "Loja",
    codigo.barras AS "Código de barras",
    p.descricaocompleta AS "Descrição",
    m1.descricao AS "Departamento",
    COALESCE(m3.descricao, m4.descricao, m5.descricao) AS "Categoria",
    round(pc.precovenda, 2) AS "Preço de venda",
        CASE
            WHEN (pc.dataultimopreco IS NULL) THEN 'PRODUTO NÃO PRECIFICADO PARA ESTA LOJA'::character varying
            ELSE (pc.dataultimopreco)::character varying
        END AS "Data da ultima alteração preço",
    (p.dataalteracao)::character varying AS "Data da ultima alteração cadastro",
    sc.descricao AS "Situação do Cadastro",
    '...'::character varying AS "Foto (caminho)"
   FROM (((((((((produto p
     JOIN produtocomplemento pc ON ((pc.id_produto = p.id)))
     JOIN loja ON ((loja.id = pc.id_loja)))
     JOIN produtoautomacao pa ON ((pa.id_produto = p.id)))
     JOIN situacaocadastro sc ON ((sc.id = pc.id_situacaocadastro)))
     JOIN mercadologico m1 ON (((m1.mercadologico1 = p.mercadologico1) AND (m1.nivel = 1))))
     LEFT JOIN mercadologico m3 ON (((m3.mercadologico1 = p.mercadologico1) AND (m3.mercadologico2 = p.mercadologico2) AND (m3.mercadologico3 = p.mercadologico3) AND (m3.nivel = 3))))
     LEFT JOIN mercadologico m4 ON (((m4.mercadologico1 = p.mercadologico1) AND (m4.mercadologico2 = p.mercadologico2) AND (m4.mercadologico3 = p.mercadologico3) AND (m4.mercadologico4 = p.mercadologico4) AND (m4.nivel = 4))))
     LEFT JOIN mercadologico m5 ON (((m5.mercadologico1 = p.mercadologico1) AND (m5.mercadologico2 = p.mercadologico2) AND (m5.mercadologico3 = p.mercadologico3) AND (m5.mercadologico4 = p.mercadologico4) AND (m5.mercadologico5 = p.mercadologico5) AND (m5.nivel = 5))))
     LEFT JOIN codigo ON ((codigo.id = p.id)))
  GROUP BY p.id, p.descricaocompleta, p.dataalteracao, m1.descricao, m3.descricao, m4.descricao, m5.descricao, codigo.barras, pc.id_loja, sc.descricao, pc.dataultimopreco, pc.precovenda;
*/