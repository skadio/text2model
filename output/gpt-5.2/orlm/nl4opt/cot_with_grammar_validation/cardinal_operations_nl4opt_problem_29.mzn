% Parameters
int: items_top = 50;
int: items_front = 75;
int: kwh_top = 85;
int: kwh_front = 100;

int: min_items = 5000;
int: max_kwh = 7000;

int: min_front = 10;

% Variables
var 0..ceil(int2float(min_items) / int2float(items_top)): x_top;
var min_front..ceil(int2float(min_items) / int2float(items_front)): x_front;

var 0..(ceil(int2float(min_items) / int2float(items_top)) + ceil(int2float(min_items) / int2float(items_front))): total_machines;

% Constraints
constraint total_machines = x_top + x_front;

constraint items_top * x_top + items_front * x_front >= min_items;
constraint kwh_top * x_top + kwh_front * x_front <= max_kwh;

% At most 40% of machines are top-loading: x_top <= 0.4*(x_top+x_front)
% Use integer-safe form: 5*x_top <= 2*(x_top+x_front)  <=> 3*x_top <= 2*x_front
constraint 3 * x_top <= 2 * x_front;

constraint x_front >= min_front;

% Objective
solve minimize total_machines;