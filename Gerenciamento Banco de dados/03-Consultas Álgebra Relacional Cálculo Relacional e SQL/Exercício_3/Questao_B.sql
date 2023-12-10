-- 1. Retorne o RG/estado expedidor e nome de todos os empregados que supervisionam diretamente um empregado que trabalha no departamento que controla o projeto cujo nome é fornecido na consulta.
SELECT 
    e.rg AS rg_estado_expedidor,
    e.nome AS nome_empregado_supervisor
FROM empregado e
WHERE e.empregadoid IN (
    SELECT DISTINCT e.empregadoid 
    FROM empregado e
    INNER JOIN empregado supervisor ON e.supervisordireto = supervisor.empregadoid
    INNER JOIN empregadoprojeto ep ON e.empregadoid = ep.empregadoid
    INNER JOIN projeto p ON ep.projetoid = p.projetoid
    INNER JOIN departamento d ON p.departamentoid = d.departamentoid
    WHERE p.nome = 'Nome do Projeto'
);


-- 2. Retorne o nome, sexo e idade de todos os dependentes de algum gerente de departamento, o RG/estado expedidor e o nome do gerente do qual são dependentes, apresentando para o atributo sexo os valores 'Masculino' e 'Feminino' e ordenando pelo sobrenome e, em seguida, pelo prenome e pelo RG/estado expedidor do gerente.

SELECT 
    d.rg AS rg_estado_expedidor,
    d.nome AS nome_gerente,
    CASE 
        WHEN dep.sexo = 'm' THEN 'Masculino'
        WHEN dep.sexo = 'f' THEN 'Feminino'
    END AS sexo_dependente,
    EXTRACT(YEAR FROM AGE(current_date, dep.data_nascimento)) AS idade_dependente
FROM empregado d
INNER JOIN departamento dept ON d.empregadoid = dept.empregadoid
INNER JOIN empregado dep ON dept.departamentoid = dep.departamentoid
WHERE d.empregadoid IN (
    SELECT empregadoid
    FROM empregado
    WHERE empregadoid = supervisor
);



-- 3. Retorne o RG/estado expedidor e o nome dos empregados e a média de idade dos seus dependentes, considerando os empregados que tiverem 2 ou mais dependentes.

SELECT 
    e.rg AS rg_estado_expedidor,
    e.nome AS nome_empregado,
    AVG(EXTRACT(YEAR FROM AGE(current_date, d.data_nascimento))) AS media_idade_dependentes
FROM empregado e
LEFT JOIN dependente d ON e.empregadoid = d.empregadoid
GROUP BY e.empregadoid, e.rg, e.nome
HAVING COUNT(d.dependenteid) >= 2;




-- 4. Retorne o RG/estado expedidor, o nome completo e o endereço dos empregados que não trabalham em nenhum projeto localizado em Londrina, em ordem decrescente de salário.

SELECT 
    e.rg AS rg_estado_expedidor,
    e.nome AS nome_completo,
    e.endereco AS endereco
FROM empregado e
WHERE e.empregadoid NOT IN (
    SELECT ep.empregadoid
    FROM empregadoprojeto ep
    INNER JOIN projeto p ON ep.projetoid = p.projetoid
    WHERE p.localizacao = 'Londrina'
)
ORDER BY e.salario DESC;



-- 5. Retorne o nome dos 5 funcionários de maior salário dentre todos os empregados e, se ele for gerente de algum departamento, o nome do departamento e a data de início da gerência.

SELECT 
    e.nome AS nome_funcionario,
    COALESCE(d.nome, 'Sem departamento') AS nome_departamento,
    d.data_inicio_gerencia
FROM empregado e
LEFT JOIN (
    SELECT 
        de.empregadoid,
        d.nome,
        de.data_inicio_gerencia
    FROM departamento d
    INNER JOIN empregado de ON d.empregadoid = de.empregadoid
) d ON e.empregadoid = d.empregadoid
ORDER BY e.salario DESC
LIMIT 5;


-- 6. Retorne o valor médio do salário por faixa salarial (até R$ 3.000,00; de R$ 3.001,00 a R$ 9.000; de R$ 9.001,00 a R$ 15.000,00; e maior que R$ 15.000,00) e a quantidade de empregados que recebem salário dentro de cada faixa salarial, para as faixas salariais cujo valor total seja maior que R$ 25.000,00.

SELECT 
    e.nome AS nome_funcionario,
    COALESCE(d.nome, 'Sem departamento') AS nome_departamento,
    d.data_inicio_gerencia
FROM empregado e
LEFT JOIN (
    SELECT 
        de.empregadoid,
        d.nome,
        de.data_inicio_gerencia
    FROM departamento d
    INNER JOIN empregado de ON d.empregadoid = de.empregadoid
) d ON e.empregadoid = d.empregadoid
ORDER BY e.salario DESC
LIMIT 5;
