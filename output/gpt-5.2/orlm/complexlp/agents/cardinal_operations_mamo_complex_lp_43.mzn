% Parameters
int: nWarehouses = 4;                                   % number of warehouses
set of int: W = 1..nWarehouses;                         % warehouse index set

array[W] of int: initialStock = [500, 497, 354, 223];   % initial tons at each warehouse
array[W] of int: requiredStock = [17, 65, 26, 332];     % required tons at each warehouse

array[W, W] of int: transportCost =                     % cost per ton shipped i->j
  [|  0, 17,  3,  5
   | 39,  0, 18, 50
   |  8, 45,  0, 15
   | 11,  4, 29,  0 |];

% Variables
array[W, W] of var 0..max(initialStock): ship;          % tons shipped from warehouse i to j
var 0..(max(transportCost) * sum(initialStock)): totalCost; % total transportation cost

% Constraints

% --- No self-shipping (disallow shipping from a warehouse to itself) ---
constraint
  forall(i in W) (
    ship[i,i] = 0
  );

% --- Flow balance: final stock at each warehouse must meet required stock exactly ---
% finalStock[j] = initialStock[j] + sum_in(ship[i,j]) - sum_out(ship[j,k]) = requiredStock[j]
constraint
  forall(j in W) (
    initialStock[j]
    + sum(i in W)(ship[i,j])
    - sum(k in W)(ship[j,k])
    = requiredStock[j]
  );

% --- Define total transportation cost as sum of shipped tons times per-ton costs ---
constraint
  totalCost =
    sum(i in W, j in W) (
      ship[i,j] * transportCost[i,j]
    );

% Objective
solve minimize totalCost;