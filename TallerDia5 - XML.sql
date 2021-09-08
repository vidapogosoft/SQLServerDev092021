


/*

<Orders>
    <Order OrderID="13000" CustomerID="ALFKI" OrderDate="2006-09-20Z" EmployeeID="2">
        <OrderDetails ProductID="76" Price="123" Qty = "10"/>
        <OrderDetails ProductID="16" Price="3.23" Qty = "20"/>
    </Order>
    <Order OrderID="13001" CustomerID="VINET" OrderDate="2006-09-20Z" EmployeeID="1">
        <OrderDetails ProductID="12" Price="12.23" Qty = "1"/>
		<OrderDetails ProductID="16" Price="10" Qty = "2"/>
    </Order>
</Orders>

*/

-----Manipulando informacion en XML

declare @x XML

select @x = '<Orders>
    <Order OrderID="13000" CustomerID="ALFKI" OrderDate="2006-09-20Z" EmployeeID="2">
        <OrderDetails ProductID="76" Price="123" Qty = "10"/>
        <OrderDetails ProductID="16" Price="3.23" Qty = "20"/>
    </Order>
    <Order OrderID="13001" CustomerID="VINET" OrderDate="2006-09-20Z" EmployeeID="1">
        <OrderDetails ProductID="12" Price="12.23" Qty = "1"/>
		<OrderDetails ProductID="16" Price="10" Qty = "2"/>
    </Order>
</Orders>'


--select @x 

-----Cabeceras

select

OrderId =  T.Item.value('@OrderID', 'int'),
CustomerID = T.Item.value('@CustomerID', 'varchar(20)')
from @x.nodes('Orders/Order') as T (Item)


---Detalles
select

OrderId =  T.Item.value('../@OrderID', 'int'),
CustomerID = T.Item.value('../@CustomerID', 'varchar(20)'),
ProductID = T.Item.value('@ProductID', 'varchar(50)')
from @x.nodes('Orders/Order/OrderDetails') as T (Item)


----Convertir en XML

select top 10 * from AdventureWorks2014.Person.Person

select top 10 BusinessEntityID, FirstName, LastName from AdventureWorks2014.Person.Person for XML auto

select top 10 BusinessEntityID, FirstName, LastName from AdventureWorks2014.Person.Person as Datos
for XML auto, root('Personas'), Elements

with xmlnamespaces (default 'http://www.w3.org/2005/Atom')
select top 10 BusinessEntityID, FirstName, LastName from AdventureWorks2014.Person.Person as Datos
for XML auto, root('Personas'), Elements


