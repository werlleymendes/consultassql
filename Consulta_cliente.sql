SELECT * FROM clientepreferencial;


SELECT c.nome, c.endereco, c.numero, c.bairro, c.complemento, e.descricao AS estado, 
m.descricao as municipio, to_char(c.cep,'00000-000') as cep, c.telefone, c.celular, 
c.email, c.inscricaoestadual, c.orgaoemissor, to_char(c.cnpj, '00000000000000') AS "cpf/cnpj", 
t.descricao AS "estado civil", to_char(c.datanascimento, 'DD/MM/YYYY') AS "data de nascimento", 
to_char(c.dataresidencia, 'DD/MM/YYYY') AS "data de residencia", tr.descricao AS "tipo de residencia",
CASE 
WHEN c.sexo = 0 THEN 'feminino'
WHEN c.sexo = 1 THEN 'masculino'
ELSE 'outro'
END as sexo, 
id_banco as "codigo banco", b.descricao AS banco, c.agencia, c.conta, c.observacao,
c.valorlimite AS limite, c.nomeconjuge AS "nome do conjuge", 
datanascimentoconjuge AS "data nasc conjuge", c.vencimentocreditorotativo AS "prazo credito rotativo",
c.permitecreditorotativo, c.permitecheque, c.bloqueado, tc.descricao AS "classe risco", 
c.participaclubevantagem
FROM clientepreferencial AS c JOIN estado AS e
ON c.id_estado = e.id
JOIN municipio AS m 
ON c.id_municipio = m.id
JOIN tipoestadocivil AS t
ON c.id_tipoestadocivil = t.id
LEFT JOIN tiporesidencia AS tr
ON c.id_tiporesidencia = tr.id
LEFT JOIN banco AS b
ON c.id_banco = b.id
LEFT JOIN tipoclasserisco AS tc
ON c.id_classerisco = tc.id
WHERE c.datacadastro >= '01/02/2021' or 
c.id in (SELECT v.id_clientepreferencial FROM pdv.venda as v 
WHERE v.data >= '01/02/2021' GROUP by v.id_clientepreferencial)
ORDER BY c.nome ASC;


SELECT * FROM clientepreferencial WHERE nomemae <> '';

SELECT v.id_clientepreferencial FROM pdv.venda as v 
WHERE v.data >= '01/06/2021'
GROUP by v.id_clientepreferencial;

select * from tipoclasserisco

SELECT column_name, table_name FROM information_schema.columns WHERE column_name like '%classe%'