-- створення розрізів даних

CREATE OR REPLACE VIEW active_users AS
SELECT user_id, username, email
FROM Users
WHERE is_deleted = FALSE;

CREATE OR REPLACE VIEW user_order_summary AS
SELECT u.user_id, u.username, COUNT(o.order_id) AS total_orders
FROM Users u
LEFT JOIN Orders o ON u.user_id = o.user_id
WHERE u.is_deleted = FALSE
GROUP BY u.user_id, u.username;
