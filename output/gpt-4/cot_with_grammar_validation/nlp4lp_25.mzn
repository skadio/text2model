% Parameters
int: K; % Number of mines
int: MaxWork; % Maximum number of mines that can be operated in a year
array[1..K] of float: Royalty; % Royalty cost for operating mine k
array[1..K] of float: Limit; % Production limit for mine k
array[1..K] of float: Quality; % Quality of the material from mine k
array[1..K] of float: RequiredQuality; % Required quality of the material for client i
float: Price; % Price per unit of material sold
float: Discount; % Discount on the royalty cost per unit of material sold

% Variables
array[1..K] of var 0..1: operate; % Whether to operate mine k or not
array[1..K] of var 0.0..Limit[K]: production; % Amount of material produced from mine k
array[1..K] of var 0.0..sum(i in 1..K)(Limit[i]): blended; % Amount of blended material for client i

% Constraints
constraint forall(i in 1..K)(operate[i] * production[i] <= Limit[i]); % Production limit constraint
constraint sum(i in 1..K)(operate[i]) <= MaxWork; % Maximum number of mines constraint
constraint forall(i in 1..K)(sum(j in 1..K)(operate[j] * Quality[j] * production[j]) / blended[i] = RequiredQuality[i]); % Quality constraint

% Objective
var float: profit = sum(i in 1..K)(Price * production[i] - Discount * Royalty[i] * operate[i]);
solve maximize profit;