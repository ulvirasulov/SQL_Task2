create database BlogDB

use BlogDB

create table Categories(
Id int primary key identity,
Name nvarchar(50) not null unique
)

create table Tags(
Id int primary key identity,
Name nvarchar(50) not null unique
)

create table Users(
Id int primary key identity,
UserName nvarchar(50) not null unique,
FullName nvarchar(50) not null,
Age int check(Age>0 and Age<150)
)

create table Blogs(
Id int primary key identity,
Title nvarchar(50) not null,
Description nvarchar(100) not null,
UsersId int foreign key references Users(Id),
CategoriesId int foreign key references Categories(Id)
)

create table BlogTags(
Id int primary key identity,
BlogId int foreign key references Blogs(Id),
TagId int foreign key references Tags(Id)
)

create table Comments(
Id int primary key identity,
Content nvarchar(250) not null,
UsersId int foreign key references Users(Id),
BlogsId int foreign key references Blogs(Id)
)

create view BlogAndUser as
select B.Title as BlogTitle, U.UserName as UserName, U.FullName as FullName
from Blogs as B join Users as U on B.UsersId=U.Id

create view BlogAndCategories as
select B.Title as BlogTitle, C.Name as CategoryName 
from Blogs as B join Categories as C on B.CategoriesId=C.Id

create procedure UserComments @UserId int as
select C.Content as CommmentContent, C.Id as CommentId, B.Title as BlogTitle
from Comments as C join Blogs as B on C.BlogsId=B.Id where C.UsersId=@UserId

create procedure UserBlogs @UserId int as
select B.Title as BlogTitle, B.Description as BlogDescription, B.Id as BlogId
from Blogs as B where B.UsersId=@UserId

create function BlogSayiByCategory (@CategoryId int) returns int
as begin
return(
select COUNT(*) from Blogs where CategoriesId=@CategoryId
)
end

create function UserBlogsFunc (@UserId int) returns table
as
return(
select Title,Description,CategoriesId from Blogs where UsersId=@UserId
)

select * from BlogAndCategories
select * from BlogAndUser
select * from Categories
select * from Blogs
select * from Tags
select * from Users
select * from Comments
select * from BlogTags