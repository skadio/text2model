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
array[1..K, 1..K] of var 0..1: Operate; % Whether mine k is operated in year i
array[1..K, 1..K] of var 0..Limit[k]: Production; % Amount of material produced by mine k in year i

% Constraints
constraint forall(i in 1..K)(sum(k in 1..K)(Operate[k, i]) <= MaxWork); % Maximum number of mines that can be operated in a year
constraint forall(i in 1..K)(sum(k in 1..K)(Operate[k, i]*Quality[k]*Production[k, i]) = RequiredQuality[i]); % Required quality of the material for client i
constraint forall(k in 1..K, i in 1..K)(Operate[k, i]*Production[k, i] <= Limit[k]); % Production limit for mine k

% Objective
var float: Profit = sum(i in 1..K, k in 1..K)(Price*Production[k, i] - Discount*Royalty[k]*Operate[k, i]);
solve maximize Profit;