-- Consulta para listar funcionários ativos com dados organizacionais
-- Baseada em tabelas padrão do TOTVS RM (sem dados sensíveis)

with CTE as (

select 
sb.CODSECAO as SesaoSuperior,
pf.CHAPA as ChapaSuperior,
pp.CPF as CPFSuperior,
pp.NOME as NomeSuperior
from PSUBSTCHEFE as sb
left join pfunc as pf on pf.CHAPA = sb.CHAPASUBST
left join PPESSOA as pp on pp.codigo = pf.CODPESSOA
where sb.master = 1

)

select
co.CODCOLIGADA as idEmpresa,
co.NOME as txtNomeDaEmpresa,
fi.CODFILIAL as idLocalidade,
fi.NOMEFANTASIA as txtLocalidade,
sec.CODIGO as idDepartamento,
sec.CODIGOPAI,
sec.DESCRICAO as txtDepartamento,
fc.CODIGO as idCargo,
fc.NOME as txtCargo,
cu.CODCCUSTO as idCentroDeCusto,        
cu.NOME as txtNomeCentroDeCusto,        
cu.NOME as txtDescricaoCentroDeCusto,  
fu.CODSITUACAO as status,         
fu.CODFUNCAO as  enumTipoFuncionario,
NULL idDetalheTipoFuncionario,      
PTPFUNC.DESCRICAO txtNomeDetalheTipoFuncionario, 
NULL idEmpresaTerceirizacao,        
NULL txtNomeDaEmpresaTerceirizacao,        
NULL txtCNPJDaEmpresaTerceirizacao,
FU.DATAADMISSAO as dataContratacao,        
FU.DATADEMISSAO as dataDesligamento, 

CASE 
    WHEN FU.CODSITUACAO IN ('P', 'L', 'E', 'O', 'T', 'U', 'W', 'Y') THEN        
      (SELECT top 1 a.DTINICIO FROM PFHSTAFT as a WHERE A.CODCOLIGADA = FU.CODCOLIGADA AND A.CHAPA = FU.CHAPA ORDER BY a.DTINICIO DESC)         
        WHEN FU.CODSITUACAO IN ('F', 'A') THEN        
      (SELECT TOP 1 F.DATAINICIO FROM PFUFERIASPER F WHERE F.CODCOLIGADA = FU.CODCOLIGADA AND F.CHAPA = FU.CHAPA ORDER BY DATAINICIO DESC) 
                    ELSE NULL END dataInicioAfastamento,        
     CASE WHEN FU.CODSITUACAO IN ('P','L', 'E', 'O', 'T', 'U', 'W', 'Y') THEN        
      (SELECT top 1 a.DTFINAL FROM PFHSTAFT as a WHERE A.CODCOLIGADA = FU.CODCOLIGADA AND A.CHAPA = FU.CHAPA ORDER BY a.DTINICIO DESC)         
                      WHEN FU.CODSITUACAO IN ('F', 'A') THEN        
      (SELECT TOP 1 F.DATAFIM FROM PFUFERIASPER F WHERE F.CODCOLIGADA = FU.CODCOLIGADA AND F.CHAPA = FU.CHAPA ORDER BY DATAINICIO DESC)
    ELSE NULL 
END dataFimAfastamento,        

NULL idTipoAfastamento,     
NULL txtNomeTipoAfastamento,    
FU.NOME txtNomeCompleto, 
PE.APELIDO txtNomeCurto,
NULL txtPrimeiroNome,        
NULL txtNomedoMeio,        
NULL txtUltimoNome, 
PE.EMAIL txtEmailCorporativo,
CONCAT(FU.CODCOLIGADA,FU.CHAPA) txtMatriculaUnica,  
FU.CODFUNCAO,
FU.CHAPA txtMatriculaFuncional,        
PE.CPF txtCPF,        
PE.CARTIDENTIDADE txtRG,             
NULL txtTelefoneCorporativoCelular,  

(SELECT TOP 1 CONCAT(X.CODCOLIGADA,X.CHAPASUBST) 
FROM PSUBSTSUP X WHERE CODEQUIPE = FU.CODEQUIPE 
AND CODCOLIGADA = FU.CODCOLIGADA 
AND CODSECAO = FU.CODSECAO 
AND GETDATE() BETWEEN X.DATAINICIO 
AND ISNULL(X.DATAFIM,GETDATE())) 
as txtIdSuperior, 

PE.DTNASCIMENTO txtAniversario,        
PE.RUA txtEnderecoRua,        
PE.NUMERO txtEnderecoNumero,     


(SELECT TOP 1 NOME FROM PFDEPEND AS A WHERE A.CODCOLIGADA = FU.CODCOLIGADA AND A.CHAPA = FU.CHAPA AND A.GRAUPARENTESCO = '6') txtNomePai,        
(SELECT TOP 1 NOME FROM PFDEPEND AS A WHERE A.CODCOLIGADA = FU.CODCOLIGADA AND A.CHAPA = FU.CHAPA AND A.GRAUPARENTESCO = '7') txtNomeMae, 

 NULL txtTelefonePessoalCelular,

 c.NomeSuperior AS 'SUPERIOR_IMEDIATO', 
 c.ChapaSuperior AS 'CHAPA_SUPERIOR_IMEDIATO', 
 c.CPFSuperior AS 'CPF_SUPERIOR_IMEDIATO'
From
PFUNC as fu

left join PPESSOA pe on pe.CODIGO = fu.CODPESSOA
left join PFUNCAO fc on fc.CODIGO = fu.CODFUNCAO
left join PCARGO ca on ca.CODIGO = fc.CARGO 
left join GCOLIGADA co on co.CODCOLIGADA = fu.CODCOLIGADA and co.CODCOLIGADA = fc.CODCOLIGADA
left join PSECAO sec on sec.CODIGO = fu.CODSECAO
left JOIN GFILIAL fi ON sec.CODCOLIGADA = fi.CODCOLIGADA AND sec.CODFILIAL = fi.CODFILIAL
LEFT JOIN PFRATEIOFIXO rf ON fu.CODCOLIGADA = rf.CODCOLIGADA AND fu.CHAPA = rf.CHAPA
LEFT JOIN PCCUSTO cu ON rf.CODCOLIGADA = cu.CODCOLIGADA AND rf.CODCCUSTO = cu.CODCCUSTO
LEFT JOIN PCODSITUACAO cs ON fu.CODSITUACAO = cs.CODCLIENTE  
LEFT JOIN PTPFUNC PTPFUNC  ON fu.CODTIPO = PTPFUNC.CODCLIENTE   
left join CTE as c on c.SesaoSuperior = sec.CODIGO


where fu.DATADEMISSAO is null