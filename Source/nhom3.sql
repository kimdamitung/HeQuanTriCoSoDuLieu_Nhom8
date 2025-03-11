create database HolyBirdResort
go

use HolyBirdResort
go

-- room table
create table Room (
    RoomID int primary key,
    Type nvarchar(50),
    Floor int check (Floor between 1 and 13),
    Price money,
    SingleBed int,
    CoupleBed int,
    NumberPerson int
)

-- booking table
create table Booking (
    BookingID int primary key identity,
    GroupID int,
    CustomerID int,
    AgencyID int,
    NamePerson nvarchar(100),
    Deposit money,
    StartDate datetime,
    EndDate datetime,
    PriceTotal money,
    NumberRoom int
)

-- bookingdetail table
create table BookingDetail (
    BookingDetailID int primary key identity,
    BookingID int,
    CustomerID int,
    RoomID int,
    StartDate datetime,
    EndDate datetime,
    Price money,
    SubTotal money,
    CompensationFee money default 0, -- khoản bồi thường
    foreign key (BookingID) references Booking(BookingID),
    foreign key (RoomID) references Room(RoomID)
)

-- customer table
create table Customer (
    CustomerID int primary key identity,
    Name nvarchar(100),
    Phone nvarchar(15),
    Email nvarchar(100),
    CMND nvarchar(20),
    Address nvarchar(max),
    GroupID int,
    Role nvarchar(50)
)

-- group table
create table GroupBusiness (
	GroupID int primary key identity,
	CustomerID int,
    foreign key (CustomerID) references Customer(CustomerID)
)

-- agency table
create table Agency (
    AgencyID int primary key identity,
    Name nvarchar(100),
    Phone nvarchar(15),
    Email nvarchar(100),
    Address nvarchar(max)
)

-- payment table
create table Payment (
    Paymentid int primary key identity,
    CustomerID int,
    BookingID int,
    Price money,
    PaymentDate datetime,
    State nvarchar(50),
    AccountID int,
    foreign key (BookingID) references Booking(BookingID),
    foreign key (CustomerID) references Customer(CustomerID)
)

-- paymentdetail table
create table PaymentDetail (
    PaymentDetailID int primary key identity,
    PaymentID int,
    RoomID int,
    StateDevices nvarchar(100),
    PriceRoom money,
    SubTotal money,
    foreign key (PaymentID) references Payment(PaymentID),
    foreign key (RoomID) references Room(RoomID)
)

-- card table
create table Card (
    CardID int primary key identity,
    RoomID int,
	CustomerID int,
    foreign key (RoomID) references Room(RoomID),
    foreign key (CustomerID) references Customer(CustomerID)
)

-- account table
create table Account (
    AccountID int primary key identity,
    GroupID int,
    Username nvarchar(50) unique,
    Password nvarchar(255),
    State nvarchar(50),
    foreign key (GroupID) references GroupBusiness(GroupID)
)

-- employee table
create table Employee (
    EmployeeID int primary key identity,
    Name nvarchar(100),
    Role nvarchar(50)
)

-- compensation table (bảng bồi thường)
create table Compensation (
    CompensationID int primary key identity,
    BookingDetailID int,
    EmployeeID int,
    Description nvarchar(max),
    Amount money,
    CheckDate datetime,
    foreign key (BookingDetailID) references BookingDetail(BookingDetailID),
    foreign key (EmployeeID) references Employee(EmployeeID)
)
