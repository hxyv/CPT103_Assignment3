set foreign_key_checks = 0;
drop table if exists games;
drop table if exists gifts;
drop table if exists streams;
drop table if exists records;
drop table if exists users;
drop table if exists payments;
drop table if exists rectime_watch;
drop table if exists streamers;
drop table if exists gift_bill;
drop table if exists stream_detail;
drop table if exists strtime_watch;
set foreign_key_checks = 1;


create table games
(
    game_id        int           not null
        primary key check (`game_id` > 999),
    developer_name varchar(255)  not null,
    age_rating     int default 3 not null CHECK (`age_rating` >= 3),
    game_release   datetime      not null,
    game_title     varchar(255)  not null unique
);

create table gifts
(
    gift_id    int not null
        primary key check (`gift_id` > 999),
    gift_price int not null check (`gift_price` > 0),
    gift_name  int not null unique
);

create table streams
(
    stream_id    int          not null
        primary key check (`stream_id` > 99),
    stream_title varchar(255) not null unique,
    start_time   datetime     not null,
    end_time     datetime     not null
);

create table records
(
    record_id    int          not null
        primary key check (`record_id` > 99),
    record_title varchar(255) not null,
    run_time     int          not null check (`run_time` > 0),
    stream_id    int          not null check (`stream_id` > 99),
    constraint record_title
        unique (record_title, stream_id),
    constraint records_streams_stream_id_fk
        foreign key (stream_id) references streams (stream_id)
            on update cascade on delete cascade
);

create table users
(
    user_id      int           not null
        primary key check (`user_id` > 999),
    user_email   varchar(255)  not null unique,
    id_no        char(18)      not null,
    user_name    varchar(60)   not null,
    birth_date   date          not null,
    nickname     varchar(30)   not null unique,
    user_password     varchar(30)   not null,
    join_date    date          not null,
    user_balance int default 0 null check (`user_balance` >= 0)
);

create table payments
(
    payment_id   int      not null
        primary key check (`payment_id` > 999),
    total_amount int      not null check (`total_amount` > 0),
    payment_date datetime not null,
    user_id      int      null check (`user_id` > 99),
    constraint payments_users_user_id_fk
        foreign key (user_id) references users (user_id)
            on update cascade on delete cascade  
);

create table rectime_watch
(
    rectime_id  int      not null
        primary key,
    watch_date  datetime not null,
    start_point time     not null,
    end_point   time     not null,
    record_id   int      not null check (`record_id` > 99),
    user_id     int      not null check (`user_id` > 999),
    constraint rectime_watch_records_record_id_fk
        foreign key (record_id) references records (record_id)
            on update cascade on delete cascade,
    constraint rectime_watch_users_user_id_fk
        foreign key (user_id) references users (user_id)
            on update cascade on delete cascade
);

create table streamers
(
    streamer_id     int           not null
        primary key,
    user_id         int           not null,
    streamer_income int default 0 not null,
    streamer_birth  date          not null,
    streamer_name   int           not null unique,
    constraint streamers_users_user_id_fk
        foreign key (user_id) references users (user_id)
            on update cascade on delete cascade
);

create table gift_bill
(
    bill_id     int           not null
        primary key check (`bill_id` > 999),
    bill_date   datetime      not null,
    streamer_id int           not null check (`streamer_id` > 999999),
    stream_id   int           not null check (`stream_id` > 99),
    gift_no     int default 1 not null check (`gift_no` > 0),
    gift_id     int           not null check (`gift_id` > 999),
    user_id     int           not null check (`user_id` > 999),
    constraint gift_bill_gifts_gift_id_fk
        foreign key (gift_id) references gifts (gift_id)
            on update cascade on delete cascade,
    constraint gift_bill_streamers_streamer_id_fk
        foreign key (stream_id) references streamers (streamer_id)
            on update cascade on delete cascade,
    constraint gift_bill_streams_stream_id_fk
        foreign key (stream_id) references streams (stream_id)
            on update cascade on delete cascade,
    constraint gift_bill_users_user_id_fk
        foreign key (user_id) references users (user_id)
            on update cascade on delete cascade
);

create table stream_details
(
    stream_id   int null check (`streamer_id` > 999999),
    streamer_id int null check (`stream_id` > 99),
    game_id     int null check (`game_id` > 999),
    constraint stream_details_games_game_id_fk
        foreign key (game_id) references games (game_id)
            on update cascade on delete cascade,
    constraint stream_details_streamers_streamer_id_fk
        foreign key (streamer_id) references streamers (streamer_id)
            on update cascade on delete cascade,
    constraint stream_details_streams_stream_id_fk
        foreign key (stream_id) references streams (stream_id)
            on update cascade on delete cascade
);

create table strtime_watch
(
    strtime_id  int      not null
        primary key,
    watch_date  datetime not null,
    start_point time     not null,
    end_point   time     not null,
    stream_id   int      not null check (`stream_id` > 99),
    user_id     int      not null check (`user_id` > 999),
    constraint strtime_watch_streams_stream_id_fk
        foreign key (stream_id) references streams (stream_id)
            on update cascade on delete cascade,
    constraint strtime_watch_users_user_id_fk
        foreign key (user_id) references users (user_id)
            on update cascade on delete cascade
);

