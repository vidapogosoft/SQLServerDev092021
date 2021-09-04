
---SPACE
---CONCAT

select FirstName + ' ' + LastName from AdventureWorks2014.Person.Person

select CONCAT(FirstName, SPACE(1) , LastName) as Personas from AdventureWorks2014.Person.Person

select FirstName as Nombres, LastName as Apellidos, Title as Titulo from AdventureWorks2014.Person.Person

select FirstName as Nombres, LastName as Apellidos, 

case when Title is null then 'NA'
else Title end as Titulo 

from AdventureWorks2014.Person.Person


select FirstName as Nombres, LastName as Apellidos, 

case when Title is null then 'NA'
		when  Title = 'Mr.' then 'SR'
		when  Title = 'Ms.' then 'SRA'
	else UPPER(Title) end as Titulo 

from AdventureWorks2014.Person.Person

select * from AdventureWorks2014.Production.Product

select 
ProductID, Name, ProductNumber,
SafetyStockLevel,
ReorderPoint,

case when SafetyStockLevel + ReorderPoint > 1500 then 'OK'
else 'REVISAR' end as RevisionStock

from AdventureWorks2014.Production.Product


select 
ProductID, Name, ProductNumber,
SafetyStockLevel,
ReorderPoint,

YEAR(SellStartDate) as Anio,
MONTH(SellStartDate) Mes,
DAY(SellStartDate) Dia,

case when SafetyStockLevel + ReorderPoint > 1500 then 'OK'
else 'REVISAR' end as RevisionStock

from AdventureWorks2014.Production.Product
where SellEndDate IS NOT NULL 
and YEAR(SellEndDate) > 2010

select * from AdventureWorks2014.Person.Person
where ModifiedDate between '2008-01-01 00:00:00.000' and '2009-01-01 00:00:00.000'

select * from AdventureWorks2014.Person.Person
where LastName like 'A%'
order by LastName

select * from AdventureWorks2014.Person.Person
where LastName like 'A%' or  LastName like 'Z%'
order by LastName

select * from AdventureWorks2014.Person.Person
where FirstName like 'A%' and  LastName like 'A%'
order by LastName


select distinct FirstName, LastName from AdventureWorks2014.Person.Person
where LastName like 'A%'
order by LastName

select FirstName, LastName from AdventureWorks2014.Person.Person
where LastName like 'A%'
group by FirstName, LastName
order by LastName

----Combinaciones
--Cross Join
/*
Dom A	Dom B
A		1
B		2
C		3

A1
A2
A3
B1
B2
B3
C1
C2
C3
*/


select * from AdventureWorks2014.Sales.Customer
where CustomerID in (1,2,3)

select * from AdventureWorks2014.Sales.SalesPerson
where BusinessEntityID in (274,275,276)



select * from AdventureWorks2014.Sales.Customer a
cross join AdventureWorks2014.Sales.SalesPerson b
where a.CustomerID in (1,2,3)
and b.BusinessEntityID in (274,275,276)


select * from AdventureWorks2014.Sales.SalesPerson b 
cross join AdventureWorks2014.Sales.Customer a
where a.CustomerID in (1,2,3)
and b.BusinessEntityID in (274,275,276)
order by b.BusinessEntityID

---inner join

select * from AdventureWorks2014.Sales.SalesOrderHeader
select * from AdventureWorks2014.Sales.Customer

