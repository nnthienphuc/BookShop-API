USE [master]
GO
/****** Object:  Database [BOOK_SHOP_API]    Script Date: 8/1/2025 11:49:27 PM ******/
CREATE DATABASE [BOOK_SHOP_API]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'BOOK_SHOP_API', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\BOOK_SHOP_API.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'BOOK_SHOP_API_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\BOOK_SHOP_API_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT, LEDGER = OFF
GO
ALTER DATABASE [BOOK_SHOP_API] SET COMPATIBILITY_LEVEL = 160
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [BOOK_SHOP_API].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [BOOK_SHOP_API] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [BOOK_SHOP_API] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [BOOK_SHOP_API] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [BOOK_SHOP_API] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [BOOK_SHOP_API] SET ARITHABORT OFF 
GO
ALTER DATABASE [BOOK_SHOP_API] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [BOOK_SHOP_API] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [BOOK_SHOP_API] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [BOOK_SHOP_API] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [BOOK_SHOP_API] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [BOOK_SHOP_API] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [BOOK_SHOP_API] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [BOOK_SHOP_API] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [BOOK_SHOP_API] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [BOOK_SHOP_API] SET  DISABLE_BROKER 
GO
ALTER DATABASE [BOOK_SHOP_API] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [BOOK_SHOP_API] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [BOOK_SHOP_API] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [BOOK_SHOP_API] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [BOOK_SHOP_API] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [BOOK_SHOP_API] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [BOOK_SHOP_API] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [BOOK_SHOP_API] SET RECOVERY FULL 
GO
ALTER DATABASE [BOOK_SHOP_API] SET  MULTI_USER 
GO
ALTER DATABASE [BOOK_SHOP_API] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [BOOK_SHOP_API] SET DB_CHAINING OFF 
GO
ALTER DATABASE [BOOK_SHOP_API] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [BOOK_SHOP_API] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [BOOK_SHOP_API] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [BOOK_SHOP_API] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
EXEC sys.sp_db_vardecimal_storage_format N'BOOK_SHOP_API', N'ON'
GO
ALTER DATABASE [BOOK_SHOP_API] SET QUERY_STORE = ON
GO
ALTER DATABASE [BOOK_SHOP_API] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 1000, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO, MAX_PLANS_PER_QUERY = 200, WAIT_STATS_CAPTURE_MODE = ON)
GO
USE [BOOK_SHOP_API]
GO
/****** Object:  Table [dbo].[AuditLogs]    Script Date: 8/1/2025 11:49:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AuditLogs](
	[Id] [uniqueidentifier] NOT NULL,
	[StaffId] [uniqueidentifier] NOT NULL,
	[Action] [nvarchar](50) NOT NULL,
	[EntityName] [nvarchar](100) NOT NULL,
	[EntityId] [uniqueidentifier] NOT NULL,
	[Description] [nvarchar](max) NOT NULL,
	[Timestamp] [datetime2](7) NOT NULL,
	[IPAddress] [nvarchar](45) NOT NULL,
	[UserAgent] [nvarchar](200) NOT NULL,
 CONSTRAINT [PK__AuditLog__3214EC076F7A07FB] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Authors]    Script Date: 8/1/2025 11:49:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Authors](
	[Id] [uniqueidentifier] NOT NULL,
	[Name] [nvarchar](100) NOT NULL,
	[IsDeleted] [bit] NOT NULL,
 CONSTRAINT [PK_Author] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Books]    Script Date: 8/1/2025 11:49:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Books](
	[Id] [uniqueidentifier] NOT NULL,
	[Isbn] [char](13) NOT NULL,
	[Title] [nvarchar](100) NOT NULL,
	[CategoryId] [uniqueidentifier] NOT NULL,
	[AuthorId] [uniqueidentifier] NOT NULL,
	[PublisherId] [uniqueidentifier] NOT NULL,
	[YearOfPublication] [smallint] NOT NULL,
	[Price] [decimal](8, 0) NOT NULL,
	[Image] [varchar](max) NULL,
	[Quantity] [int] NOT NULL,
	[IsDeleted] [bit] NOT NULL,
 CONSTRAINT [PK_Book] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Categories]    Script Date: 8/1/2025 11:49:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Categories](
	[Id] [uniqueidentifier] NOT NULL,
	[Name] [nvarchar](100) NOT NULL,
	[IsDeleted] [bit] NOT NULL,
 CONSTRAINT [PK_Category] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Customers]    Script Date: 8/1/2025 11:49:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Customers](
	[Id] [uniqueidentifier] NOT NULL,
	[FamilyName] [nvarchar](70) NOT NULL,
	[GivenName] [nvarchar](30) NOT NULL,
	[DateOfBirth] [date] NOT NULL,
	[Address] [nvarchar](50) NOT NULL,
	[Phone] [char](10) NOT NULL,
	[Gender] [bit] NOT NULL,
	[Email] [varchar](50) NULL,
	[HashPassword] [varchar](255) NULL,
	[IsActived] [bit] NOT NULL,
	[IsDeleted] [bit] NOT NULL,
 CONSTRAINT [PK_Customer] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[OrderItems]    Script Date: 8/1/2025 11:49:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OrderItems](
	[OrderId] [uniqueidentifier] NOT NULL,
	[BookId] [uniqueidentifier] NOT NULL,
	[Quantity] [smallint] NOT NULL,
	[Price] [decimal](8, 0) NOT NULL,
	[IsDeleted] [bit] NOT NULL,
 CONSTRAINT [PK_OrderItem] PRIMARY KEY CLUSTERED 
(
	[OrderId] ASC,
	[BookId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Orders]    Script Date: 8/1/2025 11:49:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Orders](
	[Id] [uniqueidentifier] NOT NULL,
	[StaffId] [uniqueidentifier] NULL,
	[CustomerId] [uniqueidentifier] NOT NULL,
	[PromotionId] [uniqueidentifier] NULL,
	[CreatedTime] [datetime2](7) NOT NULL,
	[ShippingFee] [decimal](11, 3) NOT NULL,
	[PaymentMethod] [nvarchar](50) NOT NULL,
	[TotalAmount] [decimal](11, 3) NOT NULL,
	[Status] [nvarchar](50) NOT NULL,
	[Note] [nvarchar](max) NULL,
	[IsDeleted] [bit] NOT NULL,
 CONSTRAINT [PK_Order] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Promotions]    Script Date: 8/1/2025 11:49:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Promotions](
	[Id] [uniqueidentifier] NOT NULL,
	[Name] [nvarchar](100) NOT NULL,
	[StartDate] [datetime2](7) NOT NULL,
	[EndDate] [datetime2](7) NOT NULL,
	[Condition] [decimal](8, 0) NOT NULL,
	[DiscountPercent] [decimal](3, 2) NOT NULL,
	[Quantity] [smallint] NOT NULL,
	[IsDeleted] [bit] NOT NULL,
 CONSTRAINT [PK_Promotion] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Publishers]    Script Date: 8/1/2025 11:49:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Publishers](
	[Id] [uniqueidentifier] NOT NULL,
	[Name] [nvarchar](100) NOT NULL,
	[IsDeleted] [bit] NOT NULL,
 CONSTRAINT [PK_Publisher] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Staffs]    Script Date: 8/1/2025 11:49:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Staffs](
	[Id] [uniqueidentifier] NOT NULL,
	[FamilyName] [nvarchar](70) NOT NULL,
	[GivenName] [nvarchar](30) NOT NULL,
	[DateOfBirth] [date] NOT NULL,
	[Address] [nvarchar](50) NOT NULL,
	[Phone] [char](10) NOT NULL,
	[Email] [varchar](50) NOT NULL,
	[CitizenIdentification] [char](12) NOT NULL,
	[HashPassword] [varchar](255) NOT NULL,
	[Role] [bit] NOT NULL,
	[Gender] [bit] NOT NULL,
	[IsActived] [bit] NOT NULL,
	[IsDeleted] [bit] NOT NULL,
 CONSTRAINT [PK_Staff] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
INSERT [dbo].[AuditLogs] ([Id], [StaffId], [Action], [EntityName], [EntityId], [Description], [Timestamp], [IPAddress], [UserAgent]) VALUES (N'3be63bed-6feb-476c-a168-005b3aab59f1', N'b1009370-afce-4e2c-9fe2-25d6a0012178', N'UPDATE', N'Book', N'e56476b5-2bc9-4908-9ba9-57dafa5959a6', N'Updated book '''' to ''8935244864427'', ''Kính vạn hoa'' to ''Kính vạn hoa'', ''00000000-0000-0000-0000-000000000000'' to ''aacac6e9-cdf4-4e53-9ddc-309e776c8612'', ''00000000-0000-0000-0000-000000000000'' to ''91396c60-f995-40ef-b732-2b1bc90bf66c'', ''00000000-0000-0000-0000-000000000000'' to ''79994ae3-d421-4b92-b895-323c19e12db9'', ''0'' to ''2022'', ''0'' to ''0'', ''0'' to ''39'', IsDeleted: ''False'' → ''False''', CAST(N'2025-07-31T00:45:24.9851674' AS DateTime2), N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0')
INSERT [dbo].[AuditLogs] ([Id], [StaffId], [Action], [EntityName], [EntityId], [Description], [Timestamp], [IPAddress], [UserAgent]) VALUES (N'1688dafb-abe6-4d30-ab63-02333805066c', N'b1009370-afce-4e2c-9fe2-25d6a0012178', N'ADD', N'Order', N'1b8b771e-e7e0-4d80-b3f4-9a1dd8cbc728', N'Created order by ''b1009370-afce-4e2c-9fe2-25d6a0012178''', CAST(N'2025-08-01T23:45:05.0369095' AS DateTime2), N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0')
INSERT [dbo].[AuditLogs] ([Id], [StaffId], [Action], [EntityName], [EntityId], [Description], [Timestamp], [IPAddress], [UserAgent]) VALUES (N'a304f738-725d-4033-b6a2-08f43bbe5835', N'b1009370-afce-4e2c-9fe2-25d6a0012178', N'ADD', N'Order', N'4592b819-fc2f-4822-8bba-e5b1c747ded7', N'Created order by ''b1009370-afce-4e2c-9fe2-25d6a0012178''', CAST(N'2025-08-01T22:26:02.1410062' AS DateTime2), N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0')
INSERT [dbo].[AuditLogs] ([Id], [StaffId], [Action], [EntityName], [EntityId], [Description], [Timestamp], [IPAddress], [UserAgent]) VALUES (N'9caa72c9-6ae3-41f4-8918-0c9771dc0f4d', N'b1009370-afce-4e2c-9fe2-25d6a0012178', N'ADD', N'Promotion', N'da858eda-196e-45fb-8350-1845e2c67799', N'Created promotion ''Khuyến Mãi Tháng 8''', CAST(N'2025-07-31T01:16:18.5412085' AS DateTime2), N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0')
INSERT [dbo].[AuditLogs] ([Id], [StaffId], [Action], [EntityName], [EntityId], [Description], [Timestamp], [IPAddress], [UserAgent]) VALUES (N'40ebeb82-d6fa-4d68-8b38-1192ba5f07a2', N'b1009370-afce-4e2c-9fe2-25d6a0012178', N'UPDATE', N'Book', N'358808bc-9c89-4431-8a5f-228bbbc86a6d', N'Updated book ''8935212366533'' to ''8935212366533'', ''Gió Lạnh Đầu Mùa (Tái Bản 2024)'' to ''Gió Lạnh Đầu Mùa (Tái Bản 2024)'', ''e2bc6d43-b35c-4b43-9215-8e186ffa60c0'' to ''e2bc6d43-b35c-4b43-9215-8e186ffa60c0'', ''09189d44-9a03-44fa-a026-3704ad76ffd8'' to ''09189d44-9a03-44fa-a026-3704ad76ffd8'', ''79994ae3-d421-4b92-b895-323c19e12db9'' to ''79994ae3-d421-4b92-b895-323c19e12db9'', ''2024'' to ''2024'', ''59000'' to ''59000'', ''11'' to ''11'', IsDeleted: ''False'' → ''False''', CAST(N'2025-07-31T22:07:01.7804231' AS DateTime2), N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0')
INSERT [dbo].[AuditLogs] ([Id], [StaffId], [Action], [EntityName], [EntityId], [Description], [Timestamp], [IPAddress], [UserAgent]) VALUES (N'272cbb7e-1086-493e-981d-120a600cae12', N'b1009370-afce-4e2c-9fe2-25d6a0012178', N'UPDATE', N'Book', N'358808bc-9c89-4431-8a5f-228bbbc86a6d', N'Updated book ''8935212366533'' to ''8935212366533'', ''Gió Lạnh Đầu Mùa (Tái Bản 2024)'' to ''Gió Lạnh Đầu Mùa (Tái Bản 2024)'', ''e2bc6d43-b35c-4b43-9215-8e186ffa60c0'' to ''e2bc6d43-b35c-4b43-9215-8e186ffa60c0'', ''09189d44-9a03-44fa-a026-3704ad76ffd8'' to ''09189d44-9a03-44fa-a026-3704ad76ffd8'', ''79994ae3-d421-4b92-b895-323c19e12db9'' to ''79994ae3-d421-4b92-b895-323c19e12db9'', ''2024'' to ''2024'', ''59000'' to ''59000'', ''20'' to ''20'', IsDeleted: ''False'' → ''False''', CAST(N'2025-07-31T01:23:09.2462356' AS DateTime2), N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0')
INSERT [dbo].[AuditLogs] ([Id], [StaffId], [Action], [EntityName], [EntityId], [Description], [Timestamp], [IPAddress], [UserAgent]) VALUES (N'0b077020-3821-4d8c-a553-126233809910', N'b1009370-afce-4e2c-9fe2-25d6a0012178', N'DELETE', N'Publisher', N'ccb3f633-58ff-44a2-9aa5-8d73fd35d39e', N'Soft deleted publisher ''Nhà xuất bản Tự do''', CAST(N'2025-07-30T17:00:21.4458832' AS DateTime2), N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0')
INSERT [dbo].[AuditLogs] ([Id], [StaffId], [Action], [EntityName], [EntityId], [Description], [Timestamp], [IPAddress], [UserAgent]) VALUES (N'c66e5f9c-a2c6-4b1c-a5d6-1325836f8ce6', N'b1009370-afce-4e2c-9fe2-25d6a0012178', N'UPDATE', N'Book', N'7ae62fcb-f5c5-4ea9-985f-81914c4a97bd', N'Updated book '''' to ''8934974187622'', ''Tôi Thấy Hoa Vàng Trên Cỏ Xanh (Tái Bản 2023)'' to ''Tôi Thấy Hoa Vàng Trên Cỏ Xanh (Tái Bản 2023)'', ''00000000-0000-0000-0000-000000000000'' to ''e2bc6d43-b35c-4b43-9215-8e186ffa60c0'', ''00000000-0000-0000-0000-000000000000'' to ''91396c60-f995-40ef-b732-2b1bc90bf66c'', ''00000000-0000-0000-0000-000000000000'' to ''2d64142c-1280-48e1-9207-c7a0023fa88f'', ''0'' to ''2023'', ''0'' to ''0'', ''0'' to ''10'', IsDeleted: ''False'' → ''False''', CAST(N'2025-07-31T00:46:05.1474870' AS DateTime2), N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0')
INSERT [dbo].[AuditLogs] ([Id], [StaffId], [Action], [EntityName], [EntityId], [Description], [Timestamp], [IPAddress], [UserAgent]) VALUES (N'7819a647-c965-4e79-92f6-1343e2201c6b', N'b1009370-afce-4e2c-9fe2-25d6a0012178', N'ADD', N'Customer', N'8fefdeb4-2148-4224-a304-41c292140fdd', N'Created customer ''Nguyễn Thị Kiều Mộng''', CAST(N'2025-08-01T22:17:31.3178544' AS DateTime2), N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0')
INSERT [dbo].[AuditLogs] ([Id], [StaffId], [Action], [EntityName], [EntityId], [Description], [Timestamp], [IPAddress], [UserAgent]) VALUES (N'afa79018-f67c-40fc-8d47-17d3309cfad7', N'b1009370-afce-4e2c-9fe2-25d6a0012178', N'DELETE', N'Book', N'358808bc-9c89-4431-8a5f-228bbbc86a6d', N'Deleted book ''Gió Lạnh Đầu Mùa (Tái Bản 2024)''', CAST(N'2025-07-31T22:07:04.4562728' AS DateTime2), N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0')
INSERT [dbo].[AuditLogs] ([Id], [StaffId], [Action], [EntityName], [EntityId], [Description], [Timestamp], [IPAddress], [UserAgent]) VALUES (N'c35e8928-dc50-4a10-b352-19571149e8e7', N'b1009370-afce-4e2c-9fe2-25d6a0012178', N'UPDATE', N'Book', N'ad1fcaaf-6b6a-419f-95af-c29f8ec9982e', N'Updated book '''' to ''8934974209393'', ''Nguyễn Nhật Ánh - Người Giữ Lửa Cho Văn Học Thiếu Nhi'' to ''Nguyễn Nhật Ánh - Người Giữ Lửa Cho Văn Học Thiếu Nhi'', ''00000000-0000-0000-0000-000000000000'' to ''aacac6e9-cdf4-4e53-9ddc-309e776c8612'', ''00000000-0000-0000-0000-000000000000'' to ''91396c60-f995-40ef-b732-2b1bc90bf66c'', ''00000000-0000-0000-0000-000000000000'' to ''2d64142c-1280-48e1-9207-c7a0023fa88f'', ''0'' to ''2025'', ''0'' to ''0'', ''0'' to ''100'', IsDeleted: ''False'' → ''False''', CAST(N'2025-07-31T00:46:40.2482708' AS DateTime2), N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0')
INSERT [dbo].[AuditLogs] ([Id], [StaffId], [Action], [EntityName], [EntityId], [Description], [Timestamp], [IPAddress], [UserAgent]) VALUES (N'a6c2b0db-59f4-49a0-8035-1db81d6592bf', N'b1009370-afce-4e2c-9fe2-25d6a0012178', N'UPDATE', N'Order', N'd263c652-11fe-4e65-a6e1-887c5c9c4883', N'Updated order ''Thành công'' to ''Thành công'', '''' to '''', ''False'' to ''False''', CAST(N'2025-07-31T17:46:55.2591001' AS DateTime2), N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0')
INSERT [dbo].[AuditLogs] ([Id], [StaffId], [Action], [EntityName], [EntityId], [Description], [Timestamp], [IPAddress], [UserAgent]) VALUES (N'c797dbfa-3117-4b5d-817c-218886a30738', N'b1009370-afce-4e2c-9fe2-25d6a0012178', N'UPDATE', N'Book', N'35170fc7-a012-4baf-a15a-644a2121957f', N'Updated book '''' to ''9786043947465'', ''Ngày Mới'' to ''Ngày Mới'', ''00000000-0000-0000-0000-000000000000'' to ''e2bc6d43-b35c-4b43-9215-8e186ffa60c0'', ''00000000-0000-0000-0000-000000000000'' to ''09189d44-9a03-44fa-a026-3704ad76ffd8'', ''00000000-0000-0000-0000-000000000000'' to ''79994ae3-d421-4b92-b895-323c19e12db9'', ''0'' to ''2024'', ''0'' to ''0'', ''0'' to ''16'', IsDeleted: ''False'' → ''False''', CAST(N'2025-07-31T00:45:50.7482642' AS DateTime2), N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0')
INSERT [dbo].[AuditLogs] ([Id], [StaffId], [Action], [EntityName], [EntityId], [Description], [Timestamp], [IPAddress], [UserAgent]) VALUES (N'04dbca50-c01b-4f7c-a352-21cddf385a98', N'b1009370-afce-4e2c-9fe2-25d6a0012178', N'ADD', N'Category', N'61a89505-4c2b-447d-9f06-0e8f57bd1c97', N'Created category ''Thien Phuc''', CAST(N'2025-07-24T16:57:55.5197973' AS DateTime2), N'::1', N'PostmanRuntime/7.44.1')
INSERT [dbo].[AuditLogs] ([Id], [StaffId], [Action], [EntityName], [EntityId], [Description], [Timestamp], [IPAddress], [UserAgent]) VALUES (N'a995b075-4aae-42e6-829e-24f4d92e40bf', N'b1009370-afce-4e2c-9fe2-25d6a0012178', N'ADD', N'Order', N'4b2864fc-d2e6-488d-a547-67981e398104', N'Created order by ''b1009370-afce-4e2c-9fe2-25d6a0012178''', CAST(N'2025-08-01T22:25:50.7211974' AS DateTime2), N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0')
INSERT [dbo].[AuditLogs] ([Id], [StaffId], [Action], [EntityName], [EntityId], [Description], [Timestamp], [IPAddress], [UserAgent]) VALUES (N'23449eef-0e6f-49de-a709-2668e59f6583', N'b1009370-afce-4e2c-9fe2-25d6a0012178', N'UPDATE', N'Customer', N'8ec41d47-6d8f-4f1f-9a0d-ff518cb2b83f', N'Updated category ''Trần'' to ''Trần'', ''Ngân'' to ''Ngân'', ''1/1/2003'' to ''1/1/2003'', ''Man Thiện'' to ''Man Thiện'', ''0987654556'' to ''0987654556'', ''True'' to ''True''', CAST(N'2025-07-31T15:07:17.2201171' AS DateTime2), N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0')
INSERT [dbo].[AuditLogs] ([Id], [StaffId], [Action], [EntityName], [EntityId], [Description], [Timestamp], [IPAddress], [UserAgent]) VALUES (N'b8fc69b8-4370-4347-bf3f-26f383fab6c6', N'b1009370-afce-4e2c-9fe2-25d6a0012178', N'DELETE', N'Author', N'228df486-5ff8-40a8-a2d1-c3f4a1a0fb9e', N'Soft deleted author ''Phuc Nao To''', CAST(N'2025-07-28T10:51:21.1975674' AS DateTime2), N'::1', N'PostmanRuntime/7.44.1')
INSERT [dbo].[AuditLogs] ([Id], [StaffId], [Action], [EntityName], [EntityId], [Description], [Timestamp], [IPAddress], [UserAgent]) VALUES (N'6856b9d5-4490-4e05-9ae3-285fcca85612', N'b1009370-afce-4e2c-9fe2-25d6a0012178', N'UPDATE', N'Book', N'358808bc-9c89-4431-8a5f-228bbbc86a6d', N'Updated book ''Gió Lạnh Đầu Mùa (Tái Bản 2024)'' to ''Gió Lạnh Đầu Mùa (Tái Bản 2024)'', IsDeleted: ''False'' → ''False''', CAST(N'2025-07-31T00:19:14.5497432' AS DateTime2), N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0')
INSERT [dbo].[AuditLogs] ([Id], [StaffId], [Action], [EntityName], [EntityId], [Description], [Timestamp], [IPAddress], [UserAgent]) VALUES (N'1ad1608c-65de-40b1-bea0-2b5c34ad320c', N'b1009370-afce-4e2c-9fe2-25d6a0012178', N'DELETE', N'Category', N'77619b52-0917-4c92-a264-e4bb91a2c434', N'Soft deleted category ''Trình ai chấm''', CAST(N'2025-07-29T09:20:48.3025189' AS DateTime2), N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0')
INSERT [dbo].[AuditLogs] ([Id], [StaffId], [Action], [EntityName], [EntityId], [Description], [Timestamp], [IPAddress], [UserAgent]) VALUES (N'0dcf940d-6eb1-417e-a768-2c5d4c9667d4', N'b1009370-afce-4e2c-9fe2-25d6a0012178', N'ADD', N'Customer', N'8ec41d47-6d8f-4f1f-9a0d-ff518cb2b83f', N'Created category ''Trần'' + '' '' + ''Ngân''', CAST(N'2025-07-31T15:06:28.0828843' AS DateTime2), N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0')
INSERT [dbo].[AuditLogs] ([Id], [StaffId], [Action], [EntityName], [EntityId], [Description], [Timestamp], [IPAddress], [UserAgent]) VALUES (N'e02dc9d5-ce95-4a85-93f8-2f2f18db65e5', N'b1009370-afce-4e2c-9fe2-25d6a0012178', N'UPDATE', N'Book', N'358808bc-9c89-4431-8a5f-228bbbc86a6d', N'Updated book ''Gió Lạnh Đầu Mùa (Tái Bản 2024)'' to ''Gió Lạnh Đầu Mùa (Tái Bản 2024)'', IsDeleted: ''False'' → ''False''', CAST(N'2025-07-31T00:14:40.1708278' AS DateTime2), N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0')
INSERT [dbo].[AuditLogs] ([Id], [StaffId], [Action], [EntityName], [EntityId], [Description], [Timestamp], [IPAddress], [UserAgent]) VALUES (N'1e41964c-f3ec-4fea-943f-30dbe7bac0b9', N'b1009370-afce-4e2c-9fe2-25d6a0012178', N'UPDATE', N'Category', N'61a89505-4c2b-447d-9f06-0e8f57bd1c97', N'Updated category ''Phuc Nao To'' to ''Phuc Nao To'', IsDeleted = False', CAST(N'2025-07-24T17:02:32.7415323' AS DateTime2), N'::1', N'PostmanRuntime/7.44.1')
INSERT [dbo].[AuditLogs] ([Id], [StaffId], [Action], [EntityName], [EntityId], [Description], [Timestamp], [IPAddress], [UserAgent]) VALUES (N'd442f39e-d2e9-410d-802c-323e191ab74e', N'b1009370-afce-4e2c-9fe2-25d6a0012178', N'UPDATE', N'Book', N'ddfde72a-7e11-49d5-89fb-e2766610c1cb', N'Updated book '''' to ''8934974188841'', ''Tôi Là Bêtô'' to ''Tôi Là Bêtô'', ''00000000-0000-0000-0000-000000000000'' to ''e2bc6d43-b35c-4b43-9215-8e186ffa60c0'', ''00000000-0000-0000-0000-000000000000'' to ''91396c60-f995-40ef-b732-2b1bc90bf66c'', ''00000000-0000-0000-0000-000000000000'' to ''2d64142c-1280-48e1-9207-c7a0023fa88f'', ''0'' to ''2023'', ''0'' to ''0'', ''0'' to ''8'', IsDeleted: ''False'' → ''False''', CAST(N'2025-07-31T00:47:05.9287574' AS DateTime2), N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0')
INSERT [dbo].[AuditLogs] ([Id], [StaffId], [Action], [EntityName], [EntityId], [Description], [Timestamp], [IPAddress], [UserAgent]) VALUES (N'a99122c2-df1e-4b9a-98b3-32bdb310a6d1', N'b1009370-afce-4e2c-9fe2-25d6a0012178', N'ADD', N'Order', N'0dbf8146-cd67-48c8-a634-8fb22af03e80', N'Created order by ''b1009370-afce-4e2c-9fe2-25d6a0012178''', CAST(N'2025-08-01T22:17:53.9993061' AS DateTime2), N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0')
INSERT [dbo].[AuditLogs] ([Id], [StaffId], [Action], [EntityName], [EntityId], [Description], [Timestamp], [IPAddress], [UserAgent]) VALUES (N'ad41fb2d-ba0f-4069-99d9-367b589e2e35', N'b1009370-afce-4e2c-9fe2-25d6a0012178', N'DELETE', N'Category', N'77619b52-0917-4c92-a264-e4bb91a2c434', N'Soft deleted category ''Trình ai chấm''', CAST(N'2025-07-28T11:04:09.4322980' AS DateTime2), N'::1', N'PostmanRuntime/7.44.1')
INSERT [dbo].[AuditLogs] ([Id], [StaffId], [Action], [EntityName], [EntityId], [Description], [Timestamp], [IPAddress], [UserAgent]) VALUES (N'1e21d3ae-231d-4ab4-821c-38aef235aade', N'b1009370-afce-4e2c-9fe2-25d6a0012178', N'UPDATE', N'Category', N'61a89505-4c2b-447d-9f06-0e8f57bd1c97', N'Updated category ''Phuc Nao To'' to ''Phuc Nao To'', IsDeleted ''False'' to ''False''', CAST(N'2025-07-27T15:37:13.8540727' AS DateTime2), N'::1', N'PostmanRuntime/7.44.1')
INSERT [dbo].[AuditLogs] ([Id], [StaffId], [Action], [EntityName], [EntityId], [Description], [Timestamp], [IPAddress], [UserAgent]) VALUES (N'7bf87d10-046b-4c73-82e0-390b169dd610', N'b1009370-afce-4e2c-9fe2-25d6a0012178', N'ADD', N'Order', N'd263c652-11fe-4e65-a6e1-887c5c9c4883', N'Created order by ''b1009370-afce-4e2c-9fe2-25d6a0012178''', CAST(N'2025-07-31T17:30:17.7387146' AS DateTime2), N'::1', N'PostmanRuntime/7.44.1')
INSERT [dbo].[AuditLogs] ([Id], [StaffId], [Action], [EntityName], [EntityId], [Description], [Timestamp], [IPAddress], [UserAgent]) VALUES (N'2789221f-cfd6-49c4-89b2-398a6559891d', N'b1009370-afce-4e2c-9fe2-25d6a0012178', N'UPDATE', N'Author', N'228df486-5ff8-40a8-a2d1-c3f4a1a0fb9e', N'Updated author ''Trình'' to ''Trình'', ''False'' to ''False''', CAST(N'2025-07-28T10:43:29.1368384' AS DateTime2), N'::1', N'PostmanRuntime/7.44.1')
INSERT [dbo].[AuditLogs] ([Id], [StaffId], [Action], [EntityName], [EntityId], [Description], [Timestamp], [IPAddress], [UserAgent]) VALUES (N'ca1a99d0-88b3-42e1-824a-3a2197ddbbce', N'b1009370-afce-4e2c-9fe2-25d6a0012178', N'ADD', N'Order', N'6b40a1ce-bab1-431d-8097-b8bf74e07da2', N'Created order by ''b1009370-afce-4e2c-9fe2-25d6a0012178''', CAST(N'2025-08-01T22:26:42.3271573' AS DateTime2), N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0')
INSERT [dbo].[AuditLogs] ([Id], [StaffId], [Action], [EntityName], [EntityId], [Description], [Timestamp], [IPAddress], [UserAgent]) VALUES (N'4cb7838f-b214-4985-8d40-3bd091989595', N'b1009370-afce-4e2c-9fe2-25d6a0012178', N'UPDATE', N'Category', N'61a89505-4c2b-447d-9f06-0e8f57bd1c97', N'Updated category ''Phuc Nao To'' to ''Phuc Nao To'', IsDeleted = False', CAST(N'2025-07-24T17:01:11.5835095' AS DateTime2), N'::1', N'PostmanRuntime/7.44.1')
INSERT [dbo].[AuditLogs] ([Id], [StaffId], [Action], [EntityName], [EntityId], [Description], [Timestamp], [IPAddress], [UserAgent]) VALUES (N'70cd48eb-d167-4adf-8b1d-3c3c76b0fbf3', N'b1009370-afce-4e2c-9fe2-25d6a0012178', N'DELETE', N'Author', N'228df486-5ff8-40a8-a2d1-c3f4a1a0fb9e', N'Soft deleted author ''Trình''', CAST(N'2025-07-28T10:43:22.4582143' AS DateTime2), N'::1', N'PostmanRuntime/7.44.1')
INSERT [dbo].[AuditLogs] ([Id], [StaffId], [Action], [EntityName], [EntityId], [Description], [Timestamp], [IPAddress], [UserAgent]) VALUES (N'a93a8be4-ef97-4167-bc7b-40ca3731bd82', N'b1009370-afce-4e2c-9fe2-25d6a0012178', N'ADD', N'Order', N'3d4c92f3-7d03-4244-8f45-4e98fadabfb6', N'Created order by ''b1009370-afce-4e2c-9fe2-25d6a0012178''', CAST(N'2025-07-31T18:29:05.8493821' AS DateTime2), N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0')
INSERT [dbo].[AuditLogs] ([Id], [StaffId], [Action], [EntityName], [EntityId], [Description], [Timestamp], [IPAddress], [UserAgent]) VALUES (N'5245eef1-09a2-4ef6-98b7-43ce2dcdc2b2', N'b1009370-afce-4e2c-9fe2-25d6a0012178', N'UPDATE', N'Book', N'da8d2d28-ec88-4514-b7c4-c8d19a43b857', N'Updated book '''' to ''8935095623945'', ''Chí Phèo (2017)'' to ''Chí Phèo (2017)'', ''00000000-0000-0000-0000-000000000000'' to ''aacac6e9-cdf4-4e53-9ddc-309e776c8612'', ''00000000-0000-0000-0000-000000000000'' to ''9d988694-ec03-4141-8f41-3fddce6bf4e7'', ''00000000-0000-0000-0000-000000000000'' to ''2d64142c-1280-48e1-9207-c7a0023fa88f'', ''0'' to ''2017'', ''0'' to ''0'', ''0'' to ''19'', IsDeleted: ''False'' → ''False''', CAST(N'2025-07-31T00:46:51.8800053' AS DateTime2), N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0')
INSERT [dbo].[AuditLogs] ([Id], [StaffId], [Action], [EntityName], [EntityId], [Description], [Timestamp], [IPAddress], [UserAgent]) VALUES (N'2a9ff852-b5ad-4820-8743-45958c8431d8', N'b1009370-afce-4e2c-9fe2-25d6a0012178', N'UPDATE', N'Staff', N'0437a958-8ee4-4adb-9741-34edaff87fe3', N'Updated category ''Nguyễn Ngọc Thiên'' to ''Nguyễn Ngọc Thiên'', ''Phúc'' to ''Phúc'', ''7/1/1999'' to ''7/1/1999'', ''Hưng Lộc'' to ''Hưng Lộc'', ''0987654445'' to ''0987654446'', ''phucnaoto@gmail.com'' to ''phucnaoto@gmail.com'', ''098789001232'' to ''098789001232'', ''False'' to ''False'', ''False'' to ''False''', CAST(N'2025-07-31T15:58:18.0918151' AS DateTime2), N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0')
INSERT [dbo].[AuditLogs] ([Id], [StaffId], [Action], [EntityName], [EntityId], [Description], [Timestamp], [IPAddress], [UserAgent]) VALUES (N'ecfdd671-efa0-4513-9522-47adaf68ac45', N'b1009370-afce-4e2c-9fe2-25d6a0012178', N'DELETE', N'Order', N'f66fa9ae-0a7d-45ed-bda0-4e91f9979a94', N'Soft deleted order by ''b1009370-afce-4e2c-9fe2-25d6a0012178''', CAST(N'2025-07-31T22:07:45.0698053' AS DateTime2), N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0')
INSERT [dbo].[AuditLogs] ([Id], [StaffId], [Action], [EntityName], [EntityId], [Description], [Timestamp], [IPAddress], [UserAgent]) VALUES (N'23a9587c-0f6b-409c-8ee6-48a7cb785f63', N'b1009370-afce-4e2c-9fe2-25d6a0012178', N'DELETE', N'Customer', N'8ec41d47-6d8f-4f1f-9a0d-ff518cb2b83f', N'Soft deleted category ''Trần'' + '' '' + ''Ngân''', CAST(N'2025-07-31T15:07:10.7016923' AS DateTime2), N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0')
INSERT [dbo].[AuditLogs] ([Id], [StaffId], [Action], [EntityName], [EntityId], [Description], [Timestamp], [IPAddress], [UserAgent]) VALUES (N'a24060f8-39fc-4d14-b9f0-4aa4279774d7', N'b1009370-afce-4e2c-9fe2-25d6a0012178', N'ADD', N'Author', N'228df486-5ff8-40a8-a2d1-c3f4a1a0fb9e', N'Created author ''Trinh Thám''', CAST(N'2025-07-28T10:42:18.2487248' AS DateTime2), N'::1', N'PostmanRuntime/7.44.1')
INSERT [dbo].[AuditLogs] ([Id], [StaffId], [Action], [EntityName], [EntityId], [Description], [Timestamp], [IPAddress], [UserAgent]) VALUES (N'e1aaba5a-50f5-44fd-abb1-525bc6a95c66', N'b1009370-afce-4e2c-9fe2-25d6a0012178', N'UPDATE', N'Order', N'3d4c92f3-7d03-4244-8f45-4e98fadabfb6', N'Updated order ''Thành công'' to ''Thành công'', '''' to '''', ''True'' to ''True''', CAST(N'2025-07-31T18:48:08.0951712' AS DateTime2), N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0')
INSERT [dbo].[AuditLogs] ([Id], [StaffId], [Action], [EntityName], [EntityId], [Description], [Timestamp], [IPAddress], [UserAgent]) VALUES (N'33871582-c243-4bb9-8af6-52bba625dd43', N'b1009370-afce-4e2c-9fe2-25d6a0012178', N'ADD', N'Order', N'f223def3-60a7-42ea-a468-e5bde4d843dd', N'Created order by ''b1009370-afce-4e2c-9fe2-25d6a0012178''', CAST(N'2025-07-31T18:39:39.1700915' AS DateTime2), N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0')
INSERT [dbo].[AuditLogs] ([Id], [StaffId], [Action], [EntityName], [EntityId], [Description], [Timestamp], [IPAddress], [UserAgent]) VALUES (N'1065d575-2fbf-4064-b264-53c60d637eb2', N'b1009370-afce-4e2c-9fe2-25d6a0012178', N'UPDATE', N'Book', N'9d22dade-e1b4-4a2a-9b9e-a567f839f189', N'Updated book '''' to ''8934974177319'', ''Những Chàng Trai Xấu Tính (Tái Bản 2022)'' to ''Những Chàng Trai Xấu Tính (Tái Bản 2022)'', ''00000000-0000-0000-0000-000000000000'' to ''e2bc6d43-b35c-4b43-9215-8e186ffa60c0'', ''00000000-0000-0000-0000-000000000000'' to ''91396c60-f995-40ef-b732-2b1bc90bf66c'', ''00000000-0000-0000-0000-000000000000'' to ''2d64142c-1280-48e1-9207-c7a0023fa88f'', ''0'' to ''2022'', ''0'' to ''0'', ''0'' to ''46'', IsDeleted: ''False'' → ''False''', CAST(N'2025-07-31T00:46:22.9668215' AS DateTime2), N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0')
INSERT [dbo].[AuditLogs] ([Id], [StaffId], [Action], [EntityName], [EntityId], [Description], [Timestamp], [IPAddress], [UserAgent]) VALUES (N'd2f495fb-46bc-49e6-94b0-53e7076395a4', N'b1009370-afce-4e2c-9fe2-25d6a0012178', N'ADD', N'Order', N'16696407-7d32-427b-a94c-e2f8c367cf3c', N'Created order by ''b1009370-afce-4e2c-9fe2-25d6a0012178''', CAST(N'2025-07-31T18:48:33.6018629' AS DateTime2), N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0')
INSERT [dbo].[AuditLogs] ([Id], [StaffId], [Action], [EntityName], [EntityId], [Description], [Timestamp], [IPAddress], [UserAgent]) VALUES (N'5db000eb-bf77-424f-9fe6-549eedfd677e', N'b1009370-afce-4e2c-9fe2-25d6a0012178', N'UPDATE', N'Staff', N'0437a958-8ee4-4adb-9741-34edaff87fe3', N'Updated category ''Nguyễn Ngọc Thiên'' to ''Nguyễn Ngọc Thiên'', ''Phúc'' to ''Phúc'', ''7/1/1999'' to ''7/1/1999'', ''Hưng Lộc'' to ''Hưng Lộc'', ''0987654446'' to ''0987654446'', ''phucnaoto@gmail.com'' to ''phucnaoto@gmail.com'', ''098789001232'' to ''098789001232'', ''False'' to ''False'', ''False'' to ''False''', CAST(N'2025-07-31T15:58:59.7523830' AS DateTime2), N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0')
INSERT [dbo].[AuditLogs] ([Id], [StaffId], [Action], [EntityName], [EntityId], [Description], [Timestamp], [IPAddress], [UserAgent]) VALUES (N'4c3335be-d8ff-48a5-8330-5541e0061a0d', N'b1009370-afce-4e2c-9fe2-25d6a0012178', N'DELETE', N'Staff', N'0437a958-8ee4-4adb-9741-34edaff87fe3', N'Soft deleted staff ''Nguyễn Ngọc Thiên Phúc''', CAST(N'2025-07-31T16:00:02.6078048' AS DateTime2), N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0')
INSERT [dbo].[AuditLogs] ([Id], [StaffId], [Action], [EntityName], [EntityId], [Description], [Timestamp], [IPAddress], [UserAgent]) VALUES (N'706c0e9d-7f9c-4964-ab30-584def368568', N'b1009370-afce-4e2c-9fe2-25d6a0012178', N'ADD', N'Order', N'f66fa9ae-0a7d-45ed-bda0-4e91f9979a94', N'Created order by ''b1009370-afce-4e2c-9fe2-25d6a0012178''', CAST(N'2025-07-31T22:07:32.3408280' AS DateTime2), N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0')
INSERT [dbo].[AuditLogs] ([Id], [StaffId], [Action], [EntityName], [EntityId], [Description], [Timestamp], [IPAddress], [UserAgent]) VALUES (N'0bf94a19-6069-4ef7-969f-5a10fed552c7', N'b1009370-afce-4e2c-9fe2-25d6a0012178', N'DELETE', N'Customer', N'8ec41d47-6d8f-4f1f-9a0d-ff518cb2b83f', N'Soft deleted category ''Trần'' + '' '' + ''Ngân''', CAST(N'2025-07-31T15:07:19.2927389' AS DateTime2), N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0')
INSERT [dbo].[AuditLogs] ([Id], [StaffId], [Action], [EntityName], [EntityId], [Description], [Timestamp], [IPAddress], [UserAgent]) VALUES (N'9fc65101-2813-49b3-b613-5ac27b2b9bf8', N'b1009370-afce-4e2c-9fe2-25d6a0012178', N'UPDATE', N'Staff', N'0437a958-8ee4-4adb-9741-34edaff87fe3', N'Updated category ''Nguyễn Ngọc Thiên'' to ''Nguyễn Ngọc Thiên'', ''Phúc'' to ''Phúc'', ''7/1/1999'' to ''7/1/1999'', ''Hưng Lộc'' to ''Hưng Lộc'', ''0987654446'' to ''0987654446'', ''phucnaoto@gmail.com'' to ''phucnaoto@gmail.com'', ''098789001232'' to ''098789001232'', ''False'' to ''False'', ''False'' to ''False''', CAST(N'2025-07-31T16:00:11.6950677' AS DateTime2), N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0')
INSERT [dbo].[AuditLogs] ([Id], [StaffId], [Action], [EntityName], [EntityId], [Description], [Timestamp], [IPAddress], [UserAgent]) VALUES (N'bb61bd42-1b85-4768-ac62-5c6687f45b90', N'b1009370-afce-4e2c-9fe2-25d6a0012178', N'UPDATE', N'Book', N'b11ff973-84f6-4adb-9c31-b6cc0fe93fdf', N'Updated book '''' to ''8936203362206'', ''Gió Đầu Mùa & Hà Nội Băm Sáu Phố Phường'' to ''Gió Đầu Mùa & Hà Nội Băm Sáu Phố Phường'', ''00000000-0000-0000-0000-000000000000'' to ''aacac6e9-cdf4-4e53-9ddc-309e776c8612'', ''00000000-0000-0000-0000-000000000000'' to ''09189d44-9a03-44fa-a026-3704ad76ffd8'', ''00000000-0000-0000-0000-000000000000'' to ''2d64142c-1280-48e1-9207-c7a0023fa88f'', ''0'' to ''2022'', ''0'' to ''0'', ''0'' to ''33'', IsDeleted: ''False'' → ''False''', CAST(N'2025-07-31T00:46:31.5048775' AS DateTime2), N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0')
INSERT [dbo].[AuditLogs] ([Id], [StaffId], [Action], [EntityName], [EntityId], [Description], [Timestamp], [IPAddress], [UserAgent]) VALUES (N'd0715a08-aa3c-4bda-b631-5fe09c68a4c7', N'b1009370-afce-4e2c-9fe2-25d6a0012178', N'UPDATE', N'Book', N'e2ccf867-c124-4e33-9b48-5cca2fb7a7f0', N'Updated book '''' to ''8934974178620'', ''Hoa Hồng Xứ Khác (Tái Bản 2022)'' to ''Hoa Hồng Xứ Khác (Tái Bản 2022)'', ''00000000-0000-0000-0000-000000000000'' to ''e2bc6d43-b35c-4b43-9215-8e186ffa60c0'', ''00000000-0000-0000-0000-000000000000'' to ''91396c60-f995-40ef-b732-2b1bc90bf66c'', ''00000000-0000-0000-0000-000000000000'' to ''2d64142c-1280-48e1-9207-c7a0023fa88f'', ''0'' to ''2022'', ''0'' to ''0'', ''0'' to ''20'', IsDeleted: ''False'' → ''False''', CAST(N'2025-07-31T00:45:32.7249290' AS DateTime2), N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0')
INSERT [dbo].[AuditLogs] ([Id], [StaffId], [Action], [EntityName], [EntityId], [Description], [Timestamp], [IPAddress], [UserAgent]) VALUES (N'3085abd3-5bfc-4514-9443-65ba70da2cfa', N'b1009370-afce-4e2c-9fe2-25d6a0012178', N'UPDATE', N'Order', N'f66fa9ae-0a7d-45ed-bda0-4e91f9979a94', N'Updated order ''Thành công'' to ''Thành công'', '''' to '''', ''True'' to ''True''', CAST(N'2025-08-01T16:52:34.5344163' AS DateTime2), N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0')
INSERT [dbo].[AuditLogs] ([Id], [StaffId], [Action], [EntityName], [EntityId], [Description], [Timestamp], [IPAddress], [UserAgent]) VALUES (N'930b8d9f-ff08-4732-aa61-66f9863df63c', N'b1009370-afce-4e2c-9fe2-25d6a0012178', N'UPDATE', N'Book', N'5c558548-e6b9-424c-9949-8ef7cf63e1ac', N'Updated book '''' to ''8935230001218'', ''Danh Tác Việt Nam - Chí Phèo (Tái Bản 2025)'' to ''Danh Tác Việt Nam - Chí Phèo (Tái Bản 2025)'', ''00000000-0000-0000-0000-000000000000'' to ''aacac6e9-cdf4-4e53-9ddc-309e776c8612'', ''00000000-0000-0000-0000-000000000000'' to ''9d988694-ec03-4141-8f41-3fddce6bf4e7'', ''00000000-0000-0000-0000-000000000000'' to ''2d64142c-1280-48e1-9207-c7a0023fa88f'', ''0'' to ''2025'', ''0'' to ''0'', ''0'' to ''13'', IsDeleted: ''False'' → ''False''', CAST(N'2025-07-31T00:46:13.2764045' AS DateTime2), N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0')
INSERT [dbo].[AuditLogs] ([Id], [StaffId], [Action], [EntityName], [EntityId], [Description], [Timestamp], [IPAddress], [UserAgent]) VALUES (N'd405962a-e674-4858-ab96-67e61abf8392', N'b1009370-afce-4e2c-9fe2-25d6a0012178', N'UPDATE', N'Book', N'358808bc-9c89-4431-8a5f-228bbbc86a6d', N'Updated book ''8935212366533'' to ''8935212366533'', ''Gió Lạnh Đầu Mùa (Tái Bản 2024)'' to ''Gió Lạnh Đầu Mùa (Tái Bản 2024)'', ''e2bc6d43-b35c-4b43-9215-8e186ffa60c0'' to ''e2bc6d43-b35c-4b43-9215-8e186ffa60c0'', ''09189d44-9a03-44fa-a026-3704ad76ffd8'' to ''09189d44-9a03-44fa-a026-3704ad76ffd8'', ''79994ae3-d421-4b92-b895-323c19e12db9'' to ''79994ae3-d421-4b92-b895-323c19e12db9'', ''2024'' to ''2024'', ''59000'' to ''59000'', ''20'' to ''20'', IsDeleted: ''False'' → ''False''', CAST(N'2025-07-31T00:50:39.3380556' AS DateTime2), N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0')
INSERT [dbo].[AuditLogs] ([Id], [StaffId], [Action], [EntityName], [EntityId], [Description], [Timestamp], [IPAddress], [UserAgent]) VALUES (N'aff84e46-270d-4e0c-8d4d-6c0dab8dbcca', N'b1009370-afce-4e2c-9fe2-25d6a0012178', N'ADD', N'Publisher', N'fa196dad-e9a3-44b7-bef5-821ccb4b59fe', N'Soft deleted publisher ''Phúc Não To''', CAST(N'2025-07-30T16:57:57.4281445' AS DateTime2), N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0')
INSERT [dbo].[AuditLogs] ([Id], [StaffId], [Action], [EntityName], [EntityId], [Description], [Timestamp], [IPAddress], [UserAgent]) VALUES (N'7e93ba63-80b4-4211-afb1-6ccf9d97dd12', N'b1009370-afce-4e2c-9fe2-25d6a0012178', N'UPDATE', N'Author', N'228df486-5ff8-40a8-a2d1-c3f4a1a0fb9e', N'Updated author ''Trình ai chấm'' to ''Phuc Nao To'', ''True'' to ''False''', CAST(N'2025-07-28T10:51:00.2140480' AS DateTime2), N'::1', N'PostmanRuntime/7.44.1')
INSERT [dbo].[AuditLogs] ([Id], [StaffId], [Action], [EntityName], [EntityId], [Description], [Timestamp], [IPAddress], [UserAgent]) VALUES (N'40aad3ea-8db4-48c2-a754-72b0fc31cf60', N'b1009370-afce-4e2c-9fe2-25d6a0012178', N'UPDATE', N'Book', N'358808bc-9c89-4431-8a5f-228bbbc86a6d', N'Updated book ''Gió Lạnh Đầu Mùa (Tái Bản 2024)'' to ''Gió Lạnh Đầu Mùa (Tái Bản 2024)'', IsDeleted: ''False'' → ''False''', CAST(N'2025-07-30T18:22:50.2979442' AS DateTime2), N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0')
INSERT [dbo].[AuditLogs] ([Id], [StaffId], [Action], [EntityName], [EntityId], [Description], [Timestamp], [IPAddress], [UserAgent]) VALUES (N'53f949f8-5cc9-4b28-a2e6-7347aec07e57', N'b1009370-afce-4e2c-9fe2-25d6a0012178', N'UPDATE', N'Book', N'358808bc-9c89-4431-8a5f-228bbbc86a6d', N'Updated book ''Gió Lạnh Đầu Mùa (Tái Bản 2024)'' to ''Gió Lạnh Đầu Mùa (Tái Bản 2024)'', IsDeleted: ''False'' → ''False''', CAST(N'2025-07-31T00:29:41.6749419' AS DateTime2), N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0')
INSERT [dbo].[AuditLogs] ([Id], [StaffId], [Action], [EntityName], [EntityId], [Description], [Timestamp], [IPAddress], [UserAgent]) VALUES (N'e3af287b-fbc9-4d96-a588-7480682208ef', N'b1009370-afce-4e2c-9fe2-25d6a0012178', N'UPDATE', N'Publisher', N'ccb3f633-58ff-44a2-9aa5-8d73fd35d39e', N'Updated publisher ''Nhà xuất bản Tự do'' to ''Nhà xuất bản Tự do'', ''True'' to ''False''', CAST(N'2025-07-30T17:00:19.1304521' AS DateTime2), N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0')
INSERT [dbo].[AuditLogs] ([Id], [StaffId], [Action], [EntityName], [EntityId], [Description], [Timestamp], [IPAddress], [UserAgent]) VALUES (N'47828be6-fba1-411c-9daa-7526541a17bc', N'b1009370-afce-4e2c-9fe2-25d6a0012178', N'UPDATE', N'Author', N'228df486-5ff8-40a8-a2d1-c3f4a1a0fb9e', N'Updated author ''Trinh Thám'' to ''Trinh Thám'', ''True'' to ''True''', CAST(N'2025-07-28T10:45:48.1399097' AS DateTime2), N'::1', N'PostmanRuntime/7.44.1')
INSERT [dbo].[AuditLogs] ([Id], [StaffId], [Action], [EntityName], [EntityId], [Description], [Timestamp], [IPAddress], [UserAgent]) VALUES (N'aad8dd12-da06-45b3-9e48-7627a85210b9', N'b1009370-afce-4e2c-9fe2-25d6a0012178', N'UPDATE', N'Book', N'4bfd61cb-691d-49fc-acf4-d91aedd5fbf6', N'Updated book '''' to ''8934974170600'', ''Con Chim Xanh Biếc Bay Về'' to ''Con Chim Xanh Biếc Bay Về'', ''00000000-0000-0000-0000-000000000000'' to ''e2bc6d43-b35c-4b43-9215-8e186ffa60c0'', ''00000000-0000-0000-0000-000000000000'' to ''91396c60-f995-40ef-b732-2b1bc90bf66c'', ''00000000-0000-0000-0000-000000000000'' to ''79994ae3-d421-4b92-b895-323c19e12db9'', ''0'' to ''2020'', ''0'' to ''0'', ''0'' to ''70'', IsDeleted: ''False'' → ''False''', CAST(N'2025-07-31T00:46:59.4242746' AS DateTime2), N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0')
INSERT [dbo].[AuditLogs] ([Id], [StaffId], [Action], [EntityName], [EntityId], [Description], [Timestamp], [IPAddress], [UserAgent]) VALUES (N'9fb6ce42-9e98-44e0-b85a-77497ab2afc9', N'b1009370-afce-4e2c-9fe2-25d6a0012178', N'ADD', N'Publisher', N'ccb3f633-58ff-44a2-9aa5-8d73fd35d39e', N'Created publisher ''Nhà xuất bản Tự nhiên''', CAST(N'2025-07-30T17:00:03.7166263' AS DateTime2), N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0')
INSERT [dbo].[AuditLogs] ([Id], [StaffId], [Action], [EntityName], [EntityId], [Description], [Timestamp], [IPAddress], [UserAgent]) VALUES (N'39900cfe-32b0-49bb-a35a-77af0e5410e9', N'b1009370-afce-4e2c-9fe2-25d6a0012178', N'UPDATE', N'Customer', N'4da1e043-c6c4-4fe6-8157-c8064e17a512', N'Updated category ''Nguyễn'' to ''Nguyễn'', ''Phúc'' to ''Phúc'', ''8/16/2003'' to ''8/16/2003'', ''Thống Nhất'' to ''Thống Nhất'', ''0989890001'' to ''0989890001'', ''False'' to ''False''', CAST(N'2025-07-31T14:51:39.1494302' AS DateTime2), N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0')
INSERT [dbo].[AuditLogs] ([Id], [StaffId], [Action], [EntityName], [EntityId], [Description], [Timestamp], [IPAddress], [UserAgent]) VALUES (N'1a7c0c87-3025-48fb-813a-7879118f4239', N'b1009370-afce-4e2c-9fe2-25d6a0012178', N'ADD', N'Order', N'46712af3-1ca6-4b72-8dc0-b46966042242', N'Created order by ''b1009370-afce-4e2c-9fe2-25d6a0012178''', CAST(N'2025-08-01T22:26:19.5574941' AS DateTime2), N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0')
INSERT [dbo].[AuditLogs] ([Id], [StaffId], [Action], [EntityName], [EntityId], [Description], [Timestamp], [IPAddress], [UserAgent]) VALUES (N'7642785d-ec30-4984-97fe-7b808e1bf9b4', N'b1009370-afce-4e2c-9fe2-25d6a0012178', N'UPDATE', N'Promotion', N'da858eda-196e-45fb-8350-1845e2c67799', N'Updated category ''Khuyến Mãi Tháng 8'' to ''Khuyến Mãi Tháng 8'', ''8/1/2025 12:00:00 AM'' to ''8/1/2025 12:00:00 AM'', ''8/31/2025 12:00:00 AM'' to ''8/31/2025 12:00:00 AM'', ''50000'' to ''50000'', ''0.10'' to ''0.1'', ''100'' to ''100'', IsDeleted ''True'' to ''False''', CAST(N'2025-07-31T01:16:44.7167301' AS DateTime2), N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0')
INSERT [dbo].[AuditLogs] ([Id], [StaffId], [Action], [EntityName], [EntityId], [Description], [Timestamp], [IPAddress], [UserAgent]) VALUES (N'56759358-44d4-4156-ba4d-7b927c06d118', N'b1009370-afce-4e2c-9fe2-25d6a0012178', N'UPDATE', N'Book', N'0b72ee3b-7e66-4cba-b5ee-3fcc947b3a03', N'Updated book '''' to ''8934974178194'', ''Bong Bóng Lên Trời (2022)'' to ''Bong Bóng Lên Trời (2022)'', ''00000000-0000-0000-0000-000000000000'' to ''e2bc6d43-b35c-4b43-9215-8e186ffa60c0'', ''00000000-0000-0000-0000-000000000000'' to ''91396c60-f995-40ef-b732-2b1bc90bf66c'', ''00000000-0000-0000-0000-000000000000'' to ''2d64142c-1280-48e1-9207-c7a0023fa88f'', ''0'' to ''2022'', ''0'' to ''0'', ''0'' to ''76'', IsDeleted: ''False'' → ''False''', CAST(N'2025-07-31T00:45:02.0224690' AS DateTime2), N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0')
INSERT [dbo].[AuditLogs] ([Id], [StaffId], [Action], [EntityName], [EntityId], [Description], [Timestamp], [IPAddress], [UserAgent]) VALUES (N'cfe541a5-e5a6-4071-971d-7d6b18497ee9', N'b1009370-afce-4e2c-9fe2-25d6a0012178', N'UPDATE', N'Category', N'61a89505-4c2b-447d-9f06-0e8f57bd1c97', N'Updated category ''Phuc Nao To'' to ''Phuc Nao To'', IsDeleted = True', CAST(N'2025-07-24T17:02:15.4954028' AS DateTime2), N'::1', N'PostmanRuntime/7.44.1')
INSERT [dbo].[AuditLogs] ([Id], [StaffId], [Action], [EntityName], [EntityId], [Description], [Timestamp], [IPAddress], [UserAgent]) VALUES (N'fd1053ea-ddbe-468e-9982-7f459ca35fce', N'b1009370-afce-4e2c-9fe2-25d6a0012178', N'ADD', N'Customer', N'833fe43e-cdbe-4587-a642-0a76f994e24e', N'Created customer ''Nguyễn Ngọc Thiên Phú''', CAST(N'2025-08-01T22:24:59.0985681' AS DateTime2), N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0')
INSERT [dbo].[AuditLogs] ([Id], [StaffId], [Action], [EntityName], [EntityId], [Description], [Timestamp], [IPAddress], [UserAgent]) VALUES (N'f7f7d3c4-56f4-4f7d-bf5c-817b851ab25d', N'b1009370-afce-4e2c-9fe2-25d6a0012178', N'DELETE', N'Category', N'61a89505-4c2b-447d-9f06-0e8f57bd1c97', N'Soft deleted category ''Phuc Nao To''', CAST(N'2025-07-27T15:37:21.2552092' AS DateTime2), N'::1', N'PostmanRuntime/7.44.1')
INSERT [dbo].[AuditLogs] ([Id], [StaffId], [Action], [EntityName], [EntityId], [Description], [Timestamp], [IPAddress], [UserAgent]) VALUES (N'6fa7cd3d-00c1-4290-8699-81b469983a2e', N'0437a958-8ee4-4adb-9741-34edaff87fe3', N'ADD', N'Order', N'262d0333-3f6e-4001-8cd3-d54ae55b070f', N'Created order by ''0437a958-8ee4-4adb-9741-34edaff87fe3''', CAST(N'2025-07-31T17:34:29.3338908' AS DateTime2), N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0')
INSERT [dbo].[AuditLogs] ([Id], [StaffId], [Action], [EntityName], [EntityId], [Description], [Timestamp], [IPAddress], [UserAgent]) VALUES (N'c8340ca2-93a8-4d5b-b934-82a87e36b466', N'b1009370-afce-4e2c-9fe2-25d6a0012178', N'UPDATE', N'Category', N'e8afa175-56b4-467b-9b7e-65d2f2c1032f', N'Updated category ''Hài Hước'' to ''Hài Hước'', IsDeleted ''True'' to ''False''', CAST(N'2025-07-29T09:18:15.9453731' AS DateTime2), N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0')
INSERT [dbo].[AuditLogs] ([Id], [StaffId], [Action], [EntityName], [EntityId], [Description], [Timestamp], [IPAddress], [UserAgent]) VALUES (N'b1a31bae-dc4c-47ca-b7b7-832bd53b274d', N'b1009370-afce-4e2c-9fe2-25d6a0012178', N'DELETE', N'Promotion', N'a38f02af-6754-40fd-bba1-3607bf60427a', N'Soft deleted category ''Khuyến Mãi Mùa hè''', CAST(N'2025-07-31T01:15:11.7783086' AS DateTime2), N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0')
INSERT [dbo].[AuditLogs] ([Id], [StaffId], [Action], [EntityName], [EntityId], [Description], [Timestamp], [IPAddress], [UserAgent]) VALUES (N'6b7f03f6-afa9-49db-bed9-833058e87093', N'b1009370-afce-4e2c-9fe2-25d6a0012178', N'UPDATE', N'Category', N'61a89505-4c2b-447d-9f06-0e8f57bd1c97', N'Updated category ''Phuc Nao To'' to ''Phuc Nao To'', IsDeleted ''True'' to ''True''', CAST(N'2025-07-31T22:06:54.1294766' AS DateTime2), N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0')
INSERT [dbo].[AuditLogs] ([Id], [StaffId], [Action], [EntityName], [EntityId], [Description], [Timestamp], [IPAddress], [UserAgent]) VALUES (N'585835e4-03c9-4835-8c29-844977837f8f', N'b1009370-afce-4e2c-9fe2-25d6a0012178', N'UPDATE', N'Book', N'643db72a-f24b-4e07-9e16-458db1f4b135', N'Updated book '''' to ''8934974178682'', ''Phòng Trọ Ba Người (Tái Bản 2022)'' to ''Phòng Trọ Ba Người (Tái Bản 2022)'', ''00000000-0000-0000-0000-000000000000'' to ''e2bc6d43-b35c-4b43-9215-8e186ffa60c0'', ''00000000-0000-0000-0000-000000000000'' to ''91396c60-f995-40ef-b732-2b1bc90bf66c'', ''00000000-0000-0000-0000-000000000000'' to ''2d64142c-1280-48e1-9207-c7a0023fa88f'', ''0'' to ''2022'', ''0'' to ''0'', ''0'' to ''13'', IsDeleted: ''False'' → ''False''', CAST(N'2025-07-31T00:45:16.3131773' AS DateTime2), N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0')
INSERT [dbo].[AuditLogs] ([Id], [StaffId], [Action], [EntityName], [EntityId], [Description], [Timestamp], [IPAddress], [UserAgent]) VALUES (N'170e7cfb-05c5-4986-b0a7-84f5b4c43fc4', N'b1009370-afce-4e2c-9fe2-25d6a0012178', N'ADD', N'Customer', N'cfd6a6dc-ae6e-4cea-9b90-9111868c3a51', N'Created customer ''Nguyễn Ngọc Thiên Kim''', CAST(N'2025-08-01T22:36:25.4336870' AS DateTime2), N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0')
INSERT [dbo].[AuditLogs] ([Id], [StaffId], [Action], [EntityName], [EntityId], [Description], [Timestamp], [IPAddress], [UserAgent]) VALUES (N'e91f80c8-27ff-4a11-9286-859aba7dc18e', N'b1009370-afce-4e2c-9fe2-25d6a0012178', N'UPDATE', N'Book', N'66d85958-f12d-43af-9827-684fe9e387d4', N'Updated book '''' to ''9786044916927'', ''Sống Mòn'' to ''Sống Mòn'', ''00000000-0000-0000-0000-000000000000'' to ''aacac6e9-cdf4-4e53-9ddc-309e776c8612'', ''00000000-0000-0000-0000-000000000000'' to ''9d988694-ec03-4141-8f41-3fddce6bf4e7'', ''00000000-0000-0000-0000-000000000000'' to ''79994ae3-d421-4b92-b895-323c19e12db9'', ''0'' to ''2024'', ''0'' to ''0'', ''0'' to ''35'', IsDeleted: ''False'' → ''False''', CAST(N'2025-07-31T00:45:57.2047257' AS DateTime2), N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0')
INSERT [dbo].[AuditLogs] ([Id], [StaffId], [Action], [EntityName], [EntityId], [Description], [Timestamp], [IPAddress], [UserAgent]) VALUES (N'88811042-584d-432d-a34b-85d475866bab', N'b1009370-afce-4e2c-9fe2-25d6a0012178', N'DELETE', N'Author', N'91396c60-f995-40ef-b732-2b1bc90bf66c', N'Soft deleted author ''Nguyễn Nhật Ánh''', CAST(N'2025-07-29T09:45:20.3211955' AS DateTime2), N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0')
INSERT [dbo].[AuditLogs] ([Id], [StaffId], [Action], [EntityName], [EntityId], [Description], [Timestamp], [IPAddress], [UserAgent]) VALUES (N'66c5c3ac-0881-46c2-9713-8f9e7d6a517d', N'b1009370-afce-4e2c-9fe2-25d6a0012178', N'ADD', N'Order', N'4196a906-de69-4ccf-85ab-22351421a1ed', N'Created order by ''b1009370-afce-4e2c-9fe2-25d6a0012178''', CAST(N'2025-08-01T22:26:26.3599902' AS DateTime2), N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0')
INSERT [dbo].[AuditLogs] ([Id], [StaffId], [Action], [EntityName], [EntityId], [Description], [Timestamp], [IPAddress], [UserAgent]) VALUES (N'97cf1c60-6d5d-4d74-9cc4-93c8054e2007', N'b1009370-afce-4e2c-9fe2-25d6a0012178', N'DELETE', N'Order', N'3d4c92f3-7d03-4244-8f45-4e98fadabfb6', N'Soft deleted order by ''b1009370-afce-4e2c-9fe2-25d6a0012178''', CAST(N'2025-07-31T18:48:04.0658046' AS DateTime2), N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0')
INSERT [dbo].[AuditLogs] ([Id], [StaffId], [Action], [EntityName], [EntityId], [Description], [Timestamp], [IPAddress], [UserAgent]) VALUES (N'ce979a4d-839b-45d3-9d1b-95238a514e82', N'b1009370-afce-4e2c-9fe2-25d6a0012178', N'UPDATE', N'Order', N'd263c652-11fe-4e65-a6e1-887c5c9c4883', N'Updated order ''Thành công'' to ''Thành công'', '''' to '''', ''True'' to ''True''', CAST(N'2025-07-31T17:47:00.4551548' AS DateTime2), N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0')
INSERT [dbo].[AuditLogs] ([Id], [StaffId], [Action], [EntityName], [EntityId], [Description], [Timestamp], [IPAddress], [UserAgent]) VALUES (N'4fddb4ae-bed5-428d-bf08-97041aa8f2d3', N'b1009370-afce-4e2c-9fe2-25d6a0012178', N'UPDATE', N'Customer', N'4da1e043-c6c4-4fe6-8157-c8064e17a512', N'Updated category ''Nguyễn'' to ''Nguyễn'', ''Phúc'' to ''Phúc'', ''8/16/2003'' to ''8/16/2003'', ''Thống Nhất'' to ''Thống Nhất'', ''0989890001'' to ''0989890001'', ''False'' to ''False''', CAST(N'2025-07-31T14:51:29.3008922' AS DateTime2), N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0')
INSERT [dbo].[AuditLogs] ([Id], [StaffId], [Action], [EntityName], [EntityId], [Description], [Timestamp], [IPAddress], [UserAgent]) VALUES (N'3f1e2669-441d-4fa1-a801-97c1479b58de', N'b1009370-afce-4e2c-9fe2-25d6a0012178', N'ADD', N'Publisher', N'fa196dad-e9a3-44b7-bef5-821ccb4b59fe', N'Updated publisher ''Phúc Não To'' to ''Phúc Não Cực To'', ''True'' to ''True''', CAST(N'2025-07-30T16:58:04.2293611' AS DateTime2), N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0')
INSERT [dbo].[AuditLogs] ([Id], [StaffId], [Action], [EntityName], [EntityId], [Description], [Timestamp], [IPAddress], [UserAgent]) VALUES (N'ec2d8819-edc9-40d8-9ce5-9bd49596f505', N'b1009370-afce-4e2c-9fe2-25d6a0012178', N'UPDATE', N'Book', N'358808bc-9c89-4431-8a5f-228bbbc86a6d', N'Updated book ''Gió Lạnh Đầu Mùa (Tái Bản 2024)'' to ''Gió Lạnh Đầu Mùa (Tái Bản 2024)'', IsDeleted: ''False'' → ''False''', CAST(N'2025-07-31T00:19:08.7498894' AS DateTime2), N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0')
INSERT [dbo].[AuditLogs] ([Id], [StaffId], [Action], [EntityName], [EntityId], [Description], [Timestamp], [IPAddress], [UserAgent]) VALUES (N'5617331f-df71-43bf-8617-9c9e9be3572f', N'b1009370-afce-4e2c-9fe2-25d6a0012178', N'UPDATE', N'Publisher', N'ccb3f633-58ff-44a2-9aa5-8d73fd35d39e', N'Updated publisher ''Nhà xuất bản Tự nhiên'' to ''Nhà xuất bản Tự do'', ''False'' to ''True''', CAST(N'2025-07-30T17:00:11.2431831' AS DateTime2), N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0')
INSERT [dbo].[AuditLogs] ([Id], [StaffId], [Action], [EntityName], [EntityId], [Description], [Timestamp], [IPAddress], [UserAgent]) VALUES (N'9ac116d5-b67b-489f-b031-9d15d7deeb33', N'b1009370-afce-4e2c-9fe2-25d6a0012178', N'ADD', N'Order', N'7e778f62-49dc-4683-8b75-0d3c6cf602bc', N'Created order by ''b1009370-afce-4e2c-9fe2-25d6a0012178''', CAST(N'2025-08-01T16:56:01.8513348' AS DateTime2), N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0')
INSERT [dbo].[AuditLogs] ([Id], [StaffId], [Action], [EntityName], [EntityId], [Description], [Timestamp], [IPAddress], [UserAgent]) VALUES (N'ffcbabf0-85c5-494f-b347-a109051bbff2', N'b1009370-afce-4e2c-9fe2-25d6a0012178', N'ADD', N'Customer', N'b76f930b-7782-42c6-a556-68d1862624fd', N'Created customer ''Test 1''', CAST(N'2025-08-01T23:22:34.6363789' AS DateTime2), N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0')
INSERT [dbo].[AuditLogs] ([Id], [StaffId], [Action], [EntityName], [EntityId], [Description], [Timestamp], [IPAddress], [UserAgent]) VALUES (N'c25bfb3a-efa7-4aee-83dd-a45e793f8747', N'b1009370-afce-4e2c-9fe2-25d6a0012178', N'ADD', N'Order', N'224b2327-5e24-4957-9437-96ab8f2993fc', N'Created order by ''b1009370-afce-4e2c-9fe2-25d6a0012178''', CAST(N'2025-07-31T17:32:37.5339144' AS DateTime2), N'::1', N'PostmanRuntime/7.44.1')
INSERT [dbo].[AuditLogs] ([Id], [StaffId], [Action], [EntityName], [EntityId], [Description], [Timestamp], [IPAddress], [UserAgent]) VALUES (N'fae67f14-e90c-4594-92ce-a4c977006d61', N'b1009370-afce-4e2c-9fe2-25d6a0012178', N'UPDATE', N'Category', N'77619b52-0917-4c92-a264-e4bb91a2c434', N'Updated category ''Trình ai chấm'' to ''Trình ai chấm'', IsDeleted ''True'' to ''False''', CAST(N'2025-07-28T11:05:03.5495292' AS DateTime2), N'::1', N'PostmanRuntime/7.44.1')
INSERT [dbo].[AuditLogs] ([Id], [StaffId], [Action], [EntityName], [EntityId], [Description], [Timestamp], [IPAddress], [UserAgent]) VALUES (N'77fa0c0a-3957-40bb-a320-a93e5f1d23d0', N'b1009370-afce-4e2c-9fe2-25d6a0012178', N'UPDATE', N'Book', N'55c70857-c0a9-4710-9ed5-34d6abb2bd10', N'Updated book '''' to ''8935244822571'', ''Văn Học Trong Nhà Trường - Gió Lạnh Đầu Mùa (Tái Bản 2019)'' to ''Văn Học Trong Nhà Trường - Gió Lạnh Đầu Mùa (Tái Bản 2019)'', ''00000000-0000-0000-0000-000000000000'' to ''e2bc6d43-b35c-4b43-9215-8e186ffa60c0'', ''00000000-0000-0000-0000-000000000000'' to ''09189d44-9a03-44fa-a026-3704ad76ffd8'', ''00000000-0000-0000-0000-000000000000'' to ''79994ae3-d421-4b92-b895-323c19e12db9'', ''0'' to ''2019'', ''0'' to ''0'', ''0'' to ''15'', IsDeleted: ''False'' → ''False''', CAST(N'2025-07-31T00:44:54.3874270' AS DateTime2), N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0')
INSERT [dbo].[AuditLogs] ([Id], [StaffId], [Action], [EntityName], [EntityId], [Description], [Timestamp], [IPAddress], [UserAgent]) VALUES (N'b9c37f54-1f51-400d-bac0-aba284fb04f6', N'b1009370-afce-4e2c-9fe2-25d6a0012178', N'DELETE', N'Category', N'61a89505-4c2b-447d-9f06-0e8f57bd1c97', N'Soft deleted category ''Phuc Nao To''', CAST(N'2025-07-24T17:13:48.7650897' AS DateTime2), N'::1', N'PostmanRuntime/7.44.1')
INSERT [dbo].[AuditLogs] ([Id], [StaffId], [Action], [EntityName], [EntityId], [Description], [Timestamp], [IPAddress], [UserAgent]) VALUES (N'39e64032-b255-47bb-80a0-ae5509d77556', N'b1009370-afce-4e2c-9fe2-25d6a0012178', N'ADD', N'Customer', N'822c71cd-b86e-4cfe-a3ea-f7324003b900', N'Created customer ''Nguyễn Ngọc Thiên Phúc''', CAST(N'2025-08-01T23:24:43.2514303' AS DateTime2), N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0')
INSERT [dbo].[AuditLogs] ([Id], [StaffId], [Action], [EntityName], [EntityId], [Description], [Timestamp], [IPAddress], [UserAgent]) VALUES (N'479efb26-a3fe-4dee-a571-b2995a1c23af', N'b1009370-afce-4e2c-9fe2-25d6a0012178', N'UPDATE', N'Book', N'358808bc-9c89-4431-8a5f-228bbbc86a6d', N'Updated book ''Gió Lạnh Đầu Mùa (Tái Bản 2024)'' to ''Gió Lạnh Đầu Mùa (Tái Bản 2024)'', IsDeleted: ''False'' → ''False''', CAST(N'2025-07-31T00:19:20.3216599' AS DateTime2), N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0')
INSERT [dbo].[AuditLogs] ([Id], [StaffId], [Action], [EntityName], [EntityId], [Description], [Timestamp], [IPAddress], [UserAgent]) VALUES (N'0508e197-0901-4b07-8840-b6298e584bf5', N'b1009370-afce-4e2c-9fe2-25d6a0012178', N'ADD', N'Publisher', N'fa196dad-e9a3-44b7-bef5-821ccb4b59fe', N'Updated publisher ''Phúc Não To'' to ''Phúc Não To'', ''True'' to ''False''', CAST(N'2025-07-30T16:57:54.2199146' AS DateTime2), N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0')
INSERT [dbo].[AuditLogs] ([Id], [StaffId], [Action], [EntityName], [EntityId], [Description], [Timestamp], [IPAddress], [UserAgent]) VALUES (N'692ee49a-2826-4696-9bdf-b8a88973cc31', N'b1009370-afce-4e2c-9fe2-25d6a0012178', N'UPDATE', N'Category', N'77619b52-0917-4c92-a264-e4bb91a2c434', N'Updated category ''Thien Phuc'' to ''Trình ai chấm'', IsDeleted ''False'' to ''False''', CAST(N'2025-07-28T11:03:52.8109997' AS DateTime2), N'::1', N'PostmanRuntime/7.44.1')
INSERT [dbo].[AuditLogs] ([Id], [StaffId], [Action], [EntityName], [EntityId], [Description], [Timestamp], [IPAddress], [UserAgent]) VALUES (N'91a928ef-8e68-460c-9811-b8d4b4be1584', N'b1009370-afce-4e2c-9fe2-25d6a0012178', N'UPDATE', N'Publisher', N'fa196dad-e9a3-44b7-bef5-821ccb4b59fe', N'Updated publisher ''Phúc Não Cực To'' to ''Phúc Não To'', ''True'' to ''True''', CAST(N'2025-07-30T17:01:13.3235086' AS DateTime2), N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0')
INSERT [dbo].[AuditLogs] ([Id], [StaffId], [Action], [EntityName], [EntityId], [Description], [Timestamp], [IPAddress], [UserAgent]) VALUES (N'a981b08f-a287-4721-baec-b9f98121d836', N'b1009370-afce-4e2c-9fe2-25d6a0012178', N'UPDATE', N'Order', N'f66fa9ae-0a7d-45ed-bda0-4e91f9979a94', N'Updated order ''Thành công'' to ''Thành công'', '''' to '''', ''True'' to ''True''', CAST(N'2025-07-31T22:07:49.4770173' AS DateTime2), N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0')
INSERT [dbo].[AuditLogs] ([Id], [StaffId], [Action], [EntityName], [EntityId], [Description], [Timestamp], [IPAddress], [UserAgent]) VALUES (N'd6b53f0e-cdc4-4473-b86c-bb2740bdb6f5', N'b1009370-afce-4e2c-9fe2-25d6a0012178', N'UPDATE', N'Order', N'3d4c92f3-7d03-4244-8f45-4e98fadabfb6', N'Updated order ''Thành công'' to ''Thành công'', '''' to '''', ''False'' to ''False''', CAST(N'2025-07-31T18:48:01.1648780' AS DateTime2), N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0')
INSERT [dbo].[AuditLogs] ([Id], [StaffId], [Action], [EntityName], [EntityId], [Description], [Timestamp], [IPAddress], [UserAgent]) VALUES (N'e9d62e19-b25e-467b-9646-be9b9dfc67d1', N'b1009370-afce-4e2c-9fe2-25d6a0012178', N'ADD', N'Customer', N'c818a418-fbdd-4f19-a534-8a8b008de33d', N'Created customer ''Test Phúc''', CAST(N'2025-08-01T23:22:21.7991062' AS DateTime2), N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0')
INSERT [dbo].[AuditLogs] ([Id], [StaffId], [Action], [EntityName], [EntityId], [Description], [Timestamp], [IPAddress], [UserAgent]) VALUES (N'e250e029-22b4-465a-9bfa-bedb46dbfc56', N'b1009370-afce-4e2c-9fe2-25d6a0012178', N'UPDATE', N'Order', N'262d0333-3f6e-4001-8cd3-d54ae55b070f', N'Updated order ''Thành công'' to ''Thành công'', '''' to '''', ''False'' to ''False''', CAST(N'2025-07-31T17:35:48.7027626' AS DateTime2), N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0')
INSERT [dbo].[AuditLogs] ([Id], [StaffId], [Action], [EntityName], [EntityId], [Description], [Timestamp], [IPAddress], [UserAgent]) VALUES (N'7d4bfc9a-9e35-4843-8c17-c09d39b3a35b', N'b1009370-afce-4e2c-9fe2-25d6a0012178', N'UPDATE', N'Book', N'fb1e00c7-bbe2-46c4-a987-24ad892a9072', N'Updated book '''' to ''8934974164135'', ''Làm bạn với bầu trời'' to ''Làm bạn với bầu trời'', ''00000000-0000-0000-0000-000000000000'' to ''aacac6e9-cdf4-4e53-9ddc-309e776c8612'', ''00000000-0000-0000-0000-000000000000'' to ''91396c60-f995-40ef-b732-2b1bc90bf66c'', ''00000000-0000-0000-0000-000000000000'' to ''79994ae3-d421-4b92-b895-323c19e12db9'', ''0'' to ''2019'', ''0'' to ''0'', ''0'' to ''37'', IsDeleted: ''False'' → ''False''', CAST(N'2025-07-31T00:44:36.6068874' AS DateTime2), N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0')
INSERT [dbo].[AuditLogs] ([Id], [StaffId], [Action], [EntityName], [EntityId], [Description], [Timestamp], [IPAddress], [UserAgent]) VALUES (N'cf18345b-319d-4445-91a9-c412c66515db', N'b1009370-afce-4e2c-9fe2-25d6a0012178', N'ADD', N'Order', N'a47d6176-ac9f-4926-9d81-471aa6e1780f', N'Created order by ''b1009370-afce-4e2c-9fe2-25d6a0012178''', CAST(N'2025-08-01T23:26:34.5060599' AS DateTime2), N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0')
INSERT [dbo].[AuditLogs] ([Id], [StaffId], [Action], [EntityName], [EntityId], [Description], [Timestamp], [IPAddress], [UserAgent]) VALUES (N'8c146b91-bc5c-434f-a1bf-c430a02a27cf', N'b1009370-afce-4e2c-9fe2-25d6a0012178', N'UPDATE', N'Promotion', N'da858eda-196e-45fb-8350-1845e2c67799', N'Updated category ''Khuyến Mãi Tháng 8'' to ''Khuyến Mãi Tháng 8'', ''8/1/2025 12:00:00 AM'' to ''8/1/2025 12:00:00 AM'', ''8/31/2025 12:00:00 AM'' to ''8/31/2025 12:00:00 AM'', ''50000'' to ''50000'', ''0.10'' to ''0.1'', ''100'' to ''100'', IsDeleted ''False'' to ''True''', CAST(N'2025-07-31T01:16:37.4533582' AS DateTime2), N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0')
INSERT [dbo].[AuditLogs] ([Id], [StaffId], [Action], [EntityName], [EntityId], [Description], [Timestamp], [IPAddress], [UserAgent]) VALUES (N'4471fc08-87e5-4c34-9e7f-c6adb2f1e7de', N'b1009370-afce-4e2c-9fe2-25d6a0012178', N'DELETE', N'Order', N'f66fa9ae-0a7d-45ed-bda0-4e91f9979a94', N'Soft deleted order by ''b1009370-afce-4e2c-9fe2-25d6a0012178''', CAST(N'2025-08-01T16:52:30.3413935' AS DateTime2), N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0')
GO
INSERT [dbo].[AuditLogs] ([Id], [StaffId], [Action], [EntityName], [EntityId], [Description], [Timestamp], [IPAddress], [UserAgent]) VALUES (N'05d2228f-bf8e-481c-a5d1-c91d4260895a', N'b1009370-afce-4e2c-9fe2-25d6a0012178', N'DELETE', N'Staff', N'0437a958-8ee4-4adb-9741-34edaff87fe3', N'Soft deleted staff ''Phúc + Phúc''', CAST(N'2025-07-31T15:58:53.3202777' AS DateTime2), N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0')
INSERT [dbo].[AuditLogs] ([Id], [StaffId], [Action], [EntityName], [EntityId], [Description], [Timestamp], [IPAddress], [UserAgent]) VALUES (N'f416108a-2f3a-4328-b11e-c92e86664fd8', N'b1009370-afce-4e2c-9fe2-25d6a0012178', N'UPDATE', N'Author', N'228df486-5ff8-40a8-a2d1-c3f4a1a0fb9e', N'Updated author ''Trình'' to ''Trình'', ''True'' to ''True''', CAST(N'2025-07-28T10:43:37.4033224' AS DateTime2), N'::1', N'PostmanRuntime/7.44.1')
INSERT [dbo].[AuditLogs] ([Id], [StaffId], [Action], [EntityName], [EntityId], [Description], [Timestamp], [IPAddress], [UserAgent]) VALUES (N'8bc735e9-e92b-41c4-aafc-d0875d22ead2', N'b1009370-afce-4e2c-9fe2-25d6a0012178', N'UPDATE', N'Book', N'c862fb23-a2d2-42d2-8253-44824c4dfecc', N'Updated book '''' to ''9786043077940'', ''Hai Đứa Trẻ (Tái Bản 2024)'' to ''Hai Đứa Trẻ (Tái Bản 2024)'', ''00000000-0000-0000-0000-000000000000'' to ''aacac6e9-cdf4-4e53-9ddc-309e776c8612'', ''00000000-0000-0000-0000-000000000000'' to ''09189d44-9a03-44fa-a026-3704ad76ffd8'', ''00000000-0000-0000-0000-000000000000'' to ''79994ae3-d421-4b92-b895-323c19e12db9'', ''0'' to ''2024'', ''0'' to ''0'', ''0'' to ''0'', IsDeleted: ''False'' → ''False''', CAST(N'2025-07-31T00:45:09.3010494' AS DateTime2), N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0')
INSERT [dbo].[AuditLogs] ([Id], [StaffId], [Action], [EntityName], [EntityId], [Description], [Timestamp], [IPAddress], [UserAgent]) VALUES (N'b2f3cd7f-761a-435b-a402-d78ef97f6772', N'b1009370-afce-4e2c-9fe2-25d6a0012178', N'UPDATE', N'Book', N'686f2b9e-5da2-4078-bb27-61fbeadda342', N'Updated book '''' to ''9786043725889'', ''Đời Thừa (Tái Bản 2022)'' to ''Đời Thừa (Tái Bản 2022)'', ''00000000-0000-0000-0000-000000000000'' to ''aacac6e9-cdf4-4e53-9ddc-309e776c8612'', ''00000000-0000-0000-0000-000000000000'' to ''9d988694-ec03-4141-8f41-3fddce6bf4e7'', ''00000000-0000-0000-0000-000000000000'' to ''79994ae3-d421-4b92-b895-323c19e12db9'', ''0'' to ''2022'', ''0'' to ''0'', ''0'' to ''8'', IsDeleted: ''True'' → ''False''', CAST(N'2025-07-31T00:45:44.1058031' AS DateTime2), N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0')
INSERT [dbo].[AuditLogs] ([Id], [StaffId], [Action], [EntityName], [EntityId], [Description], [Timestamp], [IPAddress], [UserAgent]) VALUES (N'efce2e5f-ab17-4239-8f37-da06e7c880b1', N'b1009370-afce-4e2c-9fe2-25d6a0012178', N'UPDATE', N'Category', N'61a89505-4c2b-447d-9f06-0e8f57bd1c97', N'Updated category ''Phuc Nao To'' to ''Phuc Nao To'', IsDeleted = True', CAST(N'2025-07-24T17:02:00.1694235' AS DateTime2), N'::1', N'PostmanRuntime/7.44.1')
INSERT [dbo].[AuditLogs] ([Id], [StaffId], [Action], [EntityName], [EntityId], [Description], [Timestamp], [IPAddress], [UserAgent]) VALUES (N'd59ffa1c-5575-4de8-bb01-e096a45f8165', N'b1009370-afce-4e2c-9fe2-25d6a0012178', N'ADD', N'Publisher', N'fa196dad-e9a3-44b7-bef5-821ccb4b59fe', N'Created publisher ''Phúc Não To''', CAST(N'2025-07-30T16:57:48.8558459' AS DateTime2), N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0')
INSERT [dbo].[AuditLogs] ([Id], [StaffId], [Action], [EntityName], [EntityId], [Description], [Timestamp], [IPAddress], [UserAgent]) VALUES (N'0ea41f7a-9dc2-4532-bc24-e3a48b59f8ed', N'b1009370-afce-4e2c-9fe2-25d6a0012178', N'ADD', N'Category', N'77619b52-0917-4c92-a264-e4bb91a2c434', N'Created category ''Thien Phuc''', CAST(N'2025-07-27T15:35:53.7812935' AS DateTime2), N'::1', N'PostmanRuntime/7.44.1')
INSERT [dbo].[AuditLogs] ([Id], [StaffId], [Action], [EntityName], [EntityId], [Description], [Timestamp], [IPAddress], [UserAgent]) VALUES (N'184023a2-27e6-4dec-b1db-e54af8cd9ab6', N'b1009370-afce-4e2c-9fe2-25d6a0012178', N'ADD', N'Order', N'6b5771e5-67c3-4040-b356-3b8695624e72', N'Created order by ''b1009370-afce-4e2c-9fe2-25d6a0012178''', CAST(N'2025-08-01T22:26:12.2198869' AS DateTime2), N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0')
INSERT [dbo].[AuditLogs] ([Id], [StaffId], [Action], [EntityName], [EntityId], [Description], [Timestamp], [IPAddress], [UserAgent]) VALUES (N'21ae65bb-48e7-4913-b59d-e8294e762ad3', N'b1009370-afce-4e2c-9fe2-25d6a0012178', N'UPDATE', N'Category', N'61a89505-4c2b-447d-9f06-0e8f57bd1c97', N'Updated category ''Phuc Nao To'' to ''Phuc Nao To'', IsDeleted = False', CAST(N'2025-07-24T17:11:21.8547743' AS DateTime2), N'::1', N'PostmanRuntime/7.44.1')
INSERT [dbo].[AuditLogs] ([Id], [StaffId], [Action], [EntityName], [EntityId], [Description], [Timestamp], [IPAddress], [UserAgent]) VALUES (N'bb60cd71-c337-46c4-a156-e9c8927c3424', N'b1009370-afce-4e2c-9fe2-25d6a0012178', N'UPDATE', N'Customer', N'8ec41d47-6d8f-4f1f-9a0d-ff518cb2b83f', N'Updated category ''Trần'' to ''Trần'', ''Ngân'' to ''Ngân'', ''1/1/2003'' to ''1/1/2003'', ''Man Thiện'' to ''Man Thiện'', ''0987654556'' to ''0987654556'', ''True'' to ''True''', CAST(N'2025-07-31T15:07:06.3797190' AS DateTime2), N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0')
INSERT [dbo].[AuditLogs] ([Id], [StaffId], [Action], [EntityName], [EntityId], [Description], [Timestamp], [IPAddress], [UserAgent]) VALUES (N'9cefa75e-727d-4b47-82d5-ea1057a5ca05', N'b1009370-afce-4e2c-9fe2-25d6a0012178', N'ADD', N'Order', N'4c3b7ecd-a94c-46a1-b047-3f4cdfb24ca0', N'Created order by ''b1009370-afce-4e2c-9fe2-25d6a0012178''', CAST(N'2025-08-01T22:36:41.5300260' AS DateTime2), N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0')
INSERT [dbo].[AuditLogs] ([Id], [StaffId], [Action], [EntityName], [EntityId], [Description], [Timestamp], [IPAddress], [UserAgent]) VALUES (N'1a320d82-8101-4344-8675-ea6fc26c8e86', N'b1009370-afce-4e2c-9fe2-25d6a0012178', N'UPDATE', N'Author', N'228df486-5ff8-40a8-a2d1-c3f4a1a0fb9e', N'Updated author ''Trinh Thám'' to ''Trình ai chấm'', ''True'' to ''True''', CAST(N'2025-07-28T10:48:18.1991332' AS DateTime2), N'::1', N'PostmanRuntime/7.44.1')
INSERT [dbo].[AuditLogs] ([Id], [StaffId], [Action], [EntityName], [EntityId], [Description], [Timestamp], [IPAddress], [UserAgent]) VALUES (N'd6db2f38-84ec-4885-b4d4-f093186b9a39', N'b1009370-afce-4e2c-9fe2-25d6a0012178', N'UPDATE', N'Category', N'61a89505-4c2b-447d-9f06-0e8f57bd1c97', N'Updated category ''Phuc Nao To'' to ''Phuc Nao To'', IsDeleted ''False'' to ''False''', CAST(N'2025-07-24T17:13:45.8054023' AS DateTime2), N'::1', N'PostmanRuntime/7.44.1')
INSERT [dbo].[AuditLogs] ([Id], [StaffId], [Action], [EntityName], [EntityId], [Description], [Timestamp], [IPAddress], [UserAgent]) VALUES (N'8f90e9bf-4333-4420-bb8d-f242c6293c6b', N'b1009370-afce-4e2c-9fe2-25d6a0012178', N'UPDATE', N'Book', N'358808bc-9c89-4431-8a5f-228bbbc86a6d', N'Updated book ''8935212366533'' to ''8935212366533'', ''Gió Lạnh Đầu Mùa (Tái Bản 2024)'' to ''Gió Lạnh Đầu Mùa (Tái Bản 2024)'', ''e2bc6d43-b35c-4b43-9215-8e186ffa60c0'' to ''e2bc6d43-b35c-4b43-9215-8e186ffa60c0'', ''09189d44-9a03-44fa-a026-3704ad76ffd8'' to ''09189d44-9a03-44fa-a026-3704ad76ffd8'', ''79994ae3-d421-4b92-b895-323c19e12db9'' to ''79994ae3-d421-4b92-b895-323c19e12db9'', ''2024'' to ''2024'', ''59000'' to ''59000'', ''11'' to ''11'', IsDeleted: ''True'' → ''False''', CAST(N'2025-07-31T22:07:07.4466381' AS DateTime2), N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0')
INSERT [dbo].[AuditLogs] ([Id], [StaffId], [Action], [EntityName], [EntityId], [Description], [Timestamp], [IPAddress], [UserAgent]) VALUES (N'566c4515-103f-4c97-9d86-f30c29b21e92', N'b1009370-afce-4e2c-9fe2-25d6a0012178', N'ADD', N'Category', N'e8afa175-56b4-467b-9b7e-65d2f2c1032f', N'Created category ''Hài Hước''', CAST(N'2025-07-29T09:18:11.9878620' AS DateTime2), N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0')
INSERT [dbo].[AuditLogs] ([Id], [StaffId], [Action], [EntityName], [EntityId], [Description], [Timestamp], [IPAddress], [UserAgent]) VALUES (N'a5702f2d-afc6-4914-82e6-f398aef4bdb0', N'b1009370-afce-4e2c-9fe2-25d6a0012178', N'UPDATE', N'Author', N'91396c60-f995-40ef-b732-2b1bc90bf66c', N'Updated author ''Nguyễn Nhật Ánh'' to ''Nguyễn Nhật Ánh'', ''True'' to ''False''', CAST(N'2025-07-29T09:45:27.1886205' AS DateTime2), N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0')
INSERT [dbo].[AuditLogs] ([Id], [StaffId], [Action], [EntityName], [EntityId], [Description], [Timestamp], [IPAddress], [UserAgent]) VALUES (N'42b779a8-dd0c-4a5b-9ace-f8708b2fc1f7', N'b1009370-afce-4e2c-9fe2-25d6a0012178', N'DELETE', N'Order', N'd263c652-11fe-4e65-a6e1-887c5c9c4883', N'Soft deleted order by ''b1009370-afce-4e2c-9fe2-25d6a0012178''', CAST(N'2025-07-31T17:46:57.3003956' AS DateTime2), N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0')
INSERT [dbo].[AuditLogs] ([Id], [StaffId], [Action], [EntityName], [EntityId], [Description], [Timestamp], [IPAddress], [UserAgent]) VALUES (N'd0c8d7f8-0ddf-40b0-a9ed-f875e0b0fec0', N'b1009370-afce-4e2c-9fe2-25d6a0012178', N'ADD', N'Order', N'e5dd57fd-be26-497b-b533-ebbc488cf0ba', N'Created order by ''b1009370-afce-4e2c-9fe2-25d6a0012178''', CAST(N'2025-07-31T22:08:28.5305219' AS DateTime2), N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0')
INSERT [dbo].[AuditLogs] ([Id], [StaffId], [Action], [EntityName], [EntityId], [Description], [Timestamp], [IPAddress], [UserAgent]) VALUES (N'fe03351f-a8b5-4875-9ca2-faf63da1e064', N'b1009370-afce-4e2c-9fe2-25d6a0012178', N'UPDATE', N'Category', N'61a89505-4c2b-447d-9f06-0e8f57bd1c97', N'Updated category ''Phuc Nao To'' to ''Phuc Nao To'', IsDeleted = False', CAST(N'2025-07-24T17:01:55.1428684' AS DateTime2), N'::1', N'PostmanRuntime/7.44.1')
INSERT [dbo].[AuditLogs] ([Id], [StaffId], [Action], [EntityName], [EntityId], [Description], [Timestamp], [IPAddress], [UserAgent]) VALUES (N'cf8bd289-650f-45bb-aa6f-fd330fee5342', N'b1009370-afce-4e2c-9fe2-25d6a0012178', N'UPDATE', N'Author', N'228df486-5ff8-40a8-a2d1-c3f4a1a0fb9e', N'Updated author ''Trình'' to ''Trình'', ''False'' to ''False''', CAST(N'2025-07-28T10:43:02.9006809' AS DateTime2), N'::1', N'PostmanRuntime/7.44.1')
INSERT [dbo].[AuditLogs] ([Id], [StaffId], [Action], [EntityName], [EntityId], [Description], [Timestamp], [IPAddress], [UserAgent]) VALUES (N'3e44b784-b29f-4676-a33a-fdb5717288b1', N'b1009370-afce-4e2c-9fe2-25d6a0012178', N'DELETE', N'Category', N'61a89505-4c2b-447d-9f06-0e8f57bd1c97', N'Soft deleted category ''Phuc Nao To''', CAST(N'2025-07-24T17:11:48.9250933' AS DateTime2), N'::1', N'PostmanRuntime/7.44.1')
GO
INSERT [dbo].[Authors] ([Id], [Name], [IsDeleted]) VALUES (N'91396c60-f995-40ef-b732-2b1bc90bf66c', N'Nguyễn Nhật Ánh', 0)
INSERT [dbo].[Authors] ([Id], [Name], [IsDeleted]) VALUES (N'09189d44-9a03-44fa-a026-3704ad76ffd8', N'Thạch Lam', 0)
INSERT [dbo].[Authors] ([Id], [Name], [IsDeleted]) VALUES (N'9d988694-ec03-4141-8f41-3fddce6bf4e7', N'Nam Cao', 0)
INSERT [dbo].[Authors] ([Id], [Name], [IsDeleted]) VALUES (N'eae1cb0d-2104-4f68-884d-562675b04f1a', N'Fujiko F Fujio', 0)
INSERT [dbo].[Authors] ([Id], [Name], [IsDeleted]) VALUES (N'228df486-5ff8-40a8-a2d1-c3f4a1a0fb9e', N'Phuc Nao To', 1)
GO
INSERT [dbo].[Books] ([Id], [Isbn], [Title], [CategoryId], [AuthorId], [PublisherId], [YearOfPublication], [Price], [Image], [Quantity], [IsDeleted]) VALUES (N'358808bc-9c89-4431-8a5f-228bbbc86a6d', N'8935212366533', N'Gió Lạnh Đầu Mùa (Tái Bản 2024)', N'e2bc6d43-b35c-4b43-9215-8e186ffa60c0', N'09189d44-9a03-44fa-a026-3704ad76ffd8', N'79994ae3-d421-4b92-b895-323c19e12db9', 2024, CAST(59000 AS Decimal(8, 0)), N'images/books/8935212366533.webp', 10, 0)
INSERT [dbo].[Books] ([Id], [Isbn], [Title], [CategoryId], [AuthorId], [PublisherId], [YearOfPublication], [Price], [Image], [Quantity], [IsDeleted]) VALUES (N'fb1e00c7-bbe2-46c4-a987-24ad892a9072', N'8934974164135', N'Làm bạn với bầu trời', N'aacac6e9-cdf4-4e53-9ddc-309e776c8612', N'91396c60-f995-40ef-b732-2b1bc90bf66c', N'79994ae3-d421-4b92-b895-323c19e12db9', 2019, CAST(92400 AS Decimal(8, 0)), N'images/books/8934974164135.webp', 26, 0)
INSERT [dbo].[Books] ([Id], [Isbn], [Title], [CategoryId], [AuthorId], [PublisherId], [YearOfPublication], [Price], [Image], [Quantity], [IsDeleted]) VALUES (N'55c70857-c0a9-4710-9ed5-34d6abb2bd10', N'8935244822571', N'Văn Học Trong Nhà Trường - Gió Lạnh Đầu Mùa (Tái Bản 2019)', N'e2bc6d43-b35c-4b43-9215-8e186ffa60c0', N'09189d44-9a03-44fa-a026-3704ad76ffd8', N'79994ae3-d421-4b92-b895-323c19e12db9', 2019, CAST(44000 AS Decimal(8, 0)), N'images/books/8935244822571.webp', 5, 0)
INSERT [dbo].[Books] ([Id], [Isbn], [Title], [CategoryId], [AuthorId], [PublisherId], [YearOfPublication], [Price], [Image], [Quantity], [IsDeleted]) VALUES (N'0b72ee3b-7e66-4cba-b5ee-3fcc947b3a03', N'8934974178194', N'Bong Bóng Lên Trời (2022)', N'e2bc6d43-b35c-4b43-9215-8e186ffa60c0', N'91396c60-f995-40ef-b732-2b1bc90bf66c', N'2d64142c-1280-48e1-9207-c7a0023fa88f', 2022, CAST(95000 AS Decimal(8, 0)), N'images/books/8934974178194.webp', 73, 0)
INSERT [dbo].[Books] ([Id], [Isbn], [Title], [CategoryId], [AuthorId], [PublisherId], [YearOfPublication], [Price], [Image], [Quantity], [IsDeleted]) VALUES (N'c862fb23-a2d2-42d2-8253-44824c4dfecc', N'9786043077940', N'Hai Đứa Trẻ (Tái Bản 2024)', N'aacac6e9-cdf4-4e53-9ddc-309e776c8612', N'09189d44-9a03-44fa-a026-3704ad76ffd8', N'79994ae3-d421-4b92-b895-323c19e12db9', 2024, CAST(150000 AS Decimal(8, 0)), N'images/books/9786043077940.webp', 5, 0)
INSERT [dbo].[Books] ([Id], [Isbn], [Title], [CategoryId], [AuthorId], [PublisherId], [YearOfPublication], [Price], [Image], [Quantity], [IsDeleted]) VALUES (N'643db72a-f24b-4e07-9e16-458db1f4b135', N'8934974178682', N'Phòng Trọ Ba Người (Tái Bản 2022)', N'e2bc6d43-b35c-4b43-9215-8e186ffa60c0', N'91396c60-f995-40ef-b732-2b1bc90bf66c', N'2d64142c-1280-48e1-9207-c7a0023fa88f', 2022, CAST(45000 AS Decimal(8, 0)), N'images/books/8934974178682.jpg', 13, 0)
INSERT [dbo].[Books] ([Id], [Isbn], [Title], [CategoryId], [AuthorId], [PublisherId], [YearOfPublication], [Price], [Image], [Quantity], [IsDeleted]) VALUES (N'e56476b5-2bc9-4908-9ba9-57dafa5959a6', N'8935244864427', N'Kính vạn hoa', N'aacac6e9-cdf4-4e53-9ddc-309e776c8612', N'91396c60-f995-40ef-b732-2b1bc90bf66c', N'79994ae3-d421-4b92-b895-323c19e12db9', 2022, CAST(110700 AS Decimal(8, 0)), N'images/books/8935244864427.jpg', 36, 0)
INSERT [dbo].[Books] ([Id], [Isbn], [Title], [CategoryId], [AuthorId], [PublisherId], [YearOfPublication], [Price], [Image], [Quantity], [IsDeleted]) VALUES (N'e2ccf867-c124-4e33-9b48-5cca2fb7a7f0', N'8934974178620', N'Hoa Hồng Xứ Khác (Tái Bản 2022)', N'e2bc6d43-b35c-4b43-9215-8e186ffa60c0', N'91396c60-f995-40ef-b732-2b1bc90bf66c', N'2d64142c-1280-48e1-9207-c7a0023fa88f', 2022, CAST(50000 AS Decimal(8, 0)), N'images/books/8934974178620.webp', 18, 0)
INSERT [dbo].[Books] ([Id], [Isbn], [Title], [CategoryId], [AuthorId], [PublisherId], [YearOfPublication], [Price], [Image], [Quantity], [IsDeleted]) VALUES (N'686f2b9e-5da2-4078-bb27-61fbeadda342', N'9786043725889', N'Đời Thừa (Tái Bản 2022)', N'aacac6e9-cdf4-4e53-9ddc-309e776c8612', N'9d988694-ec03-4141-8f41-3fddce6bf4e7', N'79994ae3-d421-4b92-b895-323c19e12db9', 2022, CAST(63000 AS Decimal(8, 0)), N'images/books/9786043725889.webp', 6, 0)
INSERT [dbo].[Books] ([Id], [Isbn], [Title], [CategoryId], [AuthorId], [PublisherId], [YearOfPublication], [Price], [Image], [Quantity], [IsDeleted]) VALUES (N'35170fc7-a012-4baf-a15a-644a2121957f', N'9786043947465', N'Ngày Mới', N'e2bc6d43-b35c-4b43-9215-8e186ffa60c0', N'09189d44-9a03-44fa-a026-3704ad76ffd8', N'79994ae3-d421-4b92-b895-323c19e12db9', 2024, CAST(83000 AS Decimal(8, 0)), N'images/books/9786043947465.webp', 16, 0)
INSERT [dbo].[Books] ([Id], [Isbn], [Title], [CategoryId], [AuthorId], [PublisherId], [YearOfPublication], [Price], [Image], [Quantity], [IsDeleted]) VALUES (N'66d85958-f12d-43af-9827-684fe9e387d4', N'9786044916927', N'Sống Mòn', N'aacac6e9-cdf4-4e53-9ddc-309e776c8612', N'9d988694-ec03-4141-8f41-3fddce6bf4e7', N'79994ae3-d421-4b92-b895-323c19e12db9', 2024, CAST(76000 AS Decimal(8, 0)), N'images/books/9786044916927.webp', 33, 0)
INSERT [dbo].[Books] ([Id], [Isbn], [Title], [CategoryId], [AuthorId], [PublisherId], [YearOfPublication], [Price], [Image], [Quantity], [IsDeleted]) VALUES (N'7ae62fcb-f5c5-4ea9-985f-81914c4a97bd', N'8934974187622', N'Tôi Thấy Hoa Vàng Trên Cỏ Xanh (Tái Bản 2023)', N'e2bc6d43-b35c-4b43-9215-8e186ffa60c0', N'91396c60-f995-40ef-b732-2b1bc90bf66c', N'2d64142c-1280-48e1-9207-c7a0023fa88f', 2023, CAST(150000 AS Decimal(8, 0)), N'images/books/8934974187622.webp', 9, 0)
INSERT [dbo].[Books] ([Id], [Isbn], [Title], [CategoryId], [AuthorId], [PublisherId], [YearOfPublication], [Price], [Image], [Quantity], [IsDeleted]) VALUES (N'5c558548-e6b9-424c-9949-8ef7cf63e1ac', N'8935230001218', N'Danh Tác Việt Nam - Chí Phèo (Tái Bản 2025)', N'aacac6e9-cdf4-4e53-9ddc-309e776c8612', N'9d988694-ec03-4141-8f41-3fddce6bf4e7', N'2d64142c-1280-48e1-9207-c7a0023fa88f', 2025, CAST(98000 AS Decimal(8, 0)), N'images/books/8935230001218.webp', 13, 0)
INSERT [dbo].[Books] ([Id], [Isbn], [Title], [CategoryId], [AuthorId], [PublisherId], [YearOfPublication], [Price], [Image], [Quantity], [IsDeleted]) VALUES (N'9d22dade-e1b4-4a2a-9b9e-a567f839f189', N'8934974177319', N'Những Chàng Trai Xấu Tính (Tái Bản 2022)', N'e2bc6d43-b35c-4b43-9215-8e186ffa60c0', N'91396c60-f995-40ef-b732-2b1bc90bf66c', N'2d64142c-1280-48e1-9207-c7a0023fa88f', 2022, CAST(85000 AS Decimal(8, 0)), N'images/books/8934974177319.webp', 44, 0)
INSERT [dbo].[Books] ([Id], [Isbn], [Title], [CategoryId], [AuthorId], [PublisherId], [YearOfPublication], [Price], [Image], [Quantity], [IsDeleted]) VALUES (N'b11ff973-84f6-4adb-9c31-b6cc0fe93fdf', N'8936203362206', N'Gió Đầu Mùa & Hà Nội Băm Sáu Phố Phường', N'aacac6e9-cdf4-4e53-9ddc-309e776c8612', N'09189d44-9a03-44fa-a026-3704ad76ffd8', N'2d64142c-1280-48e1-9207-c7a0023fa88f', 2022, CAST(160000 AS Decimal(8, 0)), N'images/books/8936203362206.webp', 32, 0)
INSERT [dbo].[Books] ([Id], [Isbn], [Title], [CategoryId], [AuthorId], [PublisherId], [YearOfPublication], [Price], [Image], [Quantity], [IsDeleted]) VALUES (N'ad1fcaaf-6b6a-419f-95af-c29f8ec9982e', N'8934974209393', N'Nguyễn Nhật Ánh - Người Giữ Lửa Cho Văn Học Thiếu Nhi', N'aacac6e9-cdf4-4e53-9ddc-309e776c8612', N'91396c60-f995-40ef-b732-2b1bc90bf66c', N'2d64142c-1280-48e1-9207-c7a0023fa88f', 2025, CAST(277000 AS Decimal(8, 0)), N'images/books/8934974209393.webp', 100, 0)
INSERT [dbo].[Books] ([Id], [Isbn], [Title], [CategoryId], [AuthorId], [PublisherId], [YearOfPublication], [Price], [Image], [Quantity], [IsDeleted]) VALUES (N'da8d2d28-ec88-4514-b7c4-c8d19a43b857', N'8935095623945', N'Chí Phèo (2017)', N'aacac6e9-cdf4-4e53-9ddc-309e776c8612', N'9d988694-ec03-4141-8f41-3fddce6bf4e7', N'2d64142c-1280-48e1-9207-c7a0023fa88f', 2017, CAST(40000 AS Decimal(8, 0)), N'images/books/8935095623945.webp', 18, 0)
INSERT [dbo].[Books] ([Id], [Isbn], [Title], [CategoryId], [AuthorId], [PublisherId], [YearOfPublication], [Price], [Image], [Quantity], [IsDeleted]) VALUES (N'4bfd61cb-691d-49fc-acf4-d91aedd5fbf6', N'8934974170600', N'Con Chim Xanh Biếc Bay Về', N'e2bc6d43-b35c-4b43-9215-8e186ffa60c0', N'91396c60-f995-40ef-b732-2b1bc90bf66c', N'79994ae3-d421-4b92-b895-323c19e12db9', 2020, CAST(202500 AS Decimal(8, 0)), N'images/books/8934974170600.webp', 69, 0)
INSERT [dbo].[Books] ([Id], [Isbn], [Title], [CategoryId], [AuthorId], [PublisherId], [YearOfPublication], [Price], [Image], [Quantity], [IsDeleted]) VALUES (N'ddfde72a-7e11-49d5-89fb-e2766610c1cb', N'8934974188841', N'Tôi Là Bêtô', N'e2bc6d43-b35c-4b43-9215-8e186ffa60c0', N'91396c60-f995-40ef-b732-2b1bc90bf66c', N'2d64142c-1280-48e1-9207-c7a0023fa88f', 2023, CAST(200000 AS Decimal(8, 0)), N'images/books/8934974188841.webp', 6, 0)
GO
INSERT [dbo].[Categories] ([Id], [Name], [IsDeleted]) VALUES (N'61a89505-4c2b-447d-9f06-0e8f57bd1c97', N'Phuc Nao To', 1)
INSERT [dbo].[Categories] ([Id], [Name], [IsDeleted]) VALUES (N'aacac6e9-cdf4-4e53-9ddc-309e776c8612', N'Văn Học', 0)
INSERT [dbo].[Categories] ([Id], [Name], [IsDeleted]) VALUES (N'e8afa175-56b4-467b-9b7e-65d2f2c1032f', N'Hài Hước', 0)
INSERT [dbo].[Categories] ([Id], [Name], [IsDeleted]) VALUES (N'e2bc6d43-b35c-4b43-9215-8e186ffa60c0', N'Tiểu Thuyết', 0)
INSERT [dbo].[Categories] ([Id], [Name], [IsDeleted]) VALUES (N'e2a5d950-76a5-45d8-a3cb-e28470a099f1', N'Truyện cổ tích', 0)
INSERT [dbo].[Categories] ([Id], [Name], [IsDeleted]) VALUES (N'77619b52-0917-4c92-a264-e4bb91a2c434', N'Trình ai chấm', 1)
INSERT [dbo].[Categories] ([Id], [Name], [IsDeleted]) VALUES (N'35b44e59-daf3-4561-8a4f-efa0ff9f629e', N'Truyện Tranh', 0)
GO
INSERT [dbo].[Customers] ([Id], [FamilyName], [GivenName], [DateOfBirth], [Address], [Phone], [Gender], [Email], [HashPassword], [IsActived], [IsDeleted]) VALUES (N'833fe43e-cdbe-4587-a642-0a76f994e24e', N'Nguyễn Ngọc Thiên', N'Phú', CAST(N'2000-01-01' AS Date), N'Hưng Lộc', N'0980998990', 0, NULL, NULL, 0, 0)
INSERT [dbo].[Customers] ([Id], [FamilyName], [GivenName], [DateOfBirth], [Address], [Phone], [Gender], [Email], [HashPassword], [IsActived], [IsDeleted]) VALUES (N'8fefdeb4-2148-4224-a304-41c292140fdd', N'Nguyễn Thị Kiều', N'Mộng', CAST(N'2002-01-01' AS Date), N'Techcombank Bình Hòa', N'0987676551', 1, NULL, NULL, 0, 0)
INSERT [dbo].[Customers] ([Id], [FamilyName], [GivenName], [DateOfBirth], [Address], [Phone], [Gender], [Email], [HashPassword], [IsActived], [IsDeleted]) VALUES (N'cfd6a6dc-ae6e-4cea-9b90-9111868c3a51', N'Nguyễn Ngọc Thiên', N'Kim', CAST(N'2001-01-01' AS Date), N'London', N'0989000991', 1, NULL, NULL, 0, 0)
INSERT [dbo].[Customers] ([Id], [FamilyName], [GivenName], [DateOfBirth], [Address], [Phone], [Gender], [Email], [HashPassword], [IsActived], [IsDeleted]) VALUES (N'ba12c75c-c9e1-4bb0-a928-970e24032376', N'Nguyễn Ngọc Huyền', N'Trân', CAST(N'1997-01-01' AS Date), N'Phan Thiết', N'0989098778', 1, NULL, NULL, 0, 0)
INSERT [dbo].[Customers] ([Id], [FamilyName], [GivenName], [DateOfBirth], [Address], [Phone], [Gender], [Email], [HashPassword], [IsActived], [IsDeleted]) VALUES (N'4da1e043-c6c4-4fe6-8157-c8064e17a512', N'Nguyễn', N'Phúc', CAST(N'2003-08-16' AS Date), N'Thống Nhất', N'0989890001', 0, NULL, NULL, 0, 0)
INSERT [dbo].[Customers] ([Id], [FamilyName], [GivenName], [DateOfBirth], [Address], [Phone], [Gender], [Email], [HashPassword], [IsActived], [IsDeleted]) VALUES (N'822c71cd-b86e-4cfe-a3ea-f7324003b900', N'Nguyễn Ngọc Thiên', N'Phúc', CAST(N'2003-08-16' AS Date), N'Đồng Nai', N'0989000911', 0, N'phucnaoto@gmail.com', NULL, 0, 0)
INSERT [dbo].[Customers] ([Id], [FamilyName], [GivenName], [DateOfBirth], [Address], [Phone], [Gender], [Email], [HashPassword], [IsActived], [IsDeleted]) VALUES (N'8ec41d47-6d8f-4f1f-9a0d-ff518cb2b83f', N'Trần', N'Ngân', CAST(N'2003-01-01' AS Date), N'Man Thiện', N'0987654556', 1, NULL, NULL, 0, 1)
GO
INSERT [dbo].[OrderItems] ([OrderId], [BookId], [Quantity], [Price], [IsDeleted]) VALUES (N'7e778f62-49dc-4683-8b75-0d3c6cf602bc', N'55c70857-c0a9-4710-9ed5-34d6abb2bd10', 1, CAST(44000 AS Decimal(8, 0)), 0)
INSERT [dbo].[OrderItems] ([OrderId], [BookId], [Quantity], [Price], [IsDeleted]) VALUES (N'7e778f62-49dc-4683-8b75-0d3c6cf602bc', N'c862fb23-a2d2-42d2-8253-44824c4dfecc', 1, CAST(150000 AS Decimal(8, 0)), 0)
INSERT [dbo].[OrderItems] ([OrderId], [BookId], [Quantity], [Price], [IsDeleted]) VALUES (N'4196a906-de69-4ccf-85ab-22351421a1ed', N'66d85958-f12d-43af-9827-684fe9e387d4', 1, CAST(76000 AS Decimal(8, 0)), 0)
INSERT [dbo].[OrderItems] ([OrderId], [BookId], [Quantity], [Price], [IsDeleted]) VALUES (N'6b5771e5-67c3-4040-b356-3b8695624e72', N'c862fb23-a2d2-42d2-8253-44824c4dfecc', 1, CAST(150000 AS Decimal(8, 0)), 0)
INSERT [dbo].[OrderItems] ([OrderId], [BookId], [Quantity], [Price], [IsDeleted]) VALUES (N'6b5771e5-67c3-4040-b356-3b8695624e72', N'e2ccf867-c124-4e33-9b48-5cca2fb7a7f0', 1, CAST(50000 AS Decimal(8, 0)), 0)
INSERT [dbo].[OrderItems] ([OrderId], [BookId], [Quantity], [Price], [IsDeleted]) VALUES (N'4c3b7ecd-a94c-46a1-b047-3f4cdfb24ca0', N'55c70857-c0a9-4710-9ed5-34d6abb2bd10', 3, CAST(44000 AS Decimal(8, 0)), 0)
INSERT [dbo].[OrderItems] ([OrderId], [BookId], [Quantity], [Price], [IsDeleted]) VALUES (N'a47d6176-ac9f-4926-9d81-471aa6e1780f', N'e56476b5-2bc9-4908-9ba9-57dafa5959a6', 1, CAST(110700 AS Decimal(8, 0)), 0)
INSERT [dbo].[OrderItems] ([OrderId], [BookId], [Quantity], [Price], [IsDeleted]) VALUES (N'a47d6176-ac9f-4926-9d81-471aa6e1780f', N'9d22dade-e1b4-4a2a-9b9e-a567f839f189', 2, CAST(85000 AS Decimal(8, 0)), 0)
INSERT [dbo].[OrderItems] ([OrderId], [BookId], [Quantity], [Price], [IsDeleted]) VALUES (N'f66fa9ae-0a7d-45ed-bda0-4e91f9979a94', N'0b72ee3b-7e66-4cba-b5ee-3fcc947b3a03', 1, CAST(95000 AS Decimal(8, 0)), 0)
INSERT [dbo].[OrderItems] ([OrderId], [BookId], [Quantity], [Price], [IsDeleted]) VALUES (N'f66fa9ae-0a7d-45ed-bda0-4e91f9979a94', N'e56476b5-2bc9-4908-9ba9-57dafa5959a6', 1, CAST(110700 AS Decimal(8, 0)), 0)
INSERT [dbo].[OrderItems] ([OrderId], [BookId], [Quantity], [Price], [IsDeleted]) VALUES (N'3d4c92f3-7d03-4244-8f45-4e98fadabfb6', N'358808bc-9c89-4431-8a5f-228bbbc86a6d', 1, CAST(59000 AS Decimal(8, 0)), 0)
INSERT [dbo].[OrderItems] ([OrderId], [BookId], [Quantity], [Price], [IsDeleted]) VALUES (N'3d4c92f3-7d03-4244-8f45-4e98fadabfb6', N'55c70857-c0a9-4710-9ed5-34d6abb2bd10', 3, CAST(44000 AS Decimal(8, 0)), 0)
INSERT [dbo].[OrderItems] ([OrderId], [BookId], [Quantity], [Price], [IsDeleted]) VALUES (N'4b2864fc-d2e6-488d-a547-67981e398104', N'fb1e00c7-bbe2-46c4-a987-24ad892a9072', 1, CAST(92400 AS Decimal(8, 0)), 0)
INSERT [dbo].[OrderItems] ([OrderId], [BookId], [Quantity], [Price], [IsDeleted]) VALUES (N'4b2864fc-d2e6-488d-a547-67981e398104', N'e56476b5-2bc9-4908-9ba9-57dafa5959a6', 1, CAST(110700 AS Decimal(8, 0)), 0)
INSERT [dbo].[OrderItems] ([OrderId], [BookId], [Quantity], [Price], [IsDeleted]) VALUES (N'd263c652-11fe-4e65-a6e1-887c5c9c4883', N'358808bc-9c89-4431-8a5f-228bbbc86a6d', 3, CAST(59000 AS Decimal(8, 0)), 0)
INSERT [dbo].[OrderItems] ([OrderId], [BookId], [Quantity], [Price], [IsDeleted]) VALUES (N'd263c652-11fe-4e65-a6e1-887c5c9c4883', N'fb1e00c7-bbe2-46c4-a987-24ad892a9072', 10, CAST(92400 AS Decimal(8, 0)), 0)
INSERT [dbo].[OrderItems] ([OrderId], [BookId], [Quantity], [Price], [IsDeleted]) VALUES (N'd263c652-11fe-4e65-a6e1-887c5c9c4883', N'ddfde72a-7e11-49d5-89fb-e2766610c1cb', 1, CAST(200000 AS Decimal(8, 0)), 0)
INSERT [dbo].[OrderItems] ([OrderId], [BookId], [Quantity], [Price], [IsDeleted]) VALUES (N'0dbf8146-cd67-48c8-a634-8fb22af03e80', N'0b72ee3b-7e66-4cba-b5ee-3fcc947b3a03', 1, CAST(95000 AS Decimal(8, 0)), 0)
INSERT [dbo].[OrderItems] ([OrderId], [BookId], [Quantity], [Price], [IsDeleted]) VALUES (N'0dbf8146-cd67-48c8-a634-8fb22af03e80', N'da8d2d28-ec88-4514-b7c4-c8d19a43b857', 1, CAST(40000 AS Decimal(8, 0)), 0)
INSERT [dbo].[OrderItems] ([OrderId], [BookId], [Quantity], [Price], [IsDeleted]) VALUES (N'224b2327-5e24-4957-9437-96ab8f2993fc', N'358808bc-9c89-4431-8a5f-228bbbc86a6d', 3, CAST(59000 AS Decimal(8, 0)), 0)
INSERT [dbo].[OrderItems] ([OrderId], [BookId], [Quantity], [Price], [IsDeleted]) VALUES (N'224b2327-5e24-4957-9437-96ab8f2993fc', N'ddfde72a-7e11-49d5-89fb-e2766610c1cb', 1, CAST(200000 AS Decimal(8, 0)), 0)
INSERT [dbo].[OrderItems] ([OrderId], [BookId], [Quantity], [Price], [IsDeleted]) VALUES (N'1b8b771e-e7e0-4d80-b3f4-9a1dd8cbc728', N'358808bc-9c89-4431-8a5f-228bbbc86a6d', 1, CAST(59000 AS Decimal(8, 0)), 0)
INSERT [dbo].[OrderItems] ([OrderId], [BookId], [Quantity], [Price], [IsDeleted]) VALUES (N'1b8b771e-e7e0-4d80-b3f4-9a1dd8cbc728', N'b11ff973-84f6-4adb-9c31-b6cc0fe93fdf', 1, CAST(160000 AS Decimal(8, 0)), 0)
INSERT [dbo].[OrderItems] ([OrderId], [BookId], [Quantity], [Price], [IsDeleted]) VALUES (N'46712af3-1ca6-4b72-8dc0-b46966042242', N'55c70857-c0a9-4710-9ed5-34d6abb2bd10', 1, CAST(44000 AS Decimal(8, 0)), 0)
INSERT [dbo].[OrderItems] ([OrderId], [BookId], [Quantity], [Price], [IsDeleted]) VALUES (N'6b40a1ce-bab1-431d-8097-b8bf74e07da2', N'4bfd61cb-691d-49fc-acf4-d91aedd5fbf6', 1, CAST(202500 AS Decimal(8, 0)), 0)
INSERT [dbo].[OrderItems] ([OrderId], [BookId], [Quantity], [Price], [IsDeleted]) VALUES (N'262d0333-3f6e-4001-8cd3-d54ae55b070f', N'e2ccf867-c124-4e33-9b48-5cca2fb7a7f0', 1, CAST(50000 AS Decimal(8, 0)), 0)
INSERT [dbo].[OrderItems] ([OrderId], [BookId], [Quantity], [Price], [IsDeleted]) VALUES (N'262d0333-3f6e-4001-8cd3-d54ae55b070f', N'686f2b9e-5da2-4078-bb27-61fbeadda342', 2, CAST(63000 AS Decimal(8, 0)), 0)
INSERT [dbo].[OrderItems] ([OrderId], [BookId], [Quantity], [Price], [IsDeleted]) VALUES (N'16696407-7d32-427b-a94c-e2f8c367cf3c', N'358808bc-9c89-4431-8a5f-228bbbc86a6d', 2, CAST(59000 AS Decimal(8, 0)), 0)
INSERT [dbo].[OrderItems] ([OrderId], [BookId], [Quantity], [Price], [IsDeleted]) VALUES (N'16696407-7d32-427b-a94c-e2f8c367cf3c', N'55c70857-c0a9-4710-9ed5-34d6abb2bd10', 1, CAST(44000 AS Decimal(8, 0)), 0)
INSERT [dbo].[OrderItems] ([OrderId], [BookId], [Quantity], [Price], [IsDeleted]) VALUES (N'4592b819-fc2f-4822-8bba-e5b1c747ded7', N'0b72ee3b-7e66-4cba-b5ee-3fcc947b3a03', 1, CAST(95000 AS Decimal(8, 0)), 0)
INSERT [dbo].[OrderItems] ([OrderId], [BookId], [Quantity], [Price], [IsDeleted]) VALUES (N'f223def3-60a7-42ea-a468-e5bde4d843dd', N'55c70857-c0a9-4710-9ed5-34d6abb2bd10', 1, CAST(44000 AS Decimal(8, 0)), 0)
INSERT [dbo].[OrderItems] ([OrderId], [BookId], [Quantity], [Price], [IsDeleted]) VALUES (N'f223def3-60a7-42ea-a468-e5bde4d843dd', N'c862fb23-a2d2-42d2-8253-44824c4dfecc', 3, CAST(150000 AS Decimal(8, 0)), 0)
INSERT [dbo].[OrderItems] ([OrderId], [BookId], [Quantity], [Price], [IsDeleted]) VALUES (N'e5dd57fd-be26-497b-b533-ebbc488cf0ba', N'66d85958-f12d-43af-9827-684fe9e387d4', 1, CAST(76000 AS Decimal(8, 0)), 0)
INSERT [dbo].[OrderItems] ([OrderId], [BookId], [Quantity], [Price], [IsDeleted]) VALUES (N'e5dd57fd-be26-497b-b533-ebbc488cf0ba', N'7ae62fcb-f5c5-4ea9-985f-81914c4a97bd', 1, CAST(150000 AS Decimal(8, 0)), 0)
GO
INSERT [dbo].[Orders] ([Id], [StaffId], [CustomerId], [PromotionId], [CreatedTime], [ShippingFee], [PaymentMethod], [TotalAmount], [Status], [Note], [IsDeleted]) VALUES (N'7e778f62-49dc-4683-8b75-0d3c6cf602bc', N'b1009370-afce-4e2c-9fe2-25d6a0012178', N'ba12c75c-c9e1-4bb0-a928-970e24032376', NULL, CAST(N'2025-01-01T16:56:01.7314887' AS DateTime2), CAST(0.000 AS Decimal(11, 3)), N'Tiền mặt', CAST(194000.000 AS Decimal(11, 3)), N'Thành công', NULL, 0)
INSERT [dbo].[Orders] ([Id], [StaffId], [CustomerId], [PromotionId], [CreatedTime], [ShippingFee], [PaymentMethod], [TotalAmount], [Status], [Note], [IsDeleted]) VALUES (N'4196a906-de69-4ccf-85ab-22351421a1ed', N'b1009370-afce-4e2c-9fe2-25d6a0012178', N'833fe43e-cdbe-4587-a642-0a76f994e24e', NULL, CAST(N'2025-02-01T22:26:26.3505054' AS DateTime2), CAST(0.000 AS Decimal(11, 3)), N'Tiền mặt', CAST(76000.000 AS Decimal(11, 3)), N'Thành công', NULL, 0)
INSERT [dbo].[Orders] ([Id], [StaffId], [CustomerId], [PromotionId], [CreatedTime], [ShippingFee], [PaymentMethod], [TotalAmount], [Status], [Note], [IsDeleted]) VALUES (N'6b5771e5-67c3-4040-b356-3b8695624e72', N'b1009370-afce-4e2c-9fe2-25d6a0012178', N'833fe43e-cdbe-4587-a642-0a76f994e24e', NULL, CAST(N'2025-03-01T22:26:12.1998859' AS DateTime2), CAST(0.000 AS Decimal(11, 3)), N'Tiền mặt', CAST(200000.000 AS Decimal(11, 3)), N'Thành công', NULL, 0)
INSERT [dbo].[Orders] ([Id], [StaffId], [CustomerId], [PromotionId], [CreatedTime], [ShippingFee], [PaymentMethod], [TotalAmount], [Status], [Note], [IsDeleted]) VALUES (N'4c3b7ecd-a94c-46a1-b047-3f4cdfb24ca0', N'b1009370-afce-4e2c-9fe2-25d6a0012178', N'cfd6a6dc-ae6e-4cea-9b90-9111868c3a51', NULL, CAST(N'2025-08-01T22:36:41.5130235' AS DateTime2), CAST(0.000 AS Decimal(11, 3)), N'Tiền mặt', CAST(132000.000 AS Decimal(11, 3)), N'Thành công', NULL, 0)
INSERT [dbo].[Orders] ([Id], [StaffId], [CustomerId], [PromotionId], [CreatedTime], [ShippingFee], [PaymentMethod], [TotalAmount], [Status], [Note], [IsDeleted]) VALUES (N'a47d6176-ac9f-4926-9d81-471aa6e1780f', N'b1009370-afce-4e2c-9fe2-25d6a0012178', N'8fefdeb4-2148-4224-a304-41c292140fdd', N'610d6b8d-245a-4fa4-8eb9-6c89b5168f4d', CAST(N'2025-08-01T23:26:34.4691608' AS DateTime2), CAST(0.000 AS Decimal(11, 3)), N'Tiền mặt', CAST(252630.000 AS Decimal(11, 3)), N'Thành công', NULL, 0)
INSERT [dbo].[Orders] ([Id], [StaffId], [CustomerId], [PromotionId], [CreatedTime], [ShippingFee], [PaymentMethod], [TotalAmount], [Status], [Note], [IsDeleted]) VALUES (N'f66fa9ae-0a7d-45ed-bda0-4e91f9979a94', N'b1009370-afce-4e2c-9fe2-25d6a0012178', N'ba12c75c-c9e1-4bb0-a928-970e24032376', N'a38f02af-6754-40fd-bba1-3607bf60427a', CAST(N'2025-04-25T22:07:32.1922042' AS DateTime2), CAST(0.000 AS Decimal(11, 3)), N'Tiền mặt', CAST(174845.000 AS Decimal(11, 3)), N'Thành công', N'', 0)
INSERT [dbo].[Orders] ([Id], [StaffId], [CustomerId], [PromotionId], [CreatedTime], [ShippingFee], [PaymentMethod], [TotalAmount], [Status], [Note], [IsDeleted]) VALUES (N'3d4c92f3-7d03-4244-8f45-4e98fadabfb6', N'b1009370-afce-4e2c-9fe2-25d6a0012178', N'ba12c75c-c9e1-4bb0-a928-970e24032376', N'a38f02af-6754-40fd-bba1-3607bf60427a', CAST(N'2025-05-01T18:29:05.7706031' AS DateTime2), CAST(0.000 AS Decimal(11, 3)), N'Tiền mặt', CAST(162350.000 AS Decimal(11, 3)), N'Thành công', N'', 0)
INSERT [dbo].[Orders] ([Id], [StaffId], [CustomerId], [PromotionId], [CreatedTime], [ShippingFee], [PaymentMethod], [TotalAmount], [Status], [Note], [IsDeleted]) VALUES (N'4b2864fc-d2e6-488d-a547-67981e398104', N'b1009370-afce-4e2c-9fe2-25d6a0012178', N'833fe43e-cdbe-4587-a642-0a76f994e24e', N'610d6b8d-245a-4fa4-8eb9-6c89b5168f4d', CAST(N'2025-06-01T22:25:50.6352616' AS DateTime2), CAST(0.000 AS Decimal(11, 3)), N'Tiền mặt', CAST(182790.000 AS Decimal(11, 3)), N'Thành công', NULL, 0)
INSERT [dbo].[Orders] ([Id], [StaffId], [CustomerId], [PromotionId], [CreatedTime], [ShippingFee], [PaymentMethod], [TotalAmount], [Status], [Note], [IsDeleted]) VALUES (N'd263c652-11fe-4e65-a6e1-887c5c9c4883', N'b1009370-afce-4e2c-9fe2-25d6a0012178', N'ba12c75c-c9e1-4bb0-a928-970e24032376', N'a38f02af-6754-40fd-bba1-3607bf60427a', CAST(N'2025-07-31T17:29:09.6446646' AS DateTime2), CAST(0.000 AS Decimal(11, 3)), N'Tiền mặt', CAST(1105850.000 AS Decimal(11, 3)), N'Thành công', NULL, 0)
INSERT [dbo].[Orders] ([Id], [StaffId], [CustomerId], [PromotionId], [CreatedTime], [ShippingFee], [PaymentMethod], [TotalAmount], [Status], [Note], [IsDeleted]) VALUES (N'0dbf8146-cd67-48c8-a634-8fb22af03e80', N'b1009370-afce-4e2c-9fe2-25d6a0012178', N'8fefdeb4-2148-4224-a304-41c292140fdd', N'a38f02af-6754-40fd-bba1-3607bf60427a', CAST(N'2025-06-01T22:17:53.8352111' AS DateTime2), CAST(0.000 AS Decimal(11, 3)), N'Tiền mặt', CAST(114750.000 AS Decimal(11, 3)), N'Thành công', NULL, 0)
INSERT [dbo].[Orders] ([Id], [StaffId], [CustomerId], [PromotionId], [CreatedTime], [ShippingFee], [PaymentMethod], [TotalAmount], [Status], [Note], [IsDeleted]) VALUES (N'224b2327-5e24-4957-9437-96ab8f2993fc', N'b1009370-afce-4e2c-9fe2-25d6a0012178', N'ba12c75c-c9e1-4bb0-a928-970e24032376', N'a38f02af-6754-40fd-bba1-3607bf60427a', CAST(N'2025-08-01T17:32:36.9339789' AS DateTime2), CAST(0.000 AS Decimal(11, 3)), N'Tiền mặt', CAST(320450.000 AS Decimal(11, 3)), N'Thành công', NULL, 0)
INSERT [dbo].[Orders] ([Id], [StaffId], [CustomerId], [PromotionId], [CreatedTime], [ShippingFee], [PaymentMethod], [TotalAmount], [Status], [Note], [IsDeleted]) VALUES (N'1b8b771e-e7e0-4d80-b3f4-9a1dd8cbc728', N'b1009370-afce-4e2c-9fe2-25d6a0012178', N'8fefdeb4-2148-4224-a304-41c292140fdd', N'610d6b8d-245a-4fa4-8eb9-6c89b5168f4d', CAST(N'2025-08-01T23:45:04.8617049' AS DateTime2), CAST(0.000 AS Decimal(11, 3)), N'Tiền mặt', CAST(197100.000 AS Decimal(11, 3)), N'Thành công', NULL, 0)
INSERT [dbo].[Orders] ([Id], [StaffId], [CustomerId], [PromotionId], [CreatedTime], [ShippingFee], [PaymentMethod], [TotalAmount], [Status], [Note], [IsDeleted]) VALUES (N'46712af3-1ca6-4b72-8dc0-b46966042242', N'b1009370-afce-4e2c-9fe2-25d6a0012178', N'ba12c75c-c9e1-4bb0-a928-970e24032376', NULL, CAST(N'2025-08-01T22:26:19.5443312' AS DateTime2), CAST(0.000 AS Decimal(11, 3)), N'Tiền mặt', CAST(44000.000 AS Decimal(11, 3)), N'Thành công', NULL, 0)
INSERT [dbo].[Orders] ([Id], [StaffId], [CustomerId], [PromotionId], [CreatedTime], [ShippingFee], [PaymentMethod], [TotalAmount], [Status], [Note], [IsDeleted]) VALUES (N'6b40a1ce-bab1-431d-8097-b8bf74e07da2', N'b1009370-afce-4e2c-9fe2-25d6a0012178', N'833fe43e-cdbe-4587-a642-0a76f994e24e', NULL, CAST(N'2025-08-01T22:26:42.3180110' AS DateTime2), CAST(0.000 AS Decimal(11, 3)), N'Tiền mặt', CAST(202500.000 AS Decimal(11, 3)), N'Thành công', NULL, 0)
INSERT [dbo].[Orders] ([Id], [StaffId], [CustomerId], [PromotionId], [CreatedTime], [ShippingFee], [PaymentMethod], [TotalAmount], [Status], [Note], [IsDeleted]) VALUES (N'262d0333-3f6e-4001-8cd3-d54ae55b070f', N'0437a958-8ee4-4adb-9741-34edaff87fe3', N'4da1e043-c6c4-4fe6-8157-c8064e17a512', NULL, CAST(N'2025-08-01T17:34:29.3011012' AS DateTime2), CAST(0.000 AS Decimal(11, 3)), N'Tiền mặt', CAST(176000.000 AS Decimal(11, 3)), N'Thành công', N'Khách lấy đủ sách', 0)
INSERT [dbo].[Orders] ([Id], [StaffId], [CustomerId], [PromotionId], [CreatedTime], [ShippingFee], [PaymentMethod], [TotalAmount], [Status], [Note], [IsDeleted]) VALUES (N'16696407-7d32-427b-a94c-e2f8c367cf3c', N'b1009370-afce-4e2c-9fe2-25d6a0012178', N'4da1e043-c6c4-4fe6-8157-c8064e17a512', N'a38f02af-6754-40fd-bba1-3607bf60427a', CAST(N'2025-06-30T18:48:33.5834958' AS DateTime2), CAST(0.000 AS Decimal(11, 3)), N'Tiền mặt', CAST(137700.000 AS Decimal(11, 3)), N'Thành công', NULL, 0)
INSERT [dbo].[Orders] ([Id], [StaffId], [CustomerId], [PromotionId], [CreatedTime], [ShippingFee], [PaymentMethod], [TotalAmount], [Status], [Note], [IsDeleted]) VALUES (N'4592b819-fc2f-4822-8bba-e5b1c747ded7', N'b1009370-afce-4e2c-9fe2-25d6a0012178', N'833fe43e-cdbe-4587-a642-0a76f994e24e', NULL, CAST(N'2025-08-01T22:26:02.1209702' AS DateTime2), CAST(0.000 AS Decimal(11, 3)), N'Tiền mặt', CAST(95000.000 AS Decimal(11, 3)), N'Thành công', NULL, 0)
INSERT [dbo].[Orders] ([Id], [StaffId], [CustomerId], [PromotionId], [CreatedTime], [ShippingFee], [PaymentMethod], [TotalAmount], [Status], [Note], [IsDeleted]) VALUES (N'f223def3-60a7-42ea-a468-e5bde4d843dd', N'b1009370-afce-4e2c-9fe2-25d6a0012178', N'ba12c75c-c9e1-4bb0-a928-970e24032376', N'a38f02af-6754-40fd-bba1-3607bf60427a', CAST(N'2025-07-31T18:39:38.8292153' AS DateTime2), CAST(0.000 AS Decimal(11, 3)), N'Tiền mặt', CAST(419900.000 AS Decimal(11, 3)), N'Thành công', NULL, 0)
INSERT [dbo].[Orders] ([Id], [StaffId], [CustomerId], [PromotionId], [CreatedTime], [ShippingFee], [PaymentMethod], [TotalAmount], [Status], [Note], [IsDeleted]) VALUES (N'e5dd57fd-be26-497b-b533-ebbc488cf0ba', N'b1009370-afce-4e2c-9fe2-25d6a0012178', N'ba12c75c-c9e1-4bb0-a928-970e24032376', N'a38f02af-6754-40fd-bba1-3607bf60427a', CAST(N'2025-07-31T22:08:28.4864459' AS DateTime2), CAST(0.000 AS Decimal(11, 3)), N'Tiền mặt', CAST(192100.000 AS Decimal(11, 3)), N'Thành công', NULL, 0)
GO
INSERT [dbo].[Promotions] ([Id], [Name], [StartDate], [EndDate], [Condition], [DiscountPercent], [Quantity], [IsDeleted]) VALUES (N'da858eda-196e-45fb-8350-1845e2c67799', N'Khuyến Mãi Tháng 8', CAST(N'2025-08-01T00:00:00.0000000' AS DateTime2), CAST(N'2025-08-31T00:00:00.0000000' AS DateTime2), CAST(50000 AS Decimal(8, 0)), CAST(0.10 AS Decimal(3, 2)), 100, 0)
INSERT [dbo].[Promotions] ([Id], [Name], [StartDate], [EndDate], [Condition], [DiscountPercent], [Quantity], [IsDeleted]) VALUES (N'a38f02af-6754-40fd-bba1-3607bf60427a', N'Khuyến Mãi Mùa hè', CAST(N'2025-05-14T00:00:00.0000000' AS DateTime2), CAST(N'2025-08-16T00:00:00.0000000' AS DateTime2), CAST(120000 AS Decimal(8, 0)), CAST(0.15 AS Decimal(3, 2)), 20, 0)
INSERT [dbo].[Promotions] ([Id], [Name], [StartDate], [EndDate], [Condition], [DiscountPercent], [Quantity], [IsDeleted]) VALUES (N'610d6b8d-245a-4fa4-8eb9-6c89b5168f4d', N'Khuyến Mãi Năm 2025', CAST(N'2025-01-01T00:00:00.0000000' AS DateTime2), CAST(N'2026-01-01T00:00:00.0000000' AS DateTime2), CAST(200000 AS Decimal(8, 0)), CAST(0.10 AS Decimal(3, 2)), 997, 0)
INSERT [dbo].[Promotions] ([Id], [Name], [StartDate], [EndDate], [Condition], [DiscountPercent], [Quantity], [IsDeleted]) VALUES (N'a87d963e-4c3e-491c-8c43-ab3e4792cf10', N'Khuyến Mãi Cuối Năm', CAST(N'2025-11-01T11:00:57.5100000' AS DateTime2), CAST(N'2025-12-31T11:00:57.5100000' AS DateTime2), CAST(60000 AS Decimal(8, 0)), CAST(0.20 AS Decimal(3, 2)), 11, 0)
INSERT [dbo].[Promotions] ([Id], [Name], [StartDate], [EndDate], [Condition], [DiscountPercent], [Quantity], [IsDeleted]) VALUES (N'6622cd9a-984d-400b-8b6a-f908c1a5bdec', N'Khuyến Mãi Quốc Khánh', CAST(N'2025-08-31T00:00:00.0000000' AS DateTime2), CAST(N'2025-09-04T00:00:00.0000000' AS DateTime2), CAST(230000 AS Decimal(8, 0)), CAST(0.23 AS Decimal(3, 2)), 10, 0)
GO
INSERT [dbo].[Publishers] ([Id], [Name], [IsDeleted]) VALUES (N'79994ae3-d421-4b92-b895-323c19e12db9', N'Nhà xuất bản Trẻ', 0)
INSERT [dbo].[Publishers] ([Id], [Name], [IsDeleted]) VALUES (N'fa196dad-e9a3-44b7-bef5-821ccb4b59fe', N'Phúc Não To', 1)
INSERT [dbo].[Publishers] ([Id], [Name], [IsDeleted]) VALUES (N'ccb3f633-58ff-44a2-9aa5-8d73fd35d39e', N'Nhà xuất bản Tự do', 1)
INSERT [dbo].[Publishers] ([Id], [Name], [IsDeleted]) VALUES (N'2d64142c-1280-48e1-9207-c7a0023fa88f', N'Nhà xuất bản Kim Đồng', 0)
GO
INSERT [dbo].[Staffs] ([Id], [FamilyName], [GivenName], [DateOfBirth], [Address], [Phone], [Email], [CitizenIdentification], [HashPassword], [Role], [Gender], [IsActived], [IsDeleted]) VALUES (N'b1009370-afce-4e2c-9fe2-25d6a0012178', N'PTIT', N'Thien Phuc', CAST(N'2003-01-01' AS Date), N'Dong Nai', N'0397357111', N'n21dccn066@student.ptithcm.edu.vn', N'012345678900', N'$2a$11$dDoAoqd8Ge0J3ozFMjyUHe57e5E17rMNPcI5J1RJsV3Tjy9PI0r1O', 1, 0, 1, 0)
INSERT [dbo].[Staffs] ([Id], [FamilyName], [GivenName], [DateOfBirth], [Address], [Phone], [Email], [CitizenIdentification], [HashPassword], [Role], [Gender], [IsActived], [IsDeleted]) VALUES (N'0437a958-8ee4-4adb-9741-34edaff87fe3', N'Nguyễn Ngọc Thiên', N'Phúc', CAST(N'1999-07-01' AS Date), N'Hưng Lộc', N'0987654446', N'phucnaoto@gmail.com', N'098789001232', N'$2a$11$0P42lRgKfcSSF8EAAcEs5uA.ecWykWSXBkhnbnBX9a4vivj8hje3a', 0, 0, 1, 0)
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_Book]    Script Date: 8/1/2025 11:49:27 PM ******/
ALTER TABLE [dbo].[Books] ADD  CONSTRAINT [IX_Book] UNIQUE NONCLUSTERED 
(
	[Isbn] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_Category]    Script Date: 8/1/2025 11:49:27 PM ******/
