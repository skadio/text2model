% Parameters
int: nWarehouses = 4;                         % number of warehouses
set of int: W = 1..nWarehouses;               % warehouse index set

array[W] of int: stock = [500, 497, 354, 223];        % current stock at each warehouse (tons)
array[W] of int: required = [17, 65, 26, 332];        % required stock at each warehouse (tons)

% transportation cost per ton moved from i to j (i != j), diagonal unused (set to 0)
array[W, W] of int: cost =
  [|  0, 17,  3,  5
   | 39,  0, 18, 50
   |  8, 45,  0, 15
   | 11,  4, 29,  0 |];

% Safe upper bound on shipment quantities
int: maxShip = sum(stock);

% Variables
array[W, W] of var 0..maxShip: ship;          % ship[i,j] = tons shipped from i to j

% Constraints

% Disallow self-shipping (no movement from a warehouse to itself)
constraint
  forall(i in W) (
    ship[i,i] = 0
  );

% Flow balance constraints:
% Final stock at each warehouse after shipments must be at least its required amount.
constraint
  forall(i in W) (
    stock[i]
    - sum(j in W)(ship[i,j])      % total shipped out of i
    + sum(j in W)(ship[j,i])      % total shipped into i
    >= required[i]
  );

% Supply (capacity) constraints:
% A warehouse cannot ship out more than its initial stock.
constraint
  forall(i in W) (
    sum(j in W)(ship[i,j]) <= stock[i]
  );

% Objective
var int: total_cost = sum(i in W, j in W) (cost[i,j] * ship[i,j]);

solve minimize total_cost;

output [ show(total_cost) ];