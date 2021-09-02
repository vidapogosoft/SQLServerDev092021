use master
go

---creacion de la base de datos
create database MovieStore

go

----creacion de base de datos en modo personalizado

create database MovieStore2
on
(
	name = MovieStore2_data,
	filename = 'D:\SQLData\MovieStore2data.mdf',
	size = 500,
	MAXSIZE = 2048, ---UNLIMITED 
	filegrowth = 300
)
log on
(
	name = MovieStore2_log,
	filename = 'D:\SQLData\MovieStore2log.ldf',
	size = 500,
	filegrowth = 300
)
go

use MovieStore2
go
select * from sys.database_files

----- archivos secundarios de la base datos
alter database MovieStore add filegroup MovieStore_data_3
go

alter database MovieStore
add file
(
	name = MovieStoredata3,
	filename = 'D:\SQLData\MovieStoredata3.ndf',
	size = 500,
	MAXSIZE = 2048, ---UNLIMITED 
	filegrowth = 300
)to filegroup MovieStore_data_3
go


----Creaciones de tablas
---Peliculas Online -- usuarios alquilan x cierto periodo de tiempo

/*Tablas a diseñar*/
---Empresa
---Clientes
---Peliculas
---Alquiler

-----DDl


use MovieStore2
go

Create Table Empresa
(
	IdEmpresa int primary key identity(1,1),	
	NumeroIdentificacion varchar(15),
	Nombre varchar(100),
	FechaRegistro datetime default getdate(),
	Fecha date not null,
	Hora time not null
)
go


-----Tabla Empresa
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

---- restricciones en tabla

---UNIQUE
alter table Empresa add constraint UN_IdentificacionEmpresa UNIQUE
(
	NumeroIdentificacion
)
go

---CHECK
alter table Empresa add constraint C_IdentificacionEmpresa Check
(
   len(NumeroIdentificacion)>=10
)
go
