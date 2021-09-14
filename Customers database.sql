--Creating databes with tables and using my queries

create table Customer(
id int primary key identity (1,1),
FirstName varchar (16),
LastName varchar(16),
Age int,
City varchar (16)

);

insert into dbo.Customer(FirstName,LastName,Age,City) values('Jozef','Koren',39,'Bratislava');
insert into dbo.Customer(FirstName,LastName,Age,City) values('Peter','Kvet',29,'Prague');
insert into dbo.Customer(FirstName,LastName,Age,City) values('Andrea','Lazarova',33,'Kosice');
insert into dbo.Customer(FirstName,LastName,Age,City) values('Ignac','Peluh',51,'Brno');
insert into dbo.Customer(FirstName,LastName,Age,City) values('Maros','Biller',25,'Banska Bystrica');
insert into dbo.Customer(FirstName,LastName,Age,City) values('Ondrej','Domecky',67,'Plzen');
insert into dbo.Customer(FirstName,LastName,Age,City) values('Katarina','Hokolska',18,'Meder');

select *
from dbo.Customer

-- Creating Product Table

create table Product(
idProduct int primary key identity(1,1),
ProductName varchar (16)

);
 
 select *
from dbo.Product

--Add new column 

alter table dbo.Product
add Price float;

insert into dbo.Product(ProductName,Price) values ('T-shirt',12.99);
insert into dbo.Product(ProductName,Price) values ('Hoodie',10.99);

-- Creating Orders Table

create table Orders(
idOrder int primary key identity(1,1),
OrderDate Datetime,
CustomerID int,
ProductID int
);

-- Looking on every tables witch I have
select*
from dbo.Orders;
select*
from dbo.Product;
select*
from dbo.Customer;

-- inserting orders data

insert into dbo.Orders(OrderDate,CustomerID,ProductID) values(GETDATE(),2,1);
insert into dbo.Orders(OrderDate,CustomerID,ProductID) values(GETDATE(),2,2);
insert into dbo.Orders(OrderDate,CustomerID,ProductID) values(GETDATE(),1,2);
insert into dbo.Orders(OrderDate,CustomerID,ProductID) values(GETDATE(),1,1);
insert into dbo.Orders(OrderDate,CustomerID,ProductID) values(GETDATE(),3,1);
insert into dbo.Orders(OrderDate,CustomerID,ProductID) values(GETDATE(),10,1);

-- Deleting ivalid row
delete dbo.Orders
where CustomerID=10

-- Creating FK

alter table dbo.orders
add foreign key (CustomerID) references dbo.Customer(Id);

alter table dbo.orders
add foreign key (ProductID) references dbo.Product(IdProduct);

-- Joining all tables to one 
select*
from dbo.Orders;
select*
from dbo.Product;
select*
from dbo.Customer;

-- Lookig for Produc name, price and another things
select dbo.Orders.OrderDate,dbo.Product.ProductName,dbo.Product.Price,dbo.Customer.*
from dbo.Orders

inner join dbo.Product 
on dbo.Orders.ProductID= dbo.Product.idProduct
inner join dbo.Customer
on dbo.Orders.CustomerID=dbo.Customer.id


-- looking for the total price that the customer has spent

select dbo.Customer.LastName,dbo.Product.ProductName,dbo.Customer.City,sum(dbo.Product.Price) as Total
from dbo.Orders

inner join dbo.Product 
on dbo.Orders.ProductID= dbo.Product.idProduct
inner join dbo.Customer
on dbo.Orders.CustomerID=dbo.Customer.id
group by dbo.Customer.LastName,dbo.Product.ProductName,dbo.Customer.City

-- looking for total and average price by city
select  dbo.Customer.City,sum(dbo.Product.Price) as Total, avg(dbo.Product.Price) as Average
from dbo.Orders

inner join dbo.Product 
on dbo.Orders.ProductID= dbo.Product.idProduct
inner join dbo.Customer
on dbo.Orders.CustomerID=dbo.Customer.id
group by dbo.Customer.City