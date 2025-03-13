use HolyBirdResort
go

select * from dbo.Account
go

select * from dbo.BookingDetail


use master
go

-- tài khoản cho nhân viên

create login employee with password = '1'
go

create user employee for login employee
go

grant execute on DangKyGiaoDich to employee
go

grant execute on DangKyGiaoDichTaiCho to employee
go

-- tài khoản cho người dùng 

create login A2045637819 with password = '2045637819'
go

use HolyBirdResort
go 

create user A2045637819 for login A2045637819
go

grant select on dbo.Room to A2045637819
go

grant execute on HuyChiTietDangKyGiaoDich to A2045637819
go

grant execute on XemChiTietGiaoDichTheoMadoan to A2045637819
go

select * from dbo.BookingDetail
go

select * from dbo.Booking
go