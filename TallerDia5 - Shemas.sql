
---Esquemas de base de datos

select * from MovieStore..Empresa

use MovieStore
go
create schema Clientes
go


select * from sys.schemas
go


Create table Clientes.Cliente
(
	IdCliente int identity(1,1) primary key,
	IdentificacionCliente varchar(15),
	RazonSocial varchar(600),
	FechaIngreso datetime default getdate()
)
go

Create table Clientes.AlquilerCliente
(
	IdAlquilerCliente int identity(1,1) primary key,
	IdCliente int,
	IdMovie int,
	FechaIngreso datetime default getdate()
)
go


select * from Clientes.AlquilerCliente
