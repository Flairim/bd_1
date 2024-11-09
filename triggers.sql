CREATE OR REPLACE FUNCTION update_product_timestamp()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$;

CREATE TRIGGER product_update_timestamp
BEFORE UPDATE ON Products
FOR EACH ROW
EXECUTE FUNCTION update_product_timestamp();

CREATE OR REPLACE FUNCTION soft_delete_review()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    NEW.is_deleted = TRUE;
    RETURN NEW;
END;
$$;

CREATE TRIGGER soft_delete_trigger
BEFORE DELETE ON Reviews
FOR EACH ROW
EXECUTE FUNCTION soft_delete_review();

CREATE OR REPLACE FUNCTION update_order_timestamp()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    NEW.order_date = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$;

CREATE TRIGGER order_update_timestamp
BEFORE INSERT OR UPDATE ON Orders
FOR EACH ROW
EXECUTE FUNCTION update_order_timestamp();