ALTER TABLE [dbo].[Categories] ADD  CONSTRAINT [IX_Category] UNIQUE NONCLUSTERED 
(
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_Customer_Phone]    Script Date: 8/1/2025 11:49:27 PM ******/
ALTER TABLE [dbo].[Customers] ADD  CONSTRAINT [IX_Customer_Phone] UNIQUE NONCLUSTERED 
(
	[Phone] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_Customer_Email]    Script Date: 8/1/2025 11:49:27 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_Customer_Email] ON [dbo].[Customers]
(
	[Email] ASC
)
WHERE ([Email] IS NOT NULL)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_Promotion]    Script Date: 8/1/2025 11:49:27 PM ******/
ALTER TABLE [dbo].[Promotions] ADD  CONSTRAINT [IX_Promotion] UNIQUE NONCLUSTERED 
(
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_Publisher]    Script Date: 8/1/2025 11:49:27 PM ******/
ALTER TABLE [dbo].[Publishers] ADD  CONSTRAINT [IX_Publisher] UNIQUE NONCLUSTERED 
(
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_Staff_CI]    Script Date: 8/1/2025 11:49:27 PM ******/
ALTER TABLE [dbo].[Staffs] ADD  CONSTRAINT [IX_Staff_CI] UNIQUE NONCLUSTERED 
(
	[CitizenIdentification] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_Staff_Email]    Script Date: 8/1/2025 11:49:27 PM ******/
