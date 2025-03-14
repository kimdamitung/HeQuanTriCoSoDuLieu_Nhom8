use master
go

drop database HolyBirdResort
go

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
	Status nvarchar(50) check (Status in (N'Trống', N'Đã đặt', N'Đang sử dụng'))
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
    CMND nvarchar(20) check (CMND like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]') unique null,
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
    BookingDate datetime,
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
	RoomID int,
    EmployeeID int,
	BookingID int,
    Amount money,
    CheckDate datetime,
    Description nvarchar(max) null,
    foreign key (EmployeeID) references Employee(EmployeeID),
	foreign key (RoomID) references Room(RoomID),
	foreign key (BookingID) references Booking(BookingID)
)

-- account table
create table Account (
    AccountID int primary key identity,
    GroupID nvarchar(5),
    Username nvarchar(50) unique,
    Password nvarchar(255),
	Status nvarchar(50) check (Status in (N'Giao dịch', N'Nhận phòng'))
    foreign key (GroupID) references GroupBusiness(GroupID)
)

-- card table
create table Card (
    CardID int primary key identity,
    RoomID int,
	CustomerID int,
	BookingDetailID int,
    Status nvarchar(50) check (Status in (N'Chưa kích hoạt', N'Đã kích hoạt')) null,
    foreign key (RoomID) references Room(RoomID),
    foreign key (CustomerID) references Customer(CustomerID),
	foreign key (BookingDetailID) references BookingDetail(BookingDetailID),
)

-- payment table
create table Payment (
    PaymentID int primary key identity,
    CustomerID int,
    BookingID int,
	AccountID int,
    Price money,
    PaymentDate datetime,
    Status nvarchar(50) check (Status in (N'Chờ thanh toán', N'Thanh toán thành công')),
	foreign key (CustomerID) references Customer(CustomerID),
    foreign key (BookingID) references Booking(BookingID),
	foreign key (AccountID) references Account(AccountID)
)

