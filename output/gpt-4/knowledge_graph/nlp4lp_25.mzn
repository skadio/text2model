include "globals.mzn";

% Parameters
int: K; % Number of mines
int: MaxWork; % Maximum number of mines that can be operated in a year
array[1..K] of float: Royalty; % Royalty cost for operating mine k
array[1..K] of float: Limit; % Production limit for mine k
array[1..K] of float: Quality; % Quality of the material from mine k
array[1..5] of float: RequiredQuality; % Required quality of the material for client i
float: Price; % Price per unit of material sold
float: Discount; % Discount on the royalty cost per unit of material sold

% Variables
array[1..K, 1..5] of var 0.0..Limit[K]: Production; % Production from mine k in year i
array[1..K, 1..5] of var 0..1: Open; % Whether mine k is open in year i

% Constraints
constraint forall(i in 1..5)(sum(k in 1..K)(Open[k, i]) <= MaxWork); % Maximum number of mines that can be operated in a year
constraint forall(i in 1..5)(sum(k in 1..K)(Quality[k] * Production[k, i]) = RequiredQuality[i]); % Required quality of the material for client i
constraint forall(k in 1..K, i in 1..5)(Production[k, i] <= Limit[k] * Open[k, i]); % Production limit for mine k

% Objective
var float: profit;
constraint profit = sum(i in 1..5, k in 1..K)((Price * Production[k, i] - Royalty[k] * Open[k, i]) * (1 - Discount)^(i - 1));
solve maximize profit;

% Output
output ["Profit: ", show(profit), "\n"] ++
["Production: ", show(Production), "\n"] ++
["Open: ", show(Open), "\n"];