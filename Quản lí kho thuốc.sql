-- 1. Tạo Database
CREATE DATABASE HospitalPharmacy;
GO

-- Chuyển sang sử dụng Database vừa tạo
USE HospitalPharmacy;
GO

-- 2. Tạo Bảng Thuốc
CREATE TABLE Medicine (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(255) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    expiry_date DATE NOT NULL
);
GO


-- Tạo bảng Nhà Cung Cấp
CREATE TABLE Supplier (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(255) NOT NULL,
    phone NVARCHAR(20)
);
GO


-- Tạo bảng Nhập Kho
CREATE TABLE StockIn (
    id INT IDENTITY(1,1) PRIMARY KEY,
    medicine_id INT NOT NULL,
    supplier_id INT NOT NULL,
    quantity INT NOT NULL,
    date_in DATE NOT NULL,
    FOREIGN KEY (medicine_id) REFERENCES Medicine(id),
    FOREIGN KEY (supplier_id) REFERENCES Supplier(id),

);
ALTER TABLE StockIn 
ADD CONSTRAINT chk_quantity CHECK (quantity > 0);

GO

-- Tạo bảng Xuất Kho
CREATE TABLE StockOut (
    id INT IDENTITY(1,1) PRIMARY KEY,
    medicine_id INT NOT NULL,
    quantity INT NOT NULL,
    date_out DATE NOT NULL,
    FOREIGN KEY (medicine_id) REFERENCES Medicine(id)
);
ALTER TABLE StockOut 
ADD CONSTRAINT check_quantity CHECK (quantity > 0);

GO

-- Tạo bảng Tồn Kho
CREATE TABLE Inventory (
    medicine_id INT PRIMARY KEY,
    total_quantity INT NOT NULL DEFAULT 0,
    FOREIGN KEY (medicine_id) REFERENCES Medicine(id)
);
GO

-- 9. Chèn 15 dữ liệu vào bảng Medicine
INSERT INTO Medicine (name, price, expiry_date) VALUES
(N'Paracetamol', 5000, '2026-12-31'),
(N'Amoxicillin', 12000, '2025-10-15'),
(N'Ibuprofen', 15000, '2026-05-22'),
(N'Vitamin C', 8000, '2027-03-18'),
(N'Cefixime', 25000, '2026-07-11'),
(N'Loratadine', 18000, '2025-09-30'),
(N'Metronidazole', 14000, '2026-11-25'),
(N'Omeprazole', 16000, '2025-12-14'),
(N'Aspirin', 10000, '2027-01-05'),
(N'Diazepam', 22000, '2025-08-20'),
(N'Ranitidine', 19000, '2026-02-10'),
(N'Ciprofloxacin', 23000, '2025-06-08'),
(N'Erythromycin', 21000, '2027-04-27'),
(N'Dexamethasone', 17000, '2026-09-19'),
(N'Fexofenadine', 20000, '2025-11-03');
GO

-- 10. Chèn 15 dữ liệu vào bảng Supplier
INSERT INTO Supplier (name, phone) VALUES
(N'Công ty Dược A', '0123456789'),
(N'Công ty Dược B', '0987654321'),
(N'Công ty Dược C', '0345678912'),
(N'Công ty Dược D', '0765432198'),
(N'Công ty Dược E', '0112233445'),
(N'Công ty Dược F', '0654321897'),
(N'Công ty Dược G', '0909876543'),
(N'Công ty Dược H', '0998877665'),
(N'Công ty Dược I', '0888899990'),
(N'Công ty Dược J', '0777766554'),
(N'Công ty Dược K', '0666677889'),
(N'Công ty Dược L', '0555566778'),
(N'Công ty Dược M', '0444455667'),
(N'Công ty Dược N', '0333344556'),
(N'Công ty Dược O', '0222233445');
GO
SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Supplier';