-- Dữ liệu Nhân viên khách sạn
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
insert into dbo.Room(RoomID, Type, Floor, Price, SingleBed, CoupleBed, NumberPerson, Status) values
	--tầng 1
	(101, N'Phòng Hạng Vừa', 1, 500000, 2, 0, 3, N'Trống'),
	(102, N'Phòng Hạng Sang', 1, 1000000, 0, 1, 4, N'Trống'),
	(103, N'Phòng Hạng Vừa', 1, 500000, 2, 0, 3, N'Trống'),
	(104, N'Phòng Hạng Sang', 1, 1000000, 0, 1, 4, N'Trống'),
	(105, N'Phòng Hạng Vừa', 1, 500000, 2, 0, 3, N'Trống'),
	(106, N'Phòng Hạng Sang', 1, 1000000, 0, 1, 4, N'Trống'),
	(107, N'Phòng Hạng Vừa', 1, 500000, 2, 0, 3, N'Trống'),
	(108, N'Phòng Hạng Sang', 1, 1000000, 0, 1, 4, N'Trống'),
	(109, N'Phòng Hạng Vừa', 1, 500000, 2, 0, 3, N'Trống'),
	(110, N'Phòng Hạng Sang', 1, 1000000, 0, 1, 4, N'Trống'),
	(111, N'Phòng Hạng Vừa', 1, 500000, 2, 0, 3, N'Trống'),
	(112, N'Phòng Hạng Sang', 1, 1000000, 0, 1, 4, N'Trống'),
	(113, N'Phòng Hạng Vừa', 1, 500000, 2, 0, 3, N'Trống'),
	(114, N'Phòng Hạng Sang', 1, 1000000, 0, 1, 4, N'Trống'),
	(115, N'Phòng Hạng Vừa', 1, 500000, 2, 0, 3, N'Trống'),
	(116, N'Phòng Hạng Sang', 1, 1000000, 0, 1, 4, N'Trống'),
	(117, N'Phòng Hạng Vừa', 1, 500000, 2, 0, 2, N'Trống'),
	(118, N'Phòng Hạng Sang', 1, 1000000, 0, 1, 4, N'Trống'),
	(119, N'Phòng Hạng Vừa', 1, 500000, 2, 0, 2, N'Trống'),
	(120, N'Phòng Hạng Sang', 1, 1000000, 0, 1, 4, N'Trống'),
	--tầng 2
	(201, N'Phòng Hạng Vừa', 2, 500000, 2, 0, 2, N'Trống'),
	(202, N'Phòng Hạng Sang', 2, 1000000, 0, 1, 4, N'Trống'),
	(203, N'Phòng Hạng Vừa', 2, 500000, 2, 0, 2, N'Trống'),
	(204, N'Phòng Hạng Sang', 2, 1000000, 0, 1, 4, N'Trống'),
	(205, N'Phòng Hạng Vừa', 2, 500000, 2, 0, 2, N'Trống'),
	(206, N'Phòng Hạng Sang', 2, 1000000, 0, 1, 4, N'Trống'),
	(207, N'Phòng Hạng Vừa', 2, 500000, 2, 0, 2, N'Trống'),
	(208, N'Phòng Hạng Sang', 2, 1000000, 0, 1, 4, N'Trống'),
	(209, N'Phòng Hạng Vừa', 2, 500000, 2, 0, 2, N'Trống'),
	(210, N'Phòng Hạng Sang', 2, 1000000, 0, 1, 4, N'Trống'),
	(211, N'Phòng Hạng Vừa', 2, 500000, 2, 0, 2, N'Trống'),
	(212, N'Phòng Hạng Sang', 2, 1000000, 0, 1, 4, N'Trống'),
	(213, N'Phòng Hạng Vừa', 2, 500000, 2, 0, 2, N'Trống'),
	(214, N'Phòng Hạng Sang', 2, 1000000, 0, 1, 4, N'Trống'),
	(215, N'Phòng Hạng Vừa', 2, 500000, 2, 0, 2, N'Trống'),
	(216, N'Phòng Hạng Sang', 2, 1000000, 0, 1, 4, N'Trống'),
	(217, N'Phòng Hạng Vừa', 2, 500000, 2, 0, 2, N'Trống'),
	(218, N'Phòng Hạng Sang', 2, 1000000, 0, 1, 4, N'Trống'),
	(219, N'Phòng Hạng Vừa', 2, 500000, 2, 0, 2, N'Trống'),
	(220, N'Phòng Hạng Sang', 2, 1000000, 0, 1, 4, N'Trống'),
    --tầng 3
    (301, N'Phòng Hạng Vừa', 3, 500000, 2, 0, 3, N'Trống'),
	(302, N'Phòng Hạng Sang', 3, 1000000, 0, 1, 4, N'Trống'),
	(303, N'Phòng Hạng Vừa', 3, 500000, 2, 0, 3, N'Trống'),
	(304, N'Phòng Hạng Sang', 3, 1000000, 0, 1, 4, N'Trống'),
	(305, N'Phòng Hạng Vừa', 3, 500000, 2, 0, 3, N'Trống'),
	(306, N'Phòng Hạng Sang', 3, 1000000, 0, 1, 4, N'Trống'),
	(307, N'Phòng Hạng Vừa', 3, 500000, 2, 0, 3, N'Trống'),
	(308, N'Phòng Hạng Sang', 3, 1000000, 0, 1, 4, N'Trống'),
	(309, N'Phòng Hạng Vừa', 3, 500000, 2, 0, 3, N'Trống'),
	(310, N'Phòng Hạng Sang', 3, 1000000, 0, 1, 4, N'Trống'),
	(311, N'Phòng Hạng Vừa', 3, 500000, 2, 0, 3, N'Trống'),
	(312, N'Phòng Hạng Sang', 3, 1000000, 0, 1, 4, N'Trống'),
	(313, N'Phòng Hạng Vừa', 3, 500000, 2, 0, 2, N'Trống'),
	(314, N'Phòng Hạng Sang', 3, 1000000, 0, 1, 4, N'Trống'),
	(315, N'Phòng Hạng Vừa', 3, 500000, 2, 0, 2, N'Trống'),
	(316, N'Phòng Hạng Sang', 3, 1000000, 0, 1, 4, N'Trống'),
	(317, N'Phòng Hạng Vừa', 3, 500000, 2, 0, 2, N'Trống'),
	(318, N'Phòng Hạng Sang', 3, 1000000, 0, 1, 4, N'Trống'),
	(319, N'Phòng Hạng Vừa', 3, 500000, 2, 0, 2, N'Trống'),
	(320, N'Phòng Hạng Sang', 3, 1000000, 0, 1, 4, N'Trống'),
    --tầng 4
    (401, N'Phòng Hạng Vừa', 4, 500000, 2, 0, 2, N'Trống'),
	(402, N'Phòng Hạng Sang', 4, 1000000, 0, 1, 4, N'Trống'),
	(403, N'Phòng Hạng Vừa', 4, 500000, 2, 0, 2, N'Trống'),
	(404, N'Phòng Hạng Sang', 4, 1000000, 0, 1, 4, N'Trống'),
	(405, N'Phòng Hạng Vừa', 4, 500000, 2, 0, 2, N'Trống'),
	(406, N'Phòng Hạng Sang', 4, 1000000, 0, 1, 4, N'Trống'),
	(407, N'Phòng Hạng Vừa', 4, 500000, 2, 0, 2, N'Trống'),
	(408, N'Phòng Hạng Sang', 4, 1000000, 0, 1, 4, N'Trống'),
	(409, N'Phòng Hạng Vừa', 4, 500000, 2, 0, 2, N'Trống'),
	(410, N'Phòng Hạng Sang', 4, 1000000, 0, 1, 4, N'Trống'),
	(411, N'Phòng Hạng Vừa', 4, 500000, 2, 0, 2, N'Trống'),
	(412, N'Phòng Hạng Sang', 4, 1000000, 0, 1, 4, N'Trống'),
	(413, N'Phòng Hạng Vừa', 4, 500000, 2, 0, 2, N'Trống'),
	(414, N'Phòng Hạng Sang', 4, 1000000, 0, 1, 4, N'Trống'),
	(415, N'Phòng Hạng Vừa', 4, 500000, 2, 0, 2, N'Trống'),
	(416, N'Phòng Hạng Sang', 4, 1000000, 0, 1, 4, N'Trống'),
	(417, N'Phòng Hạng Vừa', 4, 500000, 2, 0, 2, N'Trống'),
	(418, N'Phòng Hạng Sang', 4, 1000000, 0, 1, 4, N'Trống'),
	(419, N'Phòng Hạng Vừa', 4, 500000, 2, 0, 2, N'Trống'),
	(420, N'Phòng Hạng Sang', 4, 1000000, 0, 1, 4, N'Trống'),
    --tầng 5
    (501, N'Phòng Hạng Vừa', 5, 500000, 2, 0, 2, N'Trống'),
	(502, N'Phòng Hạng Sang', 5, 1000000, 0, 1, 4, N'Trống'),
	(503, N'Phòng Hạng Vừa', 5, 500000, 2, 0, 2, N'Trống'),
	(504, N'Phòng Hạng Sang', 5, 1000000, 0, 1, 4, N'Trống'),
	(505, N'Phòng Hạng Vừa', 5, 500000, 2, 0, 2, N'Trống'),
	(506, N'Phòng Hạng Sang', 5, 1000000, 0, 1, 4, N'Trống'),
	(507, N'Phòng Hạng Vừa', 5, 500000, 2, 0, 2, N'Trống'),
	(508, N'Phòng Hạng Sang', 5, 1000000, 0, 1, 4, N'Trống'),
	(509, N'Phòng Hạng Vừa', 5, 500000, 2, 0, 2, N'Trống'),
	(510, N'Phòng Hạng Sang', 5, 1000000, 0, 1, 4, N'Trống'),
	(511, N'Phòng Hạng Vừa', 5, 500000, 2, 0, 2, N'Trống'),
	(512, N'Phòng Hạng Sang', 5, 1000000, 0, 1, 4, N'Trống'),
	(513, N'Phòng Hạng Vừa', 5, 500000, 2, 0, 2, N'Trống'),
	(514, N'Phòng Hạng Sang', 5, 1000000, 0, 1, 4, N'Trống'),
	(515, N'Phòng Hạng Vừa', 5, 500000, 2, 0, 2, N'Trống'),
	(516, N'Phòng Hạng Sang', 5, 1000000, 0, 1, 4, N'Trống'),
	(517, N'Phòng Hạng Vừa', 5, 500000, 2, 0, 2, N'Trống'),
	(518, N'Phòng Hạng Sang', 5, 1000000, 0, 1, 4, N'Trống'),
	(519, N'Phòng Hạng Vừa', 5, 500000, 2, 0, 2, N'Trống'),
	(520, N'Phòng Hạng Sang', 5, 1000000, 0, 1, 4, N'Trống'),
    --tầng 6
    (601, N'Phòng Hạng Vừa', 6, 500000, 2, 0, 2, N'Trống'),
	(602, N'Phòng Hạng Sang', 6, 1000000, 0, 1, 4, N'Trống'),
	(603, N'Phòng Hạng Vừa', 6, 500000, 2, 0, 2, N'Trống'),
	(604, N'Phòng Hạng Sang', 6, 1000000, 0, 1, 4, N'Trống'),
	(605, N'Phòng Hạng Vừa', 6, 500000, 2, 0, 2, N'Trống'),
	(606, N'Phòng Hạng Sang', 6, 1000000, 0, 1, 4, N'Trống'),
	(607, N'Phòng Hạng Vừa', 6, 500000, 2, 0, 2, N'Trống'),
	(608, N'Phòng Hạng Sang', 6, 1000000, 0, 1, 4, N'Trống'),
	(609, N'Phòng Hạng Vừa', 6, 500000, 2, 0, 2, N'Trống'),
	(610, N'Phòng Hạng Sang', 6, 1000000, 0, 1, 4, N'Trống'),
	(611, N'Phòng Hạng Vừa', 6, 500000, 2, 0, 2, N'Trống'),
	(612, N'Phòng Hạng Sang', 6, 1000000, 0, 1, 4, N'Trống'),
	(613, N'Phòng Hạng Vừa', 6, 500000, 2, 0, 2, N'Trống'),
	(614, N'Phòng Hạng Sang', 6, 1000000, 0, 1, 4, N'Trống'),
	(615, N'Phòng Hạng Vừa', 6, 500000, 2, 0, 2, N'Trống'),
	(616, N'Phòng Hạng Sang', 6, 1000000, 0, 1, 4, N'Trống'),
	(617, N'Phòng Hạng Vừa', 6, 500000, 2, 0, 2, N'Trống'),
	(618, N'Phòng Hạng Sang', 6, 1000000, 0, 1, 4, N'Trống'),
	(619, N'Phòng Hạng Vừa', 6, 500000, 2, 0, 2, N'Trống'),
	(620, N'Phòng Hạng Sang', 6, 1000000, 0, 1, 4, N'Trống'),
    --tầng 7
    (701, N'Phòng Hạng Vừa', 7, 500000, 2, 0, 2, N'Trống'),
	(702, N'Phòng Hạng Sang', 7, 1000000, 0, 1, 4, N'Trống'),
	(703, N'Phòng Hạng Vừa', 7, 500000, 2, 0, 2, N'Trống'),
	(704, N'Phòng Hạng Sang', 7, 1000000, 0, 1, 4, N'Trống'),
	(705, N'Phòng Hạng Vừa', 7, 500000, 2, 0, 2, N'Trống'),
	(706, N'Phòng Hạng Sang', 7, 1000000, 0, 1, 4, N'Trống'),
	(707, N'Phòng Hạng Vừa', 7, 500000, 2, 0, 2, N'Trống'),
	(708, N'Phòng Hạng Sang', 7, 1000000, 0, 1, 4, N'Trống'),
	(709, N'Phòng Hạng Vừa', 7, 500000, 2, 0, 2, N'Trống'),
	(710, N'Phòng Hạng Sang', 7, 1000000, 0, 1, 4, N'Trống'),
	(711, N'Phòng Hạng Vừa', 7, 500000, 2, 0, 2, N'Trống'),
	(712, N'Phòng Hạng Sang', 7, 1000000, 0, 1, 4, N'Trống'),
	(713, N'Phòng Hạng Vừa', 7, 500000, 2, 0, 2, N'Trống'),
	(714, N'Phòng Hạng Sang', 7, 1000000, 0, 1, 4, N'Trống'),
	(715, N'Phòng Hạng Vừa', 7, 500000, 2, 0, 2, N'Trống'),
	(716, N'Phòng Hạng Sang', 7, 1000000, 0, 1, 4, N'Trống'),
	(717, N'Phòng Hạng Vừa', 7, 500000, 2, 0, 2, N'Trống'),
	(718, N'Phòng Hạng Sang', 7, 1000000, 0, 1, 4, N'Trống'),
	(719, N'Phòng Hạng Vừa', 7, 500000, 2, 0, 2, N'Trống'),
	(720, N'Phòng Hạng Sang', 7, 1000000, 0, 1, 4, N'Trống'),
    --tầng 8
    (801, N'Phòng Hạng Vừa', 8, 500000, 2, 0, 2, N'Trống'),
	(802, N'Phòng Hạng Sang', 8, 1000000, 0, 1, 4, N'Trống'),
	(803, N'Phòng Hạng Vừa', 8, 500000, 2, 0, 2, N'Trống'),
	(804, N'Phòng Hạng Sang', 8, 1000000, 0, 1, 4, N'Trống'),
	(805, N'Phòng Hạng Vừa', 8, 500000, 2, 0, 2, N'Trống'),
	(806, N'Phòng Hạng Sang', 8, 1000000, 0, 1, 4, N'Trống'),
	(807, N'Phòng Hạng Vừa', 8, 500000, 2, 0, 2, N'Trống'),
	(808, N'Phòng Hạng Sang', 8, 1000000, 0, 1, 4, N'Trống'),
	(809, N'Phòng Hạng Vừa', 8, 500000, 2, 0, 2, N'Trống'),
	(810, N'Phòng Hạng Sang', 8, 1000000, 0, 1, 4, N'Trống'),
	(811, N'Phòng Hạng Vừa', 8, 500000, 2, 0, 2, N'Trống'),
	(812, N'Phòng Hạng Sang', 8, 1000000, 0, 1, 4, N'Trống'),
	(813, N'Phòng Hạng Vừa', 8, 500000, 2, 0, 2, N'Trống'),
	(814, N'Phòng Hạng Sang', 8, 1000000, 0, 1, 4, N'Trống'),
	(815, N'Phòng Hạng Vừa', 8, 500000, 2, 0, 2, N'Trống'),
	(816, N'Phòng Hạng Sang', 8, 1000000, 0, 1, 4, N'Trống'),
	(817, N'Phòng Hạng Vừa', 8, 500000, 2, 0, 2, N'Trống'),
	(818, N'Phòng Hạng Sang', 8, 1000000, 0, 1, 4, N'Trống'),
	(819, N'Phòng Hạng Vừa', 8, 500000, 2, 0, 2, N'Trống'),
	(820, N'Phòng Hạng Sang', 8, 1000000, 0, 1, 4, N'Trống'),
    --tầng 9
    (901, N'Phòng Hạng Vừa', 9, 500000, 2, 0, 2, N'Trống'),
	(902, N'Phòng Hạng Sang', 9, 1000000, 0, 1, 4, N'Trống'),
	(903, N'Phòng Hạng Vừa', 9, 500000, 2, 0, 2, N'Trống'),
	(904, N'Phòng Hạng Sang', 9, 1000000, 0, 1, 4, N'Trống'),
	(905, N'Phòng Hạng Vừa', 9, 500000, 2, 0, 2, N'Trống'),
	(906, N'Phòng Hạng Sang', 9, 1000000, 0, 1, 4, N'Trống'),
	(907, N'Phòng Hạng Vừa', 9, 500000, 2, 0, 2, N'Trống'),
	(908, N'Phòng Hạng Sang', 9, 1000000, 0, 1, 4, N'Trống'),
	(909, N'Phòng Hạng Vừa', 9, 500000, 2, 0, 2, N'Trống'),
	(910, N'Phòng Hạng Sang', 9, 1000000, 0, 1, 4, N'Trống'),
	(911, N'Phòng Hạng Vừa', 9, 500000, 2, 0, 2, N'Trống'),
	(912, N'Phòng Hạng Sang', 9, 1000000, 0, 1, 4, N'Trống'),
	(913, N'Phòng Hạng Vừa', 9, 500000, 2, 0, 2, N'Trống'),
	(914, N'Phòng Hạng Sang', 9, 1000000, 0, 1, 4, N'Trống'),
	(915, N'Phòng Hạng Vừa', 9, 500000, 2, 0, 2, N'Trống'),
	(916, N'Phòng Hạng Sang', 9, 1000000, 0, 1, 4, N'Trống'),
	(917, N'Phòng Hạng Vừa', 9, 500000, 2, 0, 2, N'Trống'),
	(918, N'Phòng Hạng Sang', 9, 1000000, 0, 1, 4, N'Trống'),
	(919, N'Phòng Hạng Vừa', 9, 500000, 2, 0, 2, N'Trống'),
	(920, N'Phòng Hạng Sang', 9, 1000000, 0, 1, 4, N'Trống'),
    --tầng 10
    (1001, N'Phòng Hạng Vừa', 10, 500000, 2, 0, 2, N'Trống'),
	(1002, N'Phòng Hạng Sang', 10, 1000000, 0, 1, 4, N'Trống'),
	(1003, N'Phòng Hạng Vừa', 10, 500000, 2, 0, 2, N'Trống'),
	(1004, N'Phòng Hạng Sang', 10, 1000000, 0, 1, 4, N'Trống'),
	(1005, N'Phòng Hạng Vừa', 10, 500000, 2, 0, 2, N'Trống'),
	(1006, N'Phòng Hạng Sang', 10, 1000000, 0, 1, 4, N'Trống'),
	(1007, N'Phòng Hạng Vừa', 10, 500000, 2, 0, 2, N'Trống'),
	(1008, N'Phòng Hạng Sang', 10, 1000000, 0, 1, 4, N'Trống'),
	(1009, N'Phòng Hạng Vừa', 10, 500000, 2, 0, 2, N'Trống'),
	(1010, N'Phòng Hạng Sang', 10, 1000000, 0, 1, 4, N'Trống'),
	(1011, N'Phòng Hạng Vừa', 10, 500000, 2, 0, 2, N'Trống'),
	(1012, N'Phòng Hạng Sang', 10, 1000000, 0, 1, 4, N'Trống'),
	(1013, N'Phòng Hạng Vừa', 10, 500000, 2, 0, 2, N'Trống'),
	(1014, N'Phòng Hạng Sang', 10, 1000000, 0, 1, 4, N'Trống'),
	(1015, N'Phòng Hạng Vừa', 10, 500000, 2, 0, 2, N'Trống'),
	(1016, N'Phòng Hạng Sang', 10, 1000000, 0, 1, 4, N'Trống'),
	(1017, N'Phòng Hạng Vừa', 10, 500000, 2, 0, 2, N'Trống'),
	(1018, N'Phòng Hạng Sang', 10, 1000000, 0, 1, 4, N'Trống'),
	(1019, N'Phòng Hạng Vừa', 10, 500000, 2, 0, 2, N'Trống'),
	(1020, N'Phòng Hạng Sang', 10, 1000000, 0, 1, 4, N'Trống'),
    --tầng 11
    (1101, N'Phòng Hạng Vừa', 11, 500000, 2, 0, 2, N'Trống'),
	(1102, N'Phòng Hạng Sang', 11, 1000000, 0, 1, 4, N'Trống'),
	(1103, N'Phòng Hạng Vừa', 11, 500000, 2, 0, 2, N'Trống'),
	(1104, N'Phòng Hạng Sang', 11, 1000000, 0, 1, 4, N'Trống'),
	(1105, N'Phòng Hạng Vừa', 11, 500000, 2, 0, 2, N'Trống'),
	(1106, N'Phòng Hạng Sang', 11, 1000000, 0, 1, 4, N'Trống'),
	(1107, N'Phòng Hạng Vừa', 11, 500000, 2, 0, 2, N'Trống'),
	(1108, N'Phòng Hạng Sang', 11, 1000000, 0, 1, 4, N'Trống'),
	(1109, N'Phòng Hạng Vừa', 11, 500000, 2, 0, 2, N'Trống'),
	(1110, N'Phòng Hạng Sang', 11, 1000000, 0, 1, 4, N'Trống'),
	(1111, N'Phòng Hạng Vừa', 11, 500000, 2, 0, 2, N'Trống'),
	(1112, N'Phòng Hạng Sang', 11, 1000000, 0, 1, 4, N'Trống'),
	(1113, N'Phòng Hạng Vừa', 11, 500000, 2, 0, 2, N'Trống'),
	(1114, N'Phòng Hạng Sang', 11, 1000000, 0, 1, 4, N'Trống'),
	(1115, N'Phòng Hạng Vừa', 11, 500000, 2, 0, 2, N'Trống'),
	(1116, N'Phòng Hạng Sang', 11, 1000000, 0, 1, 4, N'Trống'),
	(1117, N'Phòng Hạng Vừa', 11, 500000, 2, 0, 2, N'Trống'),
	(1118, N'Phòng Hạng Sang', 11, 1000000, 0, 1, 4, N'Trống'),
	(1119, N'Phòng Hạng Vừa', 11, 500000, 2, 0, 2, N'Trống'),
	(1120, N'Phòng Hạng Sang', 11, 1000000, 0, 1, 4, N'Trống'),
    --tầng 12
    (1201, N'Phòng Hạng Vừa', 12, 500000, 2, 0, 2, N'Trống'),
	(1202, N'Phòng Hạng Sang', 12, 1000000, 0, 1, 4, N'Trống'),
	(1203, N'Phòng Hạng Vừa', 12, 500000, 2, 0, 2, N'Trống'),
	(1204, N'Phòng Hạng Sang', 12, 1000000, 0, 1, 4, N'Trống'),
	(1205, N'Phòng Hạng Vừa', 12, 500000, 2, 0, 2, N'Trống'),
	(1206, N'Phòng Hạng Sang', 12, 1000000, 0, 1, 4, N'Trống'),
	(1207, N'Phòng Hạng Vừa', 12, 500000, 2, 0, 2, N'Trống'),
	(1208, N'Phòng Hạng Sang', 12, 1000000, 0, 1, 4, N'Trống'),
	(1209, N'Phòng Hạng Vừa', 12, 500000, 2, 0, 2, N'Trống'),
	(1210, N'Phòng Hạng Sang', 12, 1000000, 0, 1, 4, N'Trống'),
	(1211, N'Phòng Hạng Vừa', 12, 500000, 2, 0, 2, N'Trống'),
	(1212, N'Phòng Hạng Sang', 12, 1000000, 0, 1, 4, N'Trống'),
	(1213, N'Phòng Hạng Vừa', 12, 500000, 2, 0, 2, N'Trống'),
	(1214, N'Phòng Hạng Sang', 12, 1000000, 0, 1, 4, N'Trống'),
	(1215, N'Phòng Hạng Vừa', 12, 500000, 2, 0, 2, N'Trống'),
	(1216, N'Phòng Hạng Sang', 12, 1000000, 0, 1, 4, N'Trống'),
	(1217, N'Phòng Hạng Vừa', 12, 500000, 2, 0, 2, N'Trống'),
	(1218, N'Phòng Hạng Sang', 12, 1000000, 0, 1, 4, N'Trống'),
	(1219, N'Phòng Hạng Vừa', 12, 500000, 2, 0, 2, N'Trống'),
	(1220, N'Phòng Hạng Sang', 12, 1000000, 0, 1, 4, N'Trống'),
    --tầng 13
    (1301, N'Phòng Hạng Vừa', 13, 500000, 2, 0, 2, N'Trống'),
	(1302, N'Phòng Hạng Sang', 13, 1000000, 0, 1, 4, N'Trống'),
	(1303, N'Phòng Hạng Vừa', 13, 500000, 2, 0, 2, N'Trống'),
	(1304, N'Phòng Hạng Sang', 13, 1000000, 0, 1, 4, N'Trống'),
	(1305, N'Phòng Hạng Vừa', 13, 500000, 2, 0, 2, N'Trống'),
	(1306, N'Phòng Hạng Sang', 13, 1000000, 0, 1, 4, N'Trống'),
	(1307, N'Phòng Hạng Vừa', 13, 500000, 2, 0, 2, N'Trống'),
	(1308, N'Phòng Hạng Sang', 13, 1000000, 0, 1, 4, N'Trống'),
	(1309, N'Phòng Hạng Vừa', 13, 500000, 2, 0, 2, N'Trống'),
	(1310, N'Phòng Hạng Sang', 13, 1000000, 0, 1, 4, N'Trống'),
	(1311, N'Phòng Hạng Vừa', 13, 500000, 2, 0, 2, N'Trống'),
	(1312, N'Phòng Hạng Sang', 13, 1000000, 0, 1, 4, N'Trống'),
	(1313, N'Phòng Hạng Vừa', 13, 500000, 2, 0, 2, N'Trống'),
	(1314, N'Phòng Hạng Sang', 13, 1000000, 0, 1, 4, N'Trống'),
	(1315, N'Phòng Hạng Vừa', 13, 500000, 2, 0, 2, N'Trống'),
	(1316, N'Phòng Hạng Sang', 13, 1000000, 0, 1, 4, N'Trống'),
	(1317, N'Phòng Hạng Vừa', 13, 500000, 2, 0, 2, N'Trống'),
	(1318, N'Phòng Hạng Sang', 13, 1000000, 0, 1, 4, N'Trống'),
	(1319, N'Phòng Hạng Vừa', 13, 500000, 2, 0, 2, N'Trống'),
	(1320, N'Phòng Hạng Sang', 13, 1000000, 0, 1, 4, N'Trống')
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

