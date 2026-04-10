% Garden bed soil purchase optimization (embed all data here)

% Data (from description)
int: water_sub = 10;          % water units per bag of subsoil per day
int: water_top = 6;           % water units per bag of topsoil per day
int: max_total_bags = 150;    % truck capacity in bags (top + sub)
int: min_top_bags = 10;       % at least 10 bags of topsoil
int: max_top_percent = 30;    % at most 30% of all bags can be topsoil

% Decision variables
var 0..max_total_bags: top;
var 0..max_total_bags: sub;
var 0..max_total_bags: total;

% Constraints
constraint total = top + sub;
constraint total <= max_total_bags;
constraint top >= min_top_bags;

% top <= 30% of total  <=>  100*top <= 30*total
constraint 100 * top <= max_top_percent * total;

% Objective: minimize total daily water
var 0..1000000: water;
constraint water = water_top * top + water_sub * sub;

solve minimize water;

output [
  "topsoil_bags = ", show(top), "\n",
  "subsoil_bags = ", show(sub), "\n",
  "total_bags = ", show(total), "\n",
  "daily_water = ", show(water), "\n"
];