-- 11. Chèn 15 dữ liệu vào bảng StockIn
INSERT INTO StockIn (medicine_id, supplier_id, quantity, date_in) VALUES
(16, 1, 100, '2025-01-01'),
(2, 2, 200, '2025-02-05'),
(3, 3, 150, '2025-03-10'),
(4, 4, 120, '2025-04-15'),
(5, 5, 130, '2025-05-20'),
(6, 6, 140, '2025-06-25'),
(7, 7, 110, '2025-07-30'),
(8, 8, 180, '2025-08-10'),
(9, 9, 160, '2025-09-12'),
(10, 10, 200, '2025-10-18'),
(11, 11, 170, '2025-11-22'),
(12, 12, 150, '2025-12-28'),
(13, 13, 190, '2026-01-15'),
(14, 14, 130, '2026-02-17'),
(15, 15, 180, '2026-03-21');
GO




-- 12. Chèn 15 dữ liệu vào bảng StockOut
INSERT INTO StockOut (medicine_id, quantity, date_out) VALUES
(16, 50, '2025-02-01'),
(2, 60, '2025-03-06'),
(3, 70, '2025-04-11'),
(4, 30, '2025-05-16'),
(5, 40, '2025-06-21'),
(6, 50, '2025-07-26'),
(7, 60, '2025-08-31'),
(8, 70, '2025-09-05'),
(9, 80, '2025-10-10'),
(10, 90, '2025-11-15'),
(11, 30, '2025-12-20'),
(12, 40, '2026-01-25'),
(13, 50, '2026-02-28'),
(14, 60, '2026-03-30'),
(15, 70, '2026-04-05');
GO


SELECT*FROM Medicine
SELECT*FROM Supplier
SELECT*FROM StockIn
SELECT*FROM StockOut
-- 🔹 1. Kiểm tra tổng số lượng nhập kho từng loại thuốc
SELECT medicine_id, SUM(quantity) AS total_in 
FROM StockIn 
GROUP BY medicine_id;
GO

-- 🔹 2. Kiểm tra tổng số lượng xuất kho từng loại thuốc
SELECT medicine_id, SUM(quantity) AS total_out 
FROM StockOut 
GROUP BY medicine_id;
GO

-- 🔹 3. Xóa dữ liệu cũ trong bảng tồn kho (nếu cần làm mới)
DELETE FROM Inventory;
GO

-- 🔹 4. Chèn lại dữ liệu tồn kho từ StockIn (khởi tạo lại tồn kho)
INSERT INTO Inventory (medicine_id, total_quantity)
SELECT medicine_id, SUM(quantity) 
FROM StockIn 
GROUP BY medicine_id;
GO

-- 🔹 5. Cập nhật tồn kho từ StockOut (Trừ số lượng xuất kho)
UPDATE Inventory
SET total_quantity = total_quantity - COALESCE(
    (SELECT SUM(quantity) FROM StockOut WHERE StockOut.medicine_id = Inventory.medicine_id), 
    0
);
GO


-- 🔹 6. Kiểm tra dữ liệu tồn kho sau khi cập nhật
SELECT * FROM Inventory;
GO

-- 🔹 7. Hiển thị tồn kho chi tiết kèm tên thuốc
SELECT m.id AS medicine_id, 
       m.name AS medicine_name, 
       COALESCE(i.total_quantity, 0) AS stock_quantity
FROM Medicine m
LEFT JOIN Inventory i ON m.id = i.medicine_id
ORDER BY m.id;
GO


------------------------------------------VEW------------------------------------------------


-- View 1: Danh sách thuốc và tồn kho
CREATE VIEW View_Medicine_Inventory AS
SELECT m.id AS medicine_id, 
       m.name AS medicine_name, 
       COALESCE(i.total_quantity, 0) AS stock_quantity
FROM Medicine m
LEFT JOIN Inventory i ON m.id = i.medicine_id;
GO
SELECT * FROM View_Medicine_Inventory;


