USE Lab3_DBMS;
drop table Subscription;
drop table Subscriber;
drop table Library;


CREATE TABLE Library
(
    ID integer not null primary key,
    Address varchar(30) not null,
    Nr_Of_Books integer
);

CREATE TABLE Subscriber
(
    CNP integer primary key,
    Name varchar(30) not null,
    Age integer,
    Nr_Of_Rented_Books integer,
);

CREATE TABLE Subscription
(
    Library_ID integer not null,
    CNP_Sub integer not null,
    Price integer,
    foreign key (Library_ID) references Library(ID) on delete cascade on update cascade,
    foreign key (CNP_Sub) references Subscriber(CNP) on delete cascade on update cascade,
    constraint pk_subscription primary key (Library_ID, CNP_Sub)
);

INSERT INTO Library
Values(1, 'Sighetu Marmatiei, nr 25', 100)
DELETE FROM Library WHERE ID = 1