create function KiemTraTrangThaiPhong(@maphong int) returns nvarchar(20)
as
begin
	declare @trangthai nvarchar(20)
	select @trangthai = dbo.Room.Status from dbo.Room where dbo.Room.RoomID = @maphong
	return @trangthai
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

create trigger TaoThePhong on dbo.BookingDetail for insert 
as
begin
	if exists (select * from dbo.BookingDetail)
	begin
		insert into dbo.Card(RoomID, CustomerID, BookingDetailID, Status) select inserted.RoomID, inserted.CustomerID, inserted.BookingDetailID, N'Chưa kích hoạt' from inserted
	end
end
go

create procedure DangKyGiaoDich @MaDoan nvarchar(5), @TenDaiDien nvarchar(50), @CMNDDaiDien nvarchar(15), @songuoi int, @start datetime, @end datetime, @danhsachten nvarchar(max), @danhsachcmnd nvarchar(max), @daili nvarchar(50), @phong nvarchar(max)
as
begin
    begin transaction

    if @start > @end
    begin
        raiserror('Ngày bắt đầu phải nhỏ hơn hoặc bằng ngày kết thúc.', 16, 1)
        rollback transaction
        return
    end

    declare @sophong table (ID int identity, RoomID int)
    insert into @sophong (RoomID) select cast(value as int) from string_split(@phong, ',')

    if exists (
		select 1 from @sophong R where dbo.KiemTraTrangThaiPhong(R.RoomID) <> N'Trống'
	)
    begin
        raiserror('Có phòng đã được đặt, không thể tiếp tục.', 16, 1)
        rollback transaction
        return
    end

    declare @listname table (ID int identity, Name nvarchar(50))
    insert into @listname (Name) select value from string_split(@danhsachten, ',')

    declare @listcmnd table (ID int identity, CMND nvarchar(50))
    insert into @listcmnd (CMND) select value from string_split(@danhsachcmnd, ',')

    if (select count(*) from @listname) <> (select count(*) from @listcmnd) or ((select count(*) from @listname) + 1) <> @songuoi
    begin
        raiserror('Danh sách tên hoặc CMND không khớp với số người.', 16, 1)
        rollback transaction
        return
    end

    -- Kiểm tra xem trưởng đoàn đã tồn tại hay chưa
    if not exists (select 1 from dbo.Customer where CMND = @CMNDDaiDien)
    begin
        insert into dbo.Customer(GroupID, Name, CMND, Role) values (@MaDoan, @TenDaiDien, @CMNDDaiDien, N'Trưởng Đoàn')
    end

    insert into dbo.Customer(GroupID, Name, CMND, Role) select @MaDoan, N.Name, C.CMND, N'Nhân Viên' from @listname N 
	join @listcmnd C on N.ID = C.ID where not exists (select 1 from dbo.Customer where CMND = C.CMND) --Ngăn trùng lặp

    if not exists (select 1 from dbo.Account where Username = N'A' + @CMNDDaiDien)
    begin
        insert into dbo.Account(GroupID, Username, Password, Status) values (@MaDoan, N'A' + @CMNDDaiDien, @CMNDDaiDien, N'Giao dịch')
    end

    declare @priceroom int = 0
    select @priceroom = sum(dbo.Room.Price) from @sophong R join dbo.Room on dbo.Room.RoomID = R.RoomID

    declare @numberroom int
    select @numberroom = count(*) from @sophong

    --Kiểm tra xem Booking đã tồn tại chưa
    if not exists (select 1 from dbo.Booking where GroupID = @MaDoan and NamePerson = @TenDaiDien)
    begin
        insert into dbo.Booking(GroupID, CustomerID, AgencyID, NamePerson, BookingDate, StartDate, EndDate, PriceTotal, NumberRoom) values 
		(@MaDoan, (select top 1 dbo.Customer.CustomerID from dbo.Customer where dbo.Customer.Name = @TenDaiDien), (select top 1 dbo.Agency.AgencyID from dbo.Agency where dbo.Agency.Name = @daili), @TenDaiDien, getdate(), @start, @end, (@priceroom * (case when datediff(day, @start, @end) = 0 then 1 else datediff(day, @start, @end) end)), @numberroom)
    end

    declare @bookingID int = (select top 1 BookingID from dbo.Booking where NamePerson = @TenDaiDien order by BookingID desc)

    declare @danhsachCustomer table (ID int identity, CustomerID int, Name nvarchar(100))
    insert into @danhsachCustomer (CustomerID, Name) select dbo.Customer.CustomerID, dbo.Customer.Name from dbo.Customer where dbo.Customer.GroupID = @MaDoan
    declare @customerCount int = (select count(*) from @danhsachCustomer)
    if @customerCount > @numberroom
    begin
        declare @currentRoom int = 1
        declare @totalRooms int = (select count(*) from @sophong)
        declare @CustomerID int

        declare customer_cursor cursor for
        select CustomerID from @danhsachCustomer

        open customer_cursor
        fetch next from customer_cursor into @CustomerID

        while @@fetch_status = 0
        begin
            declare @RoomID int = (select RoomID from @sophong where ID = @currentRoom)
            -- Kiểm tra xem khách đã có trong BookingDetail chưa
            if not exists (select 1 from dbo.BookingDetail where BookingID = @bookingID and CustomerID = @CustomerID)
            begin
                insert into dbo.BookingDetail(GroupID, BookingID, CustomerID, RoomID, Name, StartDate, EndDate, Price, SubTotal) values 
				(@MaDoan, @bookingID, @CustomerID, @RoomID, (select Name from dbo.Customer where CustomerID = @CustomerID), @start, @end, 0, 0)
            end
            set @currentRoom = @currentRoom + 1
            if @currentRoom > @totalRooms set @currentRoom = 1
            fetch next from customer_cursor into @CustomerID
        end
        close customer_cursor
        deallocate customer_cursor
    end
	update B set 
		B.Price = (dbo.Room.Price / P.CountCustomer), 
		B.SubTotal = (dbo.Room.Price / P.CountCustomer) * (case when datediff(day, B.StartDate, B.EndDate) = 0 then 1 else datediff(day, B.StartDate, B.EndDate) end)
	from dbo.BookingDetail B
	join dbo.Room on dbo.Room.RoomID = B.RoomID
	join (
		select dbo.BookingDetail.RoomID, count(dbo.BookingDetail.CustomerID) as CountCustomer from dbo.BookingDetail group by dbo.BookingDetail.RoomID
	) P on B.RoomID = P.RoomID
	join @sophong R on  R.RoomID = dbo.Room.RoomID
    commit transaction
