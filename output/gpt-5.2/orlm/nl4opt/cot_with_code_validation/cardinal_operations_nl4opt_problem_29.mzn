% Parameters
int: cap_top = 50;
int: cap_front = 75;

int: kwh_top = 85;
int: kwh_front = 100;

int: min_items = 5000;
int: max_kwh = 7000;

int: min_front = 10;

% Variables
var 0..1000: n_top;
var min_front..1000: n_front;
var 0..2000: n_total;

% Constraints
constraint n_total = n_top + n_front;

constraint cap_top * n_top + cap_front * n_front >= min_items;
constraint kwh_top * n_top + kwh_front * n_front <= max_kwh;

% At most 40% of machines are top-loading: n_top <= 0.4 * (n_top + n_front)
constraint 5 * n_top <= 2 * n_total;

% Objective
solve minimize n_total;