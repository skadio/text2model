% Parameters
int: demand = 1000;

int: poll_horse = 80;
int: poll_bike = 0;
int: poll_cart = 0;
int: poll_limit = 1000;

int: cap_horse = 55;
int: cap_bike = 30;
int: cap_cart = 40;

int: min_horse_trips = 8;

% Upper bounds from constraints
int: max_horse_trips = poll_limit div poll_horse; % pollution bound
int: max_total_trips = demand; % safe finite bound (at least 1 unit per trip if needed)

% Variables
var 0..max_horse_trips: x_horse;
var 0..max_total_trips: x_bike;
var 0..max_total_trips: x_cart;

var bool: use_bike;
var bool: use_cart;

var 0..poll_limit: total_pollution;

% Constraints
constraint x_horse >= min_horse_trips;

% Choose only one of bicycle and handcart (exactly one)
constraint use_bike + use_cart = 1;

% If a mode is not chosen, its trips must be 0
constraint x_bike <= max_total_trips * bool2int(use_bike);
constraint x_cart <= max_total_trips * bool2int(use_cart);

% Demand satisfaction
constraint cap_horse * x_horse + cap_bike * x_bike + cap_cart * x_cart >= demand;

% Pollution limit and definition
constraint total_pollution = poll_horse * x_horse + poll_bike * x_bike + poll_cart * x_cart;
constraint total_pollution <= poll_limit;

% Objective
solve minimize total_pollution;