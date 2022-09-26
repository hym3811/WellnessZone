***계정***

id	    /	varchar2(12)	/	primary key
pass	/	varchar2(12)	/	not null
name	/	varchar2(12)	/	not null
rank	/	number(1)			/	not null
			=> 1: 마스터 계정 / 2: 관리자 / 3: 직원
position/	varchar2(20)
joindate/	date			/	not null
outdate	/	date

=> sql
drop table wellness_account;
create table wellness_account(
	id varchar2(12) primary key,
	pass varchar2(12) not null,
	name varchar2(12) not null,
	rank char(1) not null,
	position varchar2(20),
	out number(1));

insert into wellness_account values('master','master5580','마스터',1,'마스터계정');

commit;

-----------------------------------------------------------------------------------------

***출결관리***

year	/	number(4)		/	primary key
month	/	number(2)		/	primary key
day		/	number(2)		/	primary key
id		/	varchar2(12)	/	primary key
team	/	varchar2(30)
enter	/	varchar2(10)
exit	/	varchar2(10)
work	/	varchar2(3)		/	not null
			=> 0: 근무 / 0.5: 반차 / 1: 휴무
harf	/	number(1)
			=> 0: 오전반차 / 1: 오후반차

=> sql
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
	harf number(1),
	primary key(year,month,day,id));

commit;

-----------------------------------------------------------------------------------------

***근무조 리스트***

team		/	number(2)		/	primary key
team_name	/	varchar2(30)	/	not null
enter_time	/	varchar2(10)	/	not null
exit_time	/	varchar2(10)	/	not null

=> sql
drop table wellness_team;
create table wellness_team(
	team number(2) primary key,
	team_name varchar2(30) not null,
	enter_time varchar2(10) not null,
	exit_time varchar2(10) not null);