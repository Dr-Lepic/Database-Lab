CREATE TABLE Customer (
    CustomerID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    Phone VARCHAR(20) UNIQUE NOT NULL,
    Address TEXT,
    DateOfBirth DATE NOT NULL,
    Gender ENUM('Male', 'Female', 'Other') NOT NULL
);



CREATE TABLE Agent (
    AgentID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    Phone VARCHAR(20) UNIQUE NOT NULL,
    Agency VARCHAR(255) NOT NULL
);

CREATE TABLE Flight (
    FlightID INT PRIMARY KEY AUTO_INCREMENT,
    AirlineName VARCHAR(100) NOT NULL,
    Source VARCHAR(100) NOT NULL,
    Destination VARCHAR(100) NOT NULL,
    DepartureTime DATETIME NOT NULL,
    ArrivalTime DATETIME NOT NULL,
    Price DECIMAL(10,2) NOT NULL
);

CREATE TABLE Hotel (
    HotelID INT PRIMARY KEY AUTO_INCREMENT,
    HotelName VARCHAR(255) NOT NULL,
    Location VARCHAR(255) NOT NULL,
    RoomType VARCHAR(50) NOT NULL,
    PricePerNight DECIMAL(10,2) NOT NULL
);

CREATE TABLE Vehicle_Rent (
    RentalID INT PRIMARY KEY AUTO_INCREMENT,
    VehicleType VARCHAR(50) NOT NULL,
    RentalCompany VARCHAR(100) NOT NULL,
    PricePerDay DECIMAL(10,2) NOT NULL
);

CREATE TABLE Package (
    PackageID INT PRIMARY KEY AUTO_INCREMENT,
    PackageName VARCHAR(100) NOT NULL,
    Description TEXT NOT NULL,
    Duration INT NOT NULL,
    Price DECIMAL(10,2) NOT NULL,
    HotelID INT,
    FlightID INT,
    RentalID INT,
    FOREIGN KEY (HotelID) REFERENCES Hotel(HotelID) ON DELETE SET NULL,
    FOREIGN KEY (FlightID) REFERENCES Flight(FlightID) ON DELETE SET NULL,
    FOREIGN KEY (RentalID) REFERENCES Vehicle_Rent(RentalID) ON DELETE SET NULL
);

CREATE TABLE Booking (
    BookingID INT PRIMARY KEY AUTO_INCREMENT,
    BookingDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    TravelDate DATE NOT NULL,
    TotalAmount DECIMAL(10,2) NOT NULL,
    CustomerID INT NOT NULL,
    AgentID INT,
    PackageID INT,
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID) ON DELETE CASCADE,
    FOREIGN KEY (AgentID) REFERENCES Agent(AgentID) ON DELETE SET NULL,
    FOREIGN KEY (PackageID) REFERENCES Package(PackageID) ON DELETE SET NULL
);

CREATE TABLE Payment (
    PaymentID INT PRIMARY KEY AUTO_INCREMENT,
    PaymentDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    Amount DECIMAL(10,2) NOT NULL,
    PaymentMethod ENUM('Credit Card', 'Debit Card', 'PayPal', 'Cash') NOT NULL,
    BookingID INT NOT NULL,
    FOREIGN KEY (BookingID) REFERENCES Booking(BookingID) ON DELETE CASCADE
);




-- insert data

INSERT INTO Customer (Name, Email, Phone, Address, DateOfBirth, Gender) VALUES
('John Doe', 'john.doe@example.com', '1234567890', '154 Board Bazar', '1990-05-10', 'Male'),
('Hasibul Karim', 'hasibul.karim@example.com', '0987654321', '154 Board Bazar', '1985-08-15', 'Female'),
('Mohammod Mahbub', 'mahbub.rahman@example.com', '2233445566', '154 Board Bazar', '1982-11-22', 'Male'),
('Emily Johnson', 'emily.j@example.com', '3344556677', '154 Board Bazar', '1995-04-30', 'Female'),
('Michael Lee', 'michael.lee@example.com', '4455667788', '154 Board Bazar', '1988-09-14', 'Male'),
('Sophia Davis', 'sophia.d@example.com', '5566778899', '154 Board Bazar', '1993-07-08', 'Female');

INSERT INTO Agent (Name, Email, Phone, Agency) VALUES
('Michel Davis', 'agent1@travel.com', '1122334455', 'Sky Travel'),
('Emily Lee', 'agent2@tours.com', '2233445566', 'Global Explore'),
('Sophia Doe', 'agent3@voyage.com', '3344556677', 'Voyage Unlimited'),
('Avis Doe', 'agent4@getaways.com', '4455667788', 'Luxury Travel Co.'),
('Remily John', 'agent5@budget.com', '5566778899', 'Budget Trips'),
('Holy lee', 'agent6@holiday.com', '6677889900', 'Holiday Dreams');

