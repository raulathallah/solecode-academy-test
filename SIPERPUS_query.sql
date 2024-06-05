

-- CREATE DATABASE
CREATE DATABASE siperpus_db

-- CREATE TABLE CATEGORIES
CREATE TABLE categories (
	id		VARCHAR(50)	PRIMARY KEY,
	name	VARCHAR(50)
)
-- CREATE TABLE USERS
CREATE TABLE users (
	id	VARCHAR(50) PRIMARY KEY,
	name VARCHAR(50),
	address VARCHAR(255),
	phone VARCHAR(12),
	noKtp VARCHAR(16),
	email VARCHAR(50)
)
-- CREATE TABLE BOOKS
CREATE TABLE books (
	id VARCHAR(50) PRIMARY KEY,
	title VARCHAR(255),
	isbn VARCHAR(50),
	author VARCHAR(50),
	publisher VARCHAR(50),
	publication_year VARCHAR(4),
	stock INT,
	category_id VARCHAR(50),
	FOREIGN KEY (category_id) REFERENCES categories(id)
)
-- CREATE TABLE USERBOOKRENT
CREATE TABLE userbookrent (
	id VARCHAR(50) PRIMARY KEY,
	user_id VARCHAR(50),
	book_id VARCHAR(50),
	rent_date DATE,
	return_date DATE,
	return_deadline_date DATE,
	FOREIGN KEY (user_id) REFERENCES users(id),
	FOREIGN KEY (book_id) REFERENCES books(id)
)

-- INSERT CATEGORIES
INSERT INTO categories VALUES
('CTGR001', 'ACTION')
INSERT INTO categories VALUES
('CTGR002', 'SCI-FI')
INSERT INTO categories VALUES
('CTGR003', 'ROMANCE')
INSERT INTO categories VALUES
('CTGR004', 'HORROR')
INSERT INTO categories VALUES
('CTGR005', 'COMEDY')

-- INSERT USERS
INSERT INTO users VALUES
('USER001', 'User 1', 'Address 1', '02131501342', '3674893742893742', 'user1@gmail.com')
INSERT INTO users VALUES
('USER002', 'User 2', 'Address 2', '02186902762', '3674433258433258', 'user2@gmail.com')
INSERT INTO users VALUES
('USER003', 'User 3', 'Address 3', '02183704406', '3674192007192007', 'user3@gmail.com')
INSERT INTO users VALUES
('USER004', 'User 4', 'Address 4', '02163990054', '3674662756662756', 'user4@gmail.com')
INSERT INTO users VALUES
('USER005', 'User 5', 'Address 5', '02153628124', '3674744076744076', 'user5@gmail.com')

-- INSERT BOOKS
INSERT INTO books VALUES
('BOOK001','Buku 1','9786893685142', 'John', 'Gramedia Pustaka Utama', '2022', 9, 'CTGR001')
INSERT INTO books VALUES
('BOOK002','Buku 2','9786100318337', 'Daniel', 'Gagas Media', '2012', 9,  'CTGR001')
INSERT INTO books VALUES
('BOOK003','Buku 3','9784155069174', 'Daniel', 'Gramedia Pustaka Utama', '2016', 9,  'CTGR002')
INSERT INTO books VALUES
('BOOK004','Buku 4','9784007703072', 'Ricky', 'Gagas Media', '2016', 9,  'CTGR001')
INSERT INTO books VALUES
('BOOK005','Buku 5','9787813427620', 'Alex', 'Bentang Pustaka', '2012', 9,  'CTGR002')
INSERT INTO books VALUES
('BOOK006','Buku 6','9781127577477', 'Alex', 'Bentang Pustaka', '2016', 9,  'CTGR005')
INSERT INTO books VALUES
('BOOK007','Buku 7','9787459500701', 'Alex', 'Gramedia Pustaka Utama', '2022', 9,  'CTGR005')
INSERT INTO books VALUES
('BOOK008','Buku 8','9785711789482', 'Ricky', 'Gramedia Pustaka Utama', '2022', 9,  'CTGR004')
INSERT INTO books VALUES
('BOOK009','Buku 9','9783369007262', 'Alex', 'Gramedia Pustaka Utama', '2020', 9,  'CTGR004')
INSERT INTO books VALUES
('BOOK010','Buku 10','9786961610496', 'Daniel', 'Gagas Media', '2020', 10,  'CTGR005')

-- INSERT USERBOOKRENT
INSERT INTO userbookrent VALUES
('USBR001', 'USER001', 'BOOK001', '2024-1-15', '2024-1-26', '2024-1-29')
INSERT INTO userbookrent VALUES
('USBR002', 'USER001', 'BOOK002', '2024-1-15', '2024-1-26', '2024-1-29')
INSERT INTO userbookrent VALUES
('USBR003', 'USER001', 'BOOK003', '2024-1-15', '2024-1-26', '2024-1-29')
INSERT INTO userbookrent VALUES
('USBR004', 'USER002', 'BOOK004', '2024-1-1', '2024-1-12', '2024-1-14')
INSERT INTO userbookrent VALUES
('USBR005', 'USER002', 'BOOK005', '2024-1-1', '2024-1-12', '2024-1-14')
INSERT INTO userbookrent VALUES
('USBR006', 'USER002', 'BOOK006', '2024-1-1', '2024-1-12', '2024-1-14')
INSERT INTO userbookrent VALUES
('USBR007', 'USER003', 'BOOK007', '2024-1-10', '2024-1-24', '2024-1-24')
INSERT INTO userbookrent VALUES
('USBR008', 'USER003', 'BOOK008', '2024-1-10', '2024-1-24', '2024-1-24')
INSERT INTO userbookrent VALUES
('USBR009', 'USER003', 'BOOK009', '2024-1-5', '2024-1-24', '2024-1-24')


-- 1. DAFTAR BUKU YANG TIDAK PERNAH DIPINJAM
SELECT books.title as Buku
FROM books
WHERE NOT EXISTS ( 
	SELECT * 
	FROM userbookrent 
	WHERE userbookrent.book_id = books.id
)

-- 2. DAFTAR USER YANG TERLAMBAT MENAMPILKAN BUKU
SELECT 
	users.name as 'User', 
	'Rp'+ 
	CONVERT(
		VARCHAR(10),
		(DATEDIFF(day, userbookrent.rent_date, userbookrent.return_date)-14)*1000
	) as'Denda' 
FROM 
	userbookrent
INNER JOIN users ON userbookrent.user_id = users.id
WHERE 
	DATEDIFF(day, userbookrent.rent_date, userbookrent.return_date) > 14

-- 3. DAFTAR USER DENGAN BUKU YANG DIPINJAM
SELECT 
	users.name as 'User', 
	STUFF((	
		SELECT ', '+books.title
		FROM books
		INNER JOIN userbookrent ON userbookrent.book_id = books.id
		WHERE users.id = userbookrent.user_id
		ORDER BY books.id DESC 
		FOR XML PATH(''))
	,1,1,'') as 'Buku'
FROM userbookrent
INNER JOIN users ON users.id = userbookrent.user_id
INNER JOIN books ON book_id = userbookrent.book_id
GROUP BY users.name, users.id
