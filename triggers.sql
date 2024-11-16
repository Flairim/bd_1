-- створення тригерів

CREATE OR REPLACE FUNCTION update_product_timestamp()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_product_trigger
BEFORE UPDATE ON Products
FOR EACH ROW
EXECUTE FUNCTION update_product_timestamp();

CREATE OR REPLACE FUNCTION prevent_category_deletion()
RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS (SELECT 1 FROM ProductCategories WHERE category_id = OLD.category_id) THEN
        RAISE EXCEPTION 'Cannot delete category with assigned products';
    END IF;
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER prevent_category_delete_trigger
BEFORE DELETE ON Categories
FOR EACH ROW
EXECUTE FUNCTION prevent_category_deletion();
