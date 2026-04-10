include "globals.mzn";

% Data (embedded from problem statement)
int: prodA = 30;
int: prodB = 50;
int: kwhA  = 100;
int: kwhB  = 120;

int: minItems = 1000;
int: maxKwh   = 3000;

float: maxFracB = 0.30;   % at most 30% of machines are type B
int: minA = 5;            % at least 5 machines of type A

% Decision variables: number of machines of each type
var 0..1000: A;
var 0..1000: B;

% Constraints
constraint A >= minA;

% Production requirement
constraint prodA * A + prodB * B >= minItems;

% Electricity limit
constraint kwhA * A + kwhB * B <= maxKwh;

% Fraction of type B: B <= 0.30 * (A + B)
% Use integer arithmetic: 10*B <= 3*(A+B)  <=> 7*B <= 3*A
constraint 7 * B <= 3 * A;

% Objective: minimize total number of machines
var 0..2000: total = A + B;
solve minimize total;

output [
  "A = ", show(A), "\n",
  "B = ", show(B), "\n",
  "Total machines = ", show(total), "\n",
  "Items produced = ", show(prodA*A + prodB*B), "\n",
  "kWh used = ", show(kwhA*A + kwhB*B), "\n"
];