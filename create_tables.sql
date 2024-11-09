-- Користувачі
CREATE TABLE Users (
    user_id SERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_deleted BOOLEAN DEFAULT FALSE
);

-- Ролі
CREATE TABLE Roles (
    role_id SERIAL PRIMARY KEY,
    name VARCHAR(50) UNIQUE NOT NULL,
    description TEXT
);

-- Зв'язок між користувачами і ролями
CREATE TABLE UserRoles (
    user_role_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES Users(user_id),
    role_id INT REFERENCES Roles(role_id),
    assigned_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Продукти
CREATE TABLE Products (
    product_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    price DECIMAL(10, 2) NOT NULL,
    stock_quantity INT NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_by_user INT REFERENCES Users(user_id)
);

-- Зображення продуктів
CREATE TABLE ProductImages (
    image_id SERIAL PRIMARY KEY,
    product_id INT REFERENCES Products(product_id),
    image_url TEXT NOT NULL,
    is_main BOOLEAN DEFAULT FALSE
);

-- Категорії продуктів
CREATE TABLE Categories (
    category_id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    description TEXT,
    parent_category_id INT REFERENCES Categories(category_id),
    is_deleted BOOLEAN DEFAULT FALSE
);

-- Замовлення
CREATE TABLE Orders (
    order_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES Users(user_id),
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(20) NOT NULL,
    total_price DECIMAL(10, 2) NOT NULL
);

-- Адреси доставки
CREATE TABLE ShippingAddresses (
    address_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES Users(user_id),
    order_id INT REFERENCES Orders(order_id),
    address TEXT NOT NULL,
    city VARCHAR(50) NOT NULL,
    postal_code VARCHAR(10) NOT NULL,
    country VARCHAR(50) NOT NULL
);

-- Деталі замовлення
CREATE TABLE OrderItems (
    order_item_id SERIAL PRIMARY KEY,
    order_id INT REFERENCES Orders(order_id),
    product_id INT REFERENCES Products(product_id),
    quantity INT NOT NULL,
    price_per_unit DECIMAL(10, 2) NOT NULL,
    total_price DECIMAL(10, 2) NOT NULL
);

-- Платежі
CREATE TABLE Payments (
    payment_id SERIAL PRIMARY KEY,
    order_id INT REFERENCES Orders(order_id),
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    amount DECIMAL(10, 2) NOT NULL,
    payment_method VARCHAR(20) NOT NULL,
    status VARCHAR(20) NOT NULL
);

-- Кошик
CREATE TABLE Carts (
    cart_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES Users(user_id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Товари в кошику
CREATE TABLE CartItems (
    cart_item_id SERIAL PRIMARY KEY,
    cart_id INT REFERENCES Carts(cart_id),
    product_id INT REFERENCES Products(product_id),
    quantity INT NOT NULL
);

-- Відгуки
CREATE TABLE Reviews (
    review_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES Users(user_id),
    product_id INT REFERENCES Products(product_id),
    rating INT CHECK (rating >= 1 AND rating <= 5),
    comment TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_deleted BOOLEAN DEFAULT FALSE
);

-- Списки бажань
CREATE TABLE Wishlists (
    wishlist_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES Users(user_id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Товари у списку бажань
CREATE TABLE WishlistItems (
    wishlist_item_id SERIAL PRIMARY KEY,
    wishlist_id INT REFERENCES Wishlists(wishlist_id),
    product_id INT REFERENCES Products(product_id)
);

-- Знижки
CREATE TABLE Discounts (
    discount_id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    discount_percentage DECIMAL(5, 2) NOT NULL CHECK (discount_percentage
