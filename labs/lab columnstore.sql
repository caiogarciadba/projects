-- Criar banco de dados para o laboratório
CREATE DATABASE Lab_Columnstore;
GO  

USE Lab_Columnstore;
GO-----


-- Criar tabela com índice tradicional
CREATE TABLE Tabela_RowStore (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    Categoria NVARCHAR(50),
    Valor DECIMAL(10,2),
    Descricao NVARCHAR(100)
);

-- Criar tabela drop para armazenar dados com índice Columnstore
CREATE TABLE Tabela_ColumnStore (
    ID INT IDENTITY(1,1),
    Categoria NVARCHAR(50),
    Valor DECIMAL(10,2),
    Descricao NVARCHAR(100)
);

-- Criar índice Columnstore não clusterizado na tabela
CREATE NONCLUSTERED COLUMNSTORE INDEX IDX_ColumnStore 
ON Tabela_ColumnStore (Categoria, Valor);

-- Popular as tabelas com dados
SET NOCOUNT ON;
DECLARE @i INT = 1;
WHILE @i <= 1000000
BEGIN
    INSERT INTO Tabela_RowStore (Categoria, Valor, Descricao)
    VALUES ('Categoria ' + CAST(@i % 10 AS NVARCHAR(10)), RAND() * 1000, 'Descricao ' + CAST(@i AS NVARCHAR(10)));
    
    INSERT INTO Tabela_ColumnStore (Categoria, Valor, Descricao)
    VALUES ('Categoria ' + CAST(@i % 10 AS NVARCHAR(10)), RAND() * 1000, 'Descricao ' + CAST(@i AS NVARCHAR(10)));
    
    SET @i = @i + 1;
END



-- Teste de performance
-- Consulta na tabela com índice tradicional
SET STATISTICS IO, TIME ON;
SELECT Categoria, SUM(Valor) 
FROM Tabela_RowStore
GROUP BY Categoria;

-- Consulta na tabela com índice Columnstore
SELECT Categoria, SUM(Valor) 
FROM Tabela_ColumnStore
GROUP BY Categoria;