end
go

--b. Đặt chỗ

create procedure TimPhongTheoYeuCau @yeucau nvarchar(100)
as
begin
	declare @tien money, @tongtien money
	declare @suggest table (ID int identity, Info nvarchar(50), InfoDetail nvarchar(50))
	insert into @suggest (Info) select ltrim(rtrim(value)) from string_split(@yeucau, ',')
	update @suggest set InfoDetail = 
		case
			when Info like N'Phòng%' then Info
			when Info like N'%tầng%' and patindex('%[0-9]%', Info) > 0 then stuff(Info, 1, patindex('%[0-9]%', Info) - 1, '')
			when Info like N'%người/phòng%' and patindex('%[0-9]%', Info) > 0 then left(Info, patindex('%[^0-9]%', Info + ' ') - 1)
			when Info like N'%phòng%' and patindex('%[0-9]%', Info) > 0 then left(Info, patindex('%[^0-9]%', Info + ' ') - 1)
			when Info like N'%từ%' and patindex('%[0-9]%/%[0-9]%/%[0-9]%', Info) > 0 then convert(nvarchar(10), try_convert(date, stuff(Info, 1, charindex('từ', Info) + 2, ''), 103), 120)
			when Info like N'%đến%' and patindex('%[0-9]%/%[0-9]%/%[0-9]%', Info) > 0 then convert(nvarchar(10), try_convert(date, stuff(Info, 1, charindex('đến', Info) + 3, ''), 103), 120)
		end
	declare @sotang int, @songuoi int, @sophong int, @ngaybatdau datetime, @ngayketthuc datetime
	select @sophong = cast(S.InfoDetail as int) from @suggest S where Info like N'%phòng%' and isnumeric(InfoDetail) = 1
	select @sotang = cast(S.InfoDetail as int) from @suggest S where Info like N'%tầng%'
	select @songuoi = cast(S.InfoDetail as int) from @suggest S where Info like N'%người/phòng%'
	select @ngaybatdau = try_cast(S.InfoDetail as datetime) from @suggest S where Info like N'%từ%'
	select @ngayketthuc = try_cast(S.InfoDetail as datetime) from @suggest S where Info like N'%đến%'
	select @tien = isnull(dbo.Room.Price, 0) from dbo.Room join @suggest S on s.Info = dbo.Room.Type
	set @tongtien = @tien * @sophong * (case when datediff(day, @ngaybatdau, @ngayketthuc) = 0 then 1 else datediff(day, @ngaybatdau, @ngayketthuc) end)
	select @tongtien as TongTienPhongTheoYeuCau
	select dbo.Room.* from dbo.Room join @suggest S on S.Info = dbo.Room.Type where dbo.Room.Floor = @sotang and dbo.Room.NumberPerson >= @songuoi and dbo.Room.Status = N'Trống'
