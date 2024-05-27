--A) Criação de Usuários
--Criar um novo usuário para importar o esquema. Lembre-se de conceder quota para o usuário no
--seu tablespace padrão (e.g., QUOTA UNLIMITED ON USERS).

CREATE USER ALIFFE_UEL IDENTIFIED BY Mudar123 QUOTA UNLIMITED ON USERS;


--1) Criar uma nova atribuição com os privilégios de sistema a seguir:
--QUERY REWRITE
--CREATE VIEW
--CREATE MATERIALIZED VIEW
CREATE ROLE MEUS_PRIVILEGIOS;

GRANT QUERY REWRITE TO MEUS_PRIVILEGIOS;
GRANT CREATE VIEW TO MEUS_PRIVILEGIOS;
GRANT CREATE MATERIALIZED VIEW TO MEUS_PRIVILEGIOS;


--2) Conceder as seguintes atribuições ao usuário criado:
--CONNECT
--RESOURCE
--SELECT_CATALOG_ROLE
--Atribuição criada no item (1)

GRANT CONNECT, RESOURCE, SELECT_CATALOG_ROLE TO ALIFFE_UEL;
GRANT MEUS_PRIVILEGIOS TO ALIFFE_UEL;


--3) Conceder o seguinte de objeto privilegio ao usuário criado:
--Privilégio: EXECUTE
--Objeto: Pacote SYS.DBMS_STATS

GRANT EXECUTE ON SYS.DBMS_STATS TO ALIFFE_UEL;

-------------------------------
--B) Importação de dados

--1) Conecte no banco como o usuário criado e crie tabelas no esquema do usuário a partir das tabelas do esquema do usuário sh.

BEGIN
FOR csr IN (SELECT table_name FROM ALL_TABLES WHERE owner = 'SH' AND NOT table_name LIKE '%MV')
LOOP
EXECUTE IMMEDIATE 'GRANT SELECT ON sh.' || csr.table_name || ' TO ALIFFE_UEL';
END LOOP;
END;

GRANT CREATE ANY DIRECTORY TO ALIFFE_UEL

BEGIN
FOR csr IN (SELECT table_name FROM ALL_TABLES WHERE owner = 'SH' AND NOT table_name LIKE '%MV')
LOOP
EXECUTE IMMEDIATE 'CREATE TABLE new_' || csr.table_name || ' AS SELECT * FROM sh. ' || csr.table_name;
END LOOP;
END;

-------------------------------

--C) Consultas e indexação
--1) Escreva uma consulta em SQL usando as tabelas criadas.
-- A consulta deve ser relativamente complexa (envolva pelo menos 3 tabelas, tenha várias
--condições de filtragem e use algumas variações de predicados e operações)
-- Uma das condições deve ser um intervalo de datas na tabela sales (atributo time_id)
-- Inclua a consulta SQL gerada no relatório.


SELECT c.cust_first_name, c.cust_last_name, p.prod_name, s.amount_sold, s.time_id
FROM aliffe_uel.customers c
INNER JOIN aliffe_uel.sales s ON c.cust_id = s.cust_id
INNER JOIN aliffe_uel.products p ON s.prod_id = p.prod_id
WHERE c.cust_year_of_birth < 1980
AND p.prod_list_price BETWEEN 1000 AND 2000
AND s.time_id BETWEEN TO_DATE('1980-01-01', 'YYYY-MM-DD') AND TO_DATE('2023-12-31', 'YYYY-MM-DD');



--2) Apresente o plano de execução gerado para a consulta
-- Mostre o plano de execução no relatório.

/* 
 OPERATION 	 OBJECT_NAME 	 OPTIONS 	 CARDINALITY 	 COST 
 SELECT STATEMENT 	   	   	   	 2530 
 HASH JOIN 	   	   	 235055 	 2530 
 Access Predicates 
 C.CUST_ID=S.CUST_ID 
 TABLE ACCESS 	 CUSTOMERS 	 FULL 	 48292 	 423 
 Filter Predicates 
 C.CUST_YEAR_OF_BIRTH<1980 
 HASH JOIN 	   	   	 235059 	 1253 
 Access Predicates 
 S.PROD_ID=P.PROD_ID 
 TABLE ACCESS 	 PRODUCTS 	 FULL 	 18 	 3 
 Filter Predicates 
 TABLE ACCESS 	 SALES 	 FULL 	 918843 	 1245 
 Filter Predicates 
 AND 
 S.TIME_ID>=TO_DATE(' 1980-01-01 00:00:00', 'syyyy-mm-dd hh24:mi:ss') 
 S.TIME_ID<=TO_DATE(' 2023-12-31 00:00:00', 'syyyy-mm-dd hh24:mi:ss') 
 Other XML 
 */
 
 -- 3) Crie índices para otimizar o desempenho da consulta (lembre-se de manter as estatísticas atualizadas)
