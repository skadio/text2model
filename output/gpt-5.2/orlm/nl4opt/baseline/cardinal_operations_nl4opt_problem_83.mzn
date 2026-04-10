% Mail delivery optimization: runners vs canoers

int: runner_capacity = 3;      % bags per runner trip
int: runner_time = 4;          % hours per runner trip

int: canoe_capacity = 10;      % bags per canoe trip
int: canoe_time = 2;           % hours per canoe trip

int: max_total_hours = 200;
int: min_runners = 4;

% At most 33% of deliveries can be by canoe:
% canoe_deliveries <= 0.33 * total_deliveries
% Use exact rational form: canoe <= 33/100 * (runner + canoe)
% => 100*c <= 33*(r + c) => 67*c <= 33*r
int: canoe_pct_num = 33;
int: canoe_pct_den = 100;

var 0..max_total_hours div runner_time: runners;
var 0..max_total_hours div canoe_time: canoers;

constraint runners >= min_runners;
constraint runner_time * runners + canoe_time * canoers <= max_total_hours;

% canoe share constraint (integer-safe)
constraint (canoe_pct_den - canoe_pct_num) * canoers <= canoe_pct_num * runners; % 67*c <= 33*r

var int: total_bags = runner_capacity * runners + canoe_capacity * canoers;

solve maximize total_bags;

output [
  "runners = ", show(runners), "\n",
  "canoers = ", show(canoers), "\n",
  "total_hours = ", show(runner_time * runners + canoe_time * canoers), "\n",
  "total_bags = ", show(total_bags), "\n"
];