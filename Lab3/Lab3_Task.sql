-- 1
SELECT customer_name, customer_city from customer 
where customer_name in (select customer_name from borrower where customer_name 
not in (select customer_name from depositor where account_number 
in (select account_number from account)));

-- 2
select DISTINCT customer_name from borrower where (customer_name) 
in (select customer_name from depositor);

SELECT Distinct customer_name FROM borrower INNER JOIN depositor USING (customer_name);

-- 3 
SELECT * FROM customer WHERE customer_name IN (SELECT customer_name FROM depositor)
UNION
SELECT * FROM customer WHERE customer_name IN (SELECT customer_name FROM borrower);

SELECT DISTINCT customer.* 
FROM customer
LEFT JOIN depositor USING (customer_name)
LEFT JOIN borrower USING (customer_name);


-- 4 
SELECT SUM(assets) as total_assests FROM branch;

-- 5 
SELECT branch_city, COUNT(account_number) AS total_accounts
FROM account JOIN branch USING (branch_name)
GROUP BY branch_city;

-- 6
SELECT branch_name, AVG(balance) AS avg_balance
FROM  account
GROUP BY branch_name
ORDER BY avg_balance DESC;
-- 7
SELECT branch_name, AVG(amount) AS avg_loan
FROM loan
JOIN branch USING (branch_name)
WHERE branch_city NOT LIKE '%Horse%'
GROUP BY branch_name;
-- 8
SELECT customer_name, account_number
FROM depositor
JOIN account USING (account_number)
JOIN customer USING (customer_name)
WHERE balance = (SELECT MAX(balance) FROM account);
-- 9 
SELECT * 
FROM customer 
JOIN depositor USING (customer_name)
JOIN account USING (account_number)
JOIN branch USING (branch_name)
where customer.customer_city = branch.branch_city;
-- 10
SELECT branch_city, AVG(amount) AS avg_loan
FROM loan
JOIN branch USING (branch_name)
GROUP BY branch_city
HAVING AVG(amount) >= 1500;

-- 11
SELECT branch_name
FROM account
GROUP BY branch_name
HAVING SUM(balance) > (SELECT AVG(total_balance) 
FROM (SELECT SUM(balance) AS total_balance 
FROM account GROUP BY branch_name) 
AS branch_totals);
-- 12
SELECT customer_name
FROM customer
JOIN depositor USING (customer_name)
JOIN account USING (account_number)
JOIN borrower USING (customer_name)
JOIN loan USING (loan_number)
GROUP BY customer_name
HAVING SUM(account.balance) >= MAX(loan.amount);

-- 13
SELECT DISTINCT branch.*
FROM branch
JOIN loan USING (branch_name)
JOIN account USING (branch_name)
WHERE EXISTS (
    SELECT 1
    FROM customer
    LEFT JOIN depositor USING (customer_name)
    LEFT JOIN borrower USING (customer_name)
    WHERE customer.customer_city = branch.branch_city
    AND depositor.customer_name IS NULL
    AND borrower.customer_name IS NULL
);
