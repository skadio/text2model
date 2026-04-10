% Parameters
int: nProperties = 4;                         % number of properties
set of int: PROPERTIES = 1..nProperties;      % index set for properties

array[PROPERTIES] of int: income =            % annual income ($)
  [12500, 35000, 23000, 100000];

array[PROPERTIES] of int: cost =              % purchase cost ($)
  [1500000, 2100000, 2300000, 4200000];

int: budget = 7000000;                        % total budget ($)

int: prop3 = 3;                               % index for Property 3
int: prop4 = 4;                               % index for Property 4

% Variables
array[PROPERTIES] of var 0..1: buy;           % buy[p]=1 if property p is purchased, else 0
var 0..sum(income): totalIncome;              % total annual income ($)
var 0..budget: totalCost;                     % total cost spent ($)

% Constraints

% Compute total cost from purchase decisions
constraint
  totalCost = sum(p in PROPERTIES)(cost[p] * buy[p]);

% Compute total annual income from purchase decisions
constraint
  totalIncome = sum(p in PROPERTIES)(income[p] * buy[p]);

% Budget feasibility: do not exceed available budget
constraint
  totalCost <= budget;

% Mutual exclusivity: if Property 4 is purchased, Property 3 cannot be purchased
constraint
  buy[prop4] + buy[prop3] <= 1;

% Objective
solve maximize totalIncome;