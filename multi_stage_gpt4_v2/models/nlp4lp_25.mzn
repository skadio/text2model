% Parameters
int: K; % Number of mines
int: MaxWork; % Maximum number of mines that can be operated in a year
array[1..K] of int: Royalty; % Royalty cost for operating mine k
array[1..K] of int: Limit; % Production limit for mine k
array[1..K] of float: Quality; % Quality of the material from mine k
float: RequiredQuality; % Required quality of the material
float: Price; % Price per unit of material sold
float: Discount; % Discount on the royalty cost per unit of material sold

% Variables
array[1..K] of var 0..1: operate; % Binary variable indicating whether mine k is operated or not
array[1..K] of var 0..Limit[k]: production; % Amount of material produced from mine k

% Constraints

% Constraint 1: The number of mines operated in a year should not exceed the maximum limit
constraint sum(operate) <= MaxWork;

% Constraint 2: The production from a mine should not exceed its limit
constraint forall(k in 1..K) (production[k] <= Limit[k] * operate[k]);

% Constraint 3: The quality of the blended material should meet the required quality
constraint sum(k in 1..K) (production[k] * Quality[k]) / sum(production) = RequiredQuality;

% Objective
solve maximize Price * sum(production) - sum(k in 1..K) (Royalty[k] * operate[k] * (1 - Discount));