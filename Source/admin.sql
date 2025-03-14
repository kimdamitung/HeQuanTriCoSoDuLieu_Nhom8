use HolyBirdResort
go

select * from dbo.Account
go

select * from dbo.BookingDetail
go

-- tài khoản cho nhân viên

grant execute on DangKyGiaoDich to employee
go

grant execute on DangKyGiaoDichTaiCho to employee
go

grant execute on HuyGiaoDich to employee
go

grant execute on NhanPhong to employee
go

grant execute on ThemBoiThuongChoResort to employee
go

grant execute on TraPhong to employee
go

grant select on dbo.Room to employee
go

grant select on dbo.BookingDetail to employee
go

-- tài khoản cho người dùng 

grant select on dbo.Room to A2045637819
go

grant select on dbo.BookingDetail to A2045637819
go

grant execute on HuyChiTietDangKyGiaoDich to A2045637819
go

grant execute on TimPhongTheoYeuCau to A2045637819
go

select * from dbo.BookingDetail
go

select * from dbo.Booking
go