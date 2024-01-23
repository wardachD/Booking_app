-- Dodawanie losowych danych do tabeli salon
INSERT INTO "salon" ("name", "address_city", "address_postal_code", "address_street", "address_number", "about", "avatar", "phone_number")
VALUES
  ('Salon A', 'City A', '12345', 'Street A', '1', 'About Salon A', 'avatar_url_a', '12345678'),
  ('Salon B', 'City B', '54321', 'Street B', '2', 'About Salon B', 'avatar_url_b', '87654321');
  -- Dodaj więcej rekordów według potrzeb.

-- Dodawanie losowych danych do tabeli category
INSERT INTO "category" ("salon_id", "name", "description")
VALUES
  (1, 'Haircut', 'Haircut services'),
  (1, 'Manicure', 'Nail care services'),
  (2, 'Massage', 'Relaxation massage');
  -- Dodaj więcej rekordów według potrzeb.

-- Dodawanie losowych danych do tabeli service
INSERT INTO "service" ("salon_id", "category_id", "title", "description", "price", "duration_minutes")
VALUES
  (1, 1, 'Basic Haircut', 'Standard haircut service', 30.00, 45),
  (1, 2, 'Classic Manicure', 'Basic nail care', 20.00, 30),
  (2, 3, 'Swedish Massage', 'Relaxing massage', 50.00, 60);
  -- Dodaj więcej rekordów według potrzeb.

-- Dodawanie losowych danych do tabeli users
INSERT INTO "users" ("name", "gender", "phone", "country", "email", "uid", "avatar")
VALUES
  ('John Doe', 'M', '123456789', 'Country A', 'john@example.com', 'user1', 'avatar_url_c'),
  ('Jane Smith', 'F', '987654321', 'Country B', 'jane@example.com', 'user2', 'avatar_url_d');
  -- Dodaj więcej rekordów według potrzeb.

-- Dodawanie losowych danych do tabeli review
INSERT INTO "review" ("salon_id", "user_id", "rating", "comment")
VALUES
  (1, 1, 4, 'Great haircut!'),
  (1, 2, 5, 'Excellent service!');
  -- Dodaj więcej rekordów według potrzeb.

-- Dodawanie losowych danych do tabeli appointment
INSERT INTO "appointment" ("salon_id", "user_id", "date_of_booking", "comment", "total_amount", "status")
VALUES
  (1, 1, '2023-01-15', 'Appointment for haircut', 40.00, 'Confirmed'),
  (1, 2, '2023-02-20', 'Appointment for manicure', 25.00, 'Pending');
  -- Dodaj więcej rekordów według potrzeb.

-- Dodawanie losowych danych do tabeli appointment_services (ManyToMany)
INSERT INTO "appointment_services" ("appointment_id", "service_id")
VALUES
  (1, 1),
  (1, 2),
  (2, 3);
  -- Dodaj więcej rekordów według potrzeb.
