***계정***

id	    /	varchar2(12)	/	primary key
pass	/	varchar2(12)	/	not null
name	/	varchar2(12)	/	not null
rank	/	number(1)			/	not null
position/	varchar2(20)
			=> 1: 마스터 계정 / 2: 관리자 / 3: 직원
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

insert into wellness_account values('manager','master5580','마스터',1,'마스터계정');

commit;

-----------------------------------------------------------------------------------------

***출결관리***

year	/	number(4)		/	primary key
month	/	number(2)		/	primary key
day		/	number(2)		/	primary key
week	/	number(1)			/	primary key
			=> 1:일 / 2:월 / 3:화 / 4:수 / 5:목 / 6:금 / 7:토
id		/	varchar2(12)	/	primary key
enter	/	timestamp
exit	/	timestamp
work	/	varchar2(3)		/	not null
			=> 0: 근무 / 0.5: 반차 / 1: 휴무

=> sql
drop table wellness_work;
create table wellness_work(
	year number(4),
	month number(2),
	day number(2),
	week number(1),
	id varchar2(12),
	enter timestamp,
	exit timestamp,
	work varchar2(3) not null,
	primary key(year,month,day,week,id));

commit;

-----------------------------------------------------------------------------------------
