% Parameters (with values embedded)
int: seat_sedan = 50;
int: poll_sedan = 10;
int: seat_bus   = 250;
int: poll_bus   = 40;

int: max_pollution = 800;
int: min_customers = 4600;

% Upper bounds from pollution limit
int: max_sedans = max_pollution div poll_sedan; % 80
int: max_buses  = max_pollution div poll_bus;   % 20

% Variables
var 0..max_sedans: sedans;
var 0..max_buses: buses;

% Constraints
constraint seat_sedan * sedans + seat_bus * buses >= min_customers;
constraint poll_sedan * sedans + poll_bus * buses <= max_pollution;

% Objective
solve minimize sedans + buses;