-- View 2: Danh sách nhà cung cấp
CREATE VIEW View_Suppliers AS
SELECT id AS supplier_id, name AS supplier_name, phone 
FROM Supplier;
GO


-- View 3: Tổng số lượng nhập kho theo thuốc
CREATE VIEW View_Total_StockIn AS
SELECT medicine_id, SUM(quantity) AS total_in 
FROM StockIn 
GROUP BY medicine_id;
GO
SELECT * FROM View_Total_StockIn;

-- View 4: Tổng số lượng xuất kho theo thuốc
CREATE VIEW View_Total_StockOut AS
SELECT medicine_id, SUM(quantity) AS total_out 
FROM StockOut 
GROUP BY medicine_id;
GO
SELECT * FROM View_Total_StockOut;

-- View 5: Lịch sử nhập kho
CREATE VIEW View_StockIn_History AS
SELECT si.id AS stockin_id, m.name AS medicine_name, s.name AS supplier_name, si.quantity, si.date_in
FROM StockIn si
JOIN Medicine m ON si.medicine_id = m.id
JOIN Supplier s ON si.supplier_id = s.id;
GO
SELECT * FROM View_StockIn_History;


-- View 6: Lịch sử xuất kho
CREATE VIEW View_StockOut_History AS
SELECT so.id AS stockout_id, m.name AS medicine_name, so.quantity, so.date_out
FROM StockOut so
JOIN Medicine m ON so.medicine_id = m.id;
GO
SELECT * FROM View_StockOut_History;


-- View 7: Tình trạng thuốc sắp hết hạn
CREATE VIEW View_Expiring_Medicine AS
SELECT id AS medicine_id, name AS medicine_name, expiry_date
FROM Medicine
WHERE expiry_date <= DATEADD(MONTH, 6, GETDATE());
GO
SELECT * FROM View_Expiring_Medicine;


-- View 8: Tình trạng tồn kho dưới mức tối thiểu (10 đơn vị)
CREATE VIEW View_Low_Stock AS
SELECT m.id AS medicine_id, m.name AS medicine_name, COALESCE(i.total_quantity, 0) AS stock_quantity
FROM Medicine m
LEFT JOIN Inventory i ON m.id = i.medicine_id
WHERE COALESCE(i.total_quantity, 0) < 10;
GO
SELECT * FROM View_Low_Stock;


-- View 9: Chi tiết tồn kho kèm thông tin thuốc
CREATE VIEW View_Inventory_Details AS
SELECT m.id AS medicine_id, m.name AS medicine_name, m.price, i.total_quantity, m.expiry_date
FROM Medicine m
LEFT JOIN Inventory i ON m.id = i.medicine_id;
GO
SELECT * FROM View_Inventory_Details;


-- View 10: Báo cáo nhập - xuất - tồn kho
CREATE VIEW View_Stock_Report AS
SELECT m.id AS medicine_id, m.name AS medicine_name, 
       COALESCE(SUM(si.quantity), 0) AS total_in,
       COALESCE(SUM(so.quantity), 0) AS total_out,
       COALESCE(i.total_quantity, 0) AS current_stock
FROM Medicine m
LEFT JOIN StockIn si ON m.id = si.medicine_id
LEFT JOIN StockOut so ON m.id = so.medicine_id
LEFT JOIN Inventory i ON m.id = i.medicine_id
GROUP BY m.id, m.name, i.total_quantity;
GO
SELECT * FROM View_Stock_Report;

----------------------Procedure-----------------------------------------------------
-- Procedure 1: Thêm thuốc mới
CREATE PROCEDURE AddMedicine
    @name NVARCHAR(255),
    @price DECIMAL(10,2),
    @expiry_date DATE
AS
BEGIN
    INSERT INTO Medicine (name, price, expiry_date)
    VALUES (@name, @price, @expiry_date);
END;
GO


-- Procedure 2: Thêm nhà cung cấp mới
CREATE PROCEDURE AddSupplier
    @name NVARCHAR(255),
    @phone NVARCHAR(20)
