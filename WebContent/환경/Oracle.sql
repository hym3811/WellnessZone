drop table wellness_account;
create table wellness_account(
	id varchar2(12) primary key,
	pass varchar2(12) not null,
	name varchar2(12) not null,
	rank char(1) not null,
	position varchar2(20));

insert into wellness_account values('manager','master5580','마스터',1,'마스터계정');
insert into wellness_account values('a1234','1234','홍길동',3,'관리사');
insert into wellness_account values('b1234','1234','강감찬',2,'매니저');

drop table wellness_work;
create table wellness_work(
	year varchar2(4),
	month varchar2(2),
	day varchar2(2),
	week number(1),
	id varchar2(12),
	enter timestamp,
	exit timestamp,
	work varchar2(3) not null,
	primary key(year,month,day,week,id));

commit;
