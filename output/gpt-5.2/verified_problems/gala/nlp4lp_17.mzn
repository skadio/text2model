% Oil refinery blending / process planning (LP with continuous decisions)
% Maximizes profit = revenue from products - process execution costs
%
% Data (from .dzn):
%   int: O;                          % number of crude options/resources
%   int: P;                          % number of products/price points
%   int: L;                          % number of processes
%   array[1..O] of float: Allocated; % available amount of each crude option
%   array[1..P] of float: Price;     % selling price for each product
%   array[1..L,1..O] of float: Input;% crude consumption per process execution
%   array[1..L,1..P] of float: Output;% product output per process execution
%   array[1..L] of float: Cost;      % cost per process execution

int: O;
int: P;
int: L;

array[1..O] of float: Allocated;
array[1..P] of float: Price;
array[1..L,1..O] of float: Input;
array[1..L,1..P] of float: Output;
array[1..L] of float: Cost;

% Decision variables: number of times to execute each process (continuous)
array[1..L] of var float: x;

% Nonnegativity
constraint forall(l in 1..L)(x[l] >= 0.0);

% Resource availability constraints (do not exceed allocated crude)
constraint
  forall(o in 1..O)(
    sum(l in 1..L)(Input[l,o] * x[l]) <= Allocated[o]
  );

% Objective: maximize profit = revenue - costs
var float: revenue =
  sum(l in 1..L, p in 1..P)(Price[p] * Output[l,p] * x[l]);

var float: total_cost =
  sum(l in 1..L)(Cost[l] * x[l]);

var float: profit = revenue - total_cost;

solve maximize profit;

output [
  "x (process executions) = ", show(x), "\n",
  "revenue = ", show(revenue), "\n",
  "total_cost = ", show(total_cost), "\n",
  "profit = ", show(profit), "\n",
  "resource_used = ", show([ sum(l in 1..L)(Input[l,o]*x[l]) | o in 1..O ]), "\n",
  "product_made = ", show([ sum(l in 1..L)(Output[l,p]*x[l]) | p in 1..P ]), "\n"
];