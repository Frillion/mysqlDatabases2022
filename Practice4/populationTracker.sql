drop database population_tracker;
create database if not exists population_tracker;
use population_tracker;

create table regions(
	RegionID int auto_increment,
    RegionName varchar(75),
    primary key(RegionID)
);

create table JsonFiles(
	JsonData json,
    RegionID int,
    constraint Json_Region_key foreign key(RegionID) 
    references Regions(RegionID)
);

create table cities(
	CityID char(4),
    RegionID int,
    CityName varchar(75),
    primary key(CityID),
    constraint Region_key foreign key(RegionID)
    references Regions(RegionID)
);

create table population(
	RecordDate date,
    CityID char(4),
    population int,
    primary key(RecordDate,CityID),
    constraint city_key foreign key(CityID)
    references cities(CityID)
);
