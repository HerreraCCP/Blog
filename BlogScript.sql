-- Criar database
IF NOT EXISTS(SELECT * FROM sys.databases WHERE name = 'Blog')
BEGIN
    CREATE DATABASE [Blog]
END
GO

USE [Blog]
GO

-- Create First Table
IF NOT EXISTS (SELECT * FROM sys.sysobjects WHERE NAME = 'User' AND xtype='U')
BEGIN
    CREATE TABLE [User] (
        [Id] INT NOT NULL IDENTITY(1,1)
        ,[Name] NVARCHAR(80) NOT NULL
        ,[Email] VARCHAR(200) NOT NULL
        ,[PasswordHash] VARCHAR(255) NOT NULL
        ,[Bio] TEXT NOT NULL
        ,[Image] VARCHAR(2000) NOT NULL
        ,[Slug] VARCHAR(80) NOT NULL

        CONSTRAINT [PK_User] PRIMARY KEY([Id]),
        CONSTRAINT [UQ_User_Email] UNIQUE ([Email]),
        CONSTRAINT [UQ_User_Slug] UNIQUE ([Slug])
    )

    CREATE NONCLUSTERED INDEX [IX_User_Email] ON [User]([Email])
    CREATE NONCLUSTERED INDEX [IX_User_Slug] ON [User]([Slug])
END
GO

-- Create Second Table
IF NOT EXISTS (SELECT * FROM sys.sysobjects WHERE NAME = 'Role' AND xtype='U')
BEGIN
  CREATE TABLE [Role] (
      [Id] INT NOT NULL IDENTITY(1,1),
      [Name] VARCHAR(80) NOT NULL,
      [Slug] VARCHAR(80) NOT NULL,

      CONSTRAINT [PK_Role] PRIMARY KEY ([Id]),
      CONSTRAINT [UQ_Role_Slug] UNIQUE ([Slug]),
  )
  CREATE NONCLUSTERED INDEX [IX_Role_Slug] ON [Role]([Slug])
END
GO

-- Create Second Table
IF NOT EXISTS (SELECT * FROM sys.sysobjects WHERE NAME = 'UserRole' AND xtype='U')
BEGIN
  CREATE TABLE [UserRole] (
      [UserId] INT NOT NULL IDENTITY(1,1),
      [RoleId] VARCHAR(80) NOT NULL

    CONSTRAINT [PK_UserRole] PRIMARY KEY ([UserId], [RoleId])
  )
END
GO

-- Create Third Table
IF NOT EXISTS (SELECT * FROM sys.sysobjects WHERE NAME = 'Category' AND xtype='U')
BEGIN
    CREATE TABLE [dbo].[Category](
        [Id] INT NOT NULL IDENTITY(1,1),
        [Name] [nvarchar](160) NOT NULL,
        [Slug] [nvarchar](1024) NOT NULL,
        
    CONSTRAINT [PK_Category] PRIMARY KEY([Id]),
    CONSTRAINT [UQ_Category_Slug] UNIQUE([Slug])

    )
    CREATE NONCLUSTERED INDEX [IX_Category_Slug] ON [Category]([Slug])
END

-- Create Fifth Table
IF NOT EXISTS (SELECT * FROM sys.sysobjects WHERE NAME = 'Tag' AND xtype='U')
BEGIN
    CREATE TABLE [Tag](
        [Id] INT NOT NULL IDENTITY(1,1),
        [Name] VARCHAR(80) NOT NULL,
        [Slug] VARCHAR(80) NOT NULL,

        CONSTRAINT [PK_Tag] PRIMARY KEY ([Id]),
        CONSTRAINT [UQ_Tag_Slug] UNIQUE ([Slug])
    )
    CREATE NONCLUSTERED INDEX [IX_Tag_Slug] ON [Tag]([Slug])
END

-- Create Sixfth Table
IF NOT EXISTS (SELECT * FROM sys.sysobjects WHERE NAME = 'PostTag' AND xtype='U')
BEGIN
    CREATE TABLE [PostTag](
        [PostId] INT NOT NULL,
        [TagId]  INT NOT NULL,

    CONSTRAINT PK_PostTag PRIMARY KEY([PostId], [TagId])
    )
END

-- Create Last Table
IF NOT EXISTS (SELECT * FROM sys.sysobjects WHERE NAME = 'Post' AND xtype='U')
BEGIN
  CREATE TABLE [Post] (
      [Id] INT NOT NULL IDENTITY(1,1),
      [CategoryId] INT NOT NULL,
      [AuthorId] INT NOT NULL,
      [Title] VARCHAR(160) NOT NULL,
      [Summary] VARCHAR(255) NOT NULL,
      [Body] TEXT NOT NULL,
      [Slug] VARCHAR(80) NOT NULL,
      [CreateDate] SMALLDATETIME NOT NULL DEFAULT(GETDATE()),
      [LastUpdateDate] SMALLDATETIME NOT NULL DEFAULT(GETDATE()),

    CONSTRAINT [PK_Post] PRIMARY KEY ([Id]),
    CONSTRAINT [FK_Post_Category] FOREIGN KEY([CategoryId]) REFERENCES [Category]([Id]),
    CONSTRAINT [FK_Post_Author] FOREIGN KEY([AuthorId]) REFERENCES [User]([Id]),
    CONSTRAINT [UQ_Post_Slug] UNIQUE([Slug])
  )
  CREATE NONCLUSTERED INDEX [IX_Post_Slug] ON [Post]([Slug])
END
GO

--Insert Data

INSERT INTO [User]
VALUES ('Rodrigo Herrera', 'herrera.ccp@gmail.com', 'Hash', 'Microsoft MVP', 'https://', 'rodrigo-herrera')

INSERT INTO [Role]
VALUES ('Autor', 'author')

INSERT INTO [Tag]
VALUES ('ASP .NET', 'Backend')

INSERT INTO [UserRole]
VALUES(1, 1)


SELECT U.*, R.*
FROM [User] AS U (nolock)
    LEFT JOIN [UserRole] AS UR (nolock) ON UR.UserId = U.Id
    LEFT JOIN [Role] AS R (nolock) ON UR.RoleId = R.Id
    