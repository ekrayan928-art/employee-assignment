-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1:3306
-- Generation Time: Sep 15, 2026 at 08:45 PM
-- Server version: 9.1.0
-- PHP Version: 8.3.14

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `employee`
--

-- --------------------------------------------------------

--
-- Table structure for table `departments`
--

DROP TABLE IF EXISTS `departments`;
CREATE TABLE IF NOT EXISTS `departments` (
  `department_id` int NOT NULL,
  `department_name` varchar(100) NOT NULL,
  PRIMARY KEY (`department_id`),
  UNIQUE KEY `department_name` (`department_name`),
  UNIQUE KEY `chk_dept_name` (`department_name`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `departments`
--

INSERT INTO `departments` (`department_id`, `department_name`) VALUES
(1, 'Human Resources'),
(2, 'Information Technology'),
(3, 'Finance'),
(4, 'Sales'),
(5, 'Marketing');

-- --------------------------------------------------------

--
-- Table structure for table `employees`
--

DROP TABLE IF EXISTS `employees`;
CREATE TABLE IF NOT EXISTS `employees` (
  `employee_id` int NOT NULL,
  `employee_name` varchar(50) NOT NULL,
  `gender` enum('M','F') DEFAULT NULL,
  `age` int DEFAULT NULL,
  `hire_date` date DEFAULT (curdate()),
  `designation` varchar(100) DEFAULT NULL,
  `department_id` int DEFAULT NULL,
  `location_id` int DEFAULT NULL,
  `salary` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`employee_id`),
  KEY `department_id` (`department_id`),
  KEY `location_id` (`location_id`)
) ;

--
-- Dumping data for table `employees`
--

INSERT INTO `employees` (`employee_id`, `employee_name`, `gender`, `age`, `hire_date`, `designation`, `department_id`, `location_id`, `salary`) VALUES
(1, 'John Doe', 'M', 28, '2020-05-14', 'Software Engineer', 2, 1, 65000.00),
(2, 'Jane Smith', 'F', 32, '2019-03-22', 'HR Manager', 1, 2, 72000.00),
(3, 'Ravi Kumar', 'M', 26, '2021-07-01', 'Data Analyst', 2, 3, 58000.00),
(4, 'Emily Brown', 'F', 24, '2022-01-10', 'Sales Executive', 4, 4, 45000.00),
(5, 'Michael Lee', 'M', 35, '2018-11-30', 'Finance Manager', 3, 5, 80000.00);

-- --------------------------------------------------------

--
-- Table structure for table `location`
--

DROP TABLE IF EXISTS `location`;
CREATE TABLE IF NOT EXISTS `location` (
  `location_id` int NOT NULL AUTO_INCREMENT,
  `location` varchar(30) NOT NULL,
  PRIMARY KEY (`location_id`),
  UNIQUE KEY `location` (`location`)
) ENGINE=MyISAM AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `location`
--

INSERT INTO `location` (`location_id`, `location`) VALUES
(1, 'New York'),
(2, 'London'),
(3, 'Bangalore'),
(4, 'Toronto'),
(5, 'Singapore');
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;


/* ============================================================
   ASSIGNMENT QUERIES
   ============================================================ */

/* ------------------------------------------------------------
   PART 1: DISTINCT VALUES, ALIAS, WHERE CLAUSE & OPERATORS
   ------------------------------------------------------------ */

-- 1a. Distinct Values
-- Retrieve distinct salaries from the Employees table.
SELECT DISTINCT salary
FROM employees;

-- 1b. Alias (AS)
-- Alias "age" as Employee_Age and "salary" as Employee_Salary.
SELECT age AS Employee_Age,
       salary AS Employee_Salary
FROM employees;

-- 1c. Where Clause & Operators
-- Employees with salary > 50000 AND hired before 2016-01-01.
SELECT *
FROM employees
WHERE salary > 50000
  AND hire_date < '2016-01-01';

-- Find the employee whose designation is missing, then fill it with "Data Scientist".
SELECT *
FROM employees
WHERE designation IS NULL;

UPDATE employees
SET designation = 'Data Scientist'
WHERE designation IS NULL;


/* ------------------------------------------------------------
   PART 2: SORTING AND GROUPING DATA
   ------------------------------------------------------------ */

-- 2a. ORDER BY
-- Employees sorted by department_id ascending, salary descending.
SELECT *
FROM employees
ORDER BY department_id ASC, salary DESC;

-- 2b. LIMIT
-- First 5 employees hired in the year 2018.
SELECT *
FROM employees
WHERE YEAR(hire_date) = 2018
ORDER BY hire_date
LIMIT 5;

-- 2c. Aggregate Functions
-- Sum of all salaries in the Finance department.
SELECT SUM(e.salary) AS Total_Finance_Salary
FROM employees e
JOIN departments d ON e.department_id = d.department_id
WHERE d.department_name = 'Finance';

-- Minimum age among all employees.
SELECT MIN(age) AS Minimum_Age
FROM employees;

-- 2d. GROUP BY
-- Maximum salary for each location.
SELECT l.location,
       MAX(e.salary) AS Max_Salary
FROM employees e
JOIN location l ON e.location_id = l.location_id
GROUP BY l.location;

-- Average salary for each designation containing the word 'Analyst'.
SELECT designation,
       AVG(salary) AS Average_Salary
FROM employees
WHERE designation LIKE '%Analyst%'
GROUP BY designation;

-- 2e. HAVING
-- Departments with fewer than 3 employees.
SELECT d.department_name,
       COUNT(e.employee_id) AS Employee_Count
FROM departments d
LEFT JOIN employees e ON d.department_id = e.department_id
GROUP BY d.department_name
HAVING COUNT(e.employee_id) < 3;

-- Locations with female employees whose average age is below 30.
SELECT l.location,
       AVG(e.age) AS Average_Age
FROM employees e
JOIN location l ON e.location_id = l.location_id
WHERE e.gender = 'F'
GROUP BY l.location
HAVING AVG(e.age) < 30;


/* ------------------------------------------------------------
   PART 3: JOINS
   ------------------------------------------------------------ */

-- 3a. Inner Join
-- Employee names, designations, and department names where an employee
-- is assigned to a department.
SELECT e.employee_name,
       e.designation,
       d.department_name
FROM employees e
INNER JOIN departments d ON e.department_id = d.department_id;

-- 3b. Left Join
-- All departments with total employee count, including departments with
-- no employees.
SELECT d.department_name,
       COUNT(e.employee_id) AS Total_Employees
FROM departments d
LEFT JOIN employees e ON d.department_id = e.department_id
GROUP BY d.department_name;

-- 3c. Right Join
-- All locations with employee names; NULL where no employee is assigned.
SELECT l.location,
       e.employee_name
FROM employees e
RIGHT JOIN location l ON e.location_id = l.location_id;
