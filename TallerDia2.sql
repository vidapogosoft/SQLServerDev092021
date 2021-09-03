
----Creaciones de tablas
---Peliculas Online -- usuarios alquilan x cierto periodo de tiempo

/*Tablas a diseñar*/
---Empresa
---Clientes
---Peliculas
---Alquiler
/*
use MovieStore
go

Create Table Empresa
(
	IdEmpresa int not null identity(1,1),	
	NumeroIdentificacion varchar(15),
	Nombre varchar(100),
	FechaRegistro datetime default getdate(),
	Fecha date not null,
	Hora time not null,

	constraint PK_IdEmpresa primary key clustered (IdEmpresa)
)
go
*/



-----DDl

use MovieStore
go

Create Table Movies
(
	IdMovie int identity(1,1),
	NombreMovie varchar(200),
	AnioMovie int,
	Estado char(1),
	FechaRegistro datetime default getdate(),

	constraint PK_IdMovie primary key clustered (IdMovie desc)
)on MovieStore_data_3
go

---Empresa - Movie
--Bridges

Create Table EmpresaMovie
(
	IdEmpresaMovie int identity(1,1),
	IdEmpresa int,
	IdMovie int,
	Estado char(1) not null,
	FechaRegistro datetime default(getdate()),

	constraint PK_IdEmpresaMovie primary key clustered (IdEmpresaMovie desc)
)

---FK

alter table EmpresaMovie
with check add constraint FK_IdEmpresa foreign key (IdEmpresa)
references Empresa (IdEmpresa)
go

alter table EmpresaMovie
with check add constraint FK_IdMovie foreign key (IdMovie)
references Movies (IdMovie)
go


------DML

--Select
--Insert
--Update
--Delete

/*
select --- Especifico las columnas
from --- especifcar el origen o tabla
where -- condicionar
select * --- recupera todas las columnas
*/
 
 select getdate()  -- 2021-09-02 19:44:06.127

 /*
insert into Empresa (NumeroIdentificacion, Nombre, FechaRegistro,Fecha,Hora)
values ('0919172551004', 'VPR SOFT 25', getdate(), getdate(), getdate())
insert into Empresa (NumeroIdentificacion, Nombre, FechaRegistro, Fecha,Hora)
values ('0919172551005', 'VPR SOFT 26', getdate(),getdate(), getdate())
insert into Empresa (NumeroIdentificacion, Nombre, FechaRegistro, Fecha,Hora)
values ('0919172551', 'VPR', getdate(),getdate(), getdate())
*/

select * from Empresa

select * from Movies

-----Movies inserts
/*
insert into Movies(NombreMovie, AnioMovie, Estado)
values ('Mi Pobre Angelito 1', 1980, 'A')

insert into Movies(NombreMovie, AnioMovie, Estado)
values ('Mi Pobre Angelito 2', 1985, 'A')

insert into Movies(NombreMovie, AnioMovie, Estado)
values ('Avengers 1', 2011 ,'A')

insert into Movies(NombreMovie, AnioMovie, Estado)
values ('Avengers 2 la era de ultron', 2018, 'A')
*/

select * from EmpresaMovie

-----EmpresaMovies

insert into EmpresaMovie (IdEmpresa, IdMovie, Estado)
values (1,3,'A')

insert into EmpresaMovie (IdEmpresa, IdMovie, Estado)
values (1,2,'A')

insert into EmpresaMovie (IdEmpresa, IdMovie, Estado)
values (2,4,'A')
insert into EmpresaMovie (IdEmpresa, IdMovie, Estado)
values (2,1,'A')

insert into EmpresaMovie (IdEmpresa, IdMovie, Estado)
values (3,1,'A')

/*
TablasTemporales
Introducción
Por qué utilizar tablas temporales
Características
Tabla #locales
Tabla ##globales
Crear una tabla como resultado de una Consulta
Select Into
*/

/**********************************************/
/********VARIABLES DE TIPO TABLA**************/
/**********************************************/

declare @Tabla1 table
(
	Secuencial int identity(1,1),
	IdMovie int,
	NombreMovie varchar(200),
	AnioMovie int,
	Estado char(1),
	FechaRegistro datetime default getdate()
)

insert into @Tabla1(IdMovie, NombreMovie, AnioMovie, Estado)
select IdMovie, NombreMovie, AnioMovie, Estado from Movies

update @Tabla1 set NombreMovie = NombreMovie + '-' + 'TMP'

select * from @Tabla1 

select * from Movies


/**********************************************/
/******TABLAS TEMPORALES DE SESSION - GLOBALES*****/
/**********************************************/

---#temporal local fisica en tempdb
---##temporal global fisica

---#temporal local fisica en tempdb
---Puede realizar creaciones de de index


---session
select IdMovie, NombreMovie, AnioMovie, Estado 
into #TablaTemp1
from Movies

select * from #TablaTemp1

--drop table #TablaTemp1

create table #TablaTemp2
(
	Secuencial int identity(1,1),
	IdMovie int,
	NombreMovie varchar(200),
	AnioMovie int,
	Estado char(1),
	FechaRegistro datetime default getdate()
)

insert into #TablaTemp2(IdMovie, NombreMovie, AnioMovie, Estado)
select IdMovie, NombreMovie, AnioMovie, Estado from Movies

select * from #TablaTemp2

--Gloables

select IdMovie, NombreMovie, AnioMovie, Estado 
into ##TablaGlob1
from Movies


select * from ##TablaGlob1