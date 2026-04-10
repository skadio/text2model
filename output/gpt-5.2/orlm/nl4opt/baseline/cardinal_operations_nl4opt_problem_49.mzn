% Cough syrup bottle production optimization

int: kids_capacity = 100;      % ml per kids bottle
int: adult_capacity = 300;     % ml per adult bottle
int: total_syrup = 25000;      % ml available

% Decision variables: number of bottles
var 0..total_syrup div kids_capacity: kids;
var 0..total_syrup div adult_capacity: adult;

% Constraints
constraint kids >= 50;
constraint adult >= 3 * kids;
constraint kids_capacity * kids + adult_capacity * adult <= total_syrup;

% Objective: maximize total number of bottles
solve maximize kids + adult;

output [
  "kids_bottles = ", show(kids), "\n",
  "adult_bottles = ", show(adult), "\n",
  "total_bottles = ", show(kids + adult), "\n",
  "syrup_used_ml = ", show(kids_capacity * kids + adult_capacity * adult), "\n",
  "syrup_left_ml = ", show(total_syrup - (kids_capacity * kids + adult_capacity * adult)), "\n"
];