
--union
--union all

select PersonType, FirstName, LastName from AdventureWorks2014.Person.Person
where PersonType = 'EM'

select PersonType, FirstName, LastName from AdventureWorks2014.Person.Person
where PersonType = 'IN'

select PersonType, FirstName, LastName from AdventureWorks2014.Person.Person
where PersonType = 'EM'
union
select PersonType, FirstName, LastName from AdventureWorks2014.Person.Person
where PersonType = 'IN'

select PersonType, FirstName, LastName from AdventureWorks2014.Person.Person
where PersonType = 'EM'
union all
select PersonType, FirstName, LastName from AdventureWorks2014.Person.Person
where PersonType = 'IN'

---MAX
---MIN
---Subconsultas

select * from AdventureWorks2014.Person.Person

select BusinessEntityID,PersonType, FirstName, LastName from AdventureWorks2014.Person.Person
order by LastName,BusinessEntityID


select a.BusinessEntityID, a.PersonType, a.FirstName, a.LastName from AdventureWorks2014.Person.Person a
where a.BusinessEntityID in (select min(b.BusinessEntityID) from AdventureWorks2014.Person.Person b
							group by b.FirstName, b.LastName)
order by a.LastName


select a.BusinessEntityID, a.PersonType, a.FirstName, a.LastName from AdventureWorks2014.Person.Person a
where a.BusinessEntityID in (select max(b.BusinessEntityID) from AdventureWorks2014.Person.Person b
							group by b.FirstName, b.LastName)
order by a.LastName


select min(b.BusinessEntityID), b.FirstName, b.LastName from AdventureWorks2014.Person.Person b
group by b.FirstName, b.LastName


USE AdventureWorks2014;
GO
SELECT Ord.SalesOrderID, Ord.OrderDate,
    (SELECT MAX(OrdDet.UnitPrice)
     FROM Sales.SalesOrderDetail AS OrdDet
     WHERE Ord.SalesOrderID = OrdDet.SalesOrderID) AS MaxUnitPrice
FROM Sales.SalesOrderHeader AS Ord;
GO


USE AdventureWorks2014;
GO

/* SELECT statement built using a subquery. */
SELECT [Name]
FROM Production.Product
WHERE ListPrice =
    (SELECT ListPrice
     FROM Production.Product
     WHERE [Name] = 'Chainring Bolts' );
GO

/* SELECT statement built using a join that returns
   the same result set. */
SELECT Prd1.[Name]
FROM Production.Product AS Prd1
     JOIN Production.Product AS Prd2
       ON (Prd1.ListPrice = Prd2.ListPrice)
WHERE Prd2.[Name] = 'Chainring Bolts';
GO

USE AdventureWorks2014;
GO
SELECT LastName, FirstName
FROM Person.Person
WHERE BusinessEntityID IN
    (SELECT BusinessEntityID
     FROM HumanResources.Employee
     WHERE BusinessEntityID IN
        (SELECT BusinessEntityID
         FROM Sales.SalesPerson)
    );
GO

USE AdventureWorks2014;
GO
SELECT LastName, FirstName
FROM Person.Person c
INNER JOIN HumanResources.Employee e
ON c.BusinessEntityID = e.BusinessEntityID
JOIN Sales.SalesPerson s 
ON e.BusinessEntityID = s.BusinessEntityID;
GO


----Subconsulta en join

select b.BusinessEntityID, B.PhoneNumber, sq.FirstName, sq.LastName from AdventureWorks2014.Person.PersonPhone b
inner join
(
	select a.BusinessEntityID, PersonType, a.FirstName, a.LastName from AdventureWorks2014.Person.Person a
)sq
on sq.BusinessEntityID = b.BusinessEntityID


/*
1 285	SP	Syed	Abbas
1 293	SC	Catherine	Abel
1 295	SC	Kim	Abercrombie
2 38	EM	Kim	Abercrombie
3 2170	GC	Kim	Abercrombie
1 2357	GC	Sam	Abolrous
*/

/*
ROW_NUMBER ( )   
    OVER ( [ PARTITION BY value_expression , ... [ n ] ] order_by_clause )  
*/

SELECT 
  ROW_NUMBER() OVER(ORDER BY name ASC) AS Row#,
  name, recovery_model_desc
FROM sys.databases 

select
a.BusinessEntityID, PersonType, a.FirstName, a.LastName from AdventureWorks2014.Person.Person a
order by a.LastName

select 
ROW_NUMBER() OVER(ORDER BY a.LastName ASC) AS Row#,
a.BusinessEntityID, PersonType, a.FirstName, a.LastName from AdventureWorks2014.Person.Person a
order by a.LastName


select 
ROW_NUMBER() OVER(Partition by a.FirstName, a.LastName ORDER BY a.FirstName, a.LastName ASC) AS Row#,
a.BusinessEntityID, PersonType, a.FirstName, a.LastName from AdventureWorks2014.Person.Person a
order by a.FirstName, a.LastName


-----VIEW
USE AdventureWorks2014;
GO
SELECT LastName, FirstName
FROM Person.Person c
INNER JOIN HumanResources.Employee e
ON c.BusinessEntityID = e.BusinessEntityID
JOIN Sales.SalesPerson s 
ON e.BusinessEntityID = s.BusinessEntityID;
GO

