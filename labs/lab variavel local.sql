DROP TABLE IF EXISTS dbo.Pedidos;
GO

CREATE TABLE dbo.Pedidos (
    Id INT IDENTITY PRIMARY KEY,
    ClienteId INT NOT NULL,
    DataPedido DATE NOT NULL,
    Valor NUMERIC(10,2)
);
GO

-- 90% dos dados para ClienteId = 1
INSERT INTO dbo.Pedidos (ClienteId, DataPedido, Valor)
SELECT top 100000 1, DATEADD(DAY, -ABS(CHECKSUM(NEWID())) % 365, GETDATE()), RAND() * 100
FROM sys.all_objects a CROSS JOIN sys.all_objects b
WHERE a.object_id < 2 --AND b.object_id < 10;

-- 10% para ClienteId variado
INSERT INTO dbo.Pedidos (ClienteId, DataPedido, Valor)
SELECT top 10000 ABS(CHECKSUM(NEWID()) % 1000) + 2, DATEADD(DAY, -ABS(CHECKSUM(NEWID())) % 365, GETDATE()), RAND() * 100
FROM sys.all_objects a CROSS JOIN sys.all_objects b
WHERE a.object_id < 20 AND b.object_id < 10;

UPDATE STATISTICS dbo.Pedidos WITH FULLSCAN;


-----
-- 90% dos dados para ClienteId = 1
DECLARE @cliente INT = 1;

SELECT *
FROM dbo.Pedidos
WHERE ClienteId = @cliente;
go


CREATE OR ALTER PROCEDURE usp_BuscaPedidos
    @cliente INT
AS
BEGIN
    SELECT *
    FROM dbo.Pedidos
    WHERE ClienteId = @cliente;
END
GO

-- Executar com ClienteId = 1 (frequente)
EXEC usp_BuscaPedidos @cliente = 1;

-- Executar com ClienteId = 9999 (raro)
EXEC usp_BuscaPedidos @cliente = 9999;


CREATE OR ALTER PROCEDURE usp_BuscaPedidos
    @cliente INT with recompile
AS 
BEGIN
    SELECT *
    FROM dbo.Pedidos
    WHERE ClienteId = @cliente;
END
GO