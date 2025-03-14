use HolyBirdResort
go

exec dbo.DangKyGiaoDich 'A001', N'Nguyễn Duy Tùng', N'2045637819',4, '2025-03-11 10:00:00', '2025-06-20 10:00:00', N'Nguyễn Văn A,Trần Thị B,Lê Văn C', N'9530187426,4730261958,5867012349', N'HolyBirdResort 3', N'105,106,108'
go

exec dbo.DangKyGiaoDich 'B002', N'Nguyễn Duy Tùng', N'7281956340',4, '2025-03-14 10:00:00', '2025-06-20 10:00:00', N'Nguyễn Văn A,Trần Thị B,Lê Văn C', N'1390827456,4765810392,5306271948', N'HolyBirdResort 2', N'505,306,408'
go

exec dbo.DangKyGiaoDichTaiCho 'C003', N'Nguyễn Duy Tùng', N'8927314560',4, '2025-06-20 10:00:00', N'Nguyễn Văn A,Trần Thị B,Lê Văn C', N'1087342659,0000000001,1000000001', N'605,806,908'
go

exec dbo.NhanPhong N'B002'
go

exec dbo.HuyGiaoDich 1
go

exec dbo.ThemBoiThuongChoResort N'Nguyễn Duy Tùng', 505, 2,1000100, N'hư đèn ngủ'
go

exec dbo.TraPhong 2
go