--Create new database
CREATE DATABASE PROJECT;

--use Project Database
USE DATABASE PROJECT;

--Create new table Sales Data Final
CREATE TABLE SALES_DATA_FINAL(
order_id	text,
order_date	text,
ship_date	text,
ship_mode	text,
customer_name	text,
segment	text,
state	text,
country	text,
market	text,
region	text,
product_id	text,
category	text,
sub_category	text,
product_name	text,
sales	number(5,0),
quantity	number(2,0),
discount	number(3,3),
profit	number(10,5),
shipping_cost	number(7,4),
order_priority	text,
year	number(4,0));

--show all data from table sales_data_final
select * from sales_data_final;

--Add the Primary key constraint to Order Id Column.
alter table sales_data_final add constraint s_pk primary key(order_id);

--Convert order date and ship date datatype to date datatype
alter table sales_data_final add column Date_order date;
alter table sales_data_final add column Date_ship date;
update sales_data_final set date_order= to_date(order_date,'MM-DD-YYYY');
update sales_data_final set Date_ship= to_date(ship_date,'MM-DD-YYYY');
alter table sales_data_final drop column ship_date;

--Create a new column called order_extract and extract the number after the last ‘–‘from Order ID column.
alter table sales_data_final add column order_extract number(10,0);
update sales_data_final set order_extract=replace(substr(order_id,8,len(order_id)-7),'-','');

--Create a new column called Discount Flag and categorize it based on discount. Use ‘Yes’ if the discount is greater than zero else ‘No’.                      
alter table sales_data_final add column discount_flag text;
update sales_data_final set discount_flag= case when discount>0 then 'Yes'
                                             else 'No' end;
                                             
--Create a new column called process days and calculate how many days it takes for each order id to process from the order to its shipment.
alter table sales_data_final add column process_days number(10,0);
update sales_data_final set process_days=datediff(day,date_order,date_ship);

--Create a new column called Rating and then based on the Process dates give
--rating like given below.
--a. If process days less than or equal to 3days then rating should be 5
--b. If process days are greater than 3 and less than or equal to 6 then rating
--should be 4
--c. If process days are greater than 6 and less than or equal to 10 then rating
--should be 3
--d. If process days are greater than 10 then the rating should be 2.
alter table sales_data_final add column Rating number(1,0);
update sales_data_final set Rating= case when process_days<=3 then 5
                                         when process_days between 3 and 6 then 4
                                         when process_days between 6 and 10 then 3
                                         when process_days >10 then 2
end;