create view VistaPersonasEmpleados
as
	SELECT LastName, FirstName
		FROM Person.Person c
	INNER JOIN HumanResources.Employee e
	ON c.BusinessEntityID = e.BusinessEntityID
	JOIN Sales.SalesPerson s 
	ON e.BusinessEntityID = s.BusinessEntityID;
GO


-------

select * from VistaPersonasEmpleados


---vista indezada

use AdventureWorks2014
go

--Set the options to support indexed views.
SET NUMERIC_ROUNDABORT OFF;
SET ANSI_PADDING, ANSI_WARNINGS, CONCAT_NULL_YIELDS_NULL, ARITHABORT,
   QUOTED_IDENTIFIER, ANSI_NULLS ON;
--Create view with schemabinding.
IF OBJECT_ID ('Sales.vOrders', 'view') IS NOT NULL
   DROP VIEW Sales.vOrders ;
GO
CREATE VIEW Sales.vOrders
   WITH SCHEMABINDING
   AS  
      SELECT SUM(UnitPrice*OrderQty*(1.00-UnitPriceDiscount)) AS Revenue,
         OrderDate, ProductID, COUNT_BIG(*) AS COUNT
      FROM Sales.SalesOrderDetail AS od, Sales.SalesOrderHeader AS o
      WHERE od.SalesOrderID = o.SalesOrderID
      GROUP BY OrderDate, ProductID;
GO
--Create an index on the view.
CREATE UNIQUE CLUSTERED INDEX IDX_V1
   ON Sales.vOrders (OrderDate, ProductID);
GO
--This query can use the indexed view even though the view is
--not specified in the FROM clause.
SELECT SUM(UnitPrice*OrderQty*(1.00-UnitPriceDiscount)) AS Rev,
   OrderDate, ProductID
FROM Sales.SalesOrderDetail AS od
JOIN Sales.SalesOrderHeader AS o
   ON od.SalesOrderID=o.SalesOrderID
      AND o.OrderDate >= CONVERT(datetime,'05/01/2012',101)
WHERE od.ProductID BETWEEN 700 and 800
   GROUP BY OrderDate, ProductID
   ORDER BY Rev DESC;
GO
--This query can use the above indexed view.
SELECT OrderDate, SUM(UnitPrice*OrderQty*(1.00-UnitPriceDiscount)) AS Rev
FROM Sales.SalesOrderDetail AS od
JOIN Sales.SalesOrderHeader AS o
   ON od.SalesOrderID=o.SalesOrderID
      AND o.OrderDate >= CONVERT(datetime,'03/01/2012',101)
      AND o.OrderDate < CONVERT(datetime,'04/01/2012',101)
    GROUP BY OrderDate
    ORDER BY OrderDate ASC;

--- usando index en la vista
select * from Sales.vOrders

-----funciones matematicas

--sum
--ceiling
--floor
--round

--round
SELECT OrderDate, round(SUM(UnitPrice*OrderQty*(1.00-UnitPriceDiscount)),2) AS Rev
FROM Sales.SalesOrderDetail AS od
JOIN Sales.SalesOrderHeader AS o
   ON od.SalesOrderID=o.SalesOrderID
      AND o.OrderDate >= CONVERT(datetime,'03/01/2012',101)
      AND o.OrderDate < CONVERT(datetime,'04/01/2012',101)
    GROUP BY OrderDate
    ORDER BY OrderDate ASC;

--ceiling

SELECT CEILING($123.45), CEILING($-123.45), CEILING($0.003);  

SELECT CEILING($123.55), CEILING($-123.45), CEILING($0.003);  


---Floor
SELECT FLOOR(123.45), FLOOR(-123.45), FLOOR($123.45);  


---replicate
--REPLICATE ( string_expression , integer_expression )   

SELECT [Name]  
, [ProductLine] AS 'Line Code'  
FROM AdventureWorks2014.[Production].[Product]  
WHERE [ProductLine] = 'T'  
ORDER BY [Name];  


SELECT [Name]  
, REPLICATE('0', 4) + [ProductLine] AS 'Line Code'  
FROM AdventureWorks2014.[Production].[Product]  
WHERE [ProductLine] = 'T'  
ORDER BY [Name];  
GO  


---Len
---Substring
--replace

---replace
select Name, ProductNumber
FROM AdventureWorks2014.[Production].[Product]  


select Name,  replace(ProductNumber, '-','***') 
FROM AdventureWorks2014.[Production].[Product]  


select CreditCardApprovalCode, REPLACE(CreditCardApprovalCode, CreditCardApprovalCode, '***********' )
FROM AdventureWorks2014.Sales.SalesOrderHeader 


--len
select CreditCardApprovalCode, len(CreditCardApprovalCode)
FROM AdventureWorks2014.Sales.SalesOrderHeader 

---Substring
select CreditCardApprovalCode, SUBSTRING(CreditCardApprovalCode,1, len(CreditCardApprovalCode) - 5)
FROM AdventureWorks2014.Sales.SalesOrderHeader 

