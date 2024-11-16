-- створення функцій та процедур

CREATE OR REPLACE FUNCTION get_active_products()
RETURNS TABLE(
    product_id INT,
    name VARCHAR,
    price DECIMAL,
    stock_quantity INT
) AS $$
BEGIN
    RETURN QUERY
    SELECT product_id, name, price, stock_quantity
    FROM Products
    WHERE is_active = TRUE;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION get_user_order_count(user_id INT)
RETURNS INT AS $$
DECLARE
    order_count INT;
BEGIN
    SELECT COUNT(*) INTO order_count
    FROM Orders
    WHERE user_id = user_id;
    RETURN order_count;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION restore_user(user_id INT)
RETURNS VOID AS $$
BEGIN
    UPDATE Users
    SET is_deleted = FALSE
    WHERE user_id = $1;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE PROCEDURE add_to_cart(
    IN user_id INT,
    IN product_id INT,
    IN quantity INT
)
LANGUAGE plpgsql
AS $$
BEGIN
    IF EXISTS (
        SELECT 1 FROM CartItems ci
        JOIN Carts c ON ci.cart_id = c.cart_id
        WHERE c.user_id = user_id AND ci.product_id = product_id
    ) THEN
        UPDATE CartItems
        SET quantity = quantity + $3
        WHERE cart_id = (SELECT cart_id FROM Carts WHERE user_id = $1)
          AND product_id = $2;
    ELSE
        INSERT INTO CartItems (cart_id, product_id, quantity)
        VALUES ((SELECT cart_id FROM Carts WHERE user_id = $1), $2, $3);
    END IF;
END;
$$;

CREATE OR REPLACE PROCEDURE complete_order(order_id INT)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE Orders
    SET status = 'Completed'
    WHERE order_id = $1;
END;
$$;

CREATE OR REPLACE FUNCTION get_user_cart(user_id INT)
RETURNS TABLE(
    product_id INT,
    name VARCHAR,
    quantity INT,
    price_per_unit DECIMAL,
    total_price DECIMAL
) AS $$
BEGIN
    RETURN QUERY
    SELECT p.product_id, p.name, ci.quantity, p.price, ci.quantity * p.price AS total_price
    FROM CartItems ci
    JOIN Carts c ON ci.cart_id = c.cart_id
    JOIN Products p ON ci.product_id = p.product_id
    WHERE c.user_id = $1;
END;
$$ LANGUAGE plpgsql;
