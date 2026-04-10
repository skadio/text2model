% Parameters (with values embedded)
int: total_acres_max = 1000;
int: rev_wheat = 2;
int: rev_corn = 3;
int: rev_barley = 1;

% Variables
var 0..total_acres_max: wheat;
var 0..total_acres_max: corn;
var 0..total_acres_max: barley;

var 0..(rev_wheat*total_acres_max + rev_corn*total_acres_max + rev_barley*total_acres_max): revenue;

% Constraints
constraint wheat + corn + barley <= total_acres_max;

% "wheat at least half of wheat+corn" as given: 2*wheat + corn >= 500
constraint 2*wheat + corn >= 500;

% "barley cannot exceed half of wheat+barley" as given: wheat + 2*barley <= 600
constraint wheat + 2*barley <= 600;

constraint revenue = rev_wheat*wheat + rev_corn*corn + rev_barley*barley;

% Objective
solve minimize revenue;

output [
  "wheat=", show(wheat), "\n",
  "corn=", show(corn), "\n",
  "barley=", show(barley), "\n",
  "min_revenue_dollars=", show(revenue), "\n"
];