AS
BEGIN
    INSERT INTO Supplier (name, phone)
    VALUES (@name, @phone);
END;
GO


-- Procedure 3: Nhập kho thuốc
CREATE PROCEDURE AddStockIn
    @medicine_id INT,
    @supplier_id INT,
    @quantity INT,
    @date_in DATE
AS
BEGIN
    INSERT INTO StockIn (medicine_id, supplier_id, quantity, date_in)
    VALUES (@medicine_id, @supplier_id, @quantity, @date_in);
    
    -- Cập nhật tồn kho
    IF EXISTS (SELECT 1 FROM Inventory WHERE medicine_id = @medicine_id)
        UPDATE Inventory SET total_quantity = total_quantity + @quantity WHERE medicine_id = @medicine_id;
    ELSE
        INSERT INTO Inventory (medicine_id, total_quantity) VALUES (@medicine_id, @quantity);
END;
GO

-- Procedure 4: Xuất kho thuốc
CREATE PROCEDURE AddStockOut
    @medicine_id INT,
    @quantity INT,
    @date_out DATE
AS
BEGIN
    INSERT INTO StockOut (medicine_id, quantity, date_out)
    VALUES (@medicine_id, @quantity, @date_out);
    
    -- Cập nhật tồn kho
    UPDATE Inventory SET total_quantity = total_quantity - @quantity WHERE medicine_id = @medicine_id;
END;
GO
-- Procedure 5: Kiểm tra tồn kho thuốc
CREATE PROCEDURE GetInventory
AS
BEGIN
    SELECT m.id AS medicine_id, m.name AS medicine_name, COALESCE(i.total_quantity, 0) AS stock_quantity
    FROM Medicine m
    LEFT JOIN Inventory i ON m.id = i.medicine_id;
END;
GO
EXEC GetInventory;

-- Procedure 6: Kiểm tra danh sách thuốc sắp hết hạn
CREATE PROCEDURE GetExpiringMedicine
AS
BEGIN
    SELECT id AS medicine_id, name AS medicine_name, expiry_date
    FROM Medicine
    WHERE expiry_date <= DATEADD(MONTH, 6, GETDATE());
END;
GO
EXEC GetExpiringMedicine;

-- Procedure 7: Cập nhật giá thuốc
CREATE PROCEDURE UpdateMedicinePrice
    @medicine_id INT,
    @new_price DECIMAL(10,2)
AS
BEGIN
    UPDATE Medicine SET price = @new_price WHERE id = @medicine_id;
END;
GO
EXECUTE UpdateMedicinePrice 15, 150.75;
SELECT * FROM Medicine WHERE id = 15;


-- Procedure 8: Xóa thuốc khỏi hệ thống
CREATE PROCEDURE DeleteMedicine
    @medicine_id INT
AS
BEGIN
    DELETE FROM Medicine WHERE id = @medicine_id;
    DELETE FROM Inventory WHERE medicine_id = @medicine_id;
    DELETE FROM StockIn WHERE medicine_id = @medicine_id;
    DELETE FROM StockOut WHERE medicine_id = @medicine_id;
END;
GO

-- Procedure 9: Lấy thông tin nhà cung cấp
CREATE PROCEDURE GetSuppliers
AS
BEGIN
    SELECT * FROM Supplier;
END;
GO

-- Procedure 10: Lấy báo cáo tổng hợp nhập - xuất - tồn kho
CREATE PROCEDURE GetStockReport
AS
BEGIN
    SELECT m.id AS medicine_id, m.name AS medicine_name, 
           COALESCE(SUM(si.quantity), 0) AS total_in,
           COALESCE(SUM(so.quantity), 0) AS total_out,
           COALESCE(i.total_quantity, 0) AS current_stock
    FROM Medicine m
    LEFT JOIN StockIn si ON m.id = si.medicine_id
    LEFT JOIN StockOut so ON m.id = so.medicine_id
    LEFT JOIN Inventory i ON m.id = i.medicine_id
    GROUP BY m.id, m.name, i.total_quantity;
