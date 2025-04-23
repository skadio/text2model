include "globals.mzn";

% Number of mines
int: K;

% Maximum number of mines that can be operated in a year
int: MaxWork;

% Royalty cost for operating mine k
array[1..K] of float: Royalty;

% Production limit for mine k
array[1..K] of float: Limit;

% Quality of the material from mine k
array[1..K] of float: Quality;

% Required quality of the material for client i
array[1..K] of float: RequiredQuality;

% Price per unit of material sold
float: Price;

% Discount on the royalty cost per unit of material sold
float: Discount;

% Decision variables
array[1..K] of var 0..1: operate; % whether to operate mine k or not
array[1..K] of var 0.0..Limit[i]: production; % amount of material to produce from mine k

% Objective: maximize profit
var float: profit = sum(i in 1..K) (Price * production[i] - (1 - Discount) * Royalty[i] * operate[i]);

% Constraints
constraint sum(i in 1..K) operate[i] <= MaxWork; % can't operate more than MaxWork mines
constraint forall(i in 1..K) (production[i] <= Limit[i] * operate[i]); % can't produce more than limit if mine is operated
constraint forall(i in 1..K) (sum(j in 1..K) (Quality[j] * production[j]) / sum(j in 1..K) production[j] = RequiredQuality[i]); % the quality of the blended ore must meet the requirement

% Solve
solve maximize profit;

% Output
output ["profit: " ++ show(profit) ++ "\n"] ++
       ["operate: " ++ show(operate) ++ "\n"] ++
       ["production: " ++ show(production) ++ "\n"];