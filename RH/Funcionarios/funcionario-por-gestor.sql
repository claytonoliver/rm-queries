with CTE as (

select 
sb.CODSECAO as SesaoSuperior,
pf.CHAPA as ChapaSuperior,
pp.NOME as NomeSuperior,
pp.CODUSUARIO as codSuperior

from PSUBSTCHEFE as sb

left join pfunc as pf on pf.CHAPA = sb.CHAPASUBST
left join PPESSOA as pp on pp.codigo = pf.CODPESSOA

where sb.master = 1

)

select
 fu.CHAPA as CHAPA_FUNCIONARIO,
 fu.NOME as FUNCIONARIO,
 pe.CODUSUARIO as LOGIN_FUNCIONARIO,
 fc.NOME as FUNCAO_FUNCIONARIO,
 sec.CODIGO as CODIGO_SECAO,
 sec.DESCRICAO as SECAO,
 c.ChapaSuperior AS CHAPA_GESTOR, 
 c.NomeSuperior AS GESTOR, 
 c.codSuperior AS LOGIN_GESTOR

From
PFUNC as fu

left join PPESSOA pe on pe.CODIGO = fu.CODPESSOA
left join PFUNCAO fc on fc.CODIGO = fu.CODFUNCAO
left join PCARGO ca on ca.CODIGO = fc.CARGO 
left join GCOLIGADA co on co.CODCOLIGADA = fu.CODCOLIGADA and co.CODCOLIGADA = fc.CODCOLIGADA
left join PSECAO sec on sec.CODIGO = fu.CODSECAO
left join CTE as c on c.SesaoSuperior = sec.CODIGO


where fu.DATADEMISSAO is null
and fu.CODCOLIGADA = 1