END;
GO


---------------------------------------------------Trigger-----------------------------------------------
-- Trigger 1: Tự động cập nhật tồn kho khi nhập kho
CREATE TRIGGER trg_AfterStockIn
ON StockIn
AFTER INSERT
AS
BEGIN
    UPDATE Inventory
    SET total_quantity = total_quantity + i.quantity
    FROM Inventory inv
    JOIN inserted i ON inv.medicine_id = i.medicine_id;
END;
GO

INSERT INTO StockIn (medicine_id, supplier_id, quantity, date_in) VALUES
(1, 1, 500, '2025-03-06');
INSERT INTO StockIn (medicine_id, supplier_id, quantity, date_in) VALUES
(3, 3, 200, '2025-03-06');
SELECT * FROM Inventory;

-- Trigger 2: Tự động cập nhật tồn kho khi xuất kho
CREATE TRIGGER trg_AfterStockOut
ON StockOut
AFTER INSERT
AS
BEGIN
    UPDATE Inventory
    SET total_quantity = total_quantity - i.quantity
    FROM Inventory inv
    JOIN inserted i ON inv.medicine_id = i.medicine_id;
END;
GO
INSERT INTO StockOut (medicine_id, quantity, date_out) VALUES
(3, 50, '2025-03-06');
SELECT * FROM Inventory;


-- Trigger 3: Ngăn chặn xuất kho nếu số lượng không đủ
CREATE TRIGGER trg_BeforeStockOut
ON StockOut
INSTEAD OF INSERT
AS
BEGIN
    IF EXISTS (
        SELECT 1 FROM inserted i
        JOIN Inventory inv ON i.medicine_id = inv.medicine_id
        WHERE i.quantity > inv.total_quantity
    )
    BEGIN
        RAISERROR ('Không đủ hàng trong kho để xuất!', 16, 1);
        RETURN;
    END;
    ELSE
    BEGIN
        INSERT INTO StockOut (medicine_id, quantity, date_out)
        SELECT medicine_id, quantity, date_out FROM inserted;
    END;
END;
GO

INSERT INTO StockOut (medicine_id, quantity, date_out) VALUES
(1, 20, '2025-03-06');  -- Thành công vì tồn kho 100, chỉ xuất 20
INSERT INTO StockOut (medicine_id, quantity, date_out) VALUES
(1, 50, '2025-03-06');  -- Lỗi vì tồn kho chỉ có 80 (100 - 20 đã xuất)
SELECT*FROM Inventory

-- Trigger 4: Xóa dữ liệu tồn kho khi xóa thuốc
CREATE TRIGGER trg_AfterDeleteMedicine
ON Medicine
AFTER DELETE
AS
BEGIN
    DELETE FROM Inventory WHERE medicine_id IN (SELECT id FROM deleted);
END;
GO
-- kiểm tra trước
SELECT * FROM Medicine;
SELECT * FROM Inventory;
DELETE FROM StockOut WHERE medicine_id = 1;  -- Xóa dữ liệu liên quan trong StockOut
DELETE FROM StockIn WHERE medicine_id = 1;   -- Xóa dữ liệu liên quan trong StockIn
DELETE FROM Inventory WHERE medicine_id = 1; -- Xóa dữ liệu trong Inventory
DELETE FROM Medicine WHERE id = 1;           -- Cuối cùng xóa thuốc

-- Trigger 5: Cấm nhập giá trị âm vào bảng nhập kho
-- Cập nhật trigger để kiểm tra medicine_id hợp lệ
CREATE OR ALTER TRIGGER trg_ValidateStockIn
ON StockIn
INSTEAD OF INSERT
AS
BEGIN
    IF EXISTS (SELECT 1 FROM inserted WHERE quantity <= 0)
        RAISERROR ('Số lượng nhập kho phải lớn hơn 0!', 16, 1);
    ELSE IF EXISTS (SELECT 1 FROM inserted i WHERE NOT EXISTS 
                    (SELECT 1 FROM Medicine m WHERE m.id = i.medicine_id))
        RAISERROR ('Lỗi: medicine_id không tồn tại trong bảng Medicine!', 16, 1);
    ELSE
        INSERT INTO StockIn (medicine_id, supplier_id, quantity, date_in)
        SELECT medicine_id, supplier_id, quantity, date_in FROM inserted;
