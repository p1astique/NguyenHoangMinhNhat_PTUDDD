
IF DB_ID(N'Bai01BTN_DB') IS NULL
BEGIN
    CREATE DATABASE Bai01BTN_DB;
END;
GO

USE Bai01BTN_DB;
GO

IF OBJECT_ID(N'dbo.DienThoai', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.DienThoai (
        MaSP VARCHAR(20) PRIMARY KEY,
        TenSP NVARCHAR(150) NOT NULL,
        HangSanXuat NVARCHAR(100) NOT NULL,
        Gia DECIMAL(18, 0) NOT NULL,
        MoTa NVARCHAR(MAX),
        HinhAnh NVARCHAR(500),
        CONSTRAINT CK_DienThoai_Gia CHECK (Gia >= 0)
    );
END;
GO

IF NOT EXISTS (SELECT 1 FROM dbo.DienThoai)
BEGIN
    INSERT INTO dbo.DienThoai
        (MaSP, TenSP, HangSanXuat, Gia, MoTa, HinhAnh)
    VALUES
        ('DT001', N'iPhone 15 Pro Max', N'Apple',
         18000000,
         N'iPhone 15 Pro Max với thiết kế titanium, camera chất lượng cao và hiệu năng mạnh mẽ.',
         NULL),

        ('DT002', N'iPhone 15', N'Apple',
         14000000,
         N'iPhone 15 với Dynamic Island, camera 48 MP và cổng USB-C.',
         NULL),

        ('DT003', N'Oppo Reno 10 Pro+', N'OPPO',
         13000000,
         N'Điện thoại OPPO Reno với màn hình đẹp và khả năng chụp ảnh chân dung.',
         NULL),

        ('DT004', N'Oppo Reno 11F', N'OPPO',
         10000000,
         N'Điện thoại OPPO Reno 11F với thiết kế trẻ trung.',
         NULL),

        ('DT005', N'Galaxy 24 Plus', N'Samsung',
         16000000,
         N'Samsung Galaxy S24 Plus với màn hình lớn và nhiều tính năng thông minh.',
         NULL),

        ('DT006', N'Xiaomi 14', N'Xiaomi',
         12000000,
         N'Xiaomi 14 với cấu hình mạnh và camera chất lượng cao.',
         NULL);
END;
GO

SELECT * FROM dbo.DienThoai;
GO
