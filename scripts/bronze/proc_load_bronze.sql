/*FULL LOAD: 
Step 1: make the table empty before loading the data into it. This is done to avoid duplicate records in the table.
Step 2: load the data into the table using BULK INSERT command. This command is used to load large amounts of data into a SQL Server table from a data file.
Truncate: quickly remove all records from the table, resetting it to an empty state 

- EVERY TIME the script is run, the table will be emptied and reloaded with the data from the source file.
This ensures that the table always contains the most up-to-date data from the source file.

- Quality check: Check that the data has not shifted and is in the correct columns
select top 10 *  from [bronze].[crm_cust_info]
select count(*) from [bronze].[crm_cust_info] --checking the number of records loaded into the table

---- Important Notes:
1. Add TRY and CATCH block to handle any errors that may occur during the loading process. 
This will help to identify and troubleshoot any issues that may arise.
2. Use PRINT statements to provide feedback on the progress of the loading process.
3.Track ETL Duration: Helps to identify bottlenecks, optimize performnace, monitor trends, detect issues.
*/
use DATAWAREHOUSE;
GO

CREATE OR ALTER PROCEDURE [bronze].[load_bronze] AS
BEGIN
    DECLARE @StartTime DATETIME, @EndTime DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME;
    BEGIN TRY
        set @batch_start_time = GETDATE();
        print'========================================'
        PRINT 'Loading Bonze Tables;'
        print'========================================'

        print '---------------------------------------'
        PRINT 'Loading CRM Tables'
        print '---------------------------------------'

        set @StartTime = GETDATE();
        print '>>Truncating Table: [bronze].[crm_cust_info] '
        TRUNCATE TABLE [bronze].[crm_cust_info]

        print '>>Inserting Data Into: [bronze].[crm_cust_info] '
        BULK INSERT [bronze].[crm_cust_info]
        FROM '/var/opt/mssql/datasets/source_crm/cust_info.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        )
        set @EndTime = GETDATE();
        print '>>Load Duration: ' + CAST(DATEDIFF(SECOND, @StartTime, @EndTime) AS NVARCHAR) + ' seconds'


        set @StartTime = GETDATE();
        print '>>Truncating Table: [bronze].[crm_prd_info] '
        TRUNCATE TABLE [bronze].[crm_prd_info]
        
        print '>>Inserting Data Into: [bronze].[crm_prd_info] '
        BULK INSERT [bronze].[crm_prd_info]
        FROM '/var/opt/mssql/datasets/source_crm/prd_info.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );
        set @EndTime = GETDATE();
        print '>>Load Duration: ' + CAST(DATEDIFF(SECOND, @StartTime, @EndTime) AS NVARCHAR) + ' seconds'


        set @StartTime = GETDATE();
        print '>>Truncating Table: [bronze].[crm_sales_details] '
        TRUNCATE TABLE [bronze].[crm_sales_details]
    
        print '>>Inserting Data Into: [bronze].[crm_sales_details] '
        BULK INSERT [bronze].[crm_sales_details]
        FROM '/var/opt/mssql/datasets/source_crm/sales_details.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );
        set @EndTime = GETDATE();
        print '>>Load Duration: ' + CAST(DATEDIFF(SECOND, @StartTime, @EndTime) AS NVARCHAR) + ' seconds'

        print '---------------------------------------'
        PRINT 'Loading ERP Tables'
        print '---------------------------------------'
        set @StartTime = GETDATE();
        print '>>Truncating Table: [bronze].[erp_cust_az12] '
        TRUNCATE TABLE [bronze].[erp_cust_az12]
        
        print '>>Inserting Data Into: [bronze].[erp_cust_az12] '
        BULK INSERT [bronze].[erp_cust_az12]
        FROM '/var/opt/mssql/datasets/source_erp/cust_az12.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );
        set @EndTime = GETDATE();
        print '>>Load Duration: ' + CAST(DATEDIFF(SECOND, @StartTime, @EndTime) AS NVARCHAR) + ' seconds'

        set @StartTime = GETDATE();
        print '>>Truncating Table: [bronze].[erp_loc_a101] '
        TRUNCATE TABLE [bronze].[erp_loc_a101]
        
        print '>>Inserting Data Into: [bronze].[erp_loc_a101] '
        BULK INSERT [bronze].[erp_loc_a101]
        FROM '/var/opt/mssql/datasets/source_erp/loc_a101.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );
        set @EndTime = GETDATE();
        print '>>Load Duration: ' + CAST(DATEDIFF(SECOND, @StartTime, @EndTime) AS NVARCHAR) + ' seconds'

        set @StartTime = GETDATE();
        print '>>Truncating Table: [bronze].[erp_px_cat_g1v2] '
        TRUNCATE TABLE [bronze].[erp_px_cat_g1v2]
        
        print '>>Inserting Data Into: [bronze].[erp_px_cat_g1v2] '
        BULK INSERT [bronze].[erp_px_cat_g1v2]
        FROM '/var/opt/mssql/datasets/source_erp/px_cat_g1v2.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );
        set @EndTime = GETDATE();
        print '>>Load Duration: ' + CAST(DATEDIFF(SECOND, @StartTime, @EndTime) AS NVARCHAR) + ' seconds'

        set @batch_end_time = GETDATE();
        print'========================================'
        PRINT 'Bronze Tables Loaded Successfully'
        print 'Total Load Duration: ' + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds'
        print'========================================'
    END TRY
    BEGIN CATCH
        print'========================================'
        PRINT 'Error Occured while loading the Bronze Tables'
        PRINT 'Error Message: ' + ERROR_MESSAGE()
        PRINT 'Error Number: ' + CAST(ERROR_NUMBER() AS NVARCHAR(10))
        print'========================================'
    END CATCH
END