END;
GO



INSERT INTO Medicine (name, price, expiry_date) 
VALUES (N'Paracetamol', 5000, '2026-12-31');

INSERT INTO StockIn (medicine_id, supplier_id, quantity, date_in)
VALUES (2, 2, 10, '2025-03-15');  -- Hợp lệ ✅

INSERT INTO StockIn (medicine_id, supplier_id, quantity, date_in)
VALUES (1, 2, -5, '2025-03-15');  -- Lỗi: Số lượng nhập kho phải lớn hơn 0! ❌

INSERT INTO StockIn (medicine_id, supplier_id, quantity, date_in)
VALUES (1, 2, 5, '2025-03-15');  -- Lỗi: medicine_id không tồn tại! ❌


-- Trigger 6: Cấm nhập giá trị âm vào bảng xuất kho
CREATE TRIGGER trg_ValidateStockOut
ON StockOut
AFTER INSERT
AS
BEGIN
    IF EXISTS (SELECT 1 FROM inserted WHERE quantity <= 0)
    BEGIN
        RAISERROR ('Số lượng xuất kho phải lớn hơn 0!', 16, 1);
        ROLLBACK TRANSACTION;
    END;
END;
GO


INSERT INTO Medicine (name, price, expiry_date) 
VALUES (N'Ibuprofen', 8000, '2027-06-30');

INSERT INTO StockOut (medicine_id, quantity, date_out)
VALUES (2, 5, '2025-03-16');  -- Hợp lệ ✅

INSERT INTO StockOut (medicine_id, quantity, date_out)
VALUES (6, -3, '2025-03-16');  -- Lỗi: Số lượng xuất kho phải lớn hơn 0! ❌

INSERT INTO StockOut (medicine_id, quantity, date_out)
VALUES (7, 0, '2025-03-16');  -- Lỗi: Số lượng xuất kho phải lớn hơn 0! ❌


-- Trigger 7: Kiểm tra hạn sử dụng khi nhập kho (không cho nhập thuốc hết hạn)
ALTER TRIGGER trg_ValidateExpiryStockIn
ON StockIn
AFTER INSERT
AS
BEGIN
    IF EXISTS (
        SELECT 1 FROM inserted i
        JOIN Medicine m ON i.medicine_id = m.id
        WHERE m.expiry_date < GETDATE()
    )
    BEGIN
        RAISERROR ('Không thể nhập kho thuốc đã hết hạn!', 16, 1);
        ROLLBACK TRANSACTION;
    END;
END;
GO

INSERT INTO Medicine (name, price, expiry_date)
VALUES (N'Amoxicillin', 7000, '2023-12-31'); -- Thuốc đã hết hạn
GO


SELECT id FROM Medicine WHERE name = N'Amoxicillin';

INSERT INTO StockIn (medicine_id, supplier_id, quantity, date_in)
VALUES (id, 2, 10, GETDATE());  -- Sẽ bị chặn do thuốc hết hạn
GO

-- Trigger 8: Kiểm tra cập nhật giá thuốc (không cho giá nhỏ hơn 0)
CREATE TRIGGER trg_ValidatePriceUpdate
ON Medicine
AFTER UPDATE
AS
BEGIN
    IF EXISTS (SELECT 1 FROM inserted WHERE price < 0)
    BEGIN
        RAISERROR ('Giá thuốc không thể nhỏ hơn 0!', 16, 1);
        ROLLBACK TRANSACTION;
    END;
