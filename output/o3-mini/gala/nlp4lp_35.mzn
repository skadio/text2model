include "globals.mzn";

% Data declarations (to be provided in the .dzn file)
int: NumProducts;
int: NumMachines;
array[1..NumProducts, 1..NumMachines] of int: ProduceTime;
array[1..NumMachines] of int: AvailableTime;
array[1..NumProducts] of int: Profit;

% Decision variables: the production quantity for each product.
% We use an arbitrary large upper bound (e.g., 10000) for each product.
array[1..NumProducts] of var 0..10000: production;

% Production time constraints:
% For each machine s, the total production time across all products must not exceed its available time.
constraint
  forall(s in 1..NumMachines) (
    sum(k in 1..NumProducts)(ProduceTime[k, s] * production[k]) <= AvailableTime[s]
  );

% Objective: maximize the total profit from production.
solve maximize sum(k in 1..NumProducts)(Profit[k] * production[k]);

% Output the production quantities
output [ "Production quantities: ", show(production) ];