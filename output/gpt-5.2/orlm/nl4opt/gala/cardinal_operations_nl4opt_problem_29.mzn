% Laundromat washing machine purchase optimization
% Data embedded as required.

int: cap_top_items = 50;
int: cap_front_items = 75;

int: kwh_top = 85;
int: kwh_front = 100;

int: min_items = 5000;
int: max_kwh = 7000;

int: min_front = 10;     % at least 10 front-loading
int: max_top_pct = 40;   % at most 40% top-loading

% Decision variables: number of machines of each type
var 0..10000: top;
var 0..10000: front;

% Demand constraint (items/day)
constraint cap_top_items * top + cap_front_items * front >= min_items;

% Energy constraint (kWh/day)
constraint kwh_top * top + kwh_front * front <= max_kwh;

% At most 40% of machines can be top-loading:
% top <= 0.4*(top+front)  <=>  5*top <= 2*(top+front)  <=>  3*top <= 2*front
constraint 3 * top <= 2 * front;

% At least 10 front-loading machines
constraint front >= min_front;

% Objective: minimize total number of machines
var 0..20000: total = top + front;
solve minimize total;

output [
  "top = ", show(top), "\n",
  "front = ", show(front), "\n",
  "total = ", show(total), "\n",
  "items/day = ", show(cap_top_items * top + cap_front_items * front), "\n",
  "kWh/day = ", show(kwh_top * top + kwh_front * front), "\n"
];