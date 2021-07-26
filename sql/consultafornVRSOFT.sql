/*Consulta de cadastro de fornecedor no sistema VRSOFTWARE com os principais campos, filtro por data e títulos abertos e 
status(ativo, inativo)*/

SELECT f.id, f.razaosocial, f.nomefantasia, f.endereco, f.numero, f.bairro, m.descricao AS municipio, 
to_char(f.cep, '00000-000') as cep, e.descricao AS estado, f.telefone, ti.descricao as "tipo inscricao", 
f.inscricaoestadual, to_char(f.cnpj, '00000000000000') as "cnpj/cpf", tr.descricao as "tipo pagamento", 
fpp.diasentregapedido AS "dias entrega pedido", fpp.diasatualizapedidoparcial as "dias atual. ped parcial", 
MAX(ne.dataentrada) as "data"
FROM fornecedor as f JOIN municipio as m ON f.id_municipio = m.id
JOIN estado AS e ON f.id_estado = e.id
FULL JOIN tipoinscricao AS ti ON f.id_tipoinscricao = ti.id
FULL JOIN tiporecebimento AS tr ON f.id_tiporecebimento = tr.id
FULL JOIN fornecedorprazopedido AS fpp ON f.id = fpp.id_fornecedor
JOIN notaentrada as ne ON f.id = ne.id_fornecedor
WHERE f.id_situacaocadastro = 1
AND (ne.dataentrada > '2020-07-15' or f.id IN (SELECT pf.id_fornecedor FROM pagarfornecedor as pf
JOIN pagarfornecedorparcela as pfp ON pf.id = pfp.id_pagarfornecedor
WHERE pfp.id_situacaopagarfornecedorparcela = 0
GROUP BY pf.id_fornecedor))
GROUP BY f.id, m.descricao, e.descricao, ti.descricao, tr.descricao, fpp.diasentregapedido, fpp.diasatualizapedidoparcial
ORDER BY f.id
;

/*


CONSULTAS AUXILIARES UTILIZADAS NO DESENVOLVIMENTO DA QUERY

SELECT * FROM fornecedor limit 10;

SELECT *
FROM fornecedorprazo AS fp 
WHERE fp.id_loja = 1
AND fp.id_divisaofornecedor = 0
ORDER BY fp.id_fornecedor;

select count(id_fornecedor) FROM notaentrada WHERE id_loja = 1 and dataentrada > '2020-07-15'
group by id_fornecedor;

SELECT * FROM tipopagamento;

SELECT * FROM tiporecebimento;

SELECT * FROM tipofornecedor;

SELECT tablename, schemaname FROM pg_tables;

SELECT * FROM pagarfornecedorparcela LIMIT 1000;
SELECT * FROM pagarfornecedor;
SELECT * FROM situacaopagarfornecedorparcela;

SELECT pf.id_fornecedor FROM pagarfornecedor as pf
JOIN pagarfornecedorparcela as pfp ON pf.id = pfp.id_pagarfornecedor
WHERE pfp.id_situacaopagarfornecedorparcela = 0
GROUP BY pf.id_fornecedor;



SELECT
column_name,
data_type,
table_catalog,
table_name,
ordinal_position,
is_nullable,
table_schema
FROM
information_schema.columns


COPY
(
    SELECT tablename, schemaname FROM pg_tables
)
TO 'C:/git/sql/fornecedor.csv'
DELIMITER ';'
CSV HEADER


SELECT * FROM agendafornecedor order by id_fornecedor;

SELECT * FROM fornecedorconfiguracaodatacorte order by id_fornecedor;

SELECT * FROM fornecedorpagamento order by id_fornecedor;

SELECT * FROM fornecedorprazopedido where id_loja = 1 order by id_fornecedor;

SELECT * FROM tipoagendafornecedor;

SELECT * FROM fornecedorprazo where id_loja = 1 order by id_fornecedor, id_divisaofornecedor;

SELECT * FROM fornecedordocumento;

SELECT * FROM notaentrada limit 10;

SELECT id_fornecedor, max(dataentrada) FROM notaentrada GROUP by id_fornecedor ORDER BY 1;
*/