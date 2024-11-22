-- 1
SELECT * 
FROM branch
WHERE assets > 1000000.00;

-- 2
SELECT * 
FROM branch
WHERE branch_city = "Brooklyn";

-- 3
SELECT c.customer_name, COUNT(account_number) as accounts
FROM customer c
INNER JOIN depositor d ON c.customer_name = d.customer_name
GROUP BY c.customer_name;

-- 4
SELECT customer_name, account_number, balance
FROM customer
NATURAL JOIN depositor
NATURAL JOIN account;

-- 5 ******
SELECT c.customer_name, d.account_number
FROM customer c
JOIN depositor d ON c.customer_name = d.customer_name
JOIN account a ON d.account_number = a.account_number
JOIN account b ON a.account_number = b.account_number
WHERE a.balance < MAX(b.balance)
GROUP BY c.customer_name
ORDER BY a.balance DESC
LIMIT 1;

-- 6
SELECT DISTINCT c.* 
FROM customer c
INNER JOIN depositor d ON c.customer_name = d.customer_name
INNER JOIN borrower b ON d.customer_name = b.customer_name;

-- 7
SELECT c.customer_name
FROM customer c
JOIN depositor d ON c.customer_name = d.customer_name
JOIN account a ON d.account_number = a.account_number
JOIN borrower b ON c.customer_name = b.customer_name
JOIN loan l ON b.loan_number = l.loan_number
GROUP BY customer_name
HAVING SUM(a.balance) >= MIN(l.amount);

-- 8
SELECT l.branch_name, AVG(amount) as avg_loan
FROM loan l
JOIN branch b ON l.branch_name = b.branch_name
WHERE b.branch_name NOT LIKE "%Horse%"
GROUP BY l.branch_name;

-- 9
SELECT c.*
FROM customer c
JOIN borrower b ON c.customer_name = b.customer_name
JOIN loan l ON b.loan_number = l.loan_number
JOIN branch br ON l.branch_name = br.branch_name
WHERE br.branch_city LIKE "Brooklyn";

-- 10
SELECT c.*
FROM customer c
JOIN borrower b ON c.customer_name = b.customer_name
JOIN loan l ON b.loan_number = l.loan_number
JOIN branch br ON l.branch_name = br.branch_name
WHERE c.customer_city = br.branch_city;

