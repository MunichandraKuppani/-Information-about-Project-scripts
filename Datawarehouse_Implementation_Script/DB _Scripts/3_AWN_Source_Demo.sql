Use [AWN_STG_Demo]

---create table in which you want to save exception
CREATE TABLE[AWN_STG_Demo].[dbo].[Exception_Log]
(  
[id] [int] IDENTITY(1, 1) NOT NULL,  
[ErrorLine] [int] NULL,  
[ErrorMessage] [nvarchar](max) NULL,  
[ErrorNumber] [int] NULL,  
[ErrorProcedure] [nvarchar](max) NULL,  
[ErrorSeverity] [int] NULL,  
[ErrorState] [int] NULL,  
[DateErrorRaised] [datetime] NULL,
[Rowscount] [int] Null
)  

Go
/****** Object:  StoredProcedure [dbo].[sp_Get_ErrorInfo]]   Script Date: 25-09-2021 13:29:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER Procedure [dbo].[sp_Get_ErrorInfo]
AS
 BEGIN
     SET NOCOUNT ON;
insert into Exception_Log
(  
[ErrorLine], 
[ErrorMessage], 
[ErrorNumber],  
[ErrorProcedure],
[ErrorSeverity], 
[ErrorState],  
[DateErrorRaised],
[Rowscount]
)  
SELECT  
ERROR_LINE () as ErrorLine,  
Error_Message() as ErrorMessage,  
Error_Number() as ErrorNumber,  
Error_Procedure() as 'Proc',  
Error_Severity() as ErrorSeverity,  
Error_State() as ErrorState,  
GETDATE () as DateErrorRaised,
@@ROWCOUNT as Rowscount

  SET NOCOUNT OFF;

end

GO
/****** Object:  StoredProcedure [dbo].[Refresh_stg_Business_Entity]   Script Date: 25-09-2021 13:29:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER Procedure [dbo].[Refresh_stg_Business_Entity]

AS
BEGIN
    SET NOCOUNT ON;
	BEGIN TRY

INSERT INTO [AWN_STG_Demo].[erp].[Business_Entity] 

(
[BusinessEntityID],
[rowguid],
[ModifiedDate]

)


SELECT  su.[BusinessEntityID]
        ,su.[rowguid]
		,su.[ModifiedDate]
  FROM [AdventureWorks2019].[Person].[BusinessEntity] Su (nolock)
    left join [AWN_STG_Demo].[erp].[Business_Entity] stg  (nolock)
  ON su.BusinessEntityID=stg.BusinessEntityID
    WHERE stg.BusinessEntityID is null
	ORDER BY Su.ModifiedDate Asc


  Update stg

  Set [ModifiedDate] = Su.[ModifiedDate]
  from [AWN_STG_Demo].[erp].[Business_Entity] stg (nolock)
  inner join [AdventureWorks2019].[Person].[BusinessEntity] Su  (nolock)
  on stg.BusinessEntityID = Su.BusinessEntityID

  END TRY
  BEGIN CATCH  
   EXEC [AWN_STG_Demo].[dbo].[sp_Get_ErrorInfo]
  END CATCH

 SET NOCOUNT OFF;
 
end

GO
/****** Object:  StoredProcedure [dbo].[Refresh_stg_Currency]   Script Date: 25-09-2021 13:29:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER Procedure [dbo].[Refresh_stg_Currency]

AS
BEGIN
    SET NOCOUNT ON; 
	BEGIN TRY
INSERT INTO [AWN_STG_Demo].[erp].[Currency]

(
[CurrencyCode],
[Name],
[ModifiedDate]

)

SELECT  su.[CurrencyCode]
        ,su.[Name]
		,su.[ModifiedDate]
  FROM [AdventureWorks2019].[Sales].[Currency] Su (nolock)
    left join [AWN_STG_Demo].[erp].[Currency] stg  (nolock)
  ON su.CurrencyCode=stg.CurrencyCode
    WHERE stg.CurrencyCode is null
	ORDER BY Su.CurrencyCode Asc

END TRY
 BEGIN CATCH  
     EXEC [AWN_STG_Demo].[dbo].[sp_Get_ErrorInfo]
 END CATCH

  SET NOCOUNT OFF;

end 
GO
 /****** Object:  StoredProcedure [dbo].[Refresh_stg_Customer]   Script Date: 25-09-2021 13:29:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER Procedure [dbo].[Refresh_stg_Customer]

AS
BEGIN
    SET NOCOUNT ON; 
	BEGIN TRY
INSERT INTO [AWN_STG_Demo].[erp].[Customer]

(
[CustomerID],
[PersonID],
[StoreID],
[TerritoryID],
[AccountNumber],
[rowguid],
[ModifiedDate]

)

SELECT su.[CustomerID],
       su.PersonID,
	   su.StoreID,
	   su.TerritoryID,
	   su.AccountNumber,
	   su.rowguid,
	   su.ModifiedDate
  FROM [AdventureWorks2019].[Sales].[Customer] Su (nolock)
    left join [AWN_STG_Demo].[erp].[Customer] stg  (nolock)
  ON su.CustomerID=stg.CustomerID
  WHERE stg.CustomerID is null
  ORDER BY Su.ModifiedDate Asc


	update stg
	set
    [AccountNumber]=su.AccountNumber
	from [AWN_STG_Demo].[erp].[Customer] stg  (nolock)
	inner join
	[AdventureWorks2019].[Sales].[Customer] Su (nolock)
	on stg.CustomerID=su.CustomerID

END TRY
BEGIN CATCH  
   EXEC [AWN_STG_Demo].[dbo].[sp_Get_ErrorInfo]
END CATCH

SET NOCOUNT OFF;

end 

GO
 /****** Object:  StoredProcedure [dbo].[Refresh_Stg_Person]   Script Date: 25-09-2021 13:29:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER Procedure [dbo].[Refresh_Stg_Person]

AS
BEGIN
    SET NOCOUNT ON;
	BEGIN TRY
INSERT INTO [AWN_STG_Demo].[erp].[Person]
(
[BusinessEntityID],
[PersonType],
[NameStyle],
[Title],
[FirstName],
[MiddleName],
[LastName],
[Suffix],
[EmailPromotion],
[AdditionalContactInfo],
[Demographics],
[rowguid],
[ModifiedDate]

)

Select su.BusinessEntityID,
       su.PersonType,
	   su.NameStyle,
	   su.Title,
	   su.FirstName,
	   su.MiddleName,
	   su.LastName,
	   su.Suffix,
	   su.EmailPromotion,
	   convert(nvarchar(max),su.AdditionalContactInfo),
	   convert(nvarchar(max),su.Demographics),
	   su.rowguid,
	   su.ModifiedDate

From [AdventureWorks2019].[Person].[Person]  Su (nolock)
left join
[AWN_STG_Demo].[erp].[Person]  stg (nolock)
ON su.BusinessEntityID = stg.BusinessEntityID
WHERE stg.BusinessEntityID is null
ORDER BY Su.ModifiedDate Asc
END TRY
 BEGIN CATCH  
   EXEC [AWN_STG_Demo].[dbo].[sp_Get_ErrorInfo]
 END CATCH

SET NOCOUNT OFF;

end
GO
 /****** Object:  StoredProcedure [dbo].[Refresh_Stg_PersonAddress]   Script Date: 25-09-2021 13:29:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER Procedure [dbo].[Refresh_Stg_PersonAddress] 

AS
BEGIN
    SET NOCOUNT ON;
	BEGIN TRY
INSERT INTO [AWN_STG_Demo].[erp].[PersonAddress]
(
 
      [AddressID],
      [AddressLine1],
      [City],
      [StateProvinceID],
      [PostalCode],
      [rowguid],
      [ModifiedDate]

)

Select Su.AddressID,
       convert(nvarchar(max),Su.AddressLine1),
	   ---convert(nvarchar(max),Su.AddressLine2),
	   convert(nvarchar(max),Su.City),
	   Su.StateProvinceID,
	   Su.PostalCode,
	   --convert(geography,Su.SpatialLocation),
	   Su.rowguid,
	   Su.ModifiedDate

From [AdventureWorks2019].[Person].[Address]  Su (nolock)
left join
[AWN_STG_Demo].[erp].[PersonAddress] stg (nolock)
ON Su.AddressID = stg.AddressID
WHERE stg.AddressID is null
ORDER BY Su.ModifiedDate Asc


END TRY
 BEGIN CATCH  
   EXEC [AWN_STG_Demo].[dbo].[sp_Get_ErrorInfo]
 END CATCH

SET NOCOUNT OFF;

end

GO
 /****** Object:  StoredProcedure [dbo].[Refresh_Stg_Product]   Script Date: 25-09-2021 13:29:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER Procedure [dbo].[Refresh_Stg_Product] 

AS
BEGIN
    SET NOCOUNT ON;
	BEGIN TRY
INSERT INTO [AWN_STG_Demo].[erp].[Product]
(
 
       [ProductID]
      ,[Name]
      ,[ProductNumber]
      ,[MakeFlag]
      ,[FinishedGoodsFlag]
      ,[Color]
      ,[SafetyStockLevel]
      ,[ReorderPoint]
      ,[StandardCost]
      ,[ListPrice]
      ,[Size]
      ,[SizeUnitMeasureCode]
      ,[WeightUnitMeasureCode]
      ,[Weight]
      ,[DaysToManufacture]
      ,[ProductLine]
      ,[Class]
      ,[Style]
      ,[ProductSubcategoryID]
      ,[ProductModelID]
      ,[SellStartDate]
      ,[SellEndDate]
      ,[DiscontinuedDate]
      ,[rowguid]
      ,[ModifiedDate]

)

SELECT Su.ProductID,
       Su.Name,
	   Su.ProductNumber,
	   su.MakeFlag,
	   Su.FinishedGoodsFlag,
	   Su.Color,
	   Su.SafetyStockLevel,
	   Su.ReorderPoint,
	   Su.StandardCost,
	   Su.ListPrice,
	   Su.Size,
	   Su.SizeUnitMeasureCode,
	   Su.WeightUnitMeasureCode,
	   Su.Weight,
	   Su.DaysToManufacture,
	   Su.ProductLine,
	   Su.Class,
	   Su.Style,
	   Su.ProductSubcategoryID,
	   Su.ProductModelID,
	   Su.SellStartDate,
	   Su.SellEndDate,
	   Su.DiscontinuedDate,
	   Su.rowguid,
	   Su.ModifiedDate


  FROM [AdventureWorks2019].[Production].[Product]  Su (nolock)
    left join
  [AWN_STG_Demo].[erp].[Product] stg (nolock)
    ON Su.[ProductID] = stg.ProductID
    WHERE stg.ProductID is null
    ORDER BY Su.ModifiedDate Asc


END TRY
 BEGIN CATCH  
   EXEC [AWN_STG_Demo].[dbo].[sp_Get_ErrorInfo]
 END CATCH

SET NOCOUNT OFF;

end

GO
 /****** Object:  StoredProcedure [dbo].[Refresh_Stg_ProductCategory]   Script Date: 25-09-2021 13:29:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER Procedure [dbo].[Refresh_Stg_ProductCategory]

AS
BEGIN
    SET NOCOUNT ON;
	BEGIN TRY
INSERT INTO [AWN_STG_Demo].[erp].[ProductCategory]
(
 [ProductCategoryID],
 [Name],
 [rowguid],
 [ModifiedDate]

)

SELECT Su.ProductCategoryID,
        Su.Name,
		Su.rowguid,
		Su.ModifiedDate


  FROM [AdventureWorks2019].[Production].[ProductCategory] Su (nolock)
    left join
  [AWN_STG_Demo].[erp].[ProductCategory] stg (nolock)
    ON Su.ProductCategoryID = stg.ProductCategoryID
    WHERE stg.ProductCategoryID is null
    ORDER BY Su.ModifiedDate Asc


END TRY
 BEGIN CATCH  
   EXEC [AWN_STG_Demo].[dbo].[sp_Get_ErrorInfo]
 END CATCH

SET NOCOUNT OFF;

end

GO
 /****** Object:  StoredProcedure [dbo].[Refresh_Stg_ProductSubCategory]   Script Date: 25-09-2021 13:29:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER Procedure [dbo].[Refresh_Stg_ProductSubCategory]

AS
BEGIN
    SET NOCOUNT ON;
	BEGIN TRY
INSERT INTO [AWN_STG_Demo].[erp].[ProductSubCategory]
(
 [ProductSubcategoryID],
 [ProductCategoryID],
 [Name]
)

SELECT Su.ProductSubcategoryID,
        Su.ProductCategoryID,
		Su.Name
		--Su.rowguid,
		--Su.ModifiedDate
		
		
  FROM [AdventureWorks2019].[Production].[ProductSubcategory] Su (nolock)
    left join
  [AWN_STG_Demo].[erp].[ProductSubCategory] stg (nolock)
    ON Su.ProductSubcategoryID = stg.ProductSubcategoryID
    WHERE stg.ProductSubcategoryID is null
    ORDER BY Su.ProductSubcategoryID Asc


END TRY
 BEGIN CATCH  
   EXEC [AWN_STG_Demo].[dbo].[sp_Get_ErrorInfo]
 END CATCH

SET NOCOUNT OFF;

end

GO
 /****** Object:  StoredProcedure [dbo].[Refresh_Stg_SalesTerritory]   Script Date: 25-09-2021 13:29:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER Procedure [dbo].[Refresh_Stg_SalesTerritory]

AS
BEGIN
    SET NOCOUNT ON;
	BEGIN TRY
INSERT INTO [AWN_STG_Demo].[erp].[SalesTerritory]
(
[TerritoryID],
[Name],
[CountryRegionCode],
[Group]
)

SELECT  Su.[TerritoryID],
        Su.[Name],
		Su.[CountryRegionCode],
		su.[Group]
		
  FROM [AdventureWorks2019].[Sales].[SalesTerritory] Su (nolock)
    left join
  [AWN_STG_Demo].[erp].[SalesTerritory] stg (nolock)
    ON Su.TerritoryID = stg.TerritoryID
    WHERE stg.TerritoryID is null
    ORDER BY Su.TerritoryID Asc


END TRY
 BEGIN CATCH  
   EXEC [AWN_STG_Demo].[dbo].[sp_Get_ErrorInfo]
 END CATCH

SET NOCOUNT OFF;

end

GO
 /****** Object:  StoredProcedure [dbo].[Refresh_Stg_Store]  Script Date: 25-09-2021 13:29:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER Procedure [dbo].[Refresh_Stg_Store]

AS
BEGIN
    SET NOCOUNT ON;
	BEGIN TRY
INSERT INTO [AWN_STG_Demo].[erp].[Store]
(
[rowguid],
[ModifiedDate],
[Name],
[Demographics],
[BusinessEntityID]

)

SELECT Su.rowguid,
       Su.ModifiedDate,
	   Su.Name,
	   CONVERT(nvarchar(max),Su.[Demographics]),
	   Su.BusinessEntityID

		
  FROM [AdventureWorks2019].[Sales].[Store] Su (nolock)
    left join
  [AWN_STG_Demo].[erp].[Store] stg (nolock)
    ON Su.BusinessEntityID = stg.BusinessEntityID
    WHERE stg.BusinessEntityID is null
    ORDER BY Su.BusinessEntityID Asc


END TRY
 BEGIN CATCH  
   EXEC [AWN_STG_Demo].[dbo].[sp_Get_ErrorInfo]
 END CATCH

SET NOCOUNT OFF;

end


GO
 /****** Object:  StoredProcedure [dbo].[Refresh_Stg_Employee]  Script Date: 25-09-2021 13:29:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER Procedure [dbo].[Refresh_Stg_Employee]

AS
BEGIN
    SET NOCOUNT ON;
	BEGIN TRY
INSERT INTO [AWN_STG_Demo].[hr].[Employee]
(
[BusinessEntityID],
[NationalIDNumber],
[LoginID],
[OrganizationNode],
[OrganizationLevel],
[JobTitle],
[BirthDate],
[MaritalStatus],
[Gender],
[HireDate],
[SalariedFlag],
[VacationHours],
[SickLeaveHours],
[CurrentFlag],
[rowguid],
[ModifiedDate]

)

SELECT Su.[BusinessEntityID],
Su.[NationalIDNumber],
Su.[LoginID],
Su.[OrganizationNode],
Su.[OrganizationLevel],
Su.[JobTitle],
Su.[BirthDate],
Su.[MaritalStatus],
Su.[Gender],
Su.[HireDate],
Su.[SalariedFlag],
Su.[VacationHours],
Su.[SickLeaveHours],
Su.[CurrentFlag],
Su.[rowguid],
Su.[ModifiedDate]

		
  FROM [AdventureWorks2019].[HumanResources].[Employee] Su (nolock)
    left join
  [AWN_STG_Demo].[hr].[Employee] stg (nolock)
    ON Su.BusinessEntityID = stg.BusinessEntityID
    WHERE stg.BusinessEntityID is null
    ORDER BY Su.ModifiedDate Asc


END TRY
 BEGIN CATCH  
   EXEC [AWN_STG_Demo].[dbo].[sp_Get_ErrorInfo]
 END CATCH

SET NOCOUNT OFF;

end

GO
 /****** Object:  StoredProcedure [dbo].[Refresh_Stg_EmployeeDepartmentHistory]  Script Date: 25-09-2021 13:29:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER Procedure [dbo].[Refresh_Stg_EmployeeDepartmentHistory]

AS
BEGIN
    SET NOCOUNT ON;
	BEGIN TRY
INSERT INTO [AWN_STG_Demo].[hr].[EmployeeDepartmentHistory]
(
[BusinessEntityID],
[DepartmentID],
[ShiftID],
[StartDate],
[EndDate],
[ModifiedDate]

)

SELECT Su.[BusinessEntityID],
Su.[DepartmentID],
Su.[ShiftID],
Su.[StartDate],
Su.[EndDate],
Su.[ModifiedDate]
		
  FROM [AdventureWorks2019].[HumanResources].[EmployeeDepartmentHistory] Su (nolock)
    left join
  [AWN_STG_Demo].[hr].[EmployeeDepartmentHistory] stg (nolock)
    ON Su.BusinessEntityID = stg.BusinessEntityID
    WHERE stg.BusinessEntityID is null
    ORDER BY Su.ModifiedDate Asc


END TRY
 BEGIN CATCH  
   EXEC [AWN_STG_Demo].[dbo].[sp_Get_ErrorInfo]
 END CATCH

SET NOCOUNT OFF;

end

GO
 /****** Object:  StoredProcedure [dbo].[Refresh_Stg_EmployeePayHistory]  Script Date: 25-09-2021 13:29:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER Procedure [dbo].[Refresh_Stg_EmployeePayHistory]

AS
BEGIN
    SET NOCOUNT ON;
	BEGIN TRY
INSERT INTO [AWN_STG_Demo].[hr].[EmployeePayHistory]
(
[BusinessEntityID],
[RateChangeDate],
[Rate],
[PayFrequency],
[ModifiedDate]

)

SELECT Su.[BusinessEntityID],
Su.RateChangeDate,
Su.Rate,
Su.PayFrequency,
Su.[ModifiedDate]
		
  FROM [AdventureWorks2019].[HumanResources].[EmployeePayHistory] Su (nolock)
    left join
  [AWN_STG_Demo].[hr].[EmployeePayHistory] stg (nolock)
    ON Su.BusinessEntityID = stg.BusinessEntityID
    WHERE stg.BusinessEntityID is null
    ORDER BY Su.ModifiedDate Asc


END TRY
 BEGIN CATCH  
   EXEC [AWN_STG_Demo].[dbo].[sp_Get_ErrorInfo]
 END CATCH

SET NOCOUNT OFF;

end

GO
 /****** Object:  StoredProcedure [dbo].[Refresh_Stg_SalesHeader]  Script Date: 25-09-2021 13:29:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER Procedure [dbo].[Refresh_Stg_SalesHeader]

AS
BEGIN
    SET NOCOUNT ON;
	BEGIN TRY

Merge [AWN_STG_Demo].[erp].[SalesHeader] as Stg
using [AdventureWorks2019].[Sales].[SalesOrderHeader] as Su
 on Stg.[SalesOrderID] = Su.[SalesOrderID]
 -- when records are matched,update the records if there is any change
 when Matched 
  and (Stg.[RevisionNumber] <> Su.[RevisionNumber] or Stg.[DueDate] <> Su.[DueDate] or
       Stg.[ShipDate] <> Su.[ShipDate] or Stg.[Status] <> Su.[Status] or Stg.[TotalDue] <> Su.[TotalDue] or
       Stg.[ModifiedDate] <> Su.[ModifiedDate] )

Then
Update set Stg.[RevisionNumber] = Su.[RevisionNumber],
           Stg.[DueDate] = Su.[DueDate],
           Stg.[ShipDate] = Su.[ShipDate],
	       Stg.[Status] = Su.[Status],
		   Stg.[TotalDue] = Su.[TotalDue],
           Stg.[ModifiedDate] = Su.[ModifiedDate]
		   
When Not Matched by Target then
insert 
([SalesOrderID],
[RevisionNumber],
[OrderDate],
[DueDate],
[ShipDate],
[Status],
[OnlineOrderFlag],
[SalesOrderNumber],
[PurchaseOrderNumber],
[AccountNumber],
[CustomerID],
[SalesPersonID],
[TerritoryID],
[BillToAddressID],
[ShipToAddressID],
[ShipMethodID],
[CreditCardID],
[CreditCardApprovalCode],
[CurrencyRateID],
[SubTotal],
[TaxAmt],
[Freight],
[TotalDue],
[Comment],
[rowguid],
[ModifiedDate]


)




values
(
Su.[SalesOrderID],
Su.[RevisionNumber],
Su.[OrderDate],
Su.[DueDate],
Su.[ShipDate],
Su.[Status],
Su.[OnlineOrderFlag],
Su.[SalesOrderNumber],
Su.[PurchaseOrderNumber],
Su.[AccountNumber],
Su.[CustomerID],
Su.[SalesPersonID],
Su.[TerritoryID],
Su.[BillToAddressID],
Su.[ShipToAddressID],
Su.[ShipMethodID],
Su.[CreditCardID],
Su.[CreditCardApprovalCode],
Su.[CurrencyRateID],
Su.[SubTotal],
Su.[TaxAmt],
Su.[Freight],
Su.[TotalDue],
Su.[Comment],
Su.[rowguid],
Su.[ModifiedDate]
)
;
END TRY
 BEGIN CATCH  
   EXEC [AWN_STG_Demo].[dbo].[sp_Get_ErrorInfo]
 END CATCH

SET NOCOUNT OFF;

end

GO
 /****** Object:  StoredProcedure [dbo].[Refresh_Stg_SalesOrderDetail]  Script Date: 25-09-2021 13:29:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER Procedure [dbo].[Refresh_Stg_SalesOrderDetail]

AS
BEGIN
    SET NOCOUNT ON;
	BEGIN TRY

Merge [AWN_STG_Demo].[erp].[SalesOrderDetail] as Stg
using [AdventureWorks2019].[Sales].[SalesOrderDetail] as Su
 on Stg.[SalesOrderDetailID] = Su.[SalesOrderDetailID]

 -- when records are matched,update the records if there is any change
 when Matched 
  and (
  Stg.[CarrierTrackingNumber] <> Su.[CarrierTrackingNumber] 
  and Stg.[UnitPriceDiscount] <> Su.[UnitPriceDiscount]
  and Stg.[OrderQty] = Su.[OrderQty]
  )

Then
Update set Stg.[CarrierTrackingNumber] = Su.[CarrierTrackingNumber],
           Stg.[UnitPriceDiscount] = Su.[UnitPriceDiscount],
		   Stg.[OrderQty] = Su.[OrderQty]
When Not Matched by Target then
insert 
(
[SalesOrderID],
[SalesOrderDetailID],
[CarrierTrackingNumber],
[OrderQty],
[ProductID],
[SpecialOfferID],
[UnitPrice],
[UnitPriceDiscount],
[LineTotal],
[rowguid],
[ModifiedDate]
)
values
(
Su.[SalesOrderID],
Su.[SalesOrderDetailID],
Su.[CarrierTrackingNumber],
Su.[OrderQty],
Su.[ProductID],
Su.[SpecialOfferID],
Su.[UnitPrice],
Su.[UnitPriceDiscount],
Su.[LineTotal],
Su.[rowguid],
Su.[ModifiedDate]
)
;
END TRY
 BEGIN CATCH  
   EXEC [AWN_STG_Demo].[dbo].[sp_Get_ErrorInfo]
 END CATCH

SET NOCOUNT OFF;

end


