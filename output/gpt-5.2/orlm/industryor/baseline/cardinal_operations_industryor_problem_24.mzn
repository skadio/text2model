% MiniZinc LP model: investment allocation to maximize wealth at end of year 3

int: initial_capital = 100000;

% Decision variables:
% x1: amount invested at time 0 in option 1 (1-year term, profit 0.7 per 1)
% x2: amount invested at time 0 in option 2 (2-year term, profit 2 per 1)
% y1: amount invested at time 1 in option 1 using proceeds available at time 1
var float: x1 >= 0.0;
var float: x2 >= 0.0;
var float: y1 >= 0.0;

% Cashflow constraints
constraint x1 + x2 <= initial_capital;                 % spend at time 0
constraint y1 <= 1.7 * x1;                             % time 1 funds from option 1

% Objective: maximize end-of-year-3 wealth
% - From y1 (invested at time 1): returns at time 2; hold as cash to year 3
% - From x2 (invested at time 0): returns at time 2; hold as cash to year 3
% - Any uninvested at time 0 stays as cash to year 3
var float: final_wealth =
    (initial_capital - x1 - x2)        % cash kept from time 0
  + 2.7 * y1                           % y1 returns at time 2 (factor 1.7) held to year 3
  + 3.0 * x2;                          % x2 returns at time 2 (factor 3) held to year 3

solve maximize final_wealth;

output [
  "x1 (option1 at t=0) = ", show(x1), "\n",
  "x2 (option2 at t=0) = ", show(x2), "\n",
  "y1 (option1 at t=1) = ", show(y1), "\n",
  "final wealth (end of year 3) = ", show(final_wealth), "\n"
];