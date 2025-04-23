% Parameters
int: K; % Number of mines
int: MaxWork; % Maximum number of mines that can be operated in a year
array[1..K] of int: Royalty; % Royalty cost for operating mine k
array[1..K] of int: Limit; % Production limit for mine k
array[1..K] of float: Quality; % Quality of the material from mine k
array[1..I] of float: RequiredQuality; % Required quality of the material for client i
float: Price; % Price per unit of material sold
float: Discount; % Discount on the royalty cost per unit of material sold

% Variables
array[1..K] of var 0..1: operate; % Binary variable indicating whether mine k is operated or not
array[1..K] of var 0..Limit: production; % Amount of material produced from mine k
array[1..I] of var float: blendedQuality; % Quality of the blended material for client i

% Constraints

% Constraint 1: Maximum number of mines that can be operated in a year
constraint sum(operate) <= MaxWork;

% Constraint 2: Production limit for each mine
constraint forall(k in 1..K) (
    production[k] <= Limit[k] * operate[k]
);

% Constraint 3: Quality of the blended material for each client
constraint forall(i in 1..I) (
    blendedQuality[i] = sum([production[k] * Quality[k] | k in 1..K]) / sum(production)
);

% Constraint 4: Required quality of the material for each client
constraint forall(i in 1..I) (
    blendedQuality[i] = RequiredQuality[i]
);

% Constraint 5: Revenue and expenditure for future years must be discounted
constraint forall(k in 1..K) (
    Price * production[k] - Discount * Royalty[k] * operate[k] >= 0
);

% Objective
solve maximize sum([Price * production[k] - Discount * Royalty[k] * operate[k] | k in 1..K]);