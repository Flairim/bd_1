-- Вставка початкових даних у таблиці

-- Ролі користувачів
INSERT INTO Roles (name, description) VALUES 
    ('admin', 'Administrator with full privileges'),
    ('customer', 'Customer with shopping privileges');

-- Користувачі
INSERT INTO Users (username, email, password_hash) VALUES
    ('admin_user', 'admin@example.com', 'hashed_password1'),
    ('customer1', 'customer1@example.com', 'hashed_password2');

-- Категорії товарів
INSERT INTO Categories (name, description) VALUES 
    ('Electronics', 'Electronic devices'),
    ('Books', 'Different genres of books');

-- Продукти
INSERT INTO Products (name, description, price, stock_quantity, updated_by_user) VALUES
    ('Smartphone', 'Latest model smartphone', 699.99, 50, 1),
    ('Laptop', 'High-performance laptop', 1299.99, 20, 1),
    ('Book - Data Science', 'A comprehensive book on Data Science', 59.99, 100, 1);

-- Замовлення
INSERT INTO Orders (user_id, status, total_price) VALUES
    (2, 'Pending', 759.98);

-- Деталі замовлення
INSERT INTO OrderItems (order_id, product_id, quantity, price_per_unit, total_price) VALUES
    (1, 1, 1, 699.99, 699.99),
    (1, 3, 1, 59.99, 59.99);

-- Знижки
INSERT INTO Discounts (name, discount_percentage, start_date, end_date) VALUES
    ('Winter Sale', 20, '2024-01-01', '2024-02-01');

-- Знижки на продукти
INSERT INTO ProductDiscounts (product_id, discount_id) VALUES
    (1, 1);
