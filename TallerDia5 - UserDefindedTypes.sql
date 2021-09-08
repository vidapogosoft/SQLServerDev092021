

---Tipos de datos definidos por el usuario

use MovieStore
go

create type AlfanumericoExtensos from varchar(2000)
create type AlfanumericoCortos from varchar(500)


---agrego columna a tabla y coloco campo con dato personalizado

alter table Clientes.AlquilerCliente add Comentario AlfanumericoExtensos