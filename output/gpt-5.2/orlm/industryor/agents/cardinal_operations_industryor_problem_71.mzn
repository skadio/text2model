% Parameters
int: nProperties = 4;                         % number of available properties
set of int: PROPS = 1..nProperties;           % property index set

array[PROPS] of int: income = [12500, 35000, 23000, 100000];        % annual income ($)
array[PROPS] of int: cost   = [1500000, 2100000, 2300000, 4200000]; % purchase cost ($)

int: budget = 7000000;                        % total available budget ($)

int: prop3 = 3;                               % index for Property 3
int: prop4 = 4;                               % index for Property 4

% Variables
array[PROPS] of var 0..1: buy;                % buy[p] = 1 if property p is purchased, else 0
var 0..sum(income): total_income;             % total annual income ($)
var 0..sum(cost): total_cost;                 % total spent ($)

% Constraints

% Compute total annual income from selected properties
constraint total_income = sum(p in PROPS)(income[p] * buy[p]);

% Compute total purchase cost from selected properties
constraint total_cost = sum(p in PROPS)(cost[p] * buy[p]);

% Budget constraint: total cost must not exceed available budget
constraint total_cost <= budget;

% Mutual exclusivity: if Property 4 is purchased, Property 3 cannot be purchased
constraint buy[prop4] + buy[prop3] <= 1;

% Objective
solve maximize total_income;