% Parameters
int: cap_top = 50;            % items/day per top-loading machine
int: cap_front = 75;          % items/day per front-loading machine
int: kwh_top = 85;            % kWh/day per top-loading machine
int: kwh_front = 100;         % kWh/day per front-loading machine
int: min_items = 5000;        % items/day required
int: max_kwh = 7000;          % kWh/day available
int: min_front = 10;          % minimum number of front-loading machines
int: max_top_percent = 40;    % at most this percent of machines can be top-loading

% Variables
var 0..1000: top;
var min_front..1000: front;
var 0..2000: total;

% Constraints
constraint total = top + front;

constraint cap_top * top + cap_front * front >= min_items;
constraint kwh_top * top + kwh_front * front <= max_kwh;

% At most 40% top-loading: top <= 0.4 * total  <=>  5*top <= 2*total
constraint 5 * top <= 2 * total;

% Objective
solve minimize total;