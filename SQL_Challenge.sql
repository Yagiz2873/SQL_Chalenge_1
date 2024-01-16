SELECT * FROM Customers 

SELECT * FROM CustomerDemographics 
SELECT * FROM Products
SELECT * FROM Categories

SELECT  * FROM [Order Details]
SELECT * FROM Orders

SELECT * FROM Employees
SELECT * FROM EmployeeTerritories

SELECT * FROM Orders INNER JOIN [Order Details] ON Orders.OrderID = [Order Details].OrderID
SELECT * FROM Products INNER JOIN Categories ON Products.CategoryID = Categories.CategoryID


--1.soru
SELECT YEAR(RequiredDate) AS Yil, MONTH(RequiredDate) AS Ay,SUM(quantity) AS Toplam FROM Orders INNER JOIN [Order Details] ON Orders.OrderID = [Order Details].OrderID GROUP BY YEAR(RequiredDate), MONTH(RequiredDate) ORDER BY YEAR(RequiredDate), MONTH(RequiredDate) 

--2.soru
SELECT * FROM Orders INNER JOIN [Order Details] ON Orders.OrderID = [Order Details].OrderID
SELECT TOP 5 CustomerID,COUNT(DISTINCT Orders.OrderID) AS Adet FROM Orders INNER JOIN [Order Details] ON Orders.OrderID = [Order Details].OrderID GROUP BY CustomerID ORDER BY Adet DESC

--3.soru  
SELECT  ProductID,UnitPrice,Quantity FROM [Order Details] GROUP BY ProductID,UnitPrice,Quantity  
SELECT  Products.ProductID,Products.ProductName,AVG([Order Details].UnitPrice) AS AVG_PRICE FROM [Order Details] INNER JOIN Products ON [Order Details].ProductId=Products.ProductId GROUP BY Products.ProductID,Products.ProductName


--4.soru 
SELECT Products.CategoryID,COUNT(ProductID) AS Toplam_Adet FROM Products INNER JOIN Categories ON Products.CategoryID = Categories.CategoryID GROUP BY Products.CategoryID 

--5.soru
SELECT EmployeeId,COUNT(OrderID) AS Order_Count FROM Orders GROUP BY EmployeeId

--6.soru
SELECT * FROM Products INNER JOIN [Order Details] ON Products.ProductID = [Order Details].ProductID  
SELECT Products.ProductID,Products.ProductName,COUNT(Products.ProductID) AS Siparis_Adeti FROM Products INNER JOIN [Order Details] ON Products.ProductID = [Order Details].ProductID GROUP BY Products.ProductID,Products.ProductName ORDER BY Siparis_Adeti DESC

--7.soru 
--SELECT * FROM Orders INNER JOIN [Order Details] ON Orders.OrderID = [Order Details].OrderID
SELECT CustomerID,SUM(UnitPrice) AS TOPLAM, SUM(UnitPrice)/COUNT(UnitPrice) AS ORT_DEGER FROM Orders INNER JOIN [Order Details] ON Orders.OrderID = [Order Details].OrderID GROUP BY CustomerID

--8.soru
SELECT Country,COUNT(CustomerID) AS Müsteri_Adet FROM Customers GROUP BY Country   

--9.soru
SELECT P.ProductName , SUM(P.UnitsInStock) Toplam_Adet FROM 
(SELECT * FROM Products WHERE UnitsInStock > 0) P  
GROUP BY P.ProductName


--10.soru
--DISTINCT yapmalıyız bir müşteri birden fazla kez sipariş vermiş olabilir.
SELECT EmployeeID,COUNT(DISTINCT CustomerID) FROM Orders GROUP BY EmployeeID


--11.soru
--SELECT * FROM Products
--SELECT T1.CategoryID,Products.ProductName,Max_Fiyat FROM
--(SELECT CategoryID, MAX(UnitPrice) AS Max_Fiyat FROM Products 
--GROUP BY CategoryID) T1

SELECT T2.CategoryID,T2.ProductName,T2.UnitPrice FROM

(SELECT CategoryID, MAX(UnitPrice) AS Max_Fiyat FROM Products 
GROUP BY CategoryID) T1

 INNER JOIN 

 (SELECT  CategoryID,ProductName,UnitPrice FROM Products 
 GROUP BY CategoryID,ProductName,UnitPrice
 ) T2
 
 
 ON T1.CategoryID = T2.CategoryID
 WHERE T1.Max_Fiyat = T2.UnitPrice 


--12.soru 
SELECT * FROM Orders
SELECT T1.CustomerID, MAX(T1.OrderDate) Max_Date, MIN(T1.OrderDate) Min_Date FROM 
(SELECT CustomerID,OrderDate FROM Orders GROUP BY CustomerID,OrderDate) T1 
GROUP BY T1.CustomerID

--13.soru 
SELECT YEAR(ShippedDate) AS YIL, SUM(UnitPrice) AS TOPLAM, SUM(UnitPrice)/COUNT(UnitPrice) AS ORT_DEGER  FROM Orders INNER JOIN [Order Details] ON Orders.OrderID = [Order Details].OrderID GROUP BY YEAR(ShippedDate) ORDER BY YEAR(ShippedDate)


--14.soru
--SELECT  * FROM [Order Details]
--SELECT * FROM Orders 
--SELECT * FROM Products
--SELECT T1.ProductID, MAX(T1.OrderDate) AS Max_Date FROM
--(
    --(SELECT Orders.OrderID,[Order Details].ProductID,Orders.OrderDate FROM [Order Details] LEFT JOIN Orders ON [Order Details].OrderID = Orders.OrderID ) T1 
    --LEFT JOIN Products ON T1.ProductID = Products.ProductID)
--GROUP BY T1.ProductID 
--ORDER BY T1.ProductID 

SELECT T2.ProductID, T2.ProductName ,MAX(T2.OrderDate) AS Max_Date FROM
(
    SELECT T1.ProductID,Products.ProductName,T1.OrderDate FROM
    (SELECT Orders.OrderID,[Order Details].ProductID,Orders.OrderDate FROM [Order Details] INNER JOIN Orders ON [Order Details].OrderID = Orders.OrderID ) T1  
    INNER JOIN Products ON T1.ProductID = Products.ProductID

) T2 INNER JOIN Products ON  T2.ProductID = Products.ProductID 
GROUP BY T2.ProductID,T2.ProductName 
ORDER BY T2.ProductID  

--15.soru
SELECT * FROM Products 
SELECT * FROM Customers 
SELECT  * FROM [Order Details]
SELECT * FROM Orders 


-- PARTITION BY ILE sıra numaraları quantity e göre çoktan aza doğru verilirken aynı zamanda bu işlemi her bir farklı customerId için yeniden yapacak (customerId'ye göre bölümlendir.) 

SELECT * FROM
(SELECT CustomerID, ProductName, MAX(Quantity) Miktar ,ROW_NUMBER() OVER(PARTITION BY CustomerID ORDER BY MAX(Quantity) DESC) RN FROM 
(SELECT o.CustomerID, p.ProductName, od.Quantity FROM Orders o 
INNER JOIN [Order Details] od ON od.OrderID = o.OrderID 
INNER JOIN Products p ON  od.ProductID = p.ProductID) T1
GROUP BY CustomerID,ProductName) T2
WHERE RN = 1 