end
go

-- c. Hủy đăng ký

create function XemChiTietGiaoDichTheoMadoan(@MaDoan nvarchar(10)) returns table
as
return (
	select 
		dbo.BookingDetail.BookingDetailID,
		dbo.BookingDetail.BookingID,
		dbo.BookingDetail.CustomerID,
		dbo.BookingDetail.GroupID,
		dbo.BookingDetail.Name,
		dbo.BookingDetail.StartDate,
		dbo.BookingDetail.EndDate,
		dbo.BookingDetail.Price,
		dbo.BookingDetail.SubTotal,
		dbo.BookingDetail.CompensationFee
	from dbo.BookingDetail join dbo.Customer on dbo.BookingDetail.CustomerID = dbo.Customer.CustomerID 
	where dbo.BookingDetail.GroupID = @MaDoan
)
go

create trigger XoaGiaoDich on dbo.BookingDetail for delete
as
begin
	begin
		declare @detailid int, @bookid int, @counter int
		select @detailid = deleted.BookingDetailID, @bookid = deleted.BookingID from deleted
		select @counter = count(*) from dbo.BookingDetail where dbo.BookingDetail.BookingID = @bookid and dbo.BookingDetail.BookingDetailID <> @detailid
		if @counter = 0
		begin
			delete from dbo.Booking where dbo.Booking.BookingID = @bookid
		end
	end
