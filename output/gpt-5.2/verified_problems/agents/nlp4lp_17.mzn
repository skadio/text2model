% Parameters
int: O; % Number of crude oil options (resource types)
int: P; % Number of products / price points
int: L; % Number of production processes

array[1..O] of float: Allocated;     % Allocated amount available for each crude option
array[1..P] of float: Price;         % Selling price for each product (price point)

array[1..L, 1..O] of float: Input;   % Input[i,o] = amount of crude option o consumed by process i (per execution)
array[1..L, 1..P] of float: Output;  % Output[i,p] = amount of product p produced by process i (per execution)

array[1..L] of float: Cost;          % Cost per execution of each process

% Variables
array[1..L] of var float: Exec;      % Exec[i] = number of times process i is executed (can be fractional), Exec[i] >= 0

array[1..O] of var float: Used;       % Used[o] = total amount of crude option o used
array[1..P] of var float: Produced;   % Produced[p] = total amount of product p produced

var float: TotalRevenue;             % Total sales revenue
var float: TotalCost;                % Total process execution cost
var float: Profit;                   % Profit = TotalRevenue - TotalCost

% Constraints

% --- Non-negativity of decision variables ---
constraint
  forall(i in 1..L) (
    Exec[i] >= 0.0
  );

% --- Resource usage definition and allocation limits ---
% Used[o] is the total amount of crude option o consumed across all processes.
constraint
  forall(o in 1..O) (
    Used[o] = sum(i in 1..L) (Exec[i] * Input[i,o])
  );

% Do not exceed allocated crude resources.
constraint
  forall(o in 1..O) (
    Used[o] <= Allocated[o]
  );

% --- Production definition ---
% Produced[p] is the total amount of product p produced across all processes.
constraint
  forall(p in 1..P) (
    Produced[p] = sum(i in 1..L) (Exec[i] * Output[i,p])
  );

% Do not allow negative production totals.
constraint
  forall(p in 1..P) (
    Produced[p] >= 0.0
  );

% --- Revenue, cost, and profit accounting ---
% Total sales revenue from all products.
constraint
  TotalRevenue = sum(p in 1..P) (Produced[p] * Price[p]);

% Total execution cost across all processes.
constraint
  TotalCost = sum(i in 1..L) (Exec[i] * Cost[i]);

% Profit definition.
constraint
  Profit = TotalRevenue - TotalCost;

% Objective
solve maximize Profit;