ALTER TABLE [dbo].[Staffs] ADD  CONSTRAINT [IX_Staff_Email] UNIQUE NONCLUSTERED 
(
	[Email] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_Staff_Phone]    Script Date: 8/1/2025 11:49:27 PM ******/
ALTER TABLE [dbo].[Staffs] ADD  CONSTRAINT [IX_Staff_Phone] UNIQUE NONCLUSTERED 
(
	[Phone] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AuditLogs] ADD  CONSTRAINT [DF_AuditLogs_Id]  DEFAULT (newid()) FOR [Id]
GO
ALTER TABLE [dbo].[AuditLogs] ADD  CONSTRAINT [DF_AuditLogs_Timestamp]  DEFAULT (sysdatetime()) FOR [Timestamp]
GO
ALTER TABLE [dbo].[Authors] ADD  CONSTRAINT [DF_Author_Id]  DEFAULT (newid()) FOR [Id]
GO
ALTER TABLE [dbo].[Authors] ADD  CONSTRAINT [DF_Author_IsDeleted]  DEFAULT ((0)) FOR [IsDeleted]
GO
ALTER TABLE [dbo].[Books] ADD  CONSTRAINT [DF_Book_Id]  DEFAULT (newid()) FOR [Id]
GO
ALTER TABLE [dbo].[Books] ADD  CONSTRAINT [DF_Book_IsDeleted]  DEFAULT ((0)) FOR [IsDeleted]
GO
ALTER TABLE [dbo].[Categories] ADD  CONSTRAINT [DF_Categories_Id]  DEFAULT (newid()) FOR [Id]
GO
ALTER TABLE [dbo].[Categories] ADD  CONSTRAINT [DF_Categories_IsDeleted]  DEFAULT ((0)) FOR [IsDeleted]
GO
ALTER TABLE [dbo].[Customers] ADD  CONSTRAINT [DF_Customer_Id]  DEFAULT (newid()) FOR [Id]
GO
ALTER TABLE [dbo].[Customers] ADD  CONSTRAINT [DF_Customer_Gender]  DEFAULT ((0)) FOR [Gender]
GO
ALTER TABLE [dbo].[Customers] ADD  CONSTRAINT [DF_Customer_IsActived]  DEFAULT ((0)) FOR [IsActived]
GO
ALTER TABLE [dbo].[Customers] ADD  CONSTRAINT [DF_Customer_IsDeleted]  DEFAULT ((0)) FOR [IsDeleted]
GO
ALTER TABLE [dbo].[OrderItems] ADD  CONSTRAINT [DF_OrderItem_IsDeleted]  DEFAULT ((0)) FOR [IsDeleted]
GO
ALTER TABLE [dbo].[Orders] ADD  CONSTRAINT [DF_Order_Id]  DEFAULT (newid()) FOR [Id]
GO
ALTER TABLE [dbo].[Orders] ADD  CONSTRAINT [DF_Order_CreatedTime]  DEFAULT (sysdatetime()) FOR [CreatedTime]
GO
ALTER TABLE [dbo].[Orders] ADD  CONSTRAINT [DF_Order_ShippingFee]  DEFAULT ((0.0)) FOR [ShippingFee]
GO
ALTER TABLE [dbo].[Orders] ADD  CONSTRAINT [DF_Order_IsDeleted]  DEFAULT ((0)) FOR [IsDeleted]
GO
ALTER TABLE [dbo].[Promotions] ADD  CONSTRAINT [DF_Promotion_Id]  DEFAULT (newid()) FOR [Id]
GO
ALTER TABLE [dbo].[Promotions] ADD  CONSTRAINT [DF_Promotion_IsDeleted]  DEFAULT ((0)) FOR [IsDeleted]
GO
ALTER TABLE [dbo].[Publishers] ADD  CONSTRAINT [DF_Publisher_Id]  DEFAULT (newid()) FOR [Id]
GO
ALTER TABLE [dbo].[Publishers] ADD  CONSTRAINT [DF_Publisher_IsDeleted]  DEFAULT ((0)) FOR [IsDeleted]
GO
ALTER TABLE [dbo].[Staffs] ADD  CONSTRAINT [DF_Staff_Id]  DEFAULT (newid()) FOR [Id]
GO
ALTER TABLE [dbo].[Staffs] ADD  CONSTRAINT [DF_Staff_Role]  DEFAULT ((0)) FOR [Role]
GO
ALTER TABLE [dbo].[Staffs] ADD  CONSTRAINT [DF_Staff_Gender]  DEFAULT ((0)) FOR [Gender]
GO
ALTER TABLE [dbo].[Staffs] ADD  CONSTRAINT [DF_Staff_IsActived]  DEFAULT ((0)) FOR [IsActived]
GO
ALTER TABLE [dbo].[Staffs] ADD  CONSTRAINT [DF_Staff_IsDeleted]  DEFAULT ((0)) FOR [IsDeleted]
GO
ALTER TABLE [dbo].[AuditLogs]  WITH CHECK ADD  CONSTRAINT [FK_AuditLogs_Staffs] FOREIGN KEY([StaffId])
REFERENCES [dbo].[Staffs] ([Id])
GO
ALTER TABLE [dbo].[AuditLogs] CHECK CONSTRAINT [FK_AuditLogs_Staffs]
GO
ALTER TABLE [dbo].[Books]  WITH CHECK ADD  CONSTRAINT [FK_Books_Authors] FOREIGN KEY([AuthorId])
REFERENCES [dbo].[Authors] ([Id])
GO
ALTER TABLE [dbo].[Books] CHECK CONSTRAINT [FK_Books_Authors]
GO
ALTER TABLE [dbo].[Books]  WITH CHECK ADD  CONSTRAINT [FK_Books_Categories] FOREIGN KEY([CategoryId])
REFERENCES [dbo].[Categories] ([Id])
GO
ALTER TABLE [dbo].[Books] CHECK CONSTRAINT [FK_Books_Categories]
GO
ALTER TABLE [dbo].[Books]  WITH CHECK ADD  CONSTRAINT [FK_Books_Publishers] FOREIGN KEY([PublisherId])
REFERENCES [dbo].[Publishers] ([Id])
GO
ALTER TABLE [dbo].[Books] CHECK CONSTRAINT [FK_Books_Publishers]
GO
ALTER TABLE [dbo].[OrderItems]  WITH CHECK ADD  CONSTRAINT [FK_OrderItems_Books] FOREIGN KEY([BookId])
REFERENCES [dbo].[Books] ([Id])
GO
ALTER TABLE [dbo].[OrderItems] CHECK CONSTRAINT [FK_OrderItems_Books]
GO
ALTER TABLE [dbo].[OrderItems]  WITH CHECK ADD  CONSTRAINT [FK_OrderItems_Orders] FOREIGN KEY([OrderId])
REFERENCES [dbo].[Orders] ([Id])
GO
ALTER TABLE [dbo].[OrderItems] CHECK CONSTRAINT [FK_OrderItems_Orders]
GO
ALTER TABLE [dbo].[Orders]  WITH CHECK ADD  CONSTRAINT [FK_Orders_Customers] FOREIGN KEY([CustomerId])
REFERENCES [dbo].[Customers] ([Id])
GO
ALTER TABLE [dbo].[Orders] CHECK CONSTRAINT [FK_Orders_Customers]
GO
ALTER TABLE [dbo].[Orders]  WITH CHECK ADD  CONSTRAINT [FK_Orders_Promotions] FOREIGN KEY([PromotionId])
REFERENCES [dbo].[Promotions] ([Id])
GO
ALTER TABLE [dbo].[Orders] CHECK CONSTRAINT [FK_Orders_Promotions]
GO
ALTER TABLE [dbo].[Orders]  WITH CHECK ADD  CONSTRAINT [FK_Orders_Staffs] FOREIGN KEY([StaffId])
REFERENCES [dbo].[Staffs] ([Id])
GO
ALTER TABLE [dbo].[Orders] CHECK CONSTRAINT [FK_Orders_Staffs]
GO
ALTER TABLE [dbo].[Books]  WITH CHECK ADD  CONSTRAINT [CK_Price] CHECK  (([Price]>(1000)))
GO
ALTER TABLE [dbo].[Books] CHECK CONSTRAINT [CK_Price]
GO
ALTER TABLE [dbo].[Books]  WITH CHECK ADD  CONSTRAINT [CK_Quantity] CHECK  (([Quantity]>=(0)))
GO
ALTER TABLE [dbo].[Books] CHECK CONSTRAINT [CK_Quantity]
GO
ALTER TABLE [dbo].[Books]  WITH CHECK ADD  CONSTRAINT [CK_YOP] CHECK  (([YearOfPublication]>(1500)))
GO
ALTER TABLE [dbo].[Books] CHECK CONSTRAINT [CK_YOP]
GO
ALTER TABLE [dbo].[OrderItems]  WITH CHECK ADD  CONSTRAINT [CK_OrderItem_Price] CHECK  (([Price]>(1000)))
GO
ALTER TABLE [dbo].[OrderItems] CHECK CONSTRAINT [CK_OrderItem_Price]
GO
ALTER TABLE [dbo].[OrderItems]  WITH CHECK ADD  CONSTRAINT [CK_OrderItem_Quantity] CHECK  (([Quantity]>(0)))
GO
ALTER TABLE [dbo].[OrderItems] CHECK CONSTRAINT [CK_OrderItem_Quantity]
GO
ALTER TABLE [dbo].[Promotions]  WITH CHECK ADD  CONSTRAINT [CK_Promotion_Condition] CHECK  (([Condition]>(1000)))
GO
ALTER TABLE [dbo].[Promotions] CHECK CONSTRAINT [CK_Promotion_Condition]
GO
ALTER TABLE [dbo].[Promotions]  WITH CHECK ADD  CONSTRAINT [CK_Promotion_DiscountPercent] CHECK  (([DiscountPercent]>(0.0)))
GO
ALTER TABLE [dbo].[Promotions] CHECK CONSTRAINT [CK_Promotion_DiscountPercent]
GO
ALTER TABLE [dbo].[Promotions]  WITH CHECK ADD  CONSTRAINT [CK_Promotion_Quantity] CHECK  (([Quantity]>=(0)))
GO
ALTER TABLE [dbo].[Promotions] CHECK CONSTRAINT [CK_Promotion_Quantity]
GO
ALTER TABLE [dbo].[Promotions]  WITH CHECK ADD  CONSTRAINT [CK_Promotions_Date] CHECK  (([StartDate]<[EndDate]))
GO
ALTER TABLE [dbo].[Promotions] CHECK CONSTRAINT [CK_Promotions_Date]
GO
USE [master]
GO
ALTER DATABASE [BOOK_SHOP_API] SET  READ_WRITE 
GO
