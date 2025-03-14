use HolyBirdResort
go

select * from dbo.Room
go

exec dbo.TimPhongTheoYeuCau N'Phòng hạng sang, tầng 1, 3 người/phòng, 4 phòng, từ 1/5/2010, đến 13/5/2010'
go

exec dbo.HuyChiTietDangKyGiaoDich N'A001', N'Lê Văn C'
go

exec dbo.HuyChiTietDangKyGiaoDich N'A001', N'Nguyễn Duy Tùng'
go

exec dbo.HuyChiTietDangKyGiaoDich N'A001', N'Nguyễn Văn A'
go

exec dbo.HuyChiTietDangKyGiaoDich N'A001', N'Trần Thị B'
go

select * from dbo.BookingDetail
go