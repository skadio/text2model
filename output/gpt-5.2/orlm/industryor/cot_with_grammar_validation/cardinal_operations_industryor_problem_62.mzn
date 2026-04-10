% Parameters
int: demand = 1000;

int: cap_horse = 55;
int: cap_bike = 30;
int: cap_cart = 40;

int: pol_horse = 80;
int: pol_bike = 0;
int: pol_cart = 0;

int: pol_limit = 1000;
int: min_horse_trips = 8;

% Upper bounds based on meeting demand (plus a small slack) and pollution limit
int: max_horse_trips = pol_limit div pol_horse; % due to pollution limit
int: max_bike_trips = (demand div cap_bike) + 50;
int: max_cart_trips = (demand div cap_cart) + 50;

% Variables
var min_horse_trips..max_horse_trips: horse_trips;
var 0..max_bike_trips: bike_trips;
var 0..max_cart_trips: cart_trips;

var 0..1: use_bike;
var 0..1: use_cart;

var 0..pol_limit: total_pollution;
var 0..(cap_horse*max_horse_trips + cap_bike*max_bike_trips + cap_cart*max_cart_trips): total_produce;

% Constraints
constraint use_bike + use_cart = 1;

constraint bike_trips <= max_bike_trips * use_bike;
constraint cart_trips <= max_cart_trips * use_cart;

constraint total_pollution = pol_horse * horse_trips + pol_bike * bike_trips + pol_cart * cart_trips;
constraint total_pollution <= pol_limit;

constraint total_produce = cap_horse * horse_trips + cap_bike * bike_trips + cap_cart * cart_trips;
constraint total_produce >= demand;

% Objective
solve minimize total_pollution;