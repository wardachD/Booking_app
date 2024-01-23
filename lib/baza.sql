CREATE TABLE salon (
    id INT PRIMARY KEY IDENTITY(1,1),
    nazwa NVARCHAR(100) NOT NULL,
    miasto NVARCHAR(100),
    kod_pocztowy NVARCHAR(6),
    ulica NVARCHAR(100),
    numer_domu NVARCHAR(10),
    o_salonie NVARCHAR(300),
    avatar NVARCHAR(60),
    numer_telefonu NVARCHAR(8) NOT NULL
);

CREATE TABLE kategoria (
    id INT PRIMARY KEY IDENTITY(1,1),
    salon_id INT REFERENCES salon(id),
    nazwa NVARCHAR(100),
    opis NVARCHAR(300)
);

CREATE TABLE usluga (
    id INT PRIMARY KEY IDENTITY(1,1),
    salon_id INT REFERENCES salon(id),
    kategoria_id INT REFERENCES kategoria(id),
    tytul NVARCHAR(100),
    opis TEXT,
    cena DECIMAL(8, 2),
    czas_trwania_min INT
);

CREATE TABLE uzytkownicy (
    id INT PRIMARY KEY IDENTITY(1,1),
    imie NVARCHAR(40),
    plec CHAR(1),
    telefon NVARCHAR(9),
    kraj NVARCHAR(30),
    email NVARCHAR(80),
    uid NVARCHAR(100) UNIQUE,
    avatar NVARCHAR(200)
);

CREATE TABLE recenzja (
    id INT PRIMARY KEY IDENTITY(1,1),
    salon_id INT REFERENCES salon(id),
    uzytkownik_id INT REFERENCES uzytkownicy(id),
    ocena INT CHECK (ocena BETWEEN 1 AND 5),
    komentarz TEXT DEFAULT '',
);

CREATE TABLE rezerwacja (
    id INT PRIMARY KEY IDENTITY(1,1),
    salon_id INT REFERENCES salon(id),
    uzytkownik_id INT REFERENCES uzytkownicy(id),
    data_rezerwacji DATE,
    komentarz NVARCHAR(200),
    calkowita_kwota DECIMAL(6, 2) CHECK (calkowita_kwota >= 0),
    status NVARCHAR(20) DEFAULT 'P',
    utworzono_w DATE
);

CREATE TABLE rezerwacja_uslugi (
    rezerwacja_id INT REFERENCES rezerwacja(id),
    usluga_id INT REFERENCES usluga(id),
    PRIMARY KEY (rezerwacja_id, usluga_id)
);

CREATE VIEW WidokSalonyZOpiniami AS
SELECT
    s.id AS SalonID,
    s.nazwa AS NazwaSalonu,
    s.miasto AS Miasto,
    s.kod_pocztowy AS KodPocztowy,
    s.ulica AS Ulica,
    s.numer_domu AS NumerDomu,
    s.o_salonie AS OpisSalonu,
    s.avatar AS AvatarSalonu,
    s.numer_telefonu AS NumerTelefonu,
    r.id AS OpiniaID,
    r.ocena AS Ocena,
    r.komentarz AS Komentarz
FROM
    salon s
LEFT JOIN
    recenzja r ON s.id = r.salon_id;

SELECT * FROM WidokSalonyZOpiniami;


CREATE VIEW WidokRezerwacjeDlaMezczyzn AS
SELECT
    r.id AS RezerwacjaID,
    s.nazwa AS NazwaSalonu,
    u.imie AS ImieUzytkownika,
    u.plec AS PlecUzytkownika,
    r.data_rezerwacji AS DataRezerwacji,
    r.komentarz AS Komentarz,
    r.calkowita_kwota AS CalkowitaKwota,
    r.status AS StatusRezerwacji,
    COUNT(r.id) AS LiczbaRezerwacji,
    SUM(r.calkowita_kwota) AS SumaKwotyRezerwacji,
    AVG(r.calkowita_kwota) AS SredniaKwotaRezerwacji
FROM
    rezerwacja r
JOIN
    salon s ON r.salon_id = s.id
JOIN
    uzytkownicy u ON r.uzytkownik_id = u.id
WHERE
    u.plec = 'M'
GROUP BY
    r.id, s.nazwa, u.imie, u.plec, r.data_rezerwacji, r.komentarz, r.calkowita_kwota, r.status;


SELECT * FROM WidokRezerwacjeDlaMezczyzn;

