USE [master]
GO
/****** Object:  Database [School]    Script Date: 13-05-2019 15:39:01 ******/
CREATE DATABASE [School] ON  PRIMARY 
( NAME = N'School', FILENAME = N'c:\Program Files\Microsoft SQL Server\MSSQL10_50.SCHOOLDATABASE\MSSQL\DATA\School.mdf' , SIZE = 2304KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'School_log', FILENAME = N'c:\Program Files\Microsoft SQL Server\MSSQL10_50.SCHOOLDATABASE\MSSQL\DATA\School_log.LDF' , SIZE = 768KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [School] SET COMPATIBILITY_LEVEL = 100
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [School].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [School] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [School] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [School] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [School] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [School] SET ARITHABORT OFF 
GO
ALTER DATABASE [School] SET AUTO_CLOSE ON 
GO
ALTER DATABASE [School] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [School] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [School] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [School] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [School] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [School] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [School] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [School] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [School] SET  DISABLE_BROKER 
GO
ALTER DATABASE [School] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [School] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [School] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [School] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [School] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [School] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [School] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [School] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [School] SET  MULTI_USER 
GO
ALTER DATABASE [School] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [School] SET DB_CHAINING OFF 
GO
USE [School]
GO
/****** Object:  UserDefinedFunction [dbo].[calculate_due]    Script Date: 13-05-2019 15:39:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[calculate_due](@amount numeric(7,2),@last_date date,@type int)
returns int
as
begin 
	declare @current_date date = GETDATE()
	declare @current_day int = DAY(@current_date), @current_month int = MONTH(@current_date), @current_year int = YEAR(@current_date)
	declare @last_day int = DAY(@last_date), @last_month int = MONTH(@last_date), @last_year int = YEAR(@last_date)
	declare @datediff int = 0 
	if @type=0 set @datediff = DATEDIFF(DAY, @last_date,@current_date)
	else if @type=1 set @datediff = DATEDIFF(MONTH, @last_date,@current_date)
	else if @type=2 set @datediff = DATEDIFF(YEAR, @last_date,@current_date)
	else if @type=3 begin
		declare @due int = 0
		declare @month_due int = DATEDIFF(MONTH,@last_date,@current_date)
		if @month_due > 12 begin
			set @due = @due + (@amount* (@month_due/12))
		end
		if @last_month = 6 begin
			if @current_month > 9 begin
				set @due = @due + @amount
			end
			if @current_month < 6 begin
				set @due = @due + (@amount*2)
			end
		end
		else if @last_month = 10 begin
			if @current_month > 6 and @current_month < 10 begin
				set @due = @due + (@amount*2)
			end
			if @current_month >=0 and @current_month < 6 begin
				set @due = @due + @amount
			end
		end
		else if @last_month = 1 begin
			if @current_month >= 6 and @current_month < 10 begin
				set @due = @due + @amount
			end
			if @current_month >= 10 begin
				set @due = @due + (@amount*2)
			end
		end
		return @due
	end
	return @datediff * @amount
return 0
end
GO
/****** Object:  UserDefinedFunction [dbo].[fn_id]    Script Date: 13-05-2019 15:39:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[fn_id](@name varchar(30),@section varchar(30))
returns int
as
begin 
declare @id int
select @id = id from class where class =@name and section = @section 
return @id
end
GO
/****** Object:  UserDefinedFunction [dbo].[getid]    Script Date: 13-05-2019 15:39:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[getid](@name varchar(50))
returns int
as
begin
declare @id int
select @id= id from students where name = @name
return @id
end
GO
/****** Object:  Table [dbo].[archive]    Script Date: 13-05-2019 15:39:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[archive](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[date] [date] NULL,
	[data] [varchar](2000) NULL,
 CONSTRAINT [PK_archive] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[attendance]    Script Date: 13-05-2019 15:39:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[attendance](
	[id] [int] NOT NULL,
	[dates] [date] NULL,
	[attendance] [smallint] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[class]    Script Date: 13-05-2019 15:39:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[class](
	[class] [varchar](50) NULL,
	[section] [varchar](50) NULL,
	[id] [int] IDENTITY(1,1) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[designation]    Script Date: 13-05-2019 15:39:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[designation](
	[name] [varchar](100) NULL,
	[id] [int] IDENTITY(1,1) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[gender]    Script Date: 13-05-2019 15:39:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[gender](
	[id] [smallint] NOT NULL,
	[name] [varchar](7) NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[marks]    Script Date: 13-05-2019 15:39:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[marks](
	[id] [int] NULL,
	[sub] [int] NULL,
	[marks] [numeric](7, 2) NULL,
	[grade] [varchar](5) NULL,
	[Remark] [smallint] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[marksdate]    Script Date: 13-05-2019 15:39:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[marksdate](
	[id] [int] NOT NULL,
	[dates] [date] NULL,
	[datesid] [int] IDENTITY(1,1) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[datesid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PA]    Script Date: 13-05-2019 15:39:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PA](
	[id] [smallint] NOT NULL,
	[name] [varchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[recurnames]    Script Date: 13-05-2019 15:39:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[recurnames](
	[id] [smallint] IDENTITY(1,1) NOT NULL,
	[name] [varchar](150) NOT NULL,
 CONSTRAINT [PK_recurnames] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[remark]    Script Date: 13-05-2019 15:39:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[remark](
	[id] [smallint] IDENTITY(1,1) NOT NULL,
	[name] [varchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[services]    Script Date: 13-05-2019 15:39:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[services](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[name] [varchar](200) NOT NULL,
	[recur] [smallint] NOT NULL,
	[amount] [numeric](7, 2) NOT NULL,
 CONSTRAINT [PK_services] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[students]    Script Date: 13-05-2019 15:39:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[students](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[name] [varchar](50) NULL,
	[Fname] [varchar](50) NULL,
	[Mname] [varchar](50) NULL,
	[Rnumber] [int] NULL,
	[age] [smallint] NULL,
	[address] [varchar](100) NULL,
	[Phone] [varchar](20) NULL,
	[picture] [varchar](100) NULL,
	[email] [varchar](50) NULL,
	[dob] [date] NULL,
	[gender] [smallint] NOT NULL,
	[class] [int] NULL,
	[amount] [numeric](10, 3) NULL,
	[due] [numeric](10, 3) NULL,
	[leaves] [int] NULL,
 CONSTRAINT [PK_students] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[sub]    Script Date: 13-05-2019 15:39:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[sub](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[name] [varchar](40) NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[subscriptions]    Script Date: 13-05-2019 15:39:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[subscriptions](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[student_id] [int] NOT NULL,
	[service_id] [int] NOT NULL,
	[date] [date] NOT NULL,
 CONSTRAINT [PK_subscriptions] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Tattendance]    Script Date: 13-05-2019 15:39:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Tattendance](
	[dates] [date] NULL,
	[attendance] [smallint] NULL,
	[id] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[teacher]    Script Date: 13-05-2019 15:39:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[teacher](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[name] [varchar](50) NULL,
	[gender] [smallint] NULL,
	[age] [smallint] NULL,
	[dob] [date] NULL,
	[designation] [int] NULL,
	[qualification] [varchar](100) NULL,
	[address] [varchar](100) NULL,
	[phone] [varchar](20) NULL,
	[email] [varchar](50) NULL,
	[fee] [numeric](10, 2) NULL,
	[dates] [date] NULL,
	[pic] [varchar](100) NULL,
	[leaves] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[transactions]    Script Date: 13-05-2019 15:39:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[transactions](
	[id] [int] NOT NULL,
	[dates] [date] NULL,
	[months] [smallint] NULL,
	[years] [int] NULL,
	[amount] [numeric](7, 2) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Users]    Script Date: 13-05-2019 15:39:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Users](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[name] [varchar](20) NULL,
	[pass] [varchar](20) NULL,
	[picture] [varchar](500) NULL,
	[username] [varchar](20) NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [dbo].[get_dates]    Script Date: 13-05-2019 15:39:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[get_dates](@name varchar(50),@date smallint)  
returns table  
as  
return(select A.dates from attendance A   
       left join students S on A.id = S.id  
       where S.name = @name and month(A.dates)=@date and A.attendance = 2)
GO
/****** Object:  UserDefinedFunction [dbo].[get_datess]    Script Date: 13-05-2019 15:39:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[get_datess](@name varchar(50),@date smallint)    
returns table    
as    
return(select A.dates as [date] from Tattendance A     
       left join teacher S on A.id = S.id    
       where S.name = @name and month(A.dates)=@date and A.attendance = 2)
GO
/****** Object:  UserDefinedFunction [dbo].[show_atclass]    Script Date: 13-05-2019 15:39:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[show_atclass](@class varchar(50),@section varchar(50))
returns table
as
return(select S.name,S.picture as [pic],
              G.name as [gender],C.class as [class],
              C.section as [section],S.leaves From  students S 
       left join class C on C.id = S.class
       left join gender G on G.id = S.gender
       where C.class = @class and C.section = @section)
GO
/****** Object:  UserDefinedFunction [dbo].[show_atclassname]    Script Date: 13-05-2019 15:39:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[show_atclassname](@class varchar(50),@section varchar(50),@name varchar(50))
returns table
as
return(select S.name,S.picture as [pic],
              G.name as [gender],C.class as [class],
              C.section as [section],S.leaves as [leaves] From  students S 
       left join class C on C.id = S.class
       left join gender G on G.id = S.gender
       where C.class = @class and C.section = @section and S.name = @name)
GO
/****** Object:  UserDefinedFunction [dbo].[show_classname]    Script Date: 13-05-2019 15:39:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[show_classname](@name varchar(50)='%',@class varchar(50)='%',@section varchar(50)='%')  
returns table  
as  
return (select S.name as [Student Name],  
               C.class as [class],  
               C.section as [section],  
               P.name as [P/A],        
               S.leaves as [Total Leaves],  
               A.dates as [date]        
        from attendance A   
        left join students S on S.id = A.id  
        left join class C on C.id = s.class   
        left join PA P on P.id = A.attendance  
        where C.class LIKE @class and C.section LIKE @section  and S.name LIKE @name)
GO
/****** Object:  UserDefinedFunction [dbo].[show_classsection]    Script Date: 13-05-2019 15:39:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[show_classsection](@name varchar(50)='%',@class varchar(50)='%',@section varchar(50)='%',@date date)
returns table
as
return (select S.name as [Student Name],
               C.class as [class],
               C.section as [section],
               P.name as [P/A],      
               S.leaves as [Total Leaves] ,
               A.dates as [date]     
        from attendance A 
        left join students S on S.id = A.id
        left join class C on C.id = s.class 
        left join PA P on P.id = A.attendance
        where C.class LIKE @class and C.section LIKE @section and A.dates = @date and S.name LIKE @name)
GO
/****** Object:  UserDefinedFunction [dbo].[show_fee]    Script Date: 13-05-2019 15:39:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[show_fee](@name varchar(50))
returns table
as
return(select S.name,F.amount,F.months,F.years,F.dates,S.due from transactions F 
      left join students S on S.id = F.id where S.name LIKE @name + '%' and F.amount <> 0)
GO
/****** Object:  UserDefinedFunction [dbo].[show_fees]    Script Date: 13-05-2019 15:39:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[show_fees](@name varchar(50),@year int)
returns table
return (select F.months from fees F 
       left join students S on S.id = F.id
       where S.name = @name and F.years = @year)
GO
/****** Object:  UserDefinedFunction [dbo].[show_marks]    Script Date: 13-05-2019 15:39:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[show_marks](@name varchar(50) = '%',@sub varchar(50)='%',@date date)  
returns table  
return(select ST.name as [Student Name],  
       S.name as [Subject Name],  
       M.marks as [Marks],
       M.grade as [Grade],
       R.name as [Remark],
       C.class as [class],
       C.section as [section] from marks M  
      left join sub S on S.id = M.sub  
      left join marksdate Z on M.id = Z.datesid  
      left join students ST on ST.id = Z.id  
      left join class C on C.id = St.class
      left join remark R on M.remark = R.id
      where   
      ST.name like @name   
      and S.name like @sub   
      and Z.dates = CAST(MONTH(@date) as varchar)+'-1-'+CAST(YEAR(@date) as varchar))
GO
/****** Object:  UserDefinedFunction [dbo].[show_stuat]    Script Date: 13-05-2019 15:39:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[show_stuat](@class varchar(50),@section varchar(50),@date date)    
returns table    
as    
return(select S.name,P.name as [at],A.dates From attendance A     
       left join students S on S.id = A.id    
       left join class C on C.id = S.class
       left join PA P on P.id = A.attendance    
       where C.class = @class and C.section = @section and A.dates = @date)
GO
/****** Object:  UserDefinedFunction [dbo].[show_stud]    Script Date: 13-05-2019 15:39:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[show_stud]()  
returns table  
as  
return (select S.name as [Student Name],S.Fname as [Father's Name],S.Mname as [Mother's Name],S.Rnumber as [Register Number],S.[address] as [address],S.Phone as [Phone Number],S.email as [Email],S.dob as [Date Of Birth],G.name as [Gender],C.class as [Clas
s], S.age as [Age],S.due as [due],C.section as [Section]from students S left join gender G on S.gender = g.id left join class C on S.class = C.id)
GO
/****** Object:  UserDefinedFunction [dbo].[show_students]    Script Date: 13-05-2019 15:39:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[show_students](@name varchar(50))  
returns table    
as    
return (select S.name as [Student Name],  
S.Fname as [Father's Name],  
S.Mname as [Mother's Name],  
S.Rnumber as [Register Number],  
S.[address] as [address],  
S.Phone as [Phone Number],  
S.email as [Email],  
S.dob as [Date Of Birth],  
G.name as [Gender],  
C.class as [Class],  
C.section as [Section],  
S.picture as [pic],  
S.age as [age],  
S.amount as [amount],  
S.due as [due]  
from students S left join gender G on S.gender = g.id left join class C on S.class = C.id where S.name = @name)
GO
/****** Object:  UserDefinedFunction [dbo].[show_studing]    Script Date: 13-05-2019 15:39:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[show_studing](@name int)       
returns table        
as        
return (select S.name as [Student Name],      
S.Fname as [Father's Name],      
S.Mname as [Mother's Name],      
S.Rnumber as [Register Number],      
S.[address] as [address],      
S.Phone as [Phone Number],      
S.email as [Email],      
S.dob as [Date Of Birth],   
S.picture as[pic],     
G.name as [Gender],      
C.class as [Class],      
C.section as [Section]
from students S       
left join gender G on S.gender = g.id      
left join class C on S.class = C.id    
where S.id = @name )
GO
/****** Object:  UserDefinedFunction [dbo].[show_studs]    Script Date: 13-05-2019 15:39:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[show_studs](@name varchar(50))    
returns table    
as    
return (select S.name as [Student Name],S.Fname as [Father's Name],S.Mname as [Mother's Name],S.Rnumber as [Register Number],S.age as [Age],S.[address] as [address],S.Phone as [Phone Number],S.email as [Email],S.dob as [Date Of Birth],G.name as [Gender],C.class as [Clas
  
s],C.section as [Section]from students S left join gender G on S.gender = g.id left join class C on S.class = C.id where S.name LIKE @name+'%')
GO
/****** Object:  UserDefinedFunction [dbo].[show_Tattendance]    Script Date: 13-05-2019 15:39:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[show_Tattendance](@date date)
returns table
as 
return(select T.name as [Staff Name],
      D.name as [Designation],
      P.name as [P/A],
      A.dates as [Date]
      From Tattendance A 
      left join teacher T on t.id = A.id
      left join PA P on P.id = A.attendance
      left join designation D on D.id = T.designation
      where A.dates = @date)
GO
/****** Object:  UserDefinedFunction [dbo].[show_Tattendancenamedate]    Script Date: 13-05-2019 15:39:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[show_Tattendancenamedate](@name varchar(50),@date date)
returns table
as 
return(select T.name as [Staff Name],
      D.name as [Designation],
      P.name as [P/A],
      A.dates as [Date]
      From Tattendance A 
      left join teacher T on t.id = A.id
      left join PA P on P.id = A.attendance
      left join designation D on D.id = T.designation
      where A.dates = @date and T.name = @name)
GO
/****** Object:  UserDefinedFunction [dbo].[show_Tattendances]    Script Date: 13-05-2019 15:39:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[show_Tattendances](@name varchar(50))
returns table
as 
return(select T.name as [Staff Name],
      D.name as [Designation],
      P.name as [P/A],
      A.dates as [Date]
      From Tattendance A 
      left join teacher T on t.id = A.id
      left join PA P on P.id = A.attendance
      left join designation D on D.id = T.designation
      where T.name = @name)
GO
/****** Object:  UserDefinedFunction [dbo].[teacher_show]    Script Date: 13-05-2019 15:39:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[teacher_show](@name varchar(50))
returns table
as
return(select T.name as [Staff Name],
              G.name as [Gender],
              T.age as [age],
              T.dob as [Birth Date],
              D.name as [Designation],
              T.qualification as [Qualification],
              T.address as [Address],
              T.phone as [Phone Number],
              T.email as [Email ID],
              T.fee as [Monthly Pay],
              T.dates as [Date Of Joining]
              from teacher T 
      left join gender G on G.id = T.gender
      left join designation D on D.id=T.designation
      where T.name like @name+'%')
GO
/****** Object:  UserDefinedFunction [dbo].[teacher_shows]    Script Date: 13-05-2019 15:39:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[teacher_shows](@name varchar(50))  
returns table  
as  
return(select T.name as [Staff Name],  
              G.name as [Gender],  
              T.age as [age],  
              T.dob as [Birth Date],  
              D.name as [Designation],  
              T.qualification as [Qualification],  
              T.address as [Address],  
              T.phone as [Phone Number],  
              T.email as [Email ID],  
              T.fee as [Monthly Pay],  
              T.dates as [Date Of Joining]  ,
              T.pic as [Picture],
              T.leaves as [leave]
              from teacher T   
      left join gender G on G.id = T.gender  
      left join designation D on D.id=T.designation  
      where T.name = @name)
GO
SET IDENTITY_INSERT [dbo].[class] ON 

INSERT [dbo].[class] ([class], [section], [id]) VALUES (N'Play School', N'Undivided', 2)
INSERT [dbo].[class] ([class], [section], [id]) VALUES (N'Tuition', N'Undivided', 3)
INSERT [dbo].[class] ([class], [section], [id]) VALUES (N'LKG', N'Undivided', 4)
INSERT [dbo].[class] ([class], [section], [id]) VALUES (N'play group', N'A', 5)
INSERT [dbo].[class] ([class], [section], [id]) VALUES (N'Play School', N'A', 6)
SET IDENTITY_INSERT [dbo].[class] OFF
SET IDENTITY_INSERT [dbo].[designation] ON 

INSERT [dbo].[designation] ([name], [id]) VALUES (N'Account Manager', 1)
INSERT [dbo].[designation] ([name], [id]) VALUES (N'Day Care Teacher', 2)
INSERT [dbo].[designation] ([name], [id]) VALUES (N'Day Care Helper', 3)
SET IDENTITY_INSERT [dbo].[designation] OFF
INSERT [dbo].[gender] ([id], [name]) VALUES (1, N'male')
INSERT [dbo].[gender] ([id], [name]) VALUES (2, N'female')
INSERT [dbo].[gender] ([id], [name]) VALUES (3, N'others')
INSERT [dbo].[PA] ([id], [name]) VALUES (1, N'present')
INSERT [dbo].[PA] ([id], [name]) VALUES (2, N'absent')
SET IDENTITY_INSERT [dbo].[recurnames] ON 

INSERT [dbo].[recurnames] ([id], [name]) VALUES (1, N'Daily')
INSERT [dbo].[recurnames] ([id], [name]) VALUES (2, N'Monthly')
INSERT [dbo].[recurnames] ([id], [name]) VALUES (3, N'Yearly')
INSERT [dbo].[recurnames] ([id], [name]) VALUES (4, N'Term')
INSERT [dbo].[recurnames] ([id], [name]) VALUES (5, N'One Time')
SET IDENTITY_INSERT [dbo].[recurnames] OFF
SET IDENTITY_INSERT [dbo].[remark] ON 

INSERT [dbo].[remark] ([id], [name]) VALUES (1, N'Outstanding')
INSERT [dbo].[remark] ([id], [name]) VALUES (2, N'Good')
INSERT [dbo].[remark] ([id], [name]) VALUES (3, N'Above Average')
INSERT [dbo].[remark] ([id], [name]) VALUES (4, N'Average')
INSERT [dbo].[remark] ([id], [name]) VALUES (5, N'Below Average')
INSERT [dbo].[remark] ([id], [name]) VALUES (6, N'Just Pass')
INSERT [dbo].[remark] ([id], [name]) VALUES (7, N'Fail')
INSERT [dbo].[remark] ([id], [name]) VALUES (8, N'UK')
SET IDENTITY_INSERT [dbo].[remark] OFF
SET IDENTITY_INSERT [dbo].[services] ON 

INSERT [dbo].[services] ([id], [name], [recur], [amount]) VALUES (14, N'Term wise', 4, CAST(12000.00 AS Numeric(7, 2)))
SET IDENTITY_INSERT [dbo].[services] OFF
SET IDENTITY_INSERT [dbo].[sub] ON 

INSERT [dbo].[sub] ([id], [name]) VALUES (12787, N'English')
INSERT [dbo].[sub] ([id], [name]) VALUES (12788, N'Math')
INSERT [dbo].[sub] ([id], [name]) VALUES (12789, N'Physics')
INSERT [dbo].[sub] ([id], [name]) VALUES (12790, N'Science')
INSERT [dbo].[sub] ([id], [name]) VALUES (12791, N'Chemistry')
INSERT [dbo].[sub] ([id], [name]) VALUES (12792, N'Tamil')
SET IDENTITY_INSERT [dbo].[sub] OFF
SET IDENTITY_INSERT [dbo].[Users] ON 

INSERT [dbo].[Users] ([id], [name], [pass], [picture], [username]) VALUES (1, N'admin', N'admin123', N'', N'admin')
SET IDENTITY_INSERT [dbo].[Users] OFF
/****** Object:  Index [Ix_fees]    Script Date: 13-05-2019 15:39:01 ******/
CREATE NONCLUSTERED INDEX [Ix_fees] ON [dbo].[transactions]
(
	[id] ASC,
	[years] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[attendance]  WITH CHECK ADD  CONSTRAINT [FK_att] FOREIGN KEY([id])
REFERENCES [dbo].[students] ([id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[attendance] CHECK CONSTRAINT [FK_att]
GO
ALTER TABLE [dbo].[attendance]  WITH CHECK ADD  CONSTRAINT [FK_id] FOREIGN KEY([attendance])
REFERENCES [dbo].[PA] ([id])
GO
ALTER TABLE [dbo].[attendance] CHECK CONSTRAINT [FK_id]
GO
ALTER TABLE [dbo].[marks]  WITH CHECK ADD  CONSTRAINT [FK_marks] FOREIGN KEY([id])
REFERENCES [dbo].[marksdate] ([datesid])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[marks] CHECK CONSTRAINT [FK_marks]
GO
ALTER TABLE [dbo].[marks]  WITH CHECK ADD  CONSTRAINT [FK_remark] FOREIGN KEY([Remark])
REFERENCES [dbo].[remark] ([id])
GO
ALTER TABLE [dbo].[marks] CHECK CONSTRAINT [FK_remark]
GO
ALTER TABLE [dbo].[marks]  WITH CHECK ADD  CONSTRAINT [FK_sub] FOREIGN KEY([sub])
REFERENCES [dbo].[sub] ([id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[marks] CHECK CONSTRAINT [FK_sub]
GO
ALTER TABLE [dbo].[marksdate]  WITH CHECK ADD  CONSTRAINT [FK_date] FOREIGN KEY([id])
REFERENCES [dbo].[students] ([id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[marksdate] CHECK CONSTRAINT [FK_date]
GO
ALTER TABLE [dbo].[services]  WITH CHECK ADD  CONSTRAINT [FK_services_recurnames] FOREIGN KEY([recur])
REFERENCES [dbo].[recurnames] ([id])
GO
ALTER TABLE [dbo].[services] CHECK CONSTRAINT [FK_services_recurnames]
GO
ALTER TABLE [dbo].[students]  WITH CHECK ADD  CONSTRAINT [gender_constraint] FOREIGN KEY([gender])
REFERENCES [dbo].[gender] ([id])
GO
ALTER TABLE [dbo].[students] CHECK CONSTRAINT [gender_constraint]
GO
ALTER TABLE [dbo].[subscriptions]  WITH CHECK ADD  CONSTRAINT [FK_subscriptions_services] FOREIGN KEY([service_id])
REFERENCES [dbo].[services] ([id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[subscriptions] CHECK CONSTRAINT [FK_subscriptions_services]
GO
ALTER TABLE [dbo].[subscriptions]  WITH CHECK ADD  CONSTRAINT [FK_subscriptions_students] FOREIGN KEY([student_id])
REFERENCES [dbo].[students] ([id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[subscriptions] CHECK CONSTRAINT [FK_subscriptions_students]
GO
ALTER TABLE [dbo].[Tattendance]  WITH CHECK ADD  CONSTRAINT [FK_con] FOREIGN KEY([attendance])
REFERENCES [dbo].[PA] ([id])
GO
ALTER TABLE [dbo].[Tattendance] CHECK CONSTRAINT [FK_con]
GO
ALTER TABLE [dbo].[Tattendance]  WITH CHECK ADD  CONSTRAINT [FK_Tid] FOREIGN KEY([id])
REFERENCES [dbo].[teacher] ([id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Tattendance] CHECK CONSTRAINT [FK_Tid]
GO
ALTER TABLE [dbo].[teacher]  WITH CHECK ADD  CONSTRAINT [FK_desig] FOREIGN KEY([designation])
REFERENCES [dbo].[designation] ([id])
GO
ALTER TABLE [dbo].[teacher] CHECK CONSTRAINT [FK_desig]
GO
ALTER TABLE [dbo].[transactions]  WITH CHECK ADD  CONSTRAINT [Fk_fees] FOREIGN KEY([id])
REFERENCES [dbo].[students] ([id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[transactions] CHECK CONSTRAINT [Fk_fees]
GO
/****** Object:  StoredProcedure [dbo].[delete_marks]    Script Date: 13-05-2019 15:39:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[delete_marks]
@name varchar(50),
@sub varchar(50),
@date date
as
begin
declare @datesid int,@subid int
select @datesid = M.id,@subid = M.sub from marks M  
      left join sub S on S.id = M.sub  
      left join marksdate Z on M.id = Z.datesid  
      left join students ST on ST.id = Z.id  
      where   
      ST.name like @name   
      and S.name like @sub   
      and Z.dates = CAST(MONTH(@date) as varchar)+'-1-'+CAST(YEAR(@date) as varchar)
delete from marks where id = @datesid and sub = @subid
declare @counts int
select @counts = COUNT(*) from marks where id = @datesid
print @counts
if @counts = 0 
delete from marksdate where datesid = @datesid
end
GO
/****** Object:  StoredProcedure [dbo].[insert_at]    Script Date: 13-05-2019 15:39:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[insert_at]
@name varchar(50),
@date date,
@at smallint
as
begin
begin tran
declare @id int
select @id = id from students where name = @name
insert into attendance values(@id,@date,@at) 
commit
end
GO
/****** Object:  StoredProcedure [dbo].[Insert_class]    Script Date: 13-05-2019 15:39:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[Insert_class]            
@gender smallint,@name varchar(50),@Fname varchar(50),@Mname varchar(50),            
@Rnum int,@add varchar(100),@phone varchar(20),            
@pic varchar(100),@email varchar(50),@date date,            
@class varchar(30),@section varchar(30)           
as            
begin            
declare @counts smallint=0;            
select @counts=COUNT(*) from class where class = @class and section = @section            
begin tran            
if @counts = 0             
begin            
insert into class(class,section) values(@class,@section)            
Insert into students(due,gender,name,Fname,Mname,Rnumber,[address],Phone,picture,email,dob,class,age)             
values(0,@gender,@name,@Fname,@Mname,@Rnum,@add,@phone,@pic,@email,@date,dbo.fn_id(@class,@section),DATEDIFF(YEAR,@date,GETDATE()))            
end            
else            
begin            
Insert into students(due,gender,name,Fname,Mname,Rnumber,[address],Phone,picture,email,dob,class,age)             
values(0,@gender,@name,@Fname,@Mname,@Rnum,@add,@phone,@pic,@email,@date,dbo.fn_id(@class,@section),DATEDIFF(YEAR,@date,GETDATE()))            
end            
commit            
end
GO
/****** Object:  StoredProcedure [dbo].[insert_marks]    Script Date: 13-05-2019 15:39:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[insert_marks]  
@date as date,  
@marks as numeric(7,2),  
@sub varchar(50),  
@name varchar(50)  
as  
begin  
 begin try  
  begin tran  
  set @date = CAST(MONTH(@date) as varchar) + '-1-'+CAST(YEAR(@date) as varchar)
  declare @remark smallint,@grade varchar(10)
  if @marks < 40 and @marks is not null
	select @remark=7,@grade='F'
   else if @marks < 50
	select @remark=6,@grade='E'
   else if @marks < 60
	select @remark=5,@grade='D'
   else if @marks < 70
	select @remark=4,@grade='C'
   else if @marks < 80
	select @remark=3,@grade='B'
   else if @marks < 90
	select @remark=2,@grade='A'
   else if @marks <= 100
	select @remark=1,@grade='O'
   else
	select @remark=8,@grade='NK'
  declare @subid int,@dateid int,@studid int  
  select @subid = id from sub where name = @sub  
  select @studid = id from students where name= @name  
  select  @dateid=datesid from marksdate where id = @studid and dates = @date  
   if @subid is null   
   insert into sub(name) values(@sub)  
   if @dateid  is null   
   insert into marksdate(id,dates) values(@studid,@date)  
   select @dateid = datesid from marksdate where id = @studid and dates = @date  
   select @subid = id from sub where name = @sub   
   insert into marks(id,sub,marks,grade,remark) values(@dateid,@subid,@marks,@grade,@remark)  
   commit tran  
  end try  
  begin catch   
  rollback  
  print 'rolled back'  
  select ERROR_MESSAGE() as [error]  
  end catch  
end
GO
/****** Object:  StoredProcedure [dbo].[insert_studing]    Script Date: 13-05-2019 15:39:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[insert_studing]        
@id int,        
@name varchar(50),        
@gender smallint,        
@add varchar(100),        
@phone varchar(20),        
@class varchar(50),        
@section varchar(50),        
@email varchar(50),        
@pic varchar(100)        
as        
begin         
declare @classid int      
select @classid = id from class where class = @class and section = @section        
if @classid is null         
insert into class values(@class,@section)           
  begin tran        
  select @classid = id from class where class = @class and section = @section           
  update students set name = @name,[address] = @add,Phone=@phone,email = @email,        
  picture = @pic,class = @classid,gender = @gender where id = @id       
  commit tran         
end
GO
/****** Object:  StoredProcedure [dbo].[Insert_Sub]    Script Date: 13-05-2019 15:39:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[Insert_Sub]         
@stu_id int, @serv_id int, @term int, @amount numeric(7,2)
as            
begin            
declare @date date = GETDATE()          
begin tran
	if @term != -1 begin
		if @term = 1 set @date = cast(YEAR(@date) as varchar)+'-06-'+cast(DAY(@date) as varchar)
		else if @term = 2 set @date = cast(YEAR(@date)as varchar)+'-10-'+cast(DAY(@date)as varchar)
		else if @term = 3 set @date = cast(YEAR(@date)as varchar)+'-01-'+cast(DAY(@date)as varchar)
	end
	insert into subscriptions(student_id,service_id,date) values(@stu_id,@serv_id,@date)
	update students set due = due +@amount where id = @stu_id
commit            
end
GO
/****** Object:  StoredProcedure [dbo].[insert_Tat]    Script Date: 13-05-2019 15:39:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[insert_Tat]  
@name varchar(50),  
@date date,  
@at smallint  
as  
begin  
begin tran  
declare @id int  
select @id = id from teacher where name = @name  
insert into Tattendance(id,dates,attendance) values(@id,@date,@at)   
commit  
end
GO
/****** Object:  StoredProcedure [dbo].[insert_teacher]    Script Date: 13-05-2019 15:39:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[insert_teacher]    
@name varchar(50),    
@gender smallint,    
@dob date,    
@desig varchar(50),    
@qua varchar(50),    
@add varchar(100),    
@phone varchar(20),    
@email varchar(50),    
@fee numeric(8,2),    
@join date ,  
@pic varchar(100)  
as    
begin    
begin tran    
declare @desigid int    
select @desigid = id from designation where name = @desig    
if @desigid is null     
begin    
insert into designation(name) values(@desig)    
end    
select @desigid = id from designation where name = @desig    
insert into teacher(name,gender,dob,designation,    
                    qualification,[address],phone    
                    ,email,fee,dates,pic,leaves,age)     
                    values(@name,@gender,@dob,@desigid,    
                           @qua,@add,@phone,@email,@fee,@join,@pic,0,DATEDIFF(YEAR,@dob,GETDATE()))    
commit    
end
GO
/****** Object:  StoredProcedure [dbo].[insert_transaction]    Script Date: 13-05-2019 15:39:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[insert_transaction]
@name varchar(50),
@date date,
@amount numeric(7,2)
as
begin
begin tran
declare @nameid int 
select @nameid = id from students where name = @name
insert into transactions(id,dates,months,years,amount) values(@nameid,@date,0,0,@amount)
update students set due = due-@amount where name= @name
commit
end
GO
/****** Object:  StoredProcedure [dbo].[update_fees]    Script Date: 13-05-2019 15:39:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[update_fees]  
as  
begin  
begin tran
	UPDATE stu SET stu.due = stu.due + dbo.calculate_due(serv.amount,sub.date,serv.recur) FROM subscriptions AS sub
		LEFT JOIN students AS stu ON sub.student_id = stu.id
		LEFT JOIN services AS serv ON sub.service_id = serv.id 
	UPDATE subscriptions SET date = GETDATE()
	UPDATE students SET age = DATEDIFF(YEAR,dob,GETDATE())
	UPDATE teacher SET age = DATEDIFF(YEAR,dob,GETDATE())
commit
end
GO
/****** Object:  StoredProcedure [dbo].[update_leaves]    Script Date: 13-05-2019 15:39:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[update_leaves]    
as    
begin    
update students set leaves = (select COUNT(*) from attendance where attendance.id = students.id and attendance.attendance = 2)  
update teacher set leaves = (select COUNT(*) from Tattendance where Tattendance.id = teacher.id and Tattendance.attendance = 2)      
end
GO
/****** Object:  StoredProcedure [dbo].[update_marks]    Script Date: 13-05-2019 15:39:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[update_marks]
@name varchar(50),
@sub varchar(50),
@date date,
@mark numeric(7,2)
as
begin 
begin tran
set @date = CAST(MONTH(@date) as varchar) + '-1-'+CAST(YEAR(@date) as varchar)
declare @dateid int,@subid int
select @dateid = datesid from marksdate M left join students S 
on S.id = M.id
where S.name = @name and M.dates = @date
select @subid = id from sub where name = @sub
declare @remark varchar(100),@grade varchar(10)
  if @mark < 40 
	select @remark=7,@grade='F'
   else if @mark < 50
	select @remark=6,@grade='E'
   else if @mark < 60
	select @remark=5,@grade='D'
   else if @mark < 70
	select @remark=4,@grade='C'
   else if @mark < 80
	select @remark=3,@grade='B'
   else if @mark < 90
	select @remark=2,@grade='A'
   else if @mark <= 100
	select @remark=1,@grade='O'
   else
	select @remark=7,@grade='NK'
update marks set  marks = @mark, Remark=@remark, grade=@grade where  id = @dateid and sub=@subid
commit
end
GO
USE [master]
GO
ALTER DATABASE [School] SET  READ_WRITE 
GO
