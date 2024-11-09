CREATE OR REPLACE VIEW ActiveProductsWithDiscount AS
SELECT p.product_id, p.name, p.price, d.discount_percentage,
       (p.price * (1 - d.discount_percentage / 100)) AS discounted_price
FROM Products p
JOIN Discounts d ON p.product_id = d.discount_id
WHERE p.is_active = TRUE;

CREATE OR REPLACE VIEW UserOrderHistory AS
SELECT o.order_id, o.order_date, oi.product_id, oi.quantity, oi.price_per_unit, oi.total_price
FROM Orders o
JOIN OrderItems oi ON o.order_id = oi.order_id
WHERE o.user_id = p_user_id;

CREATE OR REPLACE VIEW ProductReviews AS
SELECT p.product_id, p.name, r.rating, r.comment, r.created_at
FROM Products p
JOIN Reviews r ON p.product_id = r.product_id
WHERE r.is_deleted = FALSE;
