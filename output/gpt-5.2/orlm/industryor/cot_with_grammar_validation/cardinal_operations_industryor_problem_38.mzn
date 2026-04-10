% Parameters
int: max_motorcycle_trips = 8;
int: min_total_products = 300;
int: max_total_trips = 20;

int: pollution_motorcycle = 40;
int: pollution_small_truck = 70;
int: pollution_large_truck = 100;

int: capacity_motorcycle = 10;
int: capacity_small_truck = 20;
int: capacity_large_truck = 50;

% Variables
var 0..max_motorcycle_trips: m;        % motorcycle trips
var 0..max_total_trips: s;             % small truck trips
var 0..max_total_trips: l;             % large truck trips

var bool: use_m;
var bool: use_s;
var bool: use_l;

var 0..(max_total_trips * pollution_large_truck): total_pollution;

% Constraints
constraint use_m <-> (m > 0);
constraint use_s <-> (s > 0);
constraint use_l <-> (l > 0);

% Choose exactly 2 transportation methods (i.e., exactly 2 are used)
constraint bool2int(use_m) + bool2int(use_s) + bool2int(use_l) = 2;

% Total products transported
constraint m * capacity_motorcycle + s * capacity_small_truck + l * capacity_large_truck >= min_total_products;

% Total trips limit
constraint m + s + l <= max_total_trips;

% Total pollution definition
constraint total_pollution = m * pollution_motorcycle + s * pollution_small_truck + l * pollution_large_truck;

% Objective
solve minimize total_pollution;