USE [master]
GO
/****** Object:  Database [POLIZIA_Catalina]    Script Date: 5/14/2021 12:47:19 PM ******/
CREATE DATABASE [POLIZIA_Catalina]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'POLIZIA_Catalina', FILENAME = N'C:\Users\catal\POLIZIA_Catalina.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'POLIZIA_Catalina_log', FILENAME = N'C:\Users\catal\POLIZIA_Catalina_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
GO
ALTER DATABASE [POLIZIA_Catalina] SET COMPATIBILITY_LEVEL = 130
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [POLIZIA_Catalina].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [POLIZIA_Catalina] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [POLIZIA_Catalina] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [POLIZIA_Catalina] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [POLIZIA_Catalina] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [POLIZIA_Catalina] SET ARITHABORT OFF 
GO
ALTER DATABASE [POLIZIA_Catalina] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [POLIZIA_Catalina] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [POLIZIA_Catalina] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [POLIZIA_Catalina] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [POLIZIA_Catalina] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [POLIZIA_Catalina] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [POLIZIA_Catalina] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [POLIZIA_Catalina] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [POLIZIA_Catalina] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [POLIZIA_Catalina] SET  DISABLE_BROKER 
GO
ALTER DATABASE [POLIZIA_Catalina] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [POLIZIA_Catalina] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [POLIZIA_Catalina] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [POLIZIA_Catalina] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [POLIZIA_Catalina] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [POLIZIA_Catalina] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [POLIZIA_Catalina] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [POLIZIA_Catalina] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [POLIZIA_Catalina] SET  MULTI_USER 
GO
ALTER DATABASE [POLIZIA_Catalina] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [POLIZIA_Catalina] SET DB_CHAINING OFF 
GO
ALTER DATABASE [POLIZIA_Catalina] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [POLIZIA_Catalina] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [POLIZIA_Catalina] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [POLIZIA_Catalina] SET QUERY_STORE = OFF
GO
USE [POLIZIA_Catalina]
GO
ALTER DATABASE SCOPED CONFIGURATION SET LEGACY_CARDINALITY_ESTIMATION = OFF;
GO
ALTER DATABASE SCOPED CONFIGURATION SET MAXDOP = 0;
GO
ALTER DATABASE SCOPED CONFIGURATION SET PARAMETER_SNIFFING = ON;
GO
ALTER DATABASE SCOPED CONFIGURATION SET QUERY_OPTIMIZER_HOTFIXES = OFF;
GO
USE [POLIZIA_Catalina]
GO
/****** Object:  UserDefinedFunction [dbo].[CalcoloAnzianità]    Script Date: 5/14/2021 12:47:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[CalcoloAnzianità]
--FUNZIONE CALCOLO ANZIANITà PER CONTROLLARE GLI ANNI DI SERVIZIO
(@dataAssunzione DATETIME)
RETURNS INT
AS
  BEGIN
      DECLARE @anzianità INT
      DECLARE @d AS DATETIME 
 
      SET @d=GETDATE() 
 
      SELECT @anzianità = DATEDIFF(yy, @dataAssunzione, @d) - 
      --Se non ha compiuto gli anni nell'ultimo anno in corso sottrae 1 anno.
      ( CASE
            WHEN ( DATEPART(m,@dataAssunzione ) > DATEPART(m, @d) ) 
              OR ( DATEPART(m, @dataAssunzione ) = DATEPART(m, @d) AND DATEPART(d, @dataAssunzione) > DATEPART(d, @d) ) 
            THEN 1 
             
            ELSE 0 
        END
       ) 
 
      RETURN( @anzianità ) 
  END

GO
/****** Object:  UserDefinedFunction [dbo].[CalcoloEta]    Script Date: 5/14/2021 12:47:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[CalcoloEta]
--FUNZIONE CALCOLO ETA PER STABILIRE SE L'AGENTE è MAGGIORENNE
(@dataNascita DATETIME)
RETURNS INT
AS
  BEGIN
      DECLARE @eta INT
      DECLARE @d AS DATETIME 
 
      SET @d=GETDATE() 
 
      SELECT @eta = DATEDIFF(yy, @dataNascita, @d) - 
      --Se non ha compiuto gli anni nell'ultimo anno in corso sottrae 1 anno.
      ( CASE
            WHEN ( DATEPART(m,@dataNascita ) > DATEPART(m, @d) ) 
              OR ( DATEPART(m, @dataNascita ) = DATEPART(m, @d) AND DATEPART(d, @dataNascita) > DATEPART(d, @d) ) 
            THEN 1 
             
            ELSE 0 
        END
       ) 
 
      RETURN( @eta ) 
  END

GO
/****** Object:  Table [dbo].[Agenti]    Script Date: 5/14/2021 12:47:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Agenti](
	[IdAgente] [int] IDENTITY(1,1) NOT NULL,
	[Nome] [nvarchar](30) NOT NULL,
	[Cognome] [nvarchar](50) NOT NULL,
	[CodiceFiscale] [nvarchar](16) NOT NULL,
	[DataNascita] [date] NOT NULL,
	[AnniServizio] [int] NOT NULL,
	[IdArea] [int] NOT NULL,
 CONSTRAINT [PK_Agenti] PRIMARY KEY CLUSTERED 
(
	[IdAgente] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [IX_Agenti] UNIQUE NONCLUSTERED 
(
	[CodiceFiscale] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Aree]    Script Date: 5/14/2021 12:47:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Aree](
	[IdArea] [int] IDENTITY(1,1) NOT NULL,
	[IdAgente] [int] NOT NULL,
	[CodiceArea] [nchar](5) NOT NULL,
	[AltoRischio] [bit] NOT NULL,
 CONSTRAINT [PK_Aree] PRIMARY KEY CLUSTERED 
(
	[IdArea] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Aree]  WITH CHECK ADD  CONSTRAINT [FK_Aree_Agenti] FOREIGN KEY([IdArea])
REFERENCES [dbo].[Agenti] ([IdAgente])
GO
ALTER TABLE [dbo].[Aree] CHECK CONSTRAINT [FK_Aree_Agenti]
GO
/****** Object:  StoredProcedure [dbo].[EliminaAgente]    Script Date: 5/14/2021 12:47:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[EliminaAgente] 
	@nome nvarchar(30), 
	@cognome nvarchar(50),
	@codiceFiscale nvarchar(16),
	@dataNascita date,
	@anniServizio int
AS 
BEGIN
    DELETE [dbo].[Agenti]  
    WHERE CodiceFiscale = @codiceFiscale
END
GO
/****** Object:  StoredProcedure [dbo].[InserimentoAgente]    Script Date: 5/14/2021 12:47:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[InserimentoAgente]
	-- Add the parameters for the stored procedure here
	@nome nvarchar(30), 
	@cognome nvarchar(50),
	@codiceFiscale nvarchar(16),
	@dataNascita date,
	@anniServizio int
AS
BEGIN
	insert into Agenti values (@nome, @cognome, @codiceFiscale, @dataNascita, @anniServizio, @@IDENTITY);
END
GO
/****** Object:  StoredProcedure [dbo].[InserimentoAree]    Script Date: 5/14/2021 12:47:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[InserimentoAree]
	-- Add the parameters for the stored procedure here
	@codiceArea nchar(5), 
	@areaRischio bit
AS
BEGIN
	insert into Aree values (@@IDENTITY, @codiceArea, @areaRischio);
END
GO
USE [master]
GO
ALTER DATABASE [POLIZIA_Catalina] SET  READ_WRITE 
GO
