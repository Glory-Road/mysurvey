drop table if exists category;
drop table if exists function_category;
drop table if exists functions;
drop table if exists modules;
drop table if exists papers;
drop table if exists paper_questions;
drop table if exists paper_answers;
drop table if exists question_type;
drop table if exists questions;
drop table if exists role_function;
drop table if exists roles;

drop table if exists user_role;
drop table if exists users;
drop table if exists groups;
drop table if exists survey;


create table survey(
	survey_id bigint generated by default as identity,
	status varchar(64), --调查状态：  D - 草稿(可发布), P - 已发布, F - 已完成
	update_timestamp timestamp, --更新时间
	user_id varchar(64) not null, -- 调查发起人
	paper_id bigint not null,   -- 一次调查只包含一个paper
	subject varchar(128),  -- 调查问卷的主题
	groups_id varchar(32) not null,  -- 如果有多个group，用逗号隔开
	sent_timestamp timestamp,  -- 调查发送时间
	deadline_timestamp timestamp, -- 本次调查的最后期限
	is_anonymous varchar(1), -- 是否是匿名调查: T - True, F - False
	description varchar(1280), -- 描述性文字，作为group的user收到的邮件内容
	receivers varchar, -- 调查对象名单，包括其完成状态，单个结构为  昵称^ID^0/1(是否作答)^作答时间|
	primary key (survey_id)	
);

-- survey和参与调查者(receiver)的一对多映射表， survey表中的receivers字段作废
create table survey_receivers(
	survey_id bigint not null,
	user_id varchar(64), -- 被调查者user id(intranet id)
	status varchar(1), -- 标识此人是否完成了此次调查 0： 未完成， 1： 已完成
	update_timestamp timestamp, -- 被调查者答题或修改时间
	nickname varchar(64),  -- 群组中的昵称
	primary key (survey_id,user_id)	
);

create table users (
	id varchar(64) not null unique,
	name varchar(32),
	password varchar(255) not null,
	register_date timestamp,
	comment varchar(128),
	resetToken varchar(255), -- temp token for forgetting & resetting  password 
	primary key (id)
);

create table category (
	id varchar(64) not null unique,
	pid varchar(64),
	name varchar(64) not null,
	created_date timestamp not null,
	trashed varchar(1) not null,
	comment varchar(128),
	primary key (id)
);

create table modules (
	module_id varchar(64) not null unique,
	pid varchar(64),
	name varchar(64) not null,
	description varchar(128),
	path varchar(128),
	primary key (module_id)
);

create table functions (
	function_id varchar(64) not null unique,
	module_id varchar(64),
	name varchar(64) not null,
	description varchar(128),
	path varchar(512),
	primary key (function_id)
);

create table roles (
	role_id varchar(64) not null unique,
	name varchar(64) not null,
	description varchar(128),
	primary key (role_id)
);

create table role_function (
	role_id varchar(64) not null,
	function_id varchar(64) not null,
	description varchar(128),
	primary key (role_id,function_id)
);

create table user_role (
	user_id varchar(64) not null,
	role_id varchar(64) not null,
	primary key (user_id,role_id)
);

create table function_category (
	function_id varchar(64),
	category_id varchar(64),
	primary key (function_id,category_id)
);

create table papers (
	paper_id bigint generated by default as identity,
	paper_name varchar(32) not null,
	creat_timestamp timestamp,
	user_id varchar(64), -- 创建者的id
	status varchar(64) not null, -- 调查问卷的状态： draft, publish, trashed,只有publish状态的才能使用。此status在category的系统参数节点下配置，此处保存的是category id.
	default_paper varchar(1), -- 是否是某类型问卷的默认paper: T = Ture, F = False 
	business_type varchar(64) not null, -- 问卷业务类型，可以在category table配置
	primary key (paper_id)	
);

-- 调查表
create table questions (
	question_id bigint generated by default as identity,
	question varchar(256) not null,
	user_id varchar(64), -- 创建者的id
	question_type varchar(64) not null, -- 问题种类：单选，多选，开放式问题等 ,不用在category table里面配置
	question_options varchar(512), -- 问题答案选项，用特殊字符^分隔， 如果是开放式问题， 此字段为空
	business_type varchar(64), -- 问题类别，可以在category table配置
	creat_timestamp timestamp,
	trashed varchar(1),
	primary key (question_id)
);

create table paper_questions (
	paper_id bigint not null,
	question_id bigint not null,
	position int not null, -- 问题在调查问卷中的位置
	primary key (paper_id, question_id)	
);

-- 系统表，存储问题类别：单选，多选，开放式问题
create table question_type (
	question_type varchar(1) not null,
	question_name varchar(16) not null,
	primary key(question_type, question_name)
);

create table paper_answers (
	survey_id bigint not null, -- 与survery table关联，表明是哪一次调查
	question_id bigint not null,
	answer varchar(256), -- 多选项的答案应该是用逗号隔开的所选答案的index
	answer_user_id varchar(64) not null,  -- 答题者
	primary key (survey_id,question_id,answer_user_id)
);

-- 用户组，给特定人群发调查问卷用的，类似于邮件组
create table groups (
	group_id bigint generated by default as identity,
	group_name varchar(32) not null,
	comment varchar(128),-- 用户组的标注
	content varchar,
	edit_date timestamp, 
	user_id varchar(64), -- 创建者，这个group是由谁创建的，就归谁用
	trashed varchar(1),
	primary key (group_id)	
);

-- 用户组与user的映射表，一对多
create table group_users (
	group_id bigint not null,
	user_id varchar(64) not null,
	nickname varchar(64),
	primary key (group_id,user_id)	
);




