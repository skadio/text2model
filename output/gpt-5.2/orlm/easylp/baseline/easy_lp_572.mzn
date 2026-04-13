% Resource allocation for three units with embedded data

% Decision variables: whole-number allocations
var 10..50: x1;
var 20..70: x2;
var 0..40:  x3;

% Total resources limit
constraint x1 + x2 + x3 <= 100;

% Operational requirements (avoid fractions by multiplying by 10)
% 0.5*x1 + 0.6*x3 >= 0.7*x2 + 20
constraint 5*x1 + 6*x3 >= 7*x2 + 200;

% 0.8*x2 + 0.9*x3 should not surpass by more than 30 what's been taken away from x1
% Interpreted as: 0.8*x2 + 0.9*x3 <= x1 + 30
constraint 8*x2 + 9*x3 <= 10*x1 + 300;

% Costs in dollars
int: c1 = 50000;
int: c2 = 70000;
int: c3 = 60000;

var int: total_cost = c1*x1 + c2*x2 + c3*x3;

solve minimize total_cost;

output [
  "x1=", show(x1), "\n",
  "x2=", show(x2), "\n",
  "x3=", show(x3), "\n",
  "total_cost=", show(total_cost), "\n"
];