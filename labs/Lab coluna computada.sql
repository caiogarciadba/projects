CREATE TABLE dbo.TesteColuna (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    CPF VARCHAR(20)
);
CREATE TABLE dbo.TesteColuna2 (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    CPF VARCHAR(20)
);
--caio


INSERT INTO dbo.TesteColuna (CPF)
VALUES
('123.456.789-00'),
('987.654.321-99'),
('111.222.333-44');


INSERT INTO dbo.TesteColuna2 (CPF)
VALUES
('123.456.789-00'),
('987.654.321-99'),
('111.222.333-44');


-- Computada não persistida
ALTER TABLE dbo.TesteColuna
ADD CPF_LIMPO_CALC AS REPLACE(REPLACE(REPLACE(CPF, '.', ''), '-', ''), '/', '');

-- Computada persistida
ALTER TABLE dbo.TesteColuna2
ADD CPF_LIMPO_PERSISTED AS REPLACE(REPLACE(REPLACE(CPF, '.', ''), '-', ''), '/', '') PERSISTED;


SELECT CPF_LIMPO_CALC FROM dbo.TesteColuna WHERE CPF_LIMPO_CALC = '12345678900';
SELECT CPF_LIMPO_PERSISTED FROM dbo.TesteColuna2 WHERE CPF_LIMPO_PERSISTED = '12345678900';