INSERT INTO Flight (AirlineName, Source, Destination, DepartureTime, ArrivalTime, Price) VALUES
('Airways1', 'New York', 'Board Bazar', '2025-06-01 08:00:00', '2025-06-01 20:00:00', 500.00),
('Airways12', 'Board Bazar', 'Tokyo', '2025-07-15 10:00:00', '2025-07-16 14:00:00', 800.00),
('Airways13', 'Chicago', 'Board Bazar', '2025-08-10 09:30:00', '2025-08-10 19:45:00', 650.00),
('Airways14', 'San Francisco', 'Board Bazar', '2025-09-05 22:15:00', '2025-09-06 08:30:00', 950.00),
('Airways15', 'Board Bazar', 'Toronto', '2025-10-12 15:00:00', '2025-10-12 18:00:00', 300.00),
('Airways16', 'Houston', 'Board Bazar', '2025-11-20 07:45:00', '2025-11-20 18:30:00', 720.00);

INSERT INTO Hotel (HotelName, Location, RoomType, PricePerNight) VALUES
('Luxury Inn1', 'Board Bazar', 'Deluxe', 150.00),
('Luxury Inn12', 'Board Bazar', 'Suite', 200.00),
('Luxury Inn13', 'Board Bazar', 'Executive', 250.00),
('Luxury Inn14', 'Board Bazar', 'Sea View', 300.00),
('Luxury Inn15', 'Board Bazar', 'Penthouse', 180.00),
('Luxury Inn16', 'Board Bazar', 'Standard', 130.00);

INSERT INTO Vehicle_Rent (RentalID, VehicleType, RentalCompany, PricePerDay) VALUES
(1, 'SUV', 'Hertz', 80.00),
(2, 'Sedan', 'Avis', 60.00),
(3, 'Convertible', 'Enterprise', 100.00),
(4, 'Pickup Truck', 'Budget Rentals', 75.00),
(5, 'Motorbike', 'Urban Rides', 40.00),
(6, 'Luxury Van', 'Luxury Rides', 120.00);

INSERT INTO Package (PackageID, PackageName, Description, Duration, Price, HotelID, FlightID, RentalID) VALUES
(1, 'Summer Special', '7-day luxury tour', 7, 1500.00, 1, 1, 1),
(2, 'Summer Special2', '3-day city tour', 3, 600.00, 2, 2, 2),
(3, 'Paris Dream4', '5-day tour', 5, 2200.00, 3, 3, 3),
(4, 'Summer Special3', '6-day desert safari', 6, 2800.00, 4, 4, 4),
(5, 'Toronto Explorer', '4-day nature retreat', 4, 1100.00, 5, 5, 5),
(6, 'Summer Special4', '8-day historical experience', 8, 1800.00, 6, 6, 6);

select * from Hotel;

INSERT INTO Booking (BookingDate, TravelDate, TotalAmount, CustomerID, AgentID, PackageID) VALUES
('2025-03-01', '2025-04-10', 1200.00, 1, 1, 1),
('2025-03-05', '2025-06-15', 2000.00, 2, 2, 2),
('2025-03-10', '2025-07-20', 2200.00, 3, 3, 3),
('2025-04-01', '2025-08-25', 2800.00, 4, 4, 4),
('2025-04-15', '2025-09-30', 1100.00, 5, 5, 5),
('2025-05-01', '2025-10-10', 1800.00, 6, 6, 6);

INSERT INTO Payment (PaymentDate, Amount, PaymentMethod, BookingID) VALUES
('2025-03-02', 1200.00, 'Credit Card', 1),
('2025-03-06', 2000.00, 'PayPal', 2),
('2025-03-12', 2200.00, 'Debit Card', 3),
('2025-04-02', 2800.00, 'Cash', 4),
('2025-04-16', 1100.00, 'Credit Card', 5),
('2025-05-02', 1800.00, 'PayPal', 6);


-- Quries
SELECT
  p.PackageID,
  p.PackageName,
  p.Duration,
  p.Price,
  h.HotelID,
  h.HotelName,
  h.Location,
  h.RoomType,
  h.PricePerNight
FROM
  Package p
  JOIN Hotel h ON p.HotelID = h.HotelID
ORDER BY
  p.PackageID;

  
  SELECT a.name, count(b.BookingID) AS Bookings_Assigned
  FROM Agent a
  JOIN Booking b ON a.AgentID = b.AgentID
  GROUP BY a.name
  ORDER BY a.name;
  

SELECT c.CustomerID, c.name, COUNT(b.BookingID) AS Bookings
FROM Customer c
JOIN Booking b on c.CustomerID = b.CustomerID
GROUP BY c.CustomerID
ORDER BY c.CustomerID;

SELECT b.BookingID, c.Name AS CustomerName, p.PackageName, b.TravelDate, b.TotalAmount
FROM Booking b
JOIN Customer c ON b.CustomerID = c.CustomerID
JOIN Package p ON b.PackageID = p.PackageID;