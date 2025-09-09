set search_path to eshop;
-- ========================
-- USER MANAGEMENT
-- ========================
CREATE TABLE users (
    id BIGSERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    role VARCHAR(20) NOT NULL CHECK (role IN ('USER', 'MERCHANT', 'ADMIN')),
    address TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ========================
-- PRODUCT CATEGORIES
-- ========================
CREATE TABLE categories (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    parent_id BIGINT REFERENCES categories(id) ON DELETE SET NULL
);

-- ========================
-- PRODUCT MANAGEMENT
-- ========================
CREATE TABLE products (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    description TEXT,
    price NUMERIC(10,2) NOT NULL CHECK (price >= 0),
    category_id BIGINT NOT NULL REFERENCES categories(id) ON DELETE CASCADE,
    merchant_id BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Extra attributes (flexible key-value metadata)
CREATE TABLE product_metadata (
    id BIGSERIAL PRIMARY KEY,
    product_id BIGINT NOT NULL REFERENCES products(id) ON DELETE CASCADE,
    meta_key VARCHAR(100) NOT NULL,
    meta_value VARCHAR(255),
    CONSTRAINT unique_meta_per_product UNIQUE (product_id, meta_key)
);

-- ========================
-- INVENTORY MANAGEMENT
-- ========================
CREATE TABLE inventory (
    id BIGSERIAL PRIMARY KEY,
    product_id BIGINT NOT NULL UNIQUE REFERENCES products(id) ON DELETE CASCADE,
    quantity INT NOT NULL CHECK (quantity >= 0),
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ========================
-- ORDER MANAGEMENT
-- ========================
CREATE TABLE orders (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    status VARCHAR(20) NOT NULL CHECK (status IN ('PLACED', 'CONFIRMED', 'SHIPPED', 'DELIVERED', 'CANCELLED')),
    total_price NUMERIC(12,2) NOT NULL CHECK (total_price >= 0),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE order_items (
    id BIGSERIAL PRIMARY KEY,
    order_id BIGINT NOT NULL REFERENCES orders(id) ON DELETE CASCADE,
    product_id BIGINT NOT NULL REFERENCES products(id) ON DELETE CASCADE,
    quantity INT NOT NULL CHECK (quantity > 0),
    price NUMERIC(10,2) NOT NULL CHECK (price >= 0),
    CONSTRAINT unique_product_per_order UNIQUE (order_id, product_id)
);

-- ========================
-- INDEXES for performance
-- ========================
CREATE INDEX idx_products_category ON products(category_id);
CREATE INDEX idx_products_merchant ON products(merchant_id);
CREATE INDEX idx_orders_user ON orders(user_id);
CREATE INDEX idx_order_items_order ON order_items(order_id);

set search_path to eshop;

-- ========================
-- AUDIT TABLES
-- ========================

-- Inventory Audit
CREATE TABLE inventory_audit (
    audit_id BIGSERIAL PRIMARY KEY,
    inventory_id BIGINT,
    action VARCHAR(10), -- INSERT, UPDATE, DELETE
    old_data JSONB,
    new_data JSONB,
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    changed_by VARCHAR(50)
);

-- Orders Audit
CREATE TABLE order_audit (
    audit_id BIGSERIAL PRIMARY KEY,
    order_id BIGINT,
    action VARCHAR(10), -- INSERT, UPDATE, DELETE
    old_data JSONB,
    new_data JSONB,
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    changed_by VARCHAR(50)
);

-- ========================
-- TRIGGER FUNCTIONS
-- ========================

-- Inventory Trigger Function
CREATE OR REPLACE FUNCTION audit_inventory_changes()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        INSERT INTO inventory_audit(inventory_id, action, new_data, changed_by)
        VALUES (NEW.id, TG_OP, row_to_json(NEW), current_user);

    ELSIF TG_OP = 'UPDATE' THEN
        INSERT INTO inventory_audit(inventory_id, action, old_data, new_data, changed_by)
        VALUES (NEW.id, TG_OP, row_to_json(OLD), row_to_json(NEW), current_user);

    ELSIF TG_OP = 'DELETE' THEN
        INSERT INTO inventory_audit(inventory_id, action, old_data, changed_by)
        VALUES (OLD.id, TG_OP, row_to_json(OLD), current_user);
    END IF;

    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

-- Orders Trigger Function
CREATE OR REPLACE FUNCTION audit_order_changes()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        INSERT INTO order_audit(order_id, action, new_data, changed_by)
        VALUES (NEW.id, TG_OP, row_to_json(NEW), current_user);

    ELSIF TG_OP = 'UPDATE' THEN
        INSERT INTO order_audit(order_id, action, old_data, new_data, changed_by)
        VALUES (NEW.id, TG_OP, row_to_json(OLD), row_to_json(NEW), current_user);

    ELSIF TG_OP = 'DELETE' THEN
        INSERT INTO order_audit(order_id, action, old_data, changed_by)
        VALUES (OLD.id, TG_OP, row_to_json(OLD), current_user);
    END IF;

    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

-- ========================
-- TRIGGERS
-- ========================

-- Inventory Trigger
CREATE TRIGGER trg_audit_inventory
AFTER INSERT OR UPDATE OR DELETE
ON inventory
FOR EACH ROW
EXECUTE FUNCTION audit_inventory_changes();

-- Orders Trigger
CREATE TRIGGER trg_audit_orders
AFTER INSERT OR UPDATE OR DELETE
ON orders
FOR EACH ROW
EXECUTE FUNCTION audit_order_changes();
