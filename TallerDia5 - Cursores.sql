---CURSORES
---uso de memoria RAM
---DATOS EN BUCLES
---CONTROVERSIA DEL RENDEMIENTO

---Pasos en consideracion para trabajar con cursores

--declarar el cursor, a traves de DECLARE
--abrir
--lee los datos del cursor (bucle -- fetch)
--cerrar el cursor
--liberar el cursor (liberar recursor tomados)

/*
DECLARE[NOMBRE CURSOR]CURSOR[ LOCAL | GLOBAL ] [ FORWARD_ONLY | SCROLL ] FOR [SENTENCIA DE SQL (SELECT)] 
-- Apertura del cursor 
OPEN[NOMBRE CURSOR]  
-- Lectura de la primera fila del cursor 
FETCH[NOMBRE CURSOR]INTO[LISTA DE VARIABLES DECLARADAS] 
WHILE(@@FETCH_STATUS= 0) 
BEGIN 
-- Lectura de la siguiente fila de un cursor 
FETCH[NOMBRE CURSOR]INTO[LISTA DE VARIABLES DECLARADAS] ... 
-- Fin del bucle WHILE 
END 
-- Cierra el cursor 
CLOSE[NOMBRE CURSOR] 
-- Libera los recursos del cursor 
DEALLOCATE[NOMBRE CURSOR]
*/


use AdventureWorks2014
go

select b.NationalIDNumber,a.PersonType, a.FirstName, a.LastName, b.JobTitle from AdventureWorks2014.Person.Person  a
	join AdventureWorks2014.HumanResources.Employee b
	on a.BusinessEntityID = b.BusinessEntityID
	
declare @PersonType varchar(4), @FirstName varchar(max) , @LastName varchar(max) 
, @JobTitle varchar(max), @IdCard varchar(15), @NombreEmpresa varchar(max)


declare cursor_ejemplo cursor fast_forward for

	--- instruccion de toma de datos


	select concat(convert(varchar,b.NationalIDNumber),  replicate('0', 10 - len(convert(varchar,b.NationalIDNumber)))) as IdCard
	,a.PersonType, a.FirstName, a.LastName, b.JobTitle from AdventureWorks2014.Person.Person  a
	join AdventureWorks2014.HumanResources.Employee b
	on a.BusinessEntityID = b.BusinessEntityID

	open cursor_ejemplo
		
		fetch next from cursor_ejemplo into @IdCard, @PersonType , @FirstName , @LastName, @JobTitle

		while (@@FETCH_STATUS = 0)
		begin

				--- procesos a transaccionar con los datos seleccionados

				select @NombreEmpresa = CONCAT(@JobTitle, space(1), @FirstName, space(1), @LastName)

				exec MovieStore..InsEmpresa  @IdCard, @NombreEmpresa 

			fetch next from cursor_ejemplo into @IdCard, @PersonType , @FirstName , @LastName, @JobTitle
		end
	close cursor_ejemplo
deallocate cursor_ejemplo


select * from MovieStore..Empresa



/*******************************************************************/
/********************BUCLE WHILE***************************/
/*******************************************************************/

DECLARE @site_value INT

set @site_value = 0

Print getdate()

while @site_value <= 10
begin
	
	Print 'DENTRO DEL WHILE'
	
	select @site_value = @site_value + 1

	if(@site_value = 9)
	begin
		
		--tiempo de espera
		--waitfor delay '00:00:05'

		--tiempo de reanudar la espera
		waitfor time '20:01:20'

		Print getdate()
	end
end