END;
GO
-- add medicine
INSERT INTO Medicine (name, price, expiry_date)
VALUES (N'Ibuprofen', 10000, '2027-06-30'); -- Giá hợp lệ, thuốc mới
GO
-- update price
UPDATE Medicine
SET price = 12000  -- Giá mới hợp lệ (> 0)
WHERE name = N'Ibuprofen';
GO

UPDATE Medicine
SET price = -5000  -- Giá âm (bị chặn)
WHERE name = N'Ibuprofen';
GO
--ktra
SELECT * FROM Medicine WHERE name = N'Ibuprofen';
GO

-- Trigger 9: Tạo nhật ký khi có nhập kho
CREATE TABLE StockLog (
    log_id INT IDENTITY(1,1) PRIMARY KEY,
    action NVARCHAR(50),
    medicine_id INT,
    quantity INT,
    log_date DATETIME
);
GO

CREATE TRIGGER trg_LogStockIn
ON StockIn
AFTER INSERT
AS
BEGIN
    INSERT INTO StockLog (action, medicine_id, quantity, log_date)
    SELECT N'Nhập kho', medicine_id, quantity, GETDATE()
    FROM inserted;
END;
GO
INSERT INTO StockIn (medicine_id, supplier_id, quantity, date_in)
VALUES (2, 2, 10, GETDATE());--thêm dữ liệu để kích hoạt trigger
GO

SELECT * FROM StockLog;
GO
-- Trigger 10: Tạo nhật ký khi có xuất kho

CREATE TRIGGER trg_LogStockOut
ON StockOut
AFTER INSERT
AS
BEGIN
    -- Kiểm tra dữ liệu đã được chèn vào bảng StockOut
    IF EXISTS (SELECT 1 FROM inserted)
    BEGIN
        INSERT INTO StockLog (action, medicine_id, quantity, log_date)
        SELECT N'Xuất kho', medicine_id, quantity, GETDATE()
        FROM inserted;
    END
END;
GO

GRANT INSERT ON StockLog TO PUBLIC;

INSERT INTO StockOut (medicine_id, quantity, date_out)
VALUES (3, 10, GETDATE()), (2, 20, GETDATE());

SELECT * FROM StockLog;
UPDATE StockLog
SET action = N'Xuất kho'
WHERE action LIKE '%?%'; -- Kiểm tra và sửa các bản ghi bị lỗi font

SELECT * FROM StockLog;


----------------------------Phân quyền-----------------------
CREATE ROLE Warehouse_Manager;
CREATE ROLE Warehouse_Staff;
CREATE ROLE Customer;

-- Quản lý kho: Toàn quyền trên bảng Medicines
GRANT SELECT, INSERT, UPDATE, DELETE ON Medicine TO Warehouse_Manager;

-- Nhân viên kho: Chỉ được xem và thêm dữ liệu
GRANT SELECT, INSERT ON Medicine TO Warehouse_Staff;

-- Khách hàng: Chỉ được xem dữ liệu
GRANT SELECT ON Medicine TO Customer;

CREATE LOGIN admin_user WITH PASSWORD = 'password123';
CREATE LOGIN staff_user WITH PASSWORD = 'password123';
CREATE LOGIN customer_user WITH PASSWORD = 'password123';

CREATE USER admin_user FOR LOGIN admin_user;
CREATE USER staff_user FOR LOGIN staff_user;
CREATE USER customer_user FOR LOGIN customer_user;
ALTER ROLE Warehouse_Manager ADD MEMBER admin_user;
ALTER ROLE Warehouse_Staff ADD MEMBER staff_user;
ALTER ROLE Customer ADD MEMBER customer_user;
SELECT DP1.name AS RoleName, DP2.name AS UserName
FROM sys.database_role_members DRM
JOIN sys.database_principals DP1 ON DRM.role_principal_id = DP1.principal_id
JOIN sys.database_principals DP2 ON DRM.member_principal_id = DP2.principal_id;


