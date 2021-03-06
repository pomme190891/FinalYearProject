USE [master]
GO
/****** Object:  Database [finplanweb]    Script Date: 5/1/2014 8:07:53 AM ******/
CREATE DATABASE [finplanweb] ON  PRIMARY 
( NAME = N'finplanweb', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\DATA\finplanweb.mdf' , SIZE = 4096KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'finplanweb_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\DATA\finplanweb_log.ldf' , SIZE = 1024KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [finplanweb].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [finplanweb] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [finplanweb] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [finplanweb] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [finplanweb] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [finplanweb] SET ARITHABORT OFF 
GO
ALTER DATABASE [finplanweb] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [finplanweb] SET AUTO_CREATE_STATISTICS ON 
GO
ALTER DATABASE [finplanweb] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [finplanweb] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [finplanweb] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [finplanweb] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [finplanweb] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [finplanweb] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [finplanweb] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [finplanweb] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [finplanweb] SET  DISABLE_BROKER 
GO
ALTER DATABASE [finplanweb] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [finplanweb] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [finplanweb] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [finplanweb] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [finplanweb] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [finplanweb] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [finplanweb] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [finplanweb] SET RECOVERY FULL 
GO
ALTER DATABASE [finplanweb] SET  MULTI_USER 
GO
ALTER DATABASE [finplanweb] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [finplanweb] SET DB_CHAINING OFF 
GO
USE [finplanweb]
GO
/****** Object:  User [db_access_user]    Script Date: 5/1/2014 8:07:54 AM ******/
CREATE USER [db_access_user] FOR LOGIN [db_access_user] WITH DEFAULT_SCHEMA=[dbo]
GO
sys.sp_addrolemember @rolename = N'db_datareader', @membername = N'db_access_user'
GO
sys.sp_addrolemember @rolename = N'db_datawriter', @membername = N'db_access_user'
GO
/****** Object:  Table [dbo].[categories]    Script Date: 5/1/2014 8:07:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[categories](
	[categoriesID] [int] IDENTITY(1,1) NOT NULL,
	[categoriesName] [nvarchar](50) NOT NULL,
	[date_added] [datetime] NOT NULL,
	[last_modified] [datetime] NULL,
 CONSTRAINT [PK__categori__52A97118C0A10529] PRIMARY KEY CLUSTERED 
(
	[categoriesID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[orderItems]    Script Date: 5/1/2014 8:07:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[orderItems](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[ProductID] [int] NULL,
	[qty] [int] NULL,
	[orderID] [int] NULL,
 CONSTRAINT [PK_orderItems] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[orders]    Script Date: 5/1/2014 8:07:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[orders](
	[orderID] [int] IDENTITY(1,1) NOT NULL,
	[userID] [int] NULL,
	[firstName] [nvarchar](50) NULL,
	[lastName] [nvarchar](50) NULL,
	[payerEmail] [nvarchar](50) NULL,
	[paymentDate] [datetime] NULL,
	[paymentStatus] [nvarchar](50) NULL,
	[paymentType] [nvarchar](40) NULL,
	[mcGross] [money] NULL,
	[mcCurrency] [money] NULL,
	[dateCreated] [datetime] NULL,
	[paypalID] [nvarchar](100) NULL,
	[directdebitID] [nvarchar](100) NULL,
	[codeID] [nvarchar](50) NULL,
 CONSTRAINT [PK__orders__0809337D03878BC7] PRIMARY KEY CLUSTERED 
(
	[orderID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[prodtocater]    Script Date: 5/1/2014 8:07:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[prodtocater](
	[productID] [int] NOT NULL,
	[categoriesID] [int] NOT NULL,
 CONSTRAINT [PK__prodtoca__B83A465BDBC721A4] PRIMARY KEY CLUSTERED 
(
	[productID] ASC,
	[categoriesID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[products]    Script Date: 5/1/2014 8:07:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[products](
	[productID] [int] IDENTITY(1,1) NOT NULL,
	[productCode] [nvarchar](40) NOT NULL,
	[description] [nvarchar](300) NOT NULL,
	[addedDate] [datetime] NOT NULL,
	[modifiedDate] [datetime] NULL,
	[price] [money] NOT NULL,
	[categoriesID] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[productID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[promotion]    Script Date: 5/1/2014 8:07:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[promotion](
	[codeID] [nvarchar](50) NOT NULL,
	[rate] [int] NULL,
	[price] [money] NULL,
	[hidden] [bit] NULL,
 CONSTRAINT [PK_promotion] PRIMARY KEY CLUSTERED 
(
	[codeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[users]    Script Date: 5/1/2014 8:07:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[users](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Username] [nvarchar](50) NOT NULL,
	[Firstname] [nvarchar](50) NOT NULL,
	[Surname] [nvarchar](50) NOT NULL,
	[Firm] [nvarchar](50) NOT NULL,
	[Password] [nvarchar](max) NOT NULL,
	[RegDate] [datetime] NULL,
	[Email] [nvarchar](50) NOT NULL,
	[isAdmin] [bit] NULL,
	[lastlogin] [datetime] NULL,
	[iplog] [varchar](15) NULL,
	[modifiedDate] [datetime] NULL,
	[deleted] [bit] NULL,
 CONSTRAINT [PK__users__3214EC075CC267CD] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
SET IDENTITY_INSERT [dbo].[categories] ON 

INSERT [dbo].[categories] ([categoriesID], [categoriesName], [date_added], [last_modified]) VALUES (1, N'Cloud', CAST(0x0000A2F300FFDB14 AS DateTime), NULL)
INSERT [dbo].[categories] ([categoriesID], [categoriesName], [date_added], [last_modified]) VALUES (2, N'Data Transfer', CAST(0x0000A2F300FFEFAC AS DateTime), NULL)
INSERT [dbo].[categories] ([categoriesID], [categoriesName], [date_added], [last_modified]) VALUES (3, N'IT Support', CAST(0x0000A2F301000B18 AS DateTime), NULL)
SET IDENTITY_INSERT [dbo].[categories] OFF
SET IDENTITY_INSERT [dbo].[orderItems] ON 

INSERT [dbo].[orderItems] ([ID], [ProductID], [qty], [orderID]) VALUES (1, 3, 6, 2)
INSERT [dbo].[orderItems] ([ID], [ProductID], [qty], [orderID]) VALUES (2, 3, 6, 3)
INSERT [dbo].[orderItems] ([ID], [ProductID], [qty], [orderID]) VALUES (3, 3, 5, 4)
INSERT [dbo].[orderItems] ([ID], [ProductID], [qty], [orderID]) VALUES (4, 3, 1, 5)
INSERT [dbo].[orderItems] ([ID], [ProductID], [qty], [orderID]) VALUES (5, 6, 1, 5)
INSERT [dbo].[orderItems] ([ID], [ProductID], [qty], [orderID]) VALUES (6, 3, 1, 6)
INSERT [dbo].[orderItems] ([ID], [ProductID], [qty], [orderID]) VALUES (7, 2, 1, 6)
INSERT [dbo].[orderItems] ([ID], [ProductID], [qty], [orderID]) VALUES (8, 1, 1, 6)
INSERT [dbo].[orderItems] ([ID], [ProductID], [qty], [orderID]) VALUES (9, 3, 1, 7)
INSERT [dbo].[orderItems] ([ID], [ProductID], [qty], [orderID]) VALUES (10, 2, 1, 7)
INSERT [dbo].[orderItems] ([ID], [ProductID], [qty], [orderID]) VALUES (11, 3, 1, 8)
INSERT [dbo].[orderItems] ([ID], [ProductID], [qty], [orderID]) VALUES (12, 2, 1, 8)
INSERT [dbo].[orderItems] ([ID], [ProductID], [qty], [orderID]) VALUES (13, 1, 2, 9)
INSERT [dbo].[orderItems] ([ID], [ProductID], [qty], [orderID]) VALUES (14, 5, 1, 10)
INSERT [dbo].[orderItems] ([ID], [ProductID], [qty], [orderID]) VALUES (15, 4, 1, 10)
INSERT [dbo].[orderItems] ([ID], [ProductID], [qty], [orderID]) VALUES (16, 1, 1, 11)
INSERT [dbo].[orderItems] ([ID], [ProductID], [qty], [orderID]) VALUES (17, 2, 1, 11)
SET IDENTITY_INSERT [dbo].[orderItems] OFF
SET IDENTITY_INSERT [dbo].[orders] ON 

INSERT [dbo].[orders] ([orderID], [userID], [firstName], [lastName], [payerEmail], [paymentDate], [paymentStatus], [paymentType], [mcGross], [mcCurrency], [dateCreated], [paypalID], [directdebitID], [codeID]) VALUES (1, 11, N'kkhoihoh', N'ohohohoh', N'test@test.com', CAST(0x0000A30B00E0DA53 AS DateTime), N'Success', N'Paypal', 20.0000, 24.0000, CAST(0x0000A30B00E0DA54 AS DateTime), N'6FV61863MH6514742', NULL, NULL)
INSERT [dbo].[orders] ([orderID], [userID], [firstName], [lastName], [payerEmail], [paymentDate], [paymentStatus], [paymentType], [mcGross], [mcCurrency], [dateCreated], [paypalID], [directdebitID], [codeID]) VALUES (2, 11, N'gdfgfdgfd', N'gfdgdfg', N'test@test.com', CAST(0x0000A30B00E738FC AS DateTime), N'Success', N'Paypal', 30.0000, 36.0000, CAST(0x0000A30B00E738FC AS DateTime), N'8MV0442346971022A', NULL, NULL)
INSERT [dbo].[orders] ([orderID], [userID], [firstName], [lastName], [payerEmail], [paymentDate], [paymentStatus], [paymentType], [mcGross], [mcCurrency], [dateCreated], [paypalID], [directdebitID], [codeID]) VALUES (3, 11, N'egdsgsd', N'dgsgsd', N'test@test.com', CAST(0x0000A30B00EDDF6F AS DateTime), N'Success', N'Direct Debit', 30.0000, 36.0000, CAST(0x0000A30B00EDDF6F AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[orders] ([orderID], [userID], [firstName], [lastName], [payerEmail], [paymentDate], [paymentStatus], [paymentType], [mcGross], [mcCurrency], [dateCreated], [paypalID], [directdebitID], [codeID]) VALUES (4, 11, N'fsdfdsf', N'dsfdsfdsf', N'test@test.com', CAST(0x0000A30B00F05EAC AS DateTime), N'Success', N'Direct Debit', 25.0000, 30.0000, CAST(0x0000A30B00F05EAC AS DateTime), NULL, N'cMR0wsOyYDyP3OiEh', NULL)
INSERT [dbo].[orders] ([orderID], [userID], [firstName], [lastName], [payerEmail], [paymentDate], [paymentStatus], [paymentType], [mcGross], [mcCurrency], [dateCreated], [paypalID], [directdebitID], [codeID]) VALUES (5, 11, N'test', N'TEST', N'fewfew@dwd.com', CAST(0x0000A31A0184645E AS DateTime), N'Success', N'Direct Debit', 255.0000, 306.0000, CAST(0x0000A31A01846460 AS DateTime), NULL, N'K527U1ALS92ZS3ZTW', NULL)
INSERT [dbo].[orders] ([orderID], [userID], [firstName], [lastName], [payerEmail], [paymentDate], [paymentStatus], [paymentType], [mcGross], [mcCurrency], [dateCreated], [paypalID], [directdebitID], [codeID]) VALUES (6, 11, N'test', N'test', N'dqwdw@fef.com', CAST(0x0000A31A01851AD6 AS DateTime), N'Success', N'Direct Debit', 295.0000, 354.0000, CAST(0x0000A31A01851AD6 AS DateTime), NULL, N'SVZBG0YD5MN5DF4UW', NULL)
INSERT [dbo].[orders] ([orderID], [userID], [firstName], [lastName], [payerEmail], [paymentDate], [paymentStatus], [paymentType], [mcGross], [mcCurrency], [dateCreated], [paypalID], [directdebitID], [codeID]) VALUES (7, 11, N'we', N'dqwe', N'dwqdf@ded.com', CAST(0x0000A31A01860694 AS DateTime), N'Success', N'Direct Debit', 150.0000, 180.0000, CAST(0x0000A31A01860694 AS DateTime), NULL, N'GUH5O7EPCPKZ3IJCL', NULL)
INSERT [dbo].[orders] ([orderID], [userID], [firstName], [lastName], [payerEmail], [paymentDate], [paymentStatus], [paymentType], [mcGross], [mcCurrency], [dateCreated], [paypalID], [directdebitID], [codeID]) VALUES (8, 11, N'test', N'test', N'tqwedqwd@wadwd.com', CAST(0x0000A31A01879695 AS DateTime), N'Success', N'Direct Debit', 150.0000, 180.0000, CAST(0x0000A31A01879696 AS DateTime), NULL, N'9501IOROJFLQQK63H', NULL)
INSERT [dbo].[orders] ([orderID], [userID], [firstName], [lastName], [payerEmail], [paymentDate], [paymentStatus], [paymentType], [mcGross], [mcCurrency], [dateCreated], [paypalID], [directdebitID], [codeID]) VALUES (9, 22, N'Test', N'Test', N'Test@test.com', CAST(0x0000A31B00E83B8F AS DateTime), N'Success', N'Direct Debit', 290.0000, 348.0000, CAST(0x0000A31B00E83BA1 AS DateTime), NULL, N'F5KV5VUOMIO3CE31Y', NULL)
INSERT [dbo].[orders] ([orderID], [userID], [firstName], [lastName], [payerEmail], [paymentDate], [paymentStatus], [paymentType], [mcGross], [mcCurrency], [dateCreated], [paypalID], [directdebitID], [codeID]) VALUES (10, 22, N'Test', N'Test', N'test@test.com', CAST(0x0000A31B00F9850A AS DateTime), N'Success', N'Direct Debit', 91.2000, 109.4400, CAST(0x0000A31B00F98524 AS DateTime), NULL, N'GIA46DC8GD0LPEBCG', NULL)
INSERT [dbo].[orders] ([orderID], [userID], [firstName], [lastName], [payerEmail], [paymentDate], [paymentStatus], [paymentType], [mcGross], [mcCurrency], [dateCreated], [paypalID], [directdebitID], [codeID]) VALUES (11, 11, N'awe', N'aqwe', N'weqfe@feg.com', CAST(0x0000A31B011525F0 AS DateTime), N'Success', N'Direct Debit', 290.0000, 348.0000, CAST(0x0000A31B011525F6 AS DateTime), NULL, N'DUFUJ0C3COC5A12YA', NULL)
SET IDENTITY_INSERT [dbo].[orders] OFF
SET IDENTITY_INSERT [dbo].[products] ON 

INSERT [dbo].[products] ([productID], [productCode], [description], [addedDate], [modifiedDate], [price], [categoriesID]) VALUES (1, N'CLDMTH0001', N'FinPlan Cloud - Site Licence TEST', CAST(0x0000A2F700E88FE9 AS DateTime), CAST(0x0000A31E0005315C AS DateTime), 123.0000, 2)
INSERT [dbo].[products] ([productID], [productCode], [description], [addedDate], [modifiedDate], [price], [categoriesID]) VALUES (2, N'CLDMTH0002', N'FinPlan Cloud - User Licence', CAST(0x0000A2F700E9D73E AS DateTime), CAST(0x0000A31E0005D2AB AS DateTime), 1452.0000, 1)
INSERT [dbo].[products] ([productID], [productCode], [description], [addedDate], [modifiedDate], [price], [categoriesID]) VALUES (3, N'CLDMTH0410', N'FinPlan Cloud - Data Storage in GB (Price per GB)', CAST(0x0000A2F700E9D73E AS DateTime), CAST(0x0000A31E0006C369 AS DateTime), 512.0000, 1)
INSERT [dbo].[products] ([productID], [productCode], [description], [addedDate], [modifiedDate], [price], [categoriesID]) VALUES (4, N'CLDMTH0420', N'FinPlan Cloud - Documents Storage in GB(Price per GB)', CAST(0x0000A2F700E9D73E AS DateTime), NULL, 1.2000, 1)
INSERT [dbo].[products] ([productID], [productCode], [description], [addedDate], [modifiedDate], [price], [categoriesID]) VALUES (5, N'CLDOFF0001', N'FinPlan Portal - Standard Activation Fee', CAST(0x0000A2F700E9D73E AS DateTime), NULL, 90.0000, 1)
INSERT [dbo].[products] ([productID], [productCode], [description], [addedDate], [modifiedDate], [price], [categoriesID]) VALUES (6, N'CLDOFF0002', N'FinPlan Portal - Custom Activation Fee', CAST(0x0000A2F700E9D73E AS DateTime), NULL, 250.0000, 1)
INSERT [dbo].[products] ([productID], [productCode], [description], [addedDate], [modifiedDate], [price], [categoriesID]) VALUES (13, N'FINHOST0001', N'FinPlan Cloud - Installation', CAST(0x0000A2F8009B385E AS DateTime), NULL, 1000.0000, 1)
INSERT [dbo].[products] ([productID], [productCode], [description], [addedDate], [modifiedDate], [price], [categoriesID]) VALUES (14, N'FININITIAL0001', N'Finplan - Data Transfer Analysis', CAST(0x0000A2F8009B385E AS DateTime), NULL, 895.0000, 2)
INSERT [dbo].[products] ([productID], [productCode], [description], [addedDate], [modifiedDate], [price], [categoriesID]) VALUES (15, N'FININITIAL0002', N'Finplan - Bespoke Data Transfer', CAST(0x0000A2F8009B385E AS DateTime), NULL, 895.0000, 2)
INSERT [dbo].[products] ([productID], [productCode], [description], [addedDate], [modifiedDate], [price], [categoriesID]) VALUES (16, N'FININITIAL0008', N'Finplan - Website Enquiry Service', CAST(0x0000A2F8009B385E AS DateTime), NULL, 500.0000, 1)
INSERT [dbo].[products] ([productID], [productCode], [description], [addedDate], [modifiedDate], [price], [categoriesID]) VALUES (17, N'FININITIAL0010', N'Finplan - SMS Bundle', CAST(0x0000A2F8009B385E AS DateTime), NULL, 50.0000, 1)
INSERT [dbo].[products] ([productID], [productCode], [description], [addedDate], [modifiedDate], [price], [categoriesID]) VALUES (18, N'FINMTH0011', N'Finplan - Training', CAST(0x0000A2F8009B385E AS DateTime), NULL, 800.0000, 1)
INSERT [dbo].[products] ([productID], [productCode], [description], [addedDate], [modifiedDate], [price], [categoriesID]) VALUES (19, N'FINOFF001', N'Finplan- IT Support Services', CAST(0x0000A2F8009B385E AS DateTime), NULL, 90.0000, 3)
SET IDENTITY_INSERT [dbo].[products] OFF
INSERT [dbo].[promotion] ([codeID], [rate], [price]) VALUES (N'FPCLO01', 50, 0.0000)
INSERT [dbo].[promotion] ([codeID], [rate], [price]) VALUES (N'FPCLO02', 0, 1000.0000)
SET IDENTITY_INSERT [dbo].[users] ON 

INSERT [dbo].[users] ([Id], [Username], [Firstname], [Surname], [Firm], [Password], [RegDate], [Email], [isAdmin], [lastlogin], [iplog], [modifiedDate], [deleted]) VALUES (1, N'pomme', N'test', N'test', N'test', N'f865b53623b121fd34ee5426c792e5c33af8c227', CAST(0x0000A2F000BA9739 AS DateTime), N'pomme_911@hotmail.com', 0, NULL, NULL, NULL, 1)
INSERT [dbo].[users] ([Id], [Username], [Firstname], [Surname], [Firm], [Password], [RegDate], [Email], [isAdmin], [lastlogin], [iplog], [modifiedDate], [deleted]) VALUES (2, N'admin', N'test', N'test', N'test', N'f865b53623b121fd34ee5426c792e5c33af8c227', CAST(0x0000A2F000C26397 AS DateTime), N'test@admin.com', 1, CAST(0x0000A2F100BD1C5E AS DateTime), NULL, NULL, 1)
INSERT [dbo].[users] ([Id], [Username], [Firstname], [Surname], [Firm], [Password], [RegDate], [Email], [isAdmin], [lastlogin], [iplog], [modifiedDate], [deleted]) VALUES (3, N'admin', N'test', N'test', N'test', N'f865b53623b121fd34ee5426c792e5c33af8c227', CAST(0x0000A2F000C2DE47 AS DateTime), N'test@admin.com', 1, CAST(0x0000A2F100BD1C5E AS DateTime), NULL, NULL, 1)
INSERT [dbo].[users] ([Id], [Username], [Firstname], [Surname], [Firm], [Password], [RegDate], [Email], [isAdmin], [lastlogin], [iplog], [modifiedDate], [deleted]) VALUES (4, N'bluecoat', N'John', N'test', N'test', N'f865b53623b121fd34ee5426c792e5c33af8c227', CAST(0x0000A2F000C31765 AS DateTime), N'test@bluecoat.com', 0, NULL, NULL, NULL, 1)
INSERT [dbo].[users] ([Id], [Username], [Firstname], [Surname], [Firm], [Password], [RegDate], [Email], [isAdmin], [lastlogin], [iplog], [modifiedDate], [deleted]) VALUES (5, N'bluecoat', N'John', N'test', N'test', N'f865b53623b121fd34ee5426c792e5c33af8c227', CAST(0x0000A2F000C3FE9A AS DateTime), N'test@bluecoat.com', 0, NULL, NULL, NULL, 1)
INSERT [dbo].[users] ([Id], [Username], [Firstname], [Surname], [Firm], [Password], [RegDate], [Email], [isAdmin], [lastlogin], [iplog], [modifiedDate], [deleted]) VALUES (6, N'test', N'test', N'test', N'test', N'f865b53623b121fd34ee5426c792e5c33af8c227', CAST(0x0000A2F000C42BD6 AS DateTime), N'test@bluecoat.com', 0, NULL, NULL, NULL, 1)
INSERT [dbo].[users] ([Id], [Username], [Firstname], [Surname], [Firm], [Password], [RegDate], [Email], [isAdmin], [lastlogin], [iplog], [modifiedDate], [deleted]) VALUES (7, N'test', N'test', N'test', N'test', N'f865b53623b121fd34ee5426c792e5c33af8c227', CAST(0x0000A2F000C48B71 AS DateTime), N'test@bluecoat.com', 0, NULL, NULL, NULL, 1)
INSERT [dbo].[users] ([Id], [Username], [Firstname], [Surname], [Firm], [Password], [RegDate], [Email], [isAdmin], [lastlogin], [iplog], [modifiedDate], [deleted]) VALUES (8, N'fffffffff', N'test', N'test', N'test', N'2d223b9e963c0d60734478b40e5d645b768cbbd9', CAST(0x0000A2F000C4AD04 AS DateTime), N'test@bluecoat.com', 0, NULL, NULL, NULL, 1)
INSERT [dbo].[users] ([Id], [Username], [Firstname], [Surname], [Firm], [Password], [RegDate], [Email], [isAdmin], [lastlogin], [iplog], [modifiedDate], [deleted]) VALUES (9, N'admin', N'test', N'test', N'test', N'f865b53623b121fd34ee5426c792e5c33af8c227', CAST(0x0000A2F000C6AE06 AS DateTime), N'test@admin.com', 1, CAST(0x0000A2F100BD1C5E AS DateTime), NULL, NULL, 1)
INSERT [dbo].[users] ([Id], [Username], [Firstname], [Surname], [Firm], [Password], [RegDate], [Email], [isAdmin], [lastlogin], [iplog], [modifiedDate], [deleted]) VALUES (10, N'admin', N'test', N'test', N'test', N'efacc4001e857f7eba4ae781c2932dedf843865e', CAST(0x0000A2F000C6F340 AS DateTime), N'test@admin.com', 1, CAST(0x0000A2F100DB34A0 AS DateTime), N'10.0.73.249', NULL, 1)
INSERT [dbo].[users] ([Id], [Username], [Firstname], [Surname], [Firm], [Password], [RegDate], [Email], [isAdmin], [lastlogin], [iplog], [modifiedDate], [deleted]) VALUES (11, N'try', N'test', N'test', N'test', N'efacc4001e857f7eba4ae781c2932dedf843865e', CAST(0x0000A2F100DC42EF AS DateTime), N'admin@test.com', 0, CAST(0x0000A31B010459F2 AS DateTime), N'192.168.56.1', NULL, 0)
INSERT [dbo].[users] ([Id], [Username], [Firstname], [Surname], [Firm], [Password], [RegDate], [Email], [isAdmin], [lastlogin], [iplog], [modifiedDate], [deleted]) VALUES (13, N'b', N'b5', N'b55', N'b55', N'e9d71f5ee7c92d6dc9e92ffdad17b8bd49418f98', CAST(0x0000A30300FDE8AE AS DateTime), N'b55', 1, NULL, NULL, NULL, 1)
INSERT [dbo].[users] ([Id], [Username], [Firstname], [Surname], [Firm], [Password], [RegDate], [Email], [isAdmin], [lastlogin], [iplog], [modifiedDate], [deleted]) VALUES (14, N'Handsome', N'handsome2', N'handsome2', N'handsome2', N'11e1d0e16ee4d31e9880a2836d8c71cfd22599d4', CAST(0x0000A30400F8F1EF AS DateTime), N'handsome2', 1, NULL, NULL, NULL, 1)
INSERT [dbo].[users] ([Id], [Username], [Firstname], [Surname], [Firm], [Password], [RegDate], [Email], [isAdmin], [lastlogin], [iplog], [modifiedDate], [deleted]) VALUES (15, N'a', N'gs', N'fs', N'fsd', N'505be7d32701ca5445b14f294899e1c5adbf87fc', CAST(0x0000A3040106C4EF AS DateTime), N'fdsf@test.com', 1, NULL, NULL, NULL, 1)
INSERT [dbo].[users] ([Id], [Username], [Firstname], [Surname], [Firm], [Password], [RegDate], [Email], [isAdmin], [lastlogin], [iplog], [modifiedDate], [deleted]) VALUES (16, N'dfgfg', N'dgsgsd', N'dsggds', N'dsgds', N'9a912368e1db0519785c1ef7fb74b469a58676dc', CAST(0x0000A30401075C76 AS DateTime), N'test@test.com', 0, NULL, NULL, NULL, 1)
INSERT [dbo].[users] ([Id], [Username], [Firstname], [Surname], [Firm], [Password], [RegDate], [Email], [isAdmin], [lastlogin], [iplog], [modifiedDate], [deleted]) VALUES (17, N'gdfg', N'gdfg', N'gfdg', N'gfdg', N'dbce705929c7dc1924ea1173f37652bb00f96d6d', CAST(0x0000A304011EEE85 AS DateTime), N'test@test.com', 0, NULL, NULL, NULL, 1)
INSERT [dbo].[users] ([Id], [Username], [Firstname], [Surname], [Firm], [Password], [RegDate], [Email], [isAdmin], [lastlogin], [iplog], [modifiedDate], [deleted]) VALUES (21, N'Sad', N'lalal', N'lalala', N'lalala', N'b2e98ad6f6eb8508dd6a14cfa704bad7f05f6fb1', CAST(0x0000A30B01030094 AS DateTime), N'test@test.com', 0, NULL, NULL, NULL, 0)
INSERT [dbo].[users] ([Id], [Username], [Firstname], [Surname], [Firm], [Password], [RegDate], [Email], [isAdmin], [lastlogin], [iplog], [modifiedDate], [deleted]) VALUES (22, N'TJ', N'Tj', N'Tj', N'Tj', N'8e7bcdf9f280f6f0b9bf6cf3ae908b9d40c08469', CAST(0x0000A31801521A20 AS DateTime), N't_junmeng@hotmail.com', 1, CAST(0x0000A31D0132C999 AS DateTime), N'192.168.56.1', NULL, 0)
INSERT [dbo].[users] ([Id], [Username], [Firstname], [Surname], [Firm], [Password], [RegDate], [Email], [isAdmin], [lastlogin], [iplog], [modifiedDate], [deleted]) VALUES (23, N'BluecoatTest', N'Bluecoat', N'Test', N'Bluecoat', N'6b48bc2eeb4ee46e2265b7f7ca400c74e29f3461', CAST(0x0000A31D00EBD233 AS DateTime), N'support@bluecoatsoftware.com', 1, NULL, NULL, NULL, 0)
INSERT [dbo].[users] ([Id], [Username], [Firstname], [Surname], [Firm], [Password], [RegDate], [Email], [isAdmin], [lastlogin], [iplog], [modifiedDate], [deleted]) VALUES (24, N'jjjj', N'jjj', N'jj', N'jj', N'ec6451d0a70c871e09fe363ff86c4abae53e5273', CAST(0x0000A31D014E3ED6 AS DateTime), N'jj@dwqdwq.com', 1, NULL, NULL, NULL, 0)
SET IDENTITY_INSERT [dbo].[users] OFF
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_System_Categories_CategoriesName]    Script Date: 5/1/2014 8:07:55 AM ******/
CREATE NONCLUSTERED INDEX [IX_System_Categories_CategoriesName] ON [dbo].[categories]
(
	[categoriesName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [UQ__products__C2068389564FAA38]    Script Date: 5/1/2014 8:07:55 AM ******/
ALTER TABLE [dbo].[products] ADD UNIQUE NONCLUSTERED 
(
	[productCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_System_Products_Items]    Script Date: 5/1/2014 8:07:55 AM ******/
CREATE NONCLUSTERED INDEX [IX_System_Products_Items] ON [dbo].[products]
(
	[productCode] ASC,
	[description] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_System_User_Username]    Script Date: 5/1/2014 8:07:55 AM ******/
CREATE NONCLUSTERED INDEX [IX_System_User_Username] ON [dbo].[users]
(
	[Username] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[categories] ADD  CONSTRAINT [DF__categorie__date___25869641]  DEFAULT (getdate()) FOR [date_added]
GO
ALTER TABLE [dbo].[orders] ADD  CONSTRAINT [DF__orders__firstNam__70DDC3D8]  DEFAULT (NULL) FOR [firstName]
GO
ALTER TABLE [dbo].[orders] ADD  CONSTRAINT [DF__orders__lastName__71D1E811]  DEFAULT (NULL) FOR [lastName]
GO
ALTER TABLE [dbo].[orders] ADD  CONSTRAINT [DF__orders__payerEma__72C60C4A]  DEFAULT (NULL) FOR [payerEmail]
GO
ALTER TABLE [dbo].[orders] ADD  CONSTRAINT [DF__orders__paymentD__76969D2E]  DEFAULT (NULL) FOR [paymentDate]
GO
ALTER TABLE [dbo].[orders] ADD  CONSTRAINT [DF__orders__paymentS__778AC167]  DEFAULT (NULL) FOR [paymentStatus]
GO
ALTER TABLE [dbo].[orders] ADD  CONSTRAINT [DF__orders__paymentT__787EE5A0]  DEFAULT (NULL) FOR [paymentType]
GO
ALTER TABLE [dbo].[orders] ADD  CONSTRAINT [DF__orders__mcGross__797309D9]  DEFAULT (NULL) FOR [mcGross]
GO
ALTER TABLE [dbo].[orders] ADD  CONSTRAINT [DF__orders__mcCurren__7A672E12]  DEFAULT (NULL) FOR [mcCurrency]
GO
ALTER TABLE [dbo].[orders] ADD  CONSTRAINT [DF__orders__dateCrea__7B5B524B]  DEFAULT (NULL) FOR [dateCreated]
GO
ALTER TABLE [dbo].[products] ADD  DEFAULT (getdate()) FOR [addedDate]
GO
ALTER TABLE [dbo].[users] ADD  CONSTRAINT [DF__users__RegDate__108B795B]  DEFAULT (getdate()) FOR [RegDate]
GO
ALTER TABLE [dbo].[orders]  WITH CHECK ADD  CONSTRAINT [FK__orders__userID__34C8D9D1] FOREIGN KEY([userID])
REFERENCES [dbo].[users] ([Id])
GO
ALTER TABLE [dbo].[orders] CHECK CONSTRAINT [FK__orders__userID__34C8D9D1]
GO
ALTER TABLE [dbo].[orders]  WITH CHECK ADD  CONSTRAINT [FK_orders_promotion] FOREIGN KEY([codeID])
REFERENCES [dbo].[promotion] ([codeID])
GO
ALTER TABLE [dbo].[orders] CHECK CONSTRAINT [FK_orders_promotion]
GO
ALTER TABLE [dbo].[prodtocater]  WITH CHECK ADD  CONSTRAINT [fk_CID] FOREIGN KEY([categoriesID])
REFERENCES [dbo].[categories] ([categoriesID])
GO
ALTER TABLE [dbo].[prodtocater] CHECK CONSTRAINT [fk_CID]
GO
ALTER TABLE [dbo].[prodtocater]  WITH CHECK ADD  CONSTRAINT [fk_PID] FOREIGN KEY([productID])
REFERENCES [dbo].[products] ([productID])
GO
ALTER TABLE [dbo].[prodtocater] CHECK CONSTRAINT [fk_PID]
GO
ALTER TABLE [dbo].[products]  WITH CHECK ADD  CONSTRAINT [categoryID_fk01] FOREIGN KEY([categoriesID])
REFERENCES [dbo].[categories] ([categoriesID])
GO
ALTER TABLE [dbo].[products] CHECK CONSTRAINT [categoryID_fk01]
GO
USE [master]
GO
ALTER DATABASE [finplanweb] SET  READ_WRITE 
GO
