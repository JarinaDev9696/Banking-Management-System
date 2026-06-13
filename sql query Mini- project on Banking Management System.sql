create Database Banking_Management;

use Banking_Management;

--- customers table 
create Table customers_Tables(
customer_ID INT PRIMARY KEY,
Customer_Name varchar(50),
phone_No varchar(15),
city varchar(50),
AccountType varchar(30),
AccountNO INT
);

INSERT INTO customers_Tables VALUES
(1,'Rahul Sharma','9876543210','Pune','Savings',1001),
(2,'Sneha Patil','9988776655','Mumbai','Current',1002),
(3,'Aman Verma','9123456780','Nagpur','Savings',1003),
(4,'Priya Singh','9012345678','Delhi','Current',1004),
(5,'Karan Mehta','9871203456','Hyderabad','Savings',1005),
(6,'Neha Joshi','9988001122','Pune','Current',1006),
(7,'Rohit Kumar','9765432109','Bangalore','Savings',1007),
(8,'Pooja Sharma','9876540001','Chennai','Savings',1008),
(9,'Vivek Shah','9001122334','Ahmedabad','Current',1009),
(10,'Anjali Verma','9988771100','Jaipur','Savings',1010);

Select * from customers_tables;


---Accounts Table
CREATE TABLE Accounts_tables(
Account_ID INT PRIMARY KEY,
Customer_ID INT,
Balance DECIMAL(10,2),
OpenDate DATE,
FOREIGN KEY(Customer_ID) REFERENCES Customers_tables(Customer_ID)
);
INSERT INTO Accounts_tables VALUES
(1001,1,55000,'2025-01-10'),
(1002,2,120000,'2024-11-20'),
(1003,3,35000,'2025-03-15'),
(1004,4,98000,'2025-02-01'),
(1005,5,75000,'2025-01-25'),
(1006,6,150000,'2024-12-18'),
(1007,7,42000,'2025-04-10'),
(1008,8,88000,'2025-05-05'),
(1009,9,200000,'2024-09-30'),
(1010,10,67000,'2025-03-22');

Select * from Accounts_tables;

--Transactions tables

CREATE TABLE Transactions_tables(
Transaction_ID INT PRIMARY KEY,
Account_ID INT,
TransactionType VARCHAR(20),
Amount DECIMAL(10,2),
TransactionDate DATE,
FOREIGN KEY(Account_ID) REFERENCES Accounts_tables(Account_ID)
);
INSERT INTO Transactions_tables VALUES
(1,1001,'Deposit',10000,'2026-06-01'),
(2,1001,'Withdraw',5000,'2026-06-02'),
(3,1002,'Deposit',25000,'2026-06-02'),
(4,1003,'Withdraw',3000,'2026-06-03'),
(5,1004,'Deposit',15000,'2026-06-04'),
(6,1005,'Deposit',12000,'2026-06-05'),
(7,1006,'Withdraw',7000,'2026-06-05'),
(8,1007,'Deposit',9000,'2026-06-06'),
(9,1008,'Withdraw',4500,'2026-06-06'),
(10,1009,'Deposit',30000,'2026-06-07'),
(11,1010,'Withdraw',2000,'2026-06-07'),
(12,1002,'Withdraw',10000,'2026-06-08'),
(13,1003,'Deposit',5000,'2026-06-08'),
(14,1005,'Withdraw',3500,'2026-06-09'),
(15,1007,'Deposit',15000,'2026-06-09');

Select * from Transactions_tables;


---Loans tables

CREATE TABLE Loans_tables(
Loan_ID INT PRIMARY KEY,
Customer_ID INT,
LoanAmount DECIMAL(10,2),
LoanType VARCHAR(30),
FOREIGN KEY(Customer_ID) REFERENCES Customers_tables(Customer_ID)
);
INSERT INTO Loans_tables VALUES
(1,1,500000,'Home Loan'),
(2,2,200000,'Car Loan'),
(3,4,100000,'Education Loan'),
(4,5,300000,'Business Loan'),
(5,6,150000,'Personal Loan'),
(6,8,250000,'Home Loan'),
(7,9,400000,'Business Loan'),
(8,10,180000,'Car Loan');

Select * from loans_tables;


--- Display customer Names, account numbers and account balance using inner join. 
select c.Customer_Name, c.AccountNO, a.Balance
from Customers_tables c 
Inner join Accounts_tables a on c.Customer_ID = a.Customer_ID;


---Find the top 3 customers with the highest account balances.
SELECT TOP 3  c.Customer_Name,a.Balance
FROM Customers_tables c 
INNER JOIN Accounts_tables a ON c.Customer_ID = a.Customer_ID
ORDER BY a.Balance DESC;


