drop table wellness_account;
create table wellness_account(
	id varchar2(12) primary key,
	pass varchar2(12) not null,
	name varchar2(12) not null,
	rank char(1) not null,
	position varchar2(20),
	joindate date,
	outdate date);

insert into wellness_account values('master','master5580','마스터',1,'마스터계정','2020-01-01','9999-12-31');
insert into wellness_account values('a1234','1234','황영선',2,'사장','2020-01-01','9999-12-31');
insert into wellness_account values('b1234','1234','최소영',2,'원장','2020-01-01','9999-12-31');
insert into wellness_account values('c1234','1231','홍길동',3,'팀장','2020-01-01','2022-10-11');
insert into wellness_account values('d1234','1232','강감찬',3,'주임','2020-02-01','2022-10-21');
insert into wellness_account values('e1234','1233','유관순',3,'주임','2020-03-01','2022-10-31');
insert into wellness_account values('f1234','1234','장보고',3,'관리사','2020-04-01','2022-11-11');
--insert into wellness_account values('g1234','1234','김춘추',3,'관리사',1);

drop table wellness_work;
create table wellness_work(
	year number(4),
	month number(2),
	day number(2),
	id varchar2(12),
	team varchar2(30),
	enter timestamp,
	exit timestamp,
	work varchar2(3) not null,
	primary key(year,month,day,id));

	
drop table wellness_team;
create table wellness_team(
	team number(2) primary key,
	team_name varchar2(30) not null,
	enter_time varchar2(10) not null,
	exit_time varchar2(10) not null);
	
insert into wellness_team values('1','가','09:45','20:00');
insert into wellness_team values('2','나','10:15','20:30');
insert into wellness_team values('3','A','10:45','21:00');
insert into wellness_team values('4','B','11:15','21:30');
insert into wellness_team values('5','C','11:45','22:00');
	
commit;
