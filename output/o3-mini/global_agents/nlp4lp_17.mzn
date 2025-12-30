% Data parameters (provided in a separate .dzn file)
int: O;               % Number of crude oil types (options)
int: P;               % Number of products (price points)
int: L;               % Number of production processes

array[1..O] of int: Allocated;        % Allocated crude oil barrels for each type
array[1..P] of int: Price;              % Selling price for each product
array[1..L, 1..O] of int: Input;        % Crude oil consumption (barrels) per process for each oil type
array[1..L, 1..P] of int: ProdOutput;   % Product output (barrels produced) per process for each product
array[1..L] of int: Cost;               % Cost per barrel of product produced for each process

% Decision variables:
% x[l] is the (possibly fractional) number of times process l is executed.
% We assume an upper bound large enough (1e9) so that the domain is not restrictive.
array[1..L] of var 0.0..1e9: x;

% For each process, compute total product output and revenue from product sales.
array[1..L] of int: TotalOutput = [ sum(p in 1..P)( ProdOutput[l,p] ) | l in 1..L ];
array[1..L] of int: RevenuePerExec = [ sum(p in 1..P)( Price[p] * ProdOutput[l,p] ) | l in 1..L ];

% Profit per execution of process l equals revenue minus production cost.
% Production cost is the cost per barrel times total barrels produced in that process.
array[1..L] of int: profit = [ RevenuePerExec[l] - Cost[l] * TotalOutput[l] | l in 1..L ];

% Resource constraints: The total input used of each oil type must not exceed the allocated amount.
constraint
    forall(o in 1..O) (
        sum(l in 1..L)( Input[l,o] * x[l] ) <= Allocated[o]
    );

% Objective: maximize total profit over all processes.
solve maximize sum(l in 1..L)( float(profit[l]) * x[l] );

% Output: process executions and total profit.
output [
  "Process executions: ", show(x), "\n",
  "Total profit: ", show(sum(l in 1..L)( float(profit[l]) * x[l])), "\n"
];