select CreditCardApprovalCode, SUBSTRING(CreditCardApprovalCode, 1, len(CreditCardApprovalCode) - 5) + replace( SUBSTRING(CreditCardApprovalCode, 7,  len(CreditCardApprovalCode)), SUBSTRING(CreditCardApprovalCode, 7,  len(CreditCardApprovalCode)) ,'**********')
FROM AdventureWorks2014.Sales.SalesOrderHeader 



---Funciones definidas por el usuario

--Funciones Escalares
--Funciones con valores de tabla en linea
--Funciones con valores de tabla y multiples instruciones


--Funciones Escalares
---Reciben parametro de entrada, procesar y retornar 1 valor con un tipo de datos

use AdventureWorks2014
go

create function EdadPersona(@FechaNacimiento date)
returns int
as
begin
	
	declare @EdadActual int

	Select @EdadActual = DATEDIFF(YEAR, @FechaNacimiento, getdate())

	return (@EdadActual)

end
go

---prueba sin campo de tabla
select AdventureWorks2014.dbo.EdadPersona('1980-05-11') as Edad

select * FROM AdventureWorks2014.HumanResources.Employee

---- funcion en un campo de tabla
SELECT
BusinessEntityID, JobTitle
,AdventureWorks2014.dbo.EdadPersona(BirthDate) as Edad
FROM AdventureWorks2014.HumanResources.Employee


--Funciones con valores de tabla en linea

use AdventureWorks2014
go

create function VacacionesPersonas()
returns @Person table
(	
	BusinessEntityID int,
	NationalIDNumber int, 
	VacationHours int,
	Gender char(1)
)
as
begin
	
	insert into @Person (BusinessEntityID, NationalIDNumber,VacationHours, Gender )
	select 
	BusinessEntityID,
	NationalIDNumber,
	VacationHours,
	Gender
	from AdventureWorks2014.HumanResources.Employee
	where VacationHours > 40

	return

end
go

use AdventureWorks2014
go

create function VacacionesPersonas2(@Genero char(1))
returns @Person table
(	
	BusinessEntityID int,
	NationalIDNumber int, 
	VacationHours int,
	Gender char(1)
)
as
begin
	
	insert into @Person (BusinessEntityID, NationalIDNumber,VacationHours, Gender )
	select 
	BusinessEntityID,
	NationalIDNumber,
	VacationHours,
	Gender
	from AdventureWorks2014.HumanResources.Employee
	where VacationHours > 40 and Gender = @Genero

	return

end
go


select * from AdventureWorks2014.dbo.VacacionesPersonas() where Gender = 'M'

select * from AdventureWorks2014.dbo.VacacionesPersonas2('F') where VacationHours > 80


------Funciones con valores de tabla en linea y multiple instrucciones

select *
FROM AdventureWorks2014.Sales.SalesOrderHeader 



use AdventureWorks2014
go

create function VentaOrdenes()
returns table
as
return
(	
	select *
	FROM AdventureWorks2014.Sales.SalesOrderHeader 
	where TotalDue > 1000
)
go



select * from AdventureWorks2014.dbo.VentaOrdenes()


---
use AdventureWorks2014
go
CREATE FUNCTION dbo.ufn_FindReports_vpr (@InEmpID INTEGER)
RETURNS @retFindReports TABLE
(
    EmployeeID int primary key NOT NULL,
    FirstName nvarchar(255) NOT NULL,
    LastName nvarchar(255) NOT NULL,
    JobTitle nvarchar(50) NOT NULL,
    RecursionLevel int NOT NULL
)
--Returns a result set that lists all the employees who report to the
--specific employee directly or indirectly.*/
AS
BEGIN
WITH EMP_cte(EmployeeID, OrganizationNode, FirstName, LastName, JobTitle, RecursionLevel) -- CTE name and columns
    AS (
        -- Get the initial list of Employees for Manager n
        SELECT e.BusinessEntityID, OrganizationNode = ISNULL(e.OrganizationNode, CAST('/' AS hierarchyid)) 
        , p.FirstName, p.LastName, e.JobTitle, 0
        FROM HumanResources.Employee e
              INNER JOIN Person.Person p
              ON p.BusinessEntityID = e.BusinessEntityID
        WHERE e.BusinessEntityID = @InEmpID
        UNION ALL
        -- Join recursive member to anchor
        SELECT e.BusinessEntityID, e.OrganizationNode, p.FirstName, p.LastName, e.JobTitle, RecursionLevel + 1
        FROM HumanResources.Employee e
          INNER JOIN EMP_cte
          ON e.OrganizationNode.GetAncestor(1) = EMP_cte.OrganizationNode
          INNER JOIN Person.Person p
          ON p.BusinessEntityID = e.BusinessEntityID
        )
-- copy the required columns to the result of the function
    INSERT @retFindReports
    SELECT EmployeeID, FirstName, LastName, JobTitle, RecursionLevel
    FROM EMP_cte
    RETURN
END;
GO

-- Example invocation
SELECT EmployeeID, FirstName, LastName, JobTitle, RecursionLevel
FROM dbo.ufn_FindReports_vpr(100);

GO

