-- Создание таблицы товаров
CREATE TABLE IF NOT EXISTS products (
                                        id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(255) NOT NULL,
    description TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    created_by UUID,
    parent_id UUID REFERENCES products(id)
    );

-- Создание таблицы складских единиц
CREATE TABLE IF NOT EXISTS stock_items (
                                           id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(100) NOT NULL,
    description TEXT,
    product_id UUID NOT NULL REFERENCES products(id),
    status VARCHAR(20) NOT NULL CHECK (status IN ('reserved', 'paid', 'in_stock', 'on_display', 'sold')),
    supply_id UUID,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
                             employee_id UUID NOT NULL,
                             shop_id UUID NOT NULL,
                             purchase_price DECIMAL(10, 2) NOT NULL,
    selling_price DECIMAL(10, 2) NOT NULL,
    sale_id UUID,
    shift_id UUID NOT NULL,
    bouquet_id UUID,
    is_bouquet BOOLEAN DEFAULT FALSE
    );

-- Создание таблицы проданных товаров
CREATE TABLE IF NOT EXISTS sold_items (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    stock_item_id UUID NOT NULL,
    sale_id UUID NOT NULL,
    sold_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
                          product_id UUID NOT NULL,
                          name VARCHAR(100) NOT NULL,
    purchase_price DECIMAL(10, 2) NOT NULL,
    actual_selling_price DECIMAL(10, 2) NOT NULL,
    shop_id UUID NOT NULL,
    employee_id UUID NOT NULL,
    bouquet_id UUID,
    is_bouquet BOOLEAN DEFAULT FALSE
    );

-- Создание индексов
CREATE INDEX IF NOT EXISTS idx_stock_items_product_id ON stock_items(product_id);
CREATE INDEX IF NOT EXISTS idx_stock_items_status ON stock_items(status);
CREATE INDEX IF NOT EXISTS idx_sold_items_sale_id ON sold_items(sale_id);


CREATE TABLE IF NOT EXISTS positions (
   id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
   name VARCHAR(100) NOT NULL UNIQUE,
   description TEXT,
   created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS employees (
   id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
   first_name VARCHAR(50) NOT NULL,
   last_name VARCHAR(50) NOT NULL,
   middle_name VARCHAR(50),
   birth_date DATE NOT NULL,
   hire_date DATE NOT NULL,
   termination_date DATE,
   position_id UUID NOT NULL REFERENCES positions(id),
   created_by UUID REFERENCES employees(id),
   created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
   email VARCHAR(255) NOT NULL UNIQUE,
   CONSTRAINT valid_termination CHECK (
       termination_date IS NULL OR termination_date >= hire_date
       )
);

CREATE INDEX IF NOT EXISTS idx_employees_active ON employees(termination_date)
    WHERE termination_date IS NULL;

TRUNCATE TABLE eployees, positions

-- Первый администратор (пароль: admin123)
INSERT INTO positions (id, name, description) VALUES
    ('11111111-1111-1111-1111-111111111111', 'Администратор', 'Главный администратор системы');

INSERT INTO employees (
    id,
    first_name,
    last_name,
    birth_date,
    hire_date,
    position_id,
    email
) VALUES (
             '00000000-0000-0000-0000-000000000000',
             'Системный',
             'Администратор',
             '2000-01-01',
             CURRENT_DATE,
             '11111111-1111-1111-1111-111111111111',
             'admin@flowershop.ru'
         );