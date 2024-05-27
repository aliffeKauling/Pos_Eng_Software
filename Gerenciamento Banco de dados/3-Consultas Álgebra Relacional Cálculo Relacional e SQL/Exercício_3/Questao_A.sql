-- A
INSERT INTO departamento (departamentoid, nome, numero, empregadoid, data_inicio)
VALUES
    (1, 'Departamento A', 10, 101, '2023-01-01'),
    (2, 'Departamento B', 20, 102, '2023-01-01');


INSERT INTO LocalizacaoDepartamento (LocalizacaoID, NomeDepartamento) VALUES 
(1, 'Vendas'),
(2, 'Producao');

INSERT INTO projeto (projetoid, nome, numero, descricao, localizacao, tipo)
VALUES
    (1, 'Projeto 1', 101, 'Descrição do Projeto 1', 'Londrina', 'produto'),
    (2, 'Projeto 2', 102, 'Descrição do Projeto 2', 'Curitiba', 'processo');


INSERT INTO TipoProjeto (TipoProjetoID, DescricaoTipo) VALUES 
(1, 'Produto'),
(2, 'Processo'),
(3, 'Serviço');


INSERT INTO empregado (empregadoid, nome, rg, estado_expedidor, endereco, salario, sexo, data_nascimento, supervisordireto, departamento_id)
VALUES
    (101, 'João Silva', '1234567', 'PR', 'Rua A, 123', 5000, 'm', '1990-01-01', NULL, 1),
    (102, 'Maria Santos', '7654321', 'PR', 'Rua B, 456', 6000, 'f', '1988-03-15', NULL, 2);


INSERT INTO HorasTrabalhadas (EmpregadoID, ProjetoID, HorasSemana) VALUES 
(1, 1, 10),
(2, 2, 8);

INSERT INTO dependente (dependenteid, empregadoid, nome, sexo, data_nascimento)
VALUES
    (1, 101, 'Ana Silva', 'f', '2010-05-20'),
    (2, 101, 'Pedro Silva', 'm', '2015-08-12'),
    (3, 102, 'José Santos', 'm', '2012-10-25');


INSERT INTO ProjetoProduto (ProjetoID, ArquivoProjeto, ListaMateriais) VALUES 
(1, 'Arquivo Projeto A', 'Lista de Materiais Projeto A');

INSERT INTO ProjetoProcesso (ProjetoID, EmpregadoExperimentalID) VALUES 
(2, 2);

INSERT INTO Reclamacao (ReclamacaoID, Descricao, NotaInicial) VALUES 
(1, 'Reclamação A', 8);

INSERT INTO ProjetoServico (ProjetoID, ReclamacaoID, AcoesCorretivas, ResultadoDescricao, NotaFinalSatisfacao) VALUES 
(2, 1, 'Ação Corretiva Projeto A', 'Resultado Descrição Projeto A', 9);