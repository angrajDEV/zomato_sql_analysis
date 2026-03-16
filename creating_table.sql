-- create database zomato_db;
-- use zomato_db;

create table customers(
	customer_id int primary key,
    customer_name varchar(25),
    reg_date date
);

create table restaurants(
	restaurant_id int primary key,
    restaurant_name varchar(55),
    city varchar(15),
    opening_hour varchar(55)
);

create table orders(
	order_id int primary key,
	customer_id int , -- comming from customer table
	restaurant_id int , -- coming from restaurant table
	order_item varchar(55),
    order_date date,
    order_time time,
    order_status varchar(55),
    total_amount float
);
-- adding foreign key 
alter table orders add constraint fk_customers foreign key (customer_id) references customers(customer_id);
alter table orders add constraint fk_restaurants foreign key (restaurant_id) references restaurants(restaurant_id);

create table riders(
	rider_id int primary key,
    rider_name varchar(55),
    sign_up date
);

create table deliveries(
	delivery_id int primary key,
    order_id int , -- comming from orders table
    delivery_status varchar(35),
    delivery_time time,
    rider_id int, -- this is comming from riders
	constraint fk_orders foreign key (order_id) references orders(order_id),
   	constraint fk_riders foreign key (rider_id) references riders(rider_id)
);









