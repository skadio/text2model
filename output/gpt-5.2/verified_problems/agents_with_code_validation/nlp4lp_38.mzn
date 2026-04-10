% Parameters
int: N;                                  % number of time periods
set of int: PERIODS = 1..N;              % index set for periods

int: Capacity;                           % maximum warehouse capacity (units)
int: HoldingCost;                        % holding cost per unit per period

array[PERIODS] of int: Price;            % selling price per unit in each period
array[PERIODS] of int: Cost;             % buying cost per unit in each period


% Variables
array[PERIODS] of var 0..Capacity: buy;  % units bought in each period
array[PERIODS] of var 0..Capacity: sell; % units sold in each period

array[0..N] of var 0..Capacity: stock;   % inventory level at end of each period (stock[0] = initial)


% Constraints

% Inventory boundary conditions: warehouse starts empty and must end empty
constraint stock[0] = 0;
constraint stock[N] = 0;

% Inventory balance: end-of-period stock equals previous stock plus buys minus sells
constraint
  forall(t in PERIODS) (
    stock[t] = stock[t-1] + buy[t] - sell[t]
  );

% Feasibility of sales: cannot sell more than available inventory in the period
constraint
  forall(t in PERIODS) (
    sell[t] <= stock[t-1] + buy[t]
  );

% Capacity enforcement (redundant with variable domains, kept for clarity/robustness)
constraint
  forall(t in 0..N) (
    stock[t] <= Capacity
  );


% Objective
solve maximize
  sum(t in PERIODS) (
    Price[t] * sell[t]            % revenue from sales
    - Cost[t] * buy[t]            % cost of purchases
    - HoldingCost * stock[t]      % holding cost for end-of-period inventory
  );