end
go

create procedure HuyChiTietDangKyGiaoDich @MaDoan nvarchar(10), @Ten nvarchar(50)
as
begin
	delete from dbo.Card  where dbo.Card.BookingDetailID in (select dbo.BookingDetail.BookingDetailID from dbo.BookingDetail where dbo.BookingDetail.GroupID = @MaDoan and dbo.BookingDetail.Name = @Ten)
	delete from dbo.BookingDetail where dbo.BookingDetail.GroupID = @MaDoan and dbo.BookingDetail.Name = @Ten
end
go

-- d. Thuê phòng

create procedure DangKyGiaoDichTaiCho @MaDoan nvarchar(5), @TenDaiDien nvarchar(50), @CMNDDaiDien nvarchar(15), @songuoi int, @end datetime, @danhsachten nvarchar(max), @danhsachcmnd nvarchar(max), @phong nvarchar(max)
as
begin
    begin transaction

    if getdate() > @end
    begin
        raiserror('Ngày bắt đầu phải nhỏ hơn hoặc bằng ngày kết thúc.', 16, 1)
        rollback transaction
        return
    end

    declare @sophong table (ID int identity, RoomID int)
    insert into @sophong (RoomID) select cast(value as int) from string_split(@phong, ',')

    if exists (
		select 1 from @sophong R where dbo.KiemTraTrangThaiPhong(R.RoomID) <> N'Trống'
	)
    begin
        raiserror('Có phòng đã được đặt, không thể tiếp tục.', 16, 1)
        rollback transaction
        return
    end

    declare @listname table (ID int identity, Name nvarchar(50))
    insert into @listname (Name) select value from string_split(@danhsachten, ',')

    declare @listcmnd table (ID int identity, CMND nvarchar(50))
    insert into @listcmnd (CMND) select value from string_split(@danhsachcmnd, ',')

    if (select count(*) from @listname) <> (select count(*) from @listcmnd) or ((select count(*) from @listname) + 1) <> @songuoi
    begin
        raiserror('Danh sách tên hoặc CMND không khớp với số người.', 16, 1)
        rollback transaction
        return
    end

    -- Kiểm tra xem trưởng đoàn đã tồn tại hay chưa
    if not exists (select 1 from dbo.Customer where CMND = @CMNDDaiDien)
    begin
        insert into dbo.Customer(GroupID, Name, CMND, Role) values (@MaDoan, @TenDaiDien, @CMNDDaiDien, N'Trưởng Đoàn')
    end

    insert into dbo.Customer(GroupID, Name, CMND, Role) select @MaDoan, N.Name, C.CMND, N'Nhân Viên' from @listname N 
	join @listcmnd C on N.ID = C.ID where not exists (select 1 from dbo.Customer where CMND = C.CMND) --Ngăn trùng lặp

    if not exists (select 1 from dbo.Account where Username = N'A' + @CMNDDaiDien)
    begin
        insert into dbo.Account(GroupID, Username, Password, Status) values (@MaDoan, N'A' + @CMNDDaiDien, @CMNDDaiDien, N'Giao dịch')
    end

    declare @priceroom int = 0
    select @priceroom = sum(dbo.Room.Price) from @sophong R join dbo.Room on dbo.Room.RoomID = R.RoomID

    declare @numberroom int
    select @numberroom = count(*) from @sophong

    --Kiểm tra xem Booking đã tồn tại chưa
    if not exists (select 1 from dbo.Booking where GroupID = @MaDoan and NamePerson = @TenDaiDien)
    begin
        insert into dbo.Booking(GroupID, CustomerID, AgencyID, NamePerson, BookingDate, StartDate, EndDate, PriceTotal, NumberRoom) values 
		(@MaDoan, (select top 1 dbo.Customer.CustomerID from dbo.Customer where dbo.Customer.Name = @TenDaiDien), (select top 1 dbo.Agency.AgencyID from dbo.Agency where dbo.Agency.Name = N'HolyBirdResort'), @TenDaiDien, getdate(), getdate(), @end, (@priceroom * (case when datediff(day, getdate(), @end) = 0 then 1 else datediff(day, getdate(), @end) end)), @numberroom)
    end

    declare @bookingID int = (select top 1 BookingID from dbo.Booking where NamePerson = @TenDaiDien order by BookingID desc)

    declare @danhsachCustomer table (ID int identity, CustomerID int, Name nvarchar(100))
    insert into @danhsachCustomer (CustomerID, Name) select dbo.Customer.CustomerID, dbo.Customer.Name from dbo.Customer where dbo.Customer.GroupID = @MaDoan
    declare @customerCount int = (select count(*) from @danhsachCustomer)
    if @customerCount > @numberroom
    begin
        declare @currentRoom int = 1
        declare @totalRooms int = (select count(*) from @sophong)
        declare @CustomerID int

        declare customer_cursor cursor for
        select CustomerID from @danhsachCustomer

        open customer_cursor
        fetch next from customer_cursor into @CustomerID

        while @@fetch_status = 0
        begin
            declare @RoomID int = (select RoomID from @sophong where ID = @currentRoom)
            -- Kiểm tra xem khách đã có trong BookingDetail chưa
            if not exists (select 1 from dbo.BookingDetail where BookingID = @bookingID and CustomerID = @CustomerID)
            begin
                insert into dbo.BookingDetail(GroupID, BookingID, CustomerID, RoomID, Name, StartDate, EndDate, Price, SubTotal) values 
				(@MaDoan, @bookingID, @CustomerID, @RoomID, (select Name from dbo.Customer where CustomerID = @CustomerID), getdate(), @end, 0, 0)
            end
            set @currentRoom = @currentRoom + 1
            if @currentRoom > @totalRooms set @currentRoom = 1
            fetch next from customer_cursor into @CustomerID
        end
        close customer_cursor
        deallocate customer_cursor
    end
	update B set 
		B.Price = (dbo.Room.Price / P.CountCustomer), 
		B.SubTotal = (dbo.Room.Price / P.CountCustomer) * (case when datediff(day, B.StartDate, B.EndDate) = 0 then 1 else datediff(day, B.StartDate, B.EndDate) end)
	from dbo.BookingDetail B
	join dbo.Room on dbo.Room.RoomID = B.RoomID
	join (
		select dbo.BookingDetail.RoomID, count(dbo.BookingDetail.CustomerID) as CountCustomer from dbo.BookingDetail group by dbo.BookingDetail.RoomID
	) P on B.RoomID = P.RoomID
	join @sophong R on  R.RoomID = dbo.Room.RoomID
	update dbo.Account set Status = N'Nhận phòng' where dbo.Account.GroupID = @MaDoan
	update R set R.Status = N'Đang sử dụng' from dbo.Room R join @sophong P on R.RoomID = P.RoomID
	update C set C.Status = N'Đã kích hoạt' from dbo.Card C join @danhsachCustomer DS on C.CustomerID = DS.CustomerID 
    commit transaction
