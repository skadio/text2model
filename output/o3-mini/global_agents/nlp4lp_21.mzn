```
include "globals.mzn";

% --------------------------
% Data parameters (provided in the .dzn file)
% --------------------------
int: M;                         % Number of machine types
int: K;                         % Number of product types
int: I;                         % Number of time periods (months)

array[1..M] of int: NumMachines;        % Number of machines of each type
array[1..K] of int: Profit;              % Profit per unit for each product k
array[1..K, 1..M] of float: Time;         % Time required by product k on machine m
array[1..I, 1..M] of float: Maintain;     % Maintenance time for machine m in time period i
array[1..K, 1..I] of int: Limit;          % Production limit for product k in time period i
float: StorePrice;                       % Storage cost per unit per month
array[1..K] of int: KeepQuantity;         % Minimum inventory to keep at the end of period 2...I
float: WorkHours;                        % Number of working hours per day

% --------------------------
% Decision variables
% --------------------------
% For each product k and period i:
% produce[k,i] = quantity produced of product k in period i
% sell[k,i]    = quantity sold of product k in period i
% stock[k,i]   = stock (inventory) of product k at end of period i
%
% Production and sales quantities are assumed to be non-negative integers.
% Stock is naturally bounded by the storage capacity, which is 100 units per product.
array[1..K, 1..I] of var 0..max(Limit): produce;
array[1..K, 1..I] of var 0..max(Limit): sell;
array[1..K, 1..I] of var 0..100: stock;

% --------------------------
% Constraints
% --------------------------

% (1) Inventory balance:
%   - Initial stock is zero.
%   - For each period, stock carries over: 
%         stock[k,i] = stock[k,i-1] + produce[k,i] - sell[k,i]
%   - Inventory cannot be negative.
constraint
  forall(k in 1..K) (
    stock[k,1] = produce[k,1] - sell[k,1] /\  % initial period, starting from zero
    stock[k,1] >= 0
  );

constraint
  forall(k in 1..K, i in 2..I) (
    stock[k,i] = stock[k,i-1] + produce[k,i] - sell[k,i] /\
    stock[k,i] >= 0
  );

% (2) Production limits:
% The production quantity of product k in period i must not exceed the allowed limit.
constraint
  forall(k in 1..K, i in 1..I) (
    produce[k,i] <= Limit[k,i]
  );

% (3) Storage capacity:
% At most 100 units of any product can be held in stock in any period.
constraint
  forall(k in 1..K, i in 1..I) (
    stock[k,i] <= 100
  );

% (4) Minimum stock requirements:
% At the end of subsequent periods (i >= 2) the stock must be at least KeepQuantity.
constraint
  forall(k in 1..K, i in 2..I) (
    stock[k,i] >= KeepQuantity[k]
  );

% (5) Machine capacity constraints:
% In each period i and for each machine m, the total processing 
% time used by production should not exceed the available machine time.
% Available time = (number of machines * WorkHours * 24 days) - maintenance time.
constraint
  forall(i in 1..I, m in 1..M) (
    sum(k in 1..K)( Time[k,m] * produce[k,i] )
    <= NumMachines[m] * WorkHours * 24.0 - Maintain[i,m]
  );

% --------------------------
% Objective
% --------------------------
% Maximize total profit, which is revenue from sold units minus storage costs.
% (Assuming production cost is zero or already embedded in the profit per unit