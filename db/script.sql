-- -- -- -- -- -- -- -- -- -- -- --
-- Connect to the DB :
-- pgcli -h localhost -p 5432 -U delvauxo -d yolo
-- -- -- -- -- -- -- -- -- -- -- --
-- Running this script in pgcli :
-- \i path/to/script.sql
-- -- -- -- -- -- -- -- -- -- -- --

-- Extension UUID
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Table users
CREATE TABLE IF NOT EXISTS users (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  email TEXT NOT NULL UNIQUE,
  password TEXT NOT NULL
);

-- Insertion des utilisateurs
INSERT INTO users (id, name, email, password) VALUES
('410544b2-4001-4271-9855-fec4b6a6442a', 'User', 'user@nextmail.com', '123456')
ON CONFLICT (id) DO NOTHING;

-- Table customers
CREATE TABLE IF NOT EXISTS customers (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  email VARCHAR(255) NOT NULL,
  image_url VARCHAR(255) NOT NULL
);

-- Insertion des clients
INSERT INTO customers (id, name, email, image_url) VALUES
('d6e15727-9fe1-4961-8c5b-ea44a9bd81aa', 'Evil Rabbit', 'evil@rabbit.com', '/customers/evil-rabbit.png'),
('3958dc9e-712f-4377-85e9-fec4b6a6442a', 'Delba de Oliveira', 'delba@oliveira.com', '/customers/delba-de-oliveira.png'),
('3958dc9e-742f-4377-85e9-fec4b6a6442a', 'Lee Robinson', 'lee@robinson.com', '/customers/lee-robinson.png'),
('76d65c26-f784-44a2-ac19-586678f7c2f2', 'Michael Novotny', 'michael@novotny.com', '/customers/michael-novotny.png'),
('CC27C14A-0ACF-4F4A-A6C9-D45682C144B9', 'Amy Burns', 'amy@burns.com', '/customers/amy-burns.png'),
('13D07535-C59E-4157-A011-F8D2EF4E0CBB', 'Balazs Orban', 'balazs@orban.com', '/customers/balazs-orban.png')
ON CONFLICT (id) DO NOTHING;

-- Table invoices
CREATE TABLE IF NOT EXISTS invoices (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  customer_id UUID NOT NULL,
  amount INT NOT NULL,
  status VARCHAR(255) NOT NULL,
  date DATE NOT NULL,
  FOREIGN KEY (customer_id) REFERENCES customers(id) ON DELETE CASCADE
);

-- Insertion des factures
INSERT INTO invoices (customer_id, amount, status, date) VALUES
('d6e15727-9fe1-4961-8c5b-ea44a9bd81aa', 15795, 'pending', '2022-12-06'),
('3958dc9e-712f-4377-85e9-fec4b6a6442a', 20348, 'pending', '2022-11-14'),
('CC27C14A-0ACF-4F4A-A6C9-D45682C144B9', 3040, 'paid', '2022-10-29'),
('76d65c26-f784-44a2-ac19-586678f7c2f2', 44800, 'paid', '2023-09-10'),
('13D07535-C59E-4157-A011-F8D2EF4E0CBB', 34577, 'pending', '2023-08-05'),
('3958dc9e-742f-4377-85e9-fec4b6a6442a', 54246, 'pending', '2023-07-16'),
('d6e15727-9fe1-4961-8c5b-ea44a9bd81aa', 666, 'pending', '2023-06-27'),
('76d65c26-f784-44a2-ac19-586678f7c2f2', 32545, 'paid', '2023-06-09'),
('CC27C14A-0ACF-4F4A-A6C9-D45682C144B9', 1250, 'paid', '2023-06-17'),
('13D07535-C59E-4157-A011-F8D2EF4E0CBB', 8546, 'paid', '2023-06-07'),
('3958dc9e-712f-4377-85e9-fec4b6a6442a', 500, 'paid', '2023-08-19'),
('13D07535-C59E-4157-A011-F8D2EF4E0CBB', 8945, 'paid', '2023-06-03'),
('3958dc9e-742f-4377-85e9-fec4b6a6442a', 1000, 'paid', '2022-06-05')
ON CONFLICT (id) DO NOTHING;

-- Table revenue
CREATE TABLE IF NOT EXISTS revenue (
  month VARCHAR(4) NOT NULL UNIQUE,
  revenue INT NOT NULL
);

-- Insertion des revenus
INSERT INTO revenue (month, revenue) VALUES
('Jan', 2000),
('Feb', 1800),
('Mar', 2200),
('Apr', 2500),
('May', 2300),
('Jun', 3200),
('Jul', 3500),
('Aug', 3700),
('Sep', 2500),
('Oct', 2800),
('Nov', 3000),
('Dec', 4800)
ON CONFLICT (month) DO NOTHING;