end
go

-- e.Nhận phòng

create procedure HuyGiaoDich @BookID int
as
begin
	declare @number int
	declare @giaodich table (ID int identity, BookingDetailID int, CardID int)
	insert into @giaodich (BookingDetailID, CardID) select dbo.BookingDetail.BookingDetailID, dbo.Card.CardID from dbo.BookingDetail join dbo.Card on dbo.BookingDetail.BookingDetailID = dbo.Card.BookingDetailID where dbo.BookingDetail.BookingID = @BookID
	delete from dbo.Card where dbo.Card.CardID in (select CardID from @giaodich)
	delete from dbo.BookingDetail where dbo.BookingDetail.BookingDetailID in (select BookingDetailID from @giaodich)
	delete from dbo.Booking where dbo.Booking.BookingID = @BookID
end
go

create procedure NhanPhong @ID nvarchar(20)
as
begin
	update dbo.Account set Status = N'Nhận phòng' where dbo.Account.GroupID = @ID
	update C set C.Status = N'Đã kích hoạt' from dbo.Card C join dbo.BookingDetail BD on C.CustomerID = BD.CustomerID where BD.GroupID = @ID
	update dbo.Room set Status = N'Đang sử dụng' where dbo.Room.RoomID in (select dbo.BookingDetail.RoomID from dbo.BookingDetail where dbo.BookingDetail.GroupID = @ID)
