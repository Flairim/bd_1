CREATE OR REPLACE PROCEDURE add_to_cart(
    p_user_id INT,
    p_product_id INT,
    p_quantity INT
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO CartItems (cart_id, product_id, quantity)
    VALUES (
        (SELECT cart_id FROM Carts WHERE user_id = p_user_id),
        p_product_id,
        p_quantity
    )
    ON CONFLICT (cart_id, product_id) 
    DO UPDATE SET quantity = CartItems.quantity + p_quantity;
END;
$$;

CREATE OR REPLACE PROCEDURE soft_delete_product(p_product_id INT)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE Products
    SET is_active = FALSE,
        updated_at = CURRENT_TIMESTAMP
    WHERE product_id = p_product_id;
END;
$$;

CREATE OR REPLACE FUNCTION calculate_order_total(p_order_id INT)
RETURNS DECIMAL(10, 2)
LANGUAGE plpgsql
AS $$
DECLARE
    total DECIMAL(10, 2);
BEGIN
    SELECT SUM(quantity * price_per_unit)
    INTO total
    FROM OrderItems
    WHERE order_id = p_order_id;
    RETURN total;
END;
$$;

CREATE OR REPLACE FUNCTION is_user_admin(p_user_id INT)
RETURNS BOOLEAN
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN EXISTS (
        SELECT 1
        FROM UserRoles ur
        JOIN Roles r ON ur.role_id = r.role_id
        WHERE ur.user_id = p_user_id AND r.name = 'Admin'
    );
END;
$$;
