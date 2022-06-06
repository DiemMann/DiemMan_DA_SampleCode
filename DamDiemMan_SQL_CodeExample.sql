--Table
	--Table Customers ([CustomerID], [CompanyName], [ContactName], [Address])
	--Table Suppliers([SupplierID], [CompanyName], [ContactName], [Address])
	--Table Shippers ([ShipperID], [CompanyName], [Phone])
	--Table Orders ([OrderID], [CustomerID], [EmployeeID], [OrderDate],	[ShippedDate], [ShipVia], [ShipAddress])
	--Table Order Details ([OrderID], [ProductID], [UnitPrice], [Quantity], [Discount])
	--Table Employees ([EmployeeID], [LastName], [FirstName], [Title], [BirthDate], [HireDate], [Address])

--Statisticize Sales by Employees
	select E.EmployeeID,
		concat(E.FirstName, ' ',E.LastName) as [Employee Name], 
		convert(decimal(10,2), sum(OD.Quantity*OD.UnitPrice-OD.Discount)) as Sales
	from Employees E
	inner join Orders O on E.EmployeeID = O.EmployeeID
	inner join [Order Details] OD on O.OrderID = OD.OrderID
	group by E.EmployeeID, E.FirstName, E.LastName
	order by E.EmployeeID

--Create view to fetch the shipping company ships the most orders
	create view Top1_Shipper as
	select top 1 S.ShipperID, S.CompanyName, count(O.OrderID) as [Number of Orders]
	from Shippers S
	left join Orders O on S.ShipperID = O.ShipVia
	group by S.ShipperID, S.CompanyName
	order by count(O.OrderID) desc

	select * from Top1_Shipper	

--Table
	--table EmployeeDetails ([EmpId], [FullName], [ManagerId], [DateOfJoining], [City])
	--table EmployeeSalary ([EmpId], [Project], [Salary], [Variable])

--Fetch all the Employees who are also managers from the EmployeeDetails table.
	select D.EmpId, D.FullName from EmployeeDetails D
	where D.EmpId in (select distinct D.ManagerId from EmployeeDetails D)

--Fetch duplicate records from EmployeeDetails.
	select D.FullName, D.ManagerId, D.DateOfJoining, D.City, count(*) as [No of Records] 
	from EmployeeDetails D
	group by D.FullName, D.ManagerId, D.DateOfJoining, D.City
	having count(*) > 1

--Remove duplicates from a table EmployeeDetails.
	delete from EmployeeDetails
	where EmpId NOT IN
	(
	select max(D.EmpId)
	from EmployeeDetails D
	group by D.FullName, D.ManagerId, D.DateOfJoining, D.City)
