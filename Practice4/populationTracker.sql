create database if not exists population_tracker;
use population_tracker;

drop table if exists regions;
create table regions(
	RegionID int auto_increment,
    RegionName varchar(75),
    primary key(RegionID)
);

drop table if exists cities;
create table cities(
	CityID char(4),
    RegionID int,
    CityName varchar(75),
    primary key(CityID),
    constraint Region_key foreign key(RegionID)
    references Regions(RegionID)
);

drop table if exists population;
create table population(
	RecordDate date,
    CityID char(4),
    population int,
    JsonData Json,
    primary key(RecordDate,CityID),
    constraint city_key foreign key(CityID)
    references cities(CityID)
);
