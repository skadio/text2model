% Laundromat washing machines - minimize total number of machines

int: cap_top = 50;        % items/day
int: cap_front = 75;      % items/day

int: kwh_top = 85;        % kWh/day
int: kwh_front = 100;     % kWh/day

int: min_items = 5000;    % items/day required
int: max_kwh = 7000;      % kWh/day available

int: min_front = 10;      % at least this many front-loading
% at most 40% of machines can be top-loading:
% top <= 0.4*(top+front)  <=> 3*top <= 2*front (integer-safe)
 
var 0..10000: top;
var 0..10000: front;

constraint cap_top * top + cap_front * front >= min_items;
constraint kwh_top * top + kwh_front * front <= max_kwh;

constraint 3 * top <= 2 * front;
constraint front >= min_front;

solve minimize top + front;

output [
  "top_loading = ", show(top), "\n",
  "front_loading = ", show(front), "\n",
  "total_machines = ", show(top + front), "\n",
  "items_per_day = ", show(cap_top * top + cap_front * front), "\n",
  "kwh_per_day = ", show(kwh_top * top + kwh_front * front), "\n"
];