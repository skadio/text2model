include "globals.mzn";

int: K;  % Number of mines
int: MaxWork;  % Maximum number of mines that can be operated in a year
array[1..K] of int: Royalty;  % Royalty cost for operating mine k
array[1..K] of int: Limit;  % Production limit for mine k
array[1..K] of float: Quality;  % Quality of the material from mine k
array[1..I] of float: RequiredQuality;  % Required quality of the material for client i
float: Price;  % Price per unit of material sold
float: Discount;  % Discount on the royalty cost per unit of material sold

/* Decision variables */
array[1..K] of var 0..1: operate;  % 1 if mine k is operated, 0 otherwise
array[1..K] of var 0..K: production;  % Production amount from each mine

/* Constraints */
constraint count(operate, 1, MaxWork);  % At most MaxWork mines can be operated

/* Cumulative constraint for production limits */
constraint cumulative([1 | k in 1..K where operate[k] == 1], 
                      [1 | k in 1..K where operate[k] == 1], 
                      Limit, 
                      MaxWork);

/* Quality constraint: ensure the blended quality meets the required quality */
array[1..I] of var float: blendedQuality;  % Blended quality for each client
constraint forall(i in 1..I)(
    blendedQuality[i] = sum(k in 1..K)(Quality[k] * production[k]) / sum(k in 1..K)(production[k]) 
    -> blendedQuality[i] == RequiredQuality[i]
);

/* Objective function: Maximize profit */
var float: totalRevenue = sum(k in 1..K)(Price * production[k]) - sum(k in 1..K)(Royalty[k] * operate[k]);
solve maximize totalRevenue;

/* Output */
output [ "Operate = ", show(operate), "\nProduction = ", show(production), "\nTotal Revenue = ", show(totalRevenue), "\n" ];