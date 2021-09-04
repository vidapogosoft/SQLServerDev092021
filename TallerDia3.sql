
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

select * from AdventureWorks2014.Sales.SalesOrderHeader a
inner join AdventureWorks2014.Sales.Customer b on b.CustomerID = a.CustomerID
where a.CustomerID = 11657


select a.CustomerID, COUNT(*) Contador from AdventureWorks2014.Sales.SalesOrderHeader a
inner join AdventureWorks2014.Sales.Customer b on b.CustomerID = a.CustomerID
where a.CustomerID = 11657
group by a.CustomerID



select a.CustomerID, sum(SubTotal) as Montos from AdventureWorks2014.Sales.SalesOrderHeader a
inner join AdventureWorks2014.Sales.Customer b on b.CustomerID = a.CustomerID
where a.CustomerID = 11657
group by a.CustomerID


select a.CustomerID, COUNT(*) Contador from AdventureWorks2014.Sales.SalesOrderHeader a
inner join AdventureWorks2014.Sales.Customer b on b.CustomerID = a.CustomerID
group by a.CustomerID


select a.CustomerID, YEAR(OrderDate) AnioCompra  ,COUNT(*) Contador from AdventureWorks2014.Sales.SalesOrderHeader a
inner join AdventureWorks2014.Sales.Customer b on b.CustomerID = a.CustomerID
group by a.CustomerID,YEAR(OrderDate)


select a.CustomerID, YEAR(OrderDate) AnioCompra , COUNT(*) Contador from AdventureWorks2014.Sales.SalesOrderHeader a
inner join AdventureWorks2014.Sales.Customer b on b.CustomerID = a.CustomerID
group by a.CustomerID,YEAR(OrderDate)
Having COUNT(*) > 5


select a.CustomerID, YEAR(OrderDate) AnioCompra , sum(SubTotal) as Montos from AdventureWorks2014.Sales.SalesOrderHeader a
inner join AdventureWorks2014.Sales.Customer b on b.CustomerID = a.CustomerID
group by a.CustomerID,YEAR(OrderDate)
Having COUNT(*) > 5
order by sum(SubTotal) desc



select a.CustomerID, YEAR(OrderDate) AnioCompra , AVG(SubTotal) as Montos from AdventureWorks2014.Sales.SalesOrderHeader a
inner join AdventureWorks2014.Sales.Customer b on b.CustomerID = a.CustomerID
group by a.CustomerID,YEAR(OrderDate)
Having COUNT(*) > 5
order by AVG(SubTotal) desc


---- update con combinaciones

select * from AdventureWorks2014.Sales.SalesOrderHeader a
inner join AdventureWorks2014.Sales.Customer b on b.CustomerID = a.CustomerID
where a.CustomerID = 11657


update a
set a.Comment = 'TALLER DE SQL SERVER'
from AdventureWorks2014.Sales.SalesOrderHeader a
inner join AdventureWorks2014.Sales.Customer b on b.CustomerID = a.CustomerID
where a.CustomerID = 11657


begin tran v

DELETE a
from AdventureWorks2014.Sales.SalesOrderHeader a
inner join AdventureWorks2014.Sales.Customer b on b.CustomerID = a.CustomerID
where a.CustomerID = 11657

select * from AdventureWorks2014.Sales.SalesOrderHeader a
inner join AdventureWorks2014.Sales.Customer b on b.CustomerID = a.CustomerID
where a.CustomerID = 11657

rollback tran v


---Procedures en SQL Server

select * from MovieStore..Empresa

use MovieStore
go
alter procedure InsEmpresa
@NumeroIdentificacion varchar(max),
@Nombre varchar(100)
as
begin

	DECLARE @ErrorMensaje varchar(max),  @ErrorEstado int,  @ErrorSeveridad int
	
	begin try
		
		begin transaction emp

		if not exists (select 1 from MovieStore..Empresa where NumeroIdentificacion = @NumeroIdentificacion  )
		begin
		
			insert into Empresa (NumeroIdentificacion, Nombre, FechaRegistro,Fecha,Hora)
			values (@NumeroIdentificacion, @Nombre, getdate(), getdate(), getdate())
			
		end
		else
		begin
			Print 'Regla de Negocio infringida: Registro ya existe'
		end

		if (XACT_STATE()) = 1
		begin
			commit transaction emp
		end

	end try
	begin catch

		select @ErrorMensaje = ERROR_MESSAGE()
		Select @ErrorEstado = ERROR_STATE()
		Select @ErrorSeveridad = ERROR_SEVERITY()

		if (XACT_STATE()) = -1
		begin
			rollback transaction emp
		end

		RAISERROR (@ErrorMensaje, @ErrorSeveridad, @ErrorEstado)

	end catch
	
end
go


exec InsEmpresa '0919172551002', 'Victor Portugal - trg'

select * from Empresa

delete from Empresa where IdEmpresa = 5


--Bienvenido: 8-Victor Portugal - trg

--registro borrado de la base de datos: 5-Victor Portugal

----Triggers

use MovieStore
go

Create Trigger RegistroEmpresa
on Empresa
for insert
as
begin
		
		declare @IdEmpresa int, @Nombre varchar(100)

		select @IdEmpresa = IdEmpresa, @Nombre = Nombre from inserted

		Print  concat( 'Bienvenido:', space(1), @IdEmpresa, '-',  @Nombre)
end
go


Create Trigger DeleteEmpresa
on Empresa
for Delete
as
begin
		
		declare @IdEmpresa int, @Nombre varchar(100)

		select @IdEmpresa = IdEmpresa, @Nombre = Nombre from deleted

		Print  concat( 'registro borrado de la base de datos:', space(1), @IdEmpresa, '-',  @Nombre)
end
go

