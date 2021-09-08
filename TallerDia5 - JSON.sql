

----- JSON
---JavaScript Object Notation
/*
JSON es s�lo un formato de datos � contiene s�lo propiedades, no m�todos.
JSON requiere usar comillas dobles para las cadenas y los nombres de propiedades. 
Las comillas simples no son v�lidas.
Una coma o dos puntos mal ubicados pueden producir que un archivo JSON no funcione. 
Se debe ser cuidadoso para validar cualquier dato que se quiera utilizar 
(aunque los JSON generados por computador tienen menos probabilidades de tener errores, 
mientras el programa generador trabaje adecuadamente). 
Es posible validar JSON utilizando una aplicaci�n como JSONLint.
JSON puede tomar la forma de cualquier tipo de datos que sea v�lido para ser incluido 
en un JSON, no s�lo arreglos u objetos. As�, por ejemplo, una cadena o un n�mero �nico 
podr�an ser objetos JSON v�lidos.
A diferencia del c�digo JavaScript en que las propiedades del objeto pueden 
no estar entre comillas, en JSON, s�lo las cadenas entre comillas pueden ser 
utilizadas como propiedades.
*/


/*

'{
    "info":{
      "type":1,
      "address":{  
        "town":"Bristol",
        "county":"Avon",
        "country":"England"
      },
      "tags":["Sport", "Water polo"]
   },
   "type":"Basic"
}'

*/


----Manipular cadenas JSON

declare @json varchar(max)

set @json =
'{
    "info":{
      "type":1,
      "address":{  
        "town":"Bristol",
        "county":"Avon",
        "country":"England"
      },
      "tags":["Sport", "Water polo"]
   },
   "type":"Basic"
}'

-- validar JSON

if ISJSON(@json) = 1
begin
	PRINT 'JSON CORRECTO'
end
else
begin
	PRINT 'JSON INCORRECTO'
end


------- query y values

select JSON_QUERY(@json, '$.info.tags') as tags
select JSON_QUERY(@json, '$.info.address') as adress

select JSON_VALUE(@json, '$.info.address.town') as Town
select JSON_VALUE(@json, '$.type') as TypeBasic


----OPEN jSON

SELECT * FROM
openjson (@json)
with
(
	typeinfo int '$.info.type',
	typedesc varchar(max) '$.type',
	town varchar(max) '$.info.address.town'
)


------------------

DECLARE @json2 VARCHAR(MAX);
SET @json2 = '[  
  {"id": 2, "info": {"name": "John", "surname": "Smith"}, "age": 25},
  {"id": 5, "info": {"name": "Jane", "surname": "Smith", "skills": ["SQL", "C#", "Azure"]}, "dob": "2005-11-04T12:00:00"}  
]';

select * from
openjson(@json2)
with
(
	id int '$.id',
	nombres varchar(50) '$.info.name',
	apellidos varchar(50) '$.info.surname'
)


---Crear Json

select top 15 Personas.BusinessEntityID, FirstName, LastName, Emails.EmailAddress 
from AdventureWorks2014.Person.Person as Personas
join AdventureWorks2014.Person.EmailAddress as Emails
on Emails.BusinessEntityID = Personas.BusinessEntityID
for JSON auto, root ('PersonasInfo')
