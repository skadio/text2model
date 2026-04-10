int: throw_customers = 15;
int: climb_customers = 8;

int: throw_cost = 2;
int: climb_cost = 3;

int: budget = 100;

int: min_climb = 5;

var 0..budget div throw_cost: T;  % number of throwing games
var min_climb..budget div climb_cost: C; % number of climbing games

constraint throw_cost * T + climb_cost * C <= budget;
constraint T >= 2 * C;

var int: total_customers = throw_customers * T + climb_customers * C;

solve maximize total_customers;

output [
  "Throwing games = ", show(T), "\n",
  "Climbing games = ", show(C), "\n",
  "Total customers per hour = ", show(total_customers), "\n",
  "Prize cost per hour = ", show(throw_cost*T + climb_cost*C), "\n"
];