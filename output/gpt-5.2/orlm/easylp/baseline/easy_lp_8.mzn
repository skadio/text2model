% Advertising budget allocation (integer dollars)
var 0..1000: Ad1;
var 0..1000: Ad2;

% Constraints
constraint Ad1 + Ad2 >= 50;          % minimum effectiveness
constraint 4*Ad1 + 6*Ad2 <= 300;     % fatigue/combined effort limit

% Objective: minimize total cost
var int: total_cost = 5*Ad1 + 3*Ad2;
solve minimize total_cost;

output [
  "Ad1 = ", show(Ad1), "\n",
  "Ad2 = ", show(Ad2), "\n",
  "total_cost = ", show(total_cost), "\n"
];