-- Mostre as instruções de criação de índices e o plano de execução após a criação dos índices no relatório

CREATE INDEX idx_sales_cust_id_time_id ON aliffe_uel.sales (cust_id, time_id);
CREATE INDEX idx_sales_prod_id ON aliffe_uel.sales (prod_id);
CREATE INDEX idx_customers_cust_year_of_birth ON aliffe_uel.customers (cust_year_of_birth);
CREATE INDEX idx_products_prod_list_price ON aliffe_uel.products (prod_list_price);
CREATE INDEX idx_cust_sales_join ON aliffe_uel.customers (cust_id);
CREATE INDEX idx_sales_time_id ON aliffe_uel.sales (time_id);


/*
 OPERATION 	 OBJECT_NAME 	 OPTIONS 	 CARDINALITY 	 COST 	 LAST...GETS 	 LAST...TIME 
 SELECT STATEMENT 	   	   	   	 1827 	 1530 	 70357 
 HASH JOIN 	   	   	 19142 	 1827 	 1530 	 70357 
 Access Predicates 
 C.CUST_ID=S.CUST_ID 
 TABLE ACCESS 	 CUSTOMERS 	 FULL 	 50757 	 423 	 1520 	 18966 
 Filter Predicates 
 C.CUST_YEAR_OF_BIRTH<1980 
 HASH JOIN 	   	   	 19142 	 1253 	 10 	 2345 
 Access Predicates 
 S.PROD_ID=P.PROD_ID 
 TABLE ACCESS 	 PRODUCTS 	 FULL 	 1 	 3 	 3 	 122 
 Filter Predicates 
 AND 
 P.PROD_LIST_PRICE>=1000 
 P.PROD_LIST_PRICE<=2000 
 TABLE ACCESS 	 SALES 	 FULL 	 918843 	 1245 	 7 	 1091 
 Filter Predicates 
 AND 
 S.TIME_ID>=TO_DATE(' 1980-01-01 00:00:00', 'syyyy-mm-dd hh24:mi:ss') 
 S.TIME_ID<=TO_DATE(' 2023-12-31 00:00:00', 'syyyy-mm-dd hh24:mi:ss') 
 */
 
 
 --D) Uso de Visões Materializadas
 
 /*
 1) Crie uma visão materializada que otimize o desempenho da consulta do item (C).
- Lembre-se de ativar o QUERY REWRITE na visão materializada.
- Inclua no relatório a instrução SQL de criação da visão materializada.
Ex: CREATE MATERIALIZED VIEW <nome_visão> USING INDEX REFRESH FORCE ON 
DEMAND ENABLE QUERY REWRITE AS SELECT...
*/

CREATE MATERIALIZED VIEW mv_sales_analysis
USING INDEX
REFRESH FORCE ON DEMAND
ENABLE QUERY REWRITE
AS
SELECT c.cust_first_name, c.cust_last_name, p.prod_name, s.amount_sold, s.time_id
FROM aliffe_uel.customers c
INNER JOIN aliffe_uel.sales s ON c.cust_id = s.cust_id
INNER JOIN aliffe_uel.products p ON s.prod_id = p.prod_id
WHERE c.cust_year_of_birth < 1980
AND p.prod_list_price BETWEEN 1000 AND 2000
AND s.time_id BETWEEN TO_DATE('1980-01-01', 'YYYY-MM-DD') AND TO_DATE('2023-12-31', 'YYYY-MM-DD');

select * from mv_sales_analysis

/*2) Mostre o plano de execução obtido através da reescrita da consulta usando a visão 
materializada criada.
- Inclua no relatório o plano de execução gerado com a reescrita da consulta*/

/*
OPERATION 	 OBJECT_NAME 	 OPTIONS 	 CARDINALITY 	 COST 	 LAST...GETS 	 LAST...TIME 
 SELECT STATEMENT 	   	   	   	 36 	 3 	 228 
 MAT_VIEW ACCESS 	 MV_SALES_ANALYSIS 	 FULL 	 14503 	 36 	 3 	 228 
 */
 
 
 
 