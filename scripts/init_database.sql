use master;
GO -- SEPARATE batches when working with multiple SQL statements


-- Drop ans recreate the'DatawareHouse' database
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'Datawarehouse')
BEGIN 
    ALTER DATABASE DataWarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE DataWarehouse
END;
GO

--   Create Database 'DataWarehouse' --
CREATE DATABASE DataWarehouse;
GO

use DataWarehouse;
GO

-- Create each layer as a Schema
-- what is schema? It's like a folder or a container that helps you to keep things organized.
CREATE SCHEMA bronze;
GO 

CREATE SCHEMA silver;
GO

CREATE SCHEMA gold;
