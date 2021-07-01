
SELECT p.id, p.descricaocompleta, m.descricao AS mercadologico, f.descricao as familia, p.validade, p.tiponaturezareceita, tn.descricao as "natureza da receita", ct.descricao as cest,
tpc.cst as "cst pis/cofins cred", tp.cst as "cst pis/cofins deb", tp.descricao "pis e cofins"
FROM produto as p JOIN mercadologico as m ON p.mercadologico1 = m.mercadologico1 AND p.mercadologico2 = m.mercadologico2 AND p.mercadologico3 = m.mercadologico3 AND p.mercadologico4 = m.mercadologico4
JOIN familiaproduto as f ON p.id_familiaproduto = f.id
JOIN tiponaturezareceita as tn ON p.tiponaturezareceita = tn.codigo
JOIN cest as ct ON p.id_cest = ct.id
JOIN tipopiscofins AS tp ON p.id_tipopiscofins = tp.id
JOIN tipopiscofins AS tpc ON p.id_tipopiscofinscredito = tpc.id
JOIN produtocomplemento AS pc ON p.id = pc.id_produto
WHERE tn.cst = tp.cst
and pc.id_loja = 1 and
pc.dataultimaentrada >= '01/01/2021' or pc.dataultimavenda >= '01/01/2021'
LIMIT 10