---Show all customers who have taken loans along with loan amount and loan type. 
SELECT  c.Customer_Name, l.LoanAmount, l.LoanType
FROM Customers_Tables c
INNER JOIN Loans_Tables l 
ON c.customer_ID = l.Customer_ID;


---Find the total deposited amount and total withdrawn amount Separately.
Select TransactionType, SUM(Amount) as Total_Amount
from Transactions_tables 
Group by TransactionType;


--- Display customer-wise total transaction amount using group by.
SELECT c.Customer_Name, SUM(t.Amount) AS TotalTransactionAmount

FROM customers_Tables c 
INNER JOIN Accounts_tables a ON c.Customer_ID = a.Customer_ID 
INNER JOIN Transactions_tables t ON a.Account_ID = t.Account_ID
GROUP BY c.Customer_ID, c.Customer_Name;


---Find customers whose balance are greater than the average bank balance. 
 SELECT c.Customer_Name, a.Balance 
 FROM customers_Tables c INNER JOIN Accounts_tables a  
 ON c.Customer_ID = a.Customer_ID 
 Where a.Balance > (Select AVG(Balance) FROM Accounts_tables);


 ---Show the highest transaction amount performed by each customer. 
SELECT c.Customer_Name, MAX(t.Amount) AS MaxTransactionAmount
FROM customers_Tables c INNER JOIN Accounts_tables a
    ON c.Customer_ID = a.Customer_ID
INNER JOIN Transactions_tables t
    ON a.Account_ID = t.Account_ID
GROUP BY c.customer_ID, c.Customer_Name
ORDER BY MaxTransactionAmount DESC;


---Display all customers who have not taken any loans using left join.
SELECT c.Customer_Name 
From customers_Tables c 
LEFT JOIN Loans_tables l ON c.customer_ID = l.Customer_ID
WHERE l.Customer_ID is NULL;


---Find the total number of transactions performed by each customer. 
SELECT c.Customer_Name, 
    COUNT(t.Transaction_ID) AS TotalTransactions
FROM customers_Tables c 
INNER JOIN Accounts_tables a 
    ON c.Customer_ID = a.Customer_ID 
INNER JOIN Transactions_tables t 
    ON a.Account_ID = t.Account_ID
GROUP BY c.Customer_Name;


---Rank customers based on their account balances using rank() window function. 
SELECT c.Customer_Name, a.Balance,
RANK() OVER(ORDER BY a.Balance DESC) AS RankNo
FROM customers_Tables c
INNER JOIN Accounts_tables a
ON c.customer_ID = a.Customer_ID;


---Display dense ranking of customers according to balance using dense_rank().
SELECT c.Customer_Name, a.Balance,
DENSE_RANK() OVER(ORDER BY a.Balance DESC) AS Dense_Rank_No
FROM customers_Tables c
INNER JOIN Accounts_tables a
ON c.customer_ID = a.Customer_ID;


---Show previous transaction amount using lag() function. 
SELECT TRANSACTION_ID,
Amount,
LAG(Amount) OVER(ORDER BY Transaction_ID) AS PreviousAmount
FROM Transactions_tables;


---Show next transaction amount using LEAD() function. 
SELECT Transaction_ID,
Amount,
LEAD(Amount) OVER(ORDER BY Transaction_ID) AS Next_Amount
FROM Transactions_tables;


---Calculate running total of transaction amounts using SUM() OVER().
SELECT Transaction_ID, Amount,
SUM(Amount) OVER(ORDER BY Transaction_ID) AS RunningTotal
FROM Transactions_tables;


---Find the second highest account balance using sub query or window function.  
SELECT MAX(Balance) AS Second_Highest_Balance
FROM Accounts_tables
WHERE Balance < (SELECT MAX(Balance)FROM Accounts_tables);


---Find customers who performed more than two transactions. 
SELECT c.Customer_Name, COUNT(*) AS TotalTransactions
FROM customers_Tables c INNER JOIN Accounts_tables a
ON c.customer_ID = a.Customer_ID
INNER JOIN Transactions_tables t
ON a.Account_ID = t.Account_ID
GROUP BY c.Customer_Name
HAVING COUNT(*) > 2;


---Display customer-wise minimum and maximum transactions amounts. 
SELECT c.Customer_Name,
MIN(t.Amount) AS MinimumTransaction,
MAX(t.Amount) AS MaximumTransaction
FROM Customers_Tables c INNER JOIN Accounts_tables a ON c.customer_ID = a.Customer_ID
INNER JOIN Transactions_tables t ON a.Account_ID = t.Account_ID
GROUP BY c.Customer_Name;
