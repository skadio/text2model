% Farmland distribution: minimize cultivation cost with integer acres

var 0..100: wheat;
var 0..100: corn;
var 0..100: soy;

% Constraints
constraint 2*wheat + corn <= 50;
constraint wheat + 3*soy <= 60;
constraint corn + soy >= 30;

% Objective: minimize total cost
var int: total_cost = 5*wheat + 4*corn + 6*soy;
solve minimize total_cost;

output [
  "wheat=", show(wheat), "\n",
  "corn=", show(corn), "\n",
  "soy=", show(soy), "\n",
  "min_total_cost=", show(total_cost), "\n"
];