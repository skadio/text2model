% Parameters
int: N; % The number of time periods
int: Capacity; % Maximum storage capacity
int: HoldingCost; % Cost of holding one unit of product
array[1..N] of int: Price; % Selling price in each period
array[1..N] of int: Cost; % Cost of buying in each period

% Variables
array[1..N] of var 0..Capacity: Buy; % Amount of commodity bought in each period
array[1..N] of var 0..Capacity: Sell; % Amount of commodity sold in each period
array[1..N] of var 0..Capacity: Stock; % Amount of commodity in stock in each period

% Constraints

% The warehouse is originally empty
constraint Stock[1] = Buy[1] - Sell[1];

% The warehouse is required to be empty at the end of the last period
constraint Stock[N] = 0;

% The amount of commodity in stock in each period is the amount bought minus the amount sold
forall(i in 2..N) (
  constraint Stock[i] = Stock[i-1] + Buy[i] - Sell[i];
);

% The amount of commodity in stock in each period cannot exceed the warehouse capacity
forall(i in 1..N) (
  constraint Stock[i] <= Capacity;
);

% The amount of commodity sold in each period cannot exceed the amount in stock
forall(i in 1..N) (
  constraint Sell[i] <= Stock[i];
);

% The profit in each period is the selling price minus the cost of buying and the cost of holding the stock
% This constraint ensures that the profit is maximized
forall(i in 1..N) (
  constraint Sell[i]*Price[i] >= Buy[i]*Cost[i] + Stock[i]*HoldingCost;
);

% Objective
solve maximize sum(i in 1..N) (Sell[i]*Price[i] - Buy[i]*Cost[i] - Stock[i]*HoldingCost);