create database HolyBirdResort
go

use HolyBirdResort
go

-- employee table
create table Employee (
    EmployeeID int primary key identity,
    Name nvarchar(100),
    Role nvarchar(50) check (Role in (N'Quản lí', N'Lễ Tân'))
)

-- room table
create table Room (
    RoomID int primary key,
    Type nvarchar(50),
    Floor int check (Floor between 1 and 13),
    Price money,
    SingleBed int,
    CoupleBed int,
    NumberPerson int,
	Status nvarchar(50) check (Status in (N'Trống', N'Đã đặt', N'Đang thanh toán'))
)

-- group table
create table GroupBusiness(
	GroupID nvarchar(5) primary key,
	Name nvarchar(50)
)

-- agency table
create table Agency (
    AgencyID int primary key identity,
    Name nvarchar(100),
    Phone nvarchar(15) check (Phone is null or Phone like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
    Email nvarchar(100) null,
    Address nvarchar(max)
)

-- customer table
create table Customer (
    CustomerID int primary key identity,
	GroupID nvarchar(5),
    Name nvarchar(100),
    Phone nvarchar(15) check (Phone is null or Phone like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
    Email nvarchar(100) null,
    CMND nvarchar(20) check (CMND like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]') unique,
    Address nvarchar(max) null,
    Role nvarchar(50) check (Role in (N'Trưởng Đoàn', N'Nhân Viên')),
	foreign key (GroupID) references GroupBusiness(GroupID)
)

-- booking table
create table Booking (
    BookingID int primary key identity,
    GroupID nvarchar(5),
    CustomerID int,
    AgencyID int,
    NamePerson nvarchar(100),
    Deposit money null,
    StartDate datetime,
    EndDate datetime,
    PriceTotal money,
    NumberRoom int,
	foreign key (GroupID) references GroupBusiness(GroupID),
    foreign key (CustomerID) references Customer(CustomerID),
    foreign key (AgencyID) references Agency(AgencyID)
)

-- bookingdetail table
create table BookingDetail (
    BookingDetailID int primary key identity,
    BookingID int,
    CustomerID int,
    RoomID int,
	GroupID nvarchar(5),
	Name nvarchar(50),
    StartDate datetime,
    EndDate datetime,
    Price money,
    SubTotal money,
    CompensationFee money default 0, -- khoản bồi thường
	foreign key (BookingID) references Booking(BookingID),
    foreign key (CustomerID) references Customer(CustomerID),
    foreign key (RoomID) references Room(RoomID),
	foreign key (GroupID) references GroupBusiness(GroupID)
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

-- account table
create table Account (
    AccountID int primary key identity,
    GroupID nvarchar(5),
    Username nvarchar(50) unique,
    Password nvarchar(255),
    foreign key (GroupID) references GroupBusiness(GroupID)
)

-- card table
create table Card (
    CardID int primary key identity,
    RoomID int,
	CustomerID int,
    foreign key (RoomID) references Room(RoomID),
    foreign key (CustomerID) references Customer(CustomerID)
)

-- payment table
create table Payment (
    PaymentID int primary key identity,
    CustomerID int,
    BookingID int,
	AccountID int,
    Price money,
    PaymentDate datetime,
    Status nvarchar(50),
	foreign key (CustomerID) references Customer(CustomerID),
    foreign key (BookingID) references Booking(BookingID),
	foreign key (AccountID) references Account(AccountID)
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

-- dữ liệu Nhân viên khách sạn
insert into dbo.Employee(Name, Role) values
	(N'Nguyễn Khắc Sơn', N'Quản Lí'),
	(N'Nguyễn Duy Tùng', N'Lễ Tân'),
	(N'Nguyễn Tuấn Phát', N'Lễ Tân'),
	(N'Nguyễn Văn Danh', N'Lễ Tân'),
	(N'Trần Thị Ngọc Hoa', N'Lễ Tân')
go

select * from dbo.Employee
go

-- Dữ liệu cho phòng gồm 13 tầng, 20 tầng
-- status gồm: trống, đã đặt, đang thanh toán
insert into dbo.Room(RoomID, Type, Floor, Price, SingleBed, CoupleBed, NumberPerson, Status) values
	--tầng 1
	(101, N'Phòng Hạng Vừa', 1, 500000, 2, 0, 2, N'Trống'),
	(102, N'Phòng Hạng Sang', 1, 1000000, 0, 1, 4, N'Trống'),
	(103, N'Phòng Hạng Vừa', 1, 500000, 2, 0, 2, N'Trống'),
	(104, N'Phòng Hạng Sang', 1, 1000000, 0, 1, 4, N'Trống'),
	(105, N'Phòng Hạng Vừa', 1, 500000, 2, 0, 2, N'Trống'),
	(106, N'Phòng Hạng Sang', 1, 1000000, 0, 1, 4, N'Trống'),
	(107, N'Phòng Hạng Vừa', 1, 500000, 2, 0, 2, N'Trống'),
	(108, N'Phòng Hạng Sang', 1, 1000000, 0, 1, 4, N'Trống'),
	(109, N'Phòng Hạng Vừa', 1, 500000, 2, 0, 2, N'Trống'),
	(110, N'Phòng Hạng Sang', 1, 1000000, 0, 1, 4, N'Trống'),
	(111, N'Phòng Hạng Vừa', 1, 500000, 2, 0, 2, N'Trống'),
	(112, N'Phòng Hạng Sang', 1, 1000000, 0, 1, 4, N'Trống'),
	(113, N'Phòng Hạng Vừa', 1, 500000, 2, 0, 2, N'Trống'),
	(114, N'Phòng Hạng Sang', 1, 1000000, 0, 1, 4, N'Trống'),
	(115, N'Phòng Hạng Vừa', 1, 500000, 2, 0, 2, N'Trống'),
	(116, N'Phòng Hạng Sang', 1, 1000000, 0, 1, 4, N'Trống'),
	(117, N'Phòng Hạng Vừa', 1, 500000, 2, 0, 2, N'Trống'),
	(118, N'Phòng Hạng Sang', 1, 1000000, 0, 1, 4, N'Trống'),
	(119, N'Phòng Hạng Vừa', 1, 500000, 2, 0, 2, N'Trống'),
	(120, N'Phòng Hạng Sang', 1, 1000000, 0, 1, 4, N'Trống'),
	--tầng 2
	(201, N'Phòng Hạng Vừa', 1, 500000, 2, 0, 2, N'Trống'),
	(202, N'Phòng Hạng Sang', 1, 1000000, 0, 1, 4, N'Trống'),
	(203, N'Phòng Hạng Vừa', 1, 500000, 2, 0, 2, N'Trống'),
	(204, N'Phòng Hạng Sang', 1, 1000000, 0, 1, 4, N'Trống'),
	(205, N'Phòng Hạng Vừa', 1, 500000, 2, 0, 2, N'Trống'),
	(206, N'Phòng Hạng Sang', 1, 1000000, 0, 1, 4, N'Trống'),
	(207, N'Phòng Hạng Vừa', 1, 500000, 2, 0, 2, N'Trống'),
	(208, N'Phòng Hạng Sang', 1, 1000000, 0, 1, 4, N'Trống'),
	(209, N'Phòng Hạng Vừa', 1, 500000, 2, 0, 2, N'Trống'),
	(210, N'Phòng Hạng Sang', 1, 1000000, 0, 1, 4, N'Trống'),
	(211, N'Phòng Hạng Vừa', 1, 500000, 2, 0, 2, N'Trống'),
	(212, N'Phòng Hạng Sang', 1, 1000000, 0, 1, 4, N'Trống'),
	(213, N'Phòng Hạng Vừa', 1, 500000, 2, 0, 2, N'Trống'),
	(214, N'Phòng Hạng Sang', 1, 1000000, 0, 1, 4, N'Trống'),
	(215, N'Phòng Hạng Vừa', 1, 500000, 2, 0, 2, N'Trống'),
	(216, N'Phòng Hạng Sang', 1, 1000000, 0, 1, 4, N'Trống'),
	(217, N'Phòng Hạng Vừa', 1, 500000, 2, 0, 2, N'Trống'),
	(218, N'Phòng Hạng Sang', 1, 1000000, 0, 1, 4, N'Trống'),
	(219, N'Phòng Hạng Vừa', 1, 500000, 2, 0, 2, N'Trống'),
	(220, N'Phòng Hạng Sang', 1, 1000000, 0, 1, 4, N'Trống'),
    --tầng 3
    (301, N'Phòng Hạng Vừa', 1, 500000, 2, 0, 2, N'Trống'),
	(302, N'Phòng Hạng Sang', 1, 1000000, 0, 1, 4, N'Trống'),
	(303, N'Phòng Hạng Vừa', 1, 500000, 2, 0, 2, N'Trống'),
	(304, N'Phòng Hạng Sang', 1, 1000000, 0, 1, 4, N'Trống'),
	(305, N'Phòng Hạng Vừa', 1, 500000, 2, 0, 2, N'Trống'),
	(306, N'Phòng Hạng Sang', 1, 1000000, 0, 1, 4, N'Trống'),
	(307, N'Phòng Hạng Vừa', 1, 500000, 2, 0, 2, N'Trống'),
	(308, N'Phòng Hạng Sang', 1, 1000000, 0, 1, 4, N'Trống'),
	(309, N'Phòng Hạng Vừa', 1, 500000, 2, 0, 2, N'Trống'),
	(310, N'Phòng Hạng Sang', 1, 1000000, 0, 1, 4, N'Trống'),
	(311, N'Phòng Hạng Vừa', 1, 500000, 2, 0, 2, N'Trống'),
	(312, N'Phòng Hạng Sang', 1, 1000000, 0, 1, 4, N'Trống'),
	(313, N'Phòng Hạng Vừa', 1, 500000, 2, 0, 2, N'Trống'),
	(314, N'Phòng Hạng Sang', 1, 1000000, 0, 1, 4, N'Trống'),
	(315, N'Phòng Hạng Vừa', 1, 500000, 2, 0, 2, N'Trống'),
	(316, N'Phòng Hạng Sang', 1, 1000000, 0, 1, 4, N'Trống'),
	(317, N'Phòng Hạng Vừa', 1, 500000, 2, 0, 2, N'Trống'),
	(318, N'Phòng Hạng Sang', 1, 1000000, 0, 1, 4, N'Trống'),
	(319, N'Phòng Hạng Vừa', 1, 500000, 2, 0, 2, N'Trống'),
	(320, N'Phòng Hạng Sang', 1, 1000000, 0, 1, 4, N'Trống'),
    --tầng 4
    (401, N'Phòng Hạng Vừa', 1, 500000, 2, 0, 2, N'Trống'),
	(402, N'Phòng Hạng Sang', 1, 1000000, 0, 1, 4, N'Trống'),
	(403, N'Phòng Hạng Vừa', 1, 500000, 2, 0, 2, N'Trống'),
	(404, N'Phòng Hạng Sang', 1, 1000000, 0, 1, 4, N'Trống'),
	(405, N'Phòng Hạng Vừa', 1, 500000, 2, 0, 2, N'Trống'),
	(406, N'Phòng Hạng Sang', 1, 1000000, 0, 1, 4, N'Trống'),
	(407, N'Phòng Hạng Vừa', 1, 500000, 2, 0, 2, N'Trống'),
	(408, N'Phòng Hạng Sang', 1, 1000000, 0, 1, 4, N'Trống'),
	(409, N'Phòng Hạng Vừa', 1, 500000, 2, 0, 2, N'Trống'),
	(410, N'Phòng Hạng Sang', 1, 1000000, 0, 1, 4, N'Trống'),
	(411, N'Phòng Hạng Vừa', 1, 500000, 2, 0, 2, N'Trống'),
	(412, N'Phòng Hạng Sang', 1, 1000000, 0, 1, 4, N'Trống'),
	(413, N'Phòng Hạng Vừa', 1, 500000, 2, 0, 2, N'Trống'),
	(414, N'Phòng Hạng Sang', 1, 1000000, 0, 1, 4, N'Trống'),
	(415, N'Phòng Hạng Vừa', 1, 500000, 2, 0, 2, N'Trống'),
	(416, N'Phòng Hạng Sang', 1, 1000000, 0, 1, 4, N'Trống'),
	(417, N'Phòng Hạng Vừa', 1, 500000, 2, 0, 2, N'Trống'),
	(418, N'Phòng Hạng Sang', 1, 1000000, 0, 1, 4, N'Trống'),
	(419, N'Phòng Hạng Vừa', 1, 500000, 2, 0, 2, N'Trống'),
	(420, N'Phòng Hạng Sang', 1, 1000000, 0, 1, 4, N'Trống'),
    --tầng 5
    (501, N'Phòng Hạng Vừa', 1, 500000, 2, 0, 2, N'Trống'),
	(502, N'Phòng Hạng Sang', 1, 1000000, 0, 1, 4, N'Trống'),
	(503, N'Phòng Hạng Vừa', 1, 500000, 2, 0, 2, N'Trống'),
	(504, N'Phòng Hạng Sang', 1, 1000000, 0, 1, 4, N'Trống'),
	(505, N'Phòng Hạng Vừa', 1, 500000, 2, 0, 2, N'Trống'),
	(506, N'Phòng Hạng Sang', 1, 1000000, 0, 1, 4, N'Trống'),
	(507, N'Phòng Hạng Vừa', 1, 500000, 2, 0, 2, N'Trống'),
	(508, N'Phòng Hạng Sang', 1, 1000000, 0, 1, 4, N'Trống'),
	(509, N'Phòng Hạng Vừa', 1, 500000, 2, 0, 2, N'Trống'),
	(510, N'Phòng Hạng Sang', 1, 1000000, 0, 1, 4, N'Trống'),
	(511, N'Phòng Hạng Vừa', 1, 500000, 2, 0, 2, N'Trống'),
	(512, N'Phòng Hạng Sang', 1, 1000000, 0, 1, 4, N'Trống'),
	(513, N'Phòng Hạng Vừa', 1, 500000, 2, 0, 2, N'Trống'),
	(514, N'Phòng Hạng Sang', 1, 1000000, 0, 1, 4, N'Trống'),
	(515, N'Phòng Hạng Vừa', 1, 500000, 2, 0, 2, N'Trống'),
	(516, N'Phòng Hạng Sang', 1, 1000000, 0, 1, 4, N'Trống'),
	(517, N'Phòng Hạng Vừa', 1, 500000, 2, 0, 2, N'Trống'),
	(518, N'Phòng Hạng Sang', 1, 1000000, 0, 1, 4, N'Trống'),
	(519, N'Phòng Hạng Vừa', 1, 500000, 2, 0, 2, N'Trống'),
	(520, N'Phòng Hạng Sang', 1, 1000000, 0, 1, 4, N'Trống'),
    --tầng 6
    (601, N'Phòng Hạng Vừa', 1, 500000, 2, 0, 2, N'Trống'),
	(602, N'Phòng Hạng Sang', 1, 1000000, 0, 1, 4, N'Trống'),
	(603, N'Phòng Hạng Vừa', 1, 500000, 2, 0, 2, N'Trống'),
	(604, N'Phòng Hạng Sang', 1, 1000000, 0, 1, 4, N'Trống'),
	(605, N'Phòng Hạng Vừa', 1, 500000, 2, 0, 2, N'Trống'),
	(606, N'Phòng Hạng Sang', 1, 1000000, 0, 1, 4, N'Trống'),
	(607, N'Phòng Hạng Vừa', 1, 500000, 2, 0, 2, N'Trống'),
	(608, N'Phòng Hạng Sang', 1, 1000000, 0, 1, 4, N'Trống'),
	(609, N'Phòng Hạng Vừa', 1, 500000, 2, 0, 2, N'Trống'),
	(610, N'Phòng Hạng Sang', 1, 1000000, 0, 1, 4, N'Trống'),
	(611, N'Phòng Hạng Vừa', 1, 500000, 2, 0, 2, N'Trống'),
	(612, N'Phòng Hạng Sang', 1, 1000000, 0, 1, 4, N'Trống'),
	(613, N'Phòng Hạng Vừa', 1, 500000, 2, 0, 2, N'Trống'),
	(614, N'Phòng Hạng Sang', 1, 1000000, 0, 1, 4, N'Trống'),
	(615, N'Phòng Hạng Vừa', 1, 500000, 2, 0, 2, N'Trống'),
	(616, N'Phòng Hạng Sang', 1, 1000000, 0, 1, 4, N'Trống'),
	(617, N'Phòng Hạng Vừa', 1, 500000, 2, 0, 2, N'Trống'),
	(618, N'Phòng Hạng Sang', 1, 1000000, 0, 1, 4, N'Trống'),
	(619, N'Phòng Hạng Vừa', 1, 500000, 2, 0, 2, N'Trống'),
	(620, N'Phòng Hạng Sang', 1, 1000000, 0, 1, 4, N'Trống'),
    --tầng 7
    (701, N'Phòng Hạng Vừa', 1, 500000, 2, 0, 2, N'Trống'),
	(702, N'Phòng Hạng Sang', 1, 1000000, 0, 1, 4, N'Trống'),
	(703, N'Phòng Hạng Vừa', 1, 500000, 2, 0, 2, N'Trống'),
	(704, N'Phòng Hạng Sang', 1, 1000000, 0, 1, 4, N'Trống'),
	(705, N'Phòng Hạng Vừa', 1, 500000, 2, 0, 2, N'Trống'),
	(706, N'Phòng Hạng Sang', 1, 1000000, 0, 1, 4, N'Trống'),
	(707, N'Phòng Hạng Vừa', 1, 500000, 2, 0, 2, N'Trống'),
	(708, N'Phòng Hạng Sang', 1, 1000000, 0, 1, 4, N'Trống'),
	(709, N'Phòng Hạng Vừa', 1, 500000, 2, 0, 2, N'Trống'),
	(710, N'Phòng Hạng Sang', 1, 1000000, 0, 1, 4, N'Trống'),
	(711, N'Phòng Hạng Vừa', 1, 500000, 2, 0, 2, N'Trống'),
	(712, N'Phòng Hạng Sang', 1, 1000000, 0, 1, 4, N'Trống'),
	(713, N'Phòng Hạng Vừa', 1, 500000, 2, 0, 2, N'Trống'),
	(714, N'Phòng Hạng Sang', 1, 1000000, 0, 1, 4, N'Trống'),
	(715, N'Phòng Hạng Vừa', 1, 500000, 2, 0, 2, N'Trống'),
	(716, N'Phòng Hạng Sang', 1, 1000000, 0, 1, 4, N'Trống'),
	(717, N'Phòng Hạng Vừa', 1, 500000, 2, 0, 2, N'Trống'),
	(718, N'Phòng Hạng Sang', 1, 1000000, 0, 1, 4, N'Trống'),
	(719, N'Phòng Hạng Vừa', 1, 500000, 2, 0, 2, N'Trống'),
	(720, N'Phòng Hạng Sang', 1, 1000000, 0, 1, 4, N'Trống'),
    --tầng 8
    (801, N'Phòng Hạng Vừa', 1, 500000, 2, 0, 2, N'Trống'),
	(802, N'Phòng Hạng Sang', 1, 1000000, 0, 1, 4, N'Trống'),
	(803, N'Phòng Hạng Vừa', 1, 500000, 2, 0, 2, N'Trống'),
	(804, N'Phòng Hạng Sang', 1, 1000000, 0, 1, 4, N'Trống'),
	(805, N'Phòng Hạng Vừa', 1, 500000, 2, 0, 2, N'Trống'),
	(806, N'Phòng Hạng Sang', 1, 1000000, 0, 1, 4, N'Trống'),
	(807, N'Phòng Hạng Vừa', 1, 500000, 2, 0, 2, N'Trống'),
	(808, N'Phòng Hạng Sang', 1, 1000000, 0, 1, 4, N'Trống'),
	(809, N'Phòng Hạng Vừa', 1, 500000, 2, 0, 2, N'Trống'),
	(810, N'Phòng Hạng Sang', 1, 1000000, 0, 1, 4, N'Trống'),
	(811, N'Phòng Hạng Vừa', 1, 500000, 2, 0, 2, N'Trống'),
	(812, N'Phòng Hạng Sang', 1, 1000000, 0, 1, 4, N'Trống'),
	(813, N'Phòng Hạng Vừa', 1, 500000, 2, 0, 2, N'Trống'),
	(814, N'Phòng Hạng Sang', 1, 1000000, 0, 1, 4, N'Trống'),
	(815, N'Phòng Hạng Vừa', 1, 500000, 2, 0, 2, N'Trống'),
	(816, N'Phòng Hạng Sang', 1, 1000000, 0, 1, 4, N'Trống'),
	(817, N'Phòng Hạng Vừa', 1, 500000, 2, 0, 2, N'Trống'),
	(818, N'Phòng Hạng Sang', 1, 1000000, 0, 1, 4, N'Trống'),
	(819, N'Phòng Hạng Vừa', 1, 500000, 2, 0, 2, N'Trống'),
	(820, N'Phòng Hạng Sang', 1, 1000000, 0, 1, 4, N'Trống'),
    --tầng 9
    (901, N'Phòng Hạng Vừa', 1, 500000, 2, 0, 2, N'Trống'),
	(902, N'Phòng Hạng Sang', 1, 1000000, 0, 1, 4, N'Trống'),
	(903, N'Phòng Hạng Vừa', 1, 500000, 2, 0, 2, N'Trống'),
	(904, N'Phòng Hạng Sang', 1, 1000000, 0, 1, 4, N'Trống'),
	(905, N'Phòng Hạng Vừa', 1, 500000, 2, 0, 2, N'Trống'),
	(906, N'Phòng Hạng Sang', 1, 1000000, 0, 1, 4, N'Trống'),
	(907, N'Phòng Hạng Vừa', 1, 500000, 2, 0, 2, N'Trống'),
	(908, N'Phòng Hạng Sang', 1, 1000000, 0, 1, 4, N'Trống'),
	(909, N'Phòng Hạng Vừa', 1, 500000, 2, 0, 2, N'Trống'),
	(910, N'Phòng Hạng Sang', 1, 1000000, 0, 1, 4, N'Trống'),
	(911, N'Phòng Hạng Vừa', 1, 500000, 2, 0, 2, N'Trống'),
	(912, N'Phòng Hạng Sang', 1, 1000000, 0, 1, 4, N'Trống'),
	(913, N'Phòng Hạng Vừa', 1, 500000, 2, 0, 2, N'Trống'),
	(914, N'Phòng Hạng Sang', 1, 1000000, 0, 1, 4, N'Trống'),
	(915, N'Phòng Hạng Vừa', 1, 500000, 2, 0, 2, N'Trống'),
	(916, N'Phòng Hạng Sang', 1, 1000000, 0, 1, 4, N'Trống'),
	(917, N'Phòng Hạng Vừa', 1, 500000, 2, 0, 2, N'Trống'),
	(918, N'Phòng Hạng Sang', 1, 1000000, 0, 1, 4, N'Trống'),
	(919, N'Phòng Hạng Vừa', 1, 500000, 2, 0, 2, N'Trống'),
	(920, N'Phòng Hạng Sang', 1, 1000000, 0, 1, 4, N'Trống'),
    --tầng 10
    (1001, N'Phòng Hạng Vừa', 1, 500000, 2, 0, 2, N'Trống'),
	(1002, N'Phòng Hạng Sang', 1, 1000000, 0, 1, 4, N'Trống'),
	(1003, N'Phòng Hạng Vừa', 1, 500000, 2, 0, 2, N'Trống'),
	(1004, N'Phòng Hạng Sang', 1, 1000000, 0, 1, 4, N'Trống'),
	(1005, N'Phòng Hạng Vừa', 1, 500000, 2, 0, 2, N'Trống'),
	(1006, N'Phòng Hạng Sang', 1, 1000000, 0, 1, 4, N'Trống'),
	(1007, N'Phòng Hạng Vừa', 1, 500000, 2, 0, 2, N'Trống'),
	(1008, N'Phòng Hạng Sang', 1, 1000000, 0, 1, 4, N'Trống'),
	(1009, N'Phòng Hạng Vừa', 1, 500000, 2, 0, 2, N'Trống'),
	(1010, N'Phòng Hạng Sang', 1, 1000000, 0, 1, 4, N'Trống'),
	(1011, N'Phòng Hạng Vừa', 1, 500000, 2, 0, 2, N'Trống'),
	(1012, N'Phòng Hạng Sang', 1, 1000000, 0, 1, 4, N'Trống'),
	(1013, N'Phòng Hạng Vừa', 1, 500000, 2, 0, 2, N'Trống'),
	(1014, N'Phòng Hạng Sang', 1, 1000000, 0, 1, 4, N'Trống'),
	(1015, N'Phòng Hạng Vừa', 1, 500000, 2, 0, 2, N'Trống'),
	(1016, N'Phòng Hạng Sang', 1, 1000000, 0, 1, 4, N'Trống'),
	(1017, N'Phòng Hạng Vừa', 1, 500000, 2, 0, 2, N'Trống'),
	(1018, N'Phòng Hạng Sang', 1, 1000000, 0, 1, 4, N'Trống'),
	(1019, N'Phòng Hạng Vừa', 1, 500000, 2, 0, 2, N'Trống'),
	(1020, N'Phòng Hạng Sang', 1, 1000000, 0, 1, 4, N'Trống'),
    --tầng 11
    (1101, N'Phòng Hạng Vừa', 1, 500000, 2, 0, 2, N'Trống'),
	(1102, N'Phòng Hạng Sang', 1, 1000000, 0, 1, 4, N'Trống'),
	(1103, N'Phòng Hạng Vừa', 1, 500000, 2, 0, 2, N'Trống'),
	(1104, N'Phòng Hạng Sang', 1, 1000000, 0, 1, 4, N'Trống'),
	(1105, N'Phòng Hạng Vừa', 1, 500000, 2, 0, 2, N'Trống'),
	(1106, N'Phòng Hạng Sang', 1, 1000000, 0, 1, 4, N'Trống'),
	(1107, N'Phòng Hạng Vừa', 1, 500000, 2, 0, 2, N'Trống'),
	(1108, N'Phòng Hạng Sang', 1, 1000000, 0, 1, 4, N'Trống'),
	(1109, N'Phòng Hạng Vừa', 1, 500000, 2, 0, 2, N'Trống'),
	(1110, N'Phòng Hạng Sang', 1, 1000000, 0, 1, 4, N'Trống'),
	(1111, N'Phòng Hạng Vừa', 1, 500000, 2, 0, 2, N'Trống'),
	(1112, N'Phòng Hạng Sang', 1, 1000000, 0, 1, 4, N'Trống'),
	(1113, N'Phòng Hạng Vừa', 1, 500000, 2, 0, 2, N'Trống'),
	(1114, N'Phòng Hạng Sang', 1, 1000000, 0, 1, 4, N'Trống'),
	(1115, N'Phòng Hạng Vừa', 1, 500000, 2, 0, 2, N'Trống'),
	(1116, N'Phòng Hạng Sang', 1, 1000000, 0, 1, 4, N'Trống'),
	(1117, N'Phòng Hạng Vừa', 1, 500000, 2, 0, 2, N'Trống'),
	(1118, N'Phòng Hạng Sang', 1, 1000000, 0, 1, 4, N'Trống'),
	(1119, N'Phòng Hạng Vừa', 1, 500000, 2, 0, 2, N'Trống'),
	(1120, N'Phòng Hạng Sang', 1, 1000000, 0, 1, 4, N'Trống'),
    --tầng 12
    (1201, N'Phòng Hạng Vừa', 1, 500000, 2, 0, 2, N'Trống'),
	(1202, N'Phòng Hạng Sang', 1, 1000000, 0, 1, 4, N'Trống'),
	(1203, N'Phòng Hạng Vừa', 1, 500000, 2, 0, 2, N'Trống'),
	(1204, N'Phòng Hạng Sang', 1, 1000000, 0, 1, 4, N'Trống'),
	(1205, N'Phòng Hạng Vừa', 1, 500000, 2, 0, 2, N'Trống'),
	(1206, N'Phòng Hạng Sang', 1, 1000000, 0, 1, 4, N'Trống'),
	(1207, N'Phòng Hạng Vừa', 1, 500000, 2, 0, 2, N'Trống'),
	(1208, N'Phòng Hạng Sang', 1, 1000000, 0, 1, 4, N'Trống'),
	(1209, N'Phòng Hạng Vừa', 1, 500000, 2, 0, 2, N'Trống'),
	(1210, N'Phòng Hạng Sang', 1, 1000000, 0, 1, 4, N'Trống'),
	(1211, N'Phòng Hạng Vừa', 1, 500000, 2, 0, 2, N'Trống'),
	(1212, N'Phòng Hạng Sang', 1, 1000000, 0, 1, 4, N'Trống'),
	(1213, N'Phòng Hạng Vừa', 1, 500000, 2, 0, 2, N'Trống'),
	(1214, N'Phòng Hạng Sang', 1, 1000000, 0, 1, 4, N'Trống'),
	(1215, N'Phòng Hạng Vừa', 1, 500000, 2, 0, 2, N'Trống'),
	(1216, N'Phòng Hạng Sang', 1, 1000000, 0, 1, 4, N'Trống'),
	(1217, N'Phòng Hạng Vừa', 1, 500000, 2, 0, 2, N'Trống'),
	(1218, N'Phòng Hạng Sang', 1, 1000000, 0, 1, 4, N'Trống'),
	(1219, N'Phòng Hạng Vừa', 1, 500000, 2, 0, 2, N'Trống'),
	(1220, N'Phòng Hạng Sang', 1, 1000000, 0, 1, 4, N'Trống'),
    --tầng 13
    (1301, N'Phòng Hạng Vừa', 1, 500000, 2, 0, 2, N'Trống'),
	(1302, N'Phòng Hạng Sang', 1, 1000000, 0, 1, 4, N'Trống'),
	(1303, N'Phòng Hạng Vừa', 1, 500000, 2, 0, 2, N'Trống'),
	(1304, N'Phòng Hạng Sang', 1, 1000000, 0, 1, 4, N'Trống'),
	(1305, N'Phòng Hạng Vừa', 1, 500000, 2, 0, 2, N'Trống'),
	(1306, N'Phòng Hạng Sang', 1, 1000000, 0, 1, 4, N'Trống'),
	(1307, N'Phòng Hạng Vừa', 1, 500000, 2, 0, 2, N'Trống'),
	(1308, N'Phòng Hạng Sang', 1, 1000000, 0, 1, 4, N'Trống'),
	(1309, N'Phòng Hạng Vừa', 1, 500000, 2, 0, 2, N'Trống'),
	(1310, N'Phòng Hạng Sang', 1, 1000000, 0, 1, 4, N'Trống'),
	(1311, N'Phòng Hạng Vừa', 1, 500000, 2, 0, 2, N'Trống'),
	(1312, N'Phòng Hạng Sang', 1, 1000000, 0, 1, 4, N'Trống'),
	(1313, N'Phòng Hạng Vừa', 1, 500000, 2, 0, 2, N'Trống'),
	(1314, N'Phòng Hạng Sang', 1, 1000000, 0, 1, 4, N'Trống'),
	(1315, N'Phòng Hạng Vừa', 1, 500000, 2, 0, 2, N'Trống'),
	(1316, N'Phòng Hạng Sang', 1, 1000000, 0, 1, 4, N'Trống'),
	(1317, N'Phòng Hạng Vừa', 1, 500000, 2, 0, 2, N'Trống'),
	(1318, N'Phòng Hạng Sang', 1, 1000000, 0, 1, 4, N'Trống'),
	(1319, N'Phòng Hạng Vừa', 1, 500000, 2, 0, 2, N'Trống'),
	(1320, N'Phòng Hạng Sang', 1, 1000000, 0, 1, 4, N'Trống')
go

select * from dbo.Room
go

-- Dữ liệu GroupBusiness
insert into dbo.GroupBusiness(GroupID, Name) values 
	(N'A001', N'Công Ty S'),
	(N'B002', N'Công Ty F'),
	(N'C003', N'Công Ty P'),
	(N'D004', N'Công Ty T'),
	(N'F005', N'Công Ty N')
go

select * from dbo.GroupBusiness
go

-- Dữ liệu Agency
insert into dbo.Agency(Name, Phone, Email, Address) values
	(N'HolyBirdResort', '0123456789', 'holybirdresort@gmail.com', N'Nha Trang, Việt Nam'),
	(N'HolyBirdResort 2', '0987654321', 'holybirdresortchinhanh2@gmail.com', N'467 Lê Văn Thọ, Phường 09, Quận Gò Vấp, Hồ Chí Minh, Việt Nam'),
	(N'HolyBirdResort 3', '0864213579', 'holybirdresortchinhanh3@gmail.com', N'78/4 Quốc lộ 1, Phường Linh Trung, Quận Thủ Đức, Hồ Chí Minh, Việt Nam')
go

select * from dbo.Agency
go

-- Các quy trình chính

-- a. Đăng ký

create function KiemTraTrangThaiToanBoPhong() returns table
as
	return (
		select dbo.Room.RoomID from dbo.Room where dbo.Room.Status = N'Trống'
	)
go

create function KiemTraTrangThaiPhong(@maphong int) returns int
as
begin
	declare @ketqua int, @trangthai nvarchar(20)
	select @trangthai = dbo.Room.Status from dbo.Room where dbo.Room.RoomID = @maphong
	if @trangthai <> N'Trống'
		set @ketqua = 1
	else
		set @ketqua = 0
	return @ketqua
end
go

create trigger DoiTrangThaiPhong on dbo.BookingDetail for insert
as 
begin
	if exists (select * from dbo.BookingDetail)
	begin
		begin
			update dbo.Room set Status = N'Đã đặt' from dbo.Room join inserted on dbo.Room.RoomID = inserted.RoomID
		end
	end
end
go

create procedure DangKyGiaoDich @MaDoan nvarchar(5), @TenDaiDien nvarchar(50), @CMNDDaiDien nvarchar(15), @songuoi int, @start datetime, @end datetime, @danhsachten nvarchar(max), @danhsachcmnd nvarchar(max), @daili nvarchar(50), @phong nvarchar(max)
as
begin
	if @start > @end
	begin
		raiserror('Ngày bắt đầu phải nhỏ hơn hoặc bằng ngày kết thúc.', 16, 1)
		rollback transaction
		return
	end
	declare @listname table (ID int identity, Name nvarchar(50))
	insert into @listname (Name) select value from string_split(@danhsachten, ',')
	declare @listcmnd table (ID int identity, CMND nvarchar(50))
	insert into @listcmnd (CMND) select value from string_split(@danhsachcmnd, ',')
	if (select count(*) from @listname) <> (select count(*) from @listcmnd) or ((select count(*) from @listname) + 1) <> @songuoi or ((select count(*) from @listcmnd) + 1) <> @songuoi
	begin
		raiserror('Danh sách tên hoặc CMND không khớp với số người.', 16, 1)
        rollback transaction
		return
	end
	insert into dbo.Customer(GroupID, Name, CMND, Role) values (@MaDoan, @TenDaiDien, @CMNDDaiDien, N'Trưởng Đoàn')
	insert into dbo.Customer(GroupID, Name, CMND, Role) select @MaDoan, N.Name, C.CMND, N'Nhân Viên' from @listname N join @listcmnd C on N.ID = C.ID
	insert into dbo.Account(GroupID, Username, Password) values (@MaDoan, @CMNDDaiDien, @CMNDDaiDien)
	declare @sophong table (ID int identity, RoomID int)
	insert into @sophong (RoomID) select cast(value as int) from string_split(@phong, ',')
	if exists (
		select 1 from @sophong R where dbo.KiemTraTrangThaiPhong(R.RoomID) = 1
	)
	begin
		raiserror('Có phòng đã được đặt, không thể tiếp tục.', 16, 1)
		rollback transaction
		return
	end
	declare @priceroom int = 0
	select @priceroom = sum(dbo.Room.Price) * (case when datediff(day, @start, @end) = 0 then 1 else datediff(day, @start, @end) end) from dbo.Room where RoomID in (select R.RoomID from @sophong R)
	declare @numberroom int
	select @numberroom = count(R.RoomID) from @sophong R
	insert into dbo.Booking(GroupID, CustomerID, AgencyID, NamePerson, StartDate, EndDate, PriceTotal, NumberRoom) values 
		(@MaDoan, (select top 1 dbo.Customer.CustomerID from dbo.Customer where dbo.Customer.Name = @TenDaiDien), (select top 1 dbo.Agency.AgencyID from dbo.Agency where dbo.Agency.Name = @daili), @TenDaiDien, @start, @end, @priceroom, @numberroom)
	declare @danhsachCustomer table (ID int identity, CustomerID int)
	insert into @danhsachCustomer (CustomerID) select dbo.Customer.CustomerID from dbo.Customer where GroupID = @MaDoan
	declare @sophongdat int
	select @sophongdat = count(*) from @sophong
	insert into dbo.BookingDetail(GroupID, BookingID, CustomerID, RoomID, Name, StartDate, EndDate, Price, SubTotal, CompensationFee) select 
		@MaDoan, (select top 1 dbo.Booking.BookingID from dbo.Booking where dbo.Booking.NamePerson = @TenDaiDien), D.CustomerID, R.RoomID, (select dbo.Customer.Name from dbo.Customer where dbo.Customer.CustomerID = D.CustomerID), @start, @end, 0, 0, 0
		from @danhsachCustomer D 
		join @sophong R on (D.ID - 1) % (select count(*) from @sophong) + 1 = R.ID
end
go

--create procedure ChiTietGiaoDich 

select * from dbo.Room
go

exec dbo.DangKyGiaoDich 'A001', N'Nguyễn Duy Tùng', N'8629501437',4, '2024-06-15 10:00:00', '2024-06-20 10:00:00', N'Nguyễn Văn A,Trần Thị B,Lê Văn C', N'1864230975,8937526140,6840931527', N'HolyBirdResort', N'101,102,103'
go