end
go

-- f. Trả phòng

create procedure ThemBoiThuongChoResort @namenhanvien nvarchar(50), @roomid int, @magd int, @tienboithuong money, @description nvarchar(max)
as
begin
	declare @IDNV int, @tongtien money
	select @IDNV = dbo.Employee.EmployeeID from dbo.Employee where dbo.Employee.Name = @namenhanvien
	insert into dbo.Compensation(RoomID, EmployeeID, BookingID, Amount, CheckDate, Description) select 
		dbo.Room.RoomID, @IDNV, @magd,@tienboithuong, getdate(), @description
	from dbo.Room where dbo.Room.RoomID = @roomid
end
go

create procedure TraPhong @MaGD int
as
begin
	declare @boithuong money, @roomboithuong int
	select @boithuong = dbo.Compensation.Amount, @roomboithuong = dbo.Compensation.RoomID from dbo.Compensation where dbo.Compensation.BookingID = @MaGD
	insert into dbo.Payment(CustomerID, BookingID, AccountID, Price, PaymentDate, Status) select 
		dbo.Customer.CustomerID, dbo.Booking.BookingID, dbo.Account.AccountID, dbo.Booking.PriceTotal + @boithuong, getdate(), N'Thanh toán thành công' from dbo.Booking 
	join dbo.Customer on dbo.Booking.CustomerID = dbo.Customer.CustomerID
	join dbo.Account on dbo.Account.GroupID = dbo.Customer.GroupID where dbo.Booking.BookingID = @MaGD
	declare @numberroom int
	select @numberroom = count(*) from dbo.BookingDetail where dbo.BookingDetail.RoomID = @roomboithuong
	if @numberroom = 1
	begin
		update dbo.BookingDetail set CompensationFee = @boithuong where dbo.BookingDetail.RoomID = @roomboithuong
	end
	else if @numberroom > 1
	begin
		declare @tienshare money
		set @tienshare = @boithuong / @numberroom
		update dbo.BookingDetail set CompensationFee = @tienshare where dbo.BookingDetail.RoomID = @roomboithuong
	end
	--select distinct dbo.BookingDetail.RoomID from dbo.BookingDetail where dbo.BookingDetail.BookingID = 1 
	update dbo.Room set Status = N'Trống' where dbo.Room.RoomID in (select distinct dbo.BookingDetail.RoomID from dbo.BookingDetail where dbo.BookingDetail.BookingID = @MaGD and (dbo.Room.Status = N'Đã đặt' or dbo.Room.Status = N'Đang sử dụng'))
end
go

-- Phân quyền cho database

use master
go

create login admin with password = 'admin'
go

create login employee with password = '1'
go

create login A2045637819 with password = '2045637819'
go

use HolyBirdResort
go

create user admin for login admin
go

create user employee for login employee
go

create user A2045637819 for login A2045637819
go

exec sp_addrolemember 'db_owner', 'admin'
go

use HolyBirdResort
go

grant all privileges on database::HolyBirdResort to admin
go
