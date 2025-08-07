include "globals.mzn";

/* Parameters (supplied in a .dzn file) */
int: K;                % number of mines
int: MaxWork;          % max mines that can work in a year
int: I;                % number of years
array[1..K] of float: Royalty;          % yearly royalty per mine
array[1..K] of float: Limit;            % production limit per mine
array[1..K] of float: Quality;          % ore quality per mine
array[1..I] of float: RequiredQuality; % required blended quality each year
float: Price;          % price per ton
float: Discount;       % annual discount rate

/* Derived constants */
float: maxLimit = max(Limit);

/* Decision variables */
array[1..K,1..I] of var 0..1: operate;                     % 1 if mine k works in year i
array[1..K,1..I] of var 0..maxLimit: production;           % tons produced by mine k in year i

/* Derived variables */
array[1..I] of var float: total_output;
constraint forall(i in 1..I)(
    total_output[i] == sum(k in 1..K)(production[k,i])
);

array[1..I] of var float: revenue;
constraint forall(i in 1..I)(
    revenue[i] == Price * total_output[i]
);

array[1..I] of var float: cost;
constraint forall(i in 1..I)(
    cost[i] == sum(k in 1..K)(Royalty[k] * operate[k,i])
);

/* Quality blend constraint */
constraint forall(i in 1..I)(
    sum(k in 1..K)(Quality[k] * production[k,i]) == RequiredQuality[i] * total_output[i]
);

/* Production limits */
constraint forall(k in 1..K, i in 1..I)(
    production[k,i] <= Limit[k] * operate[k,i]
);

/* Maximum mines per year */
array[1..I] of var 0..K: occ;
constraint forall(i in 1..I)(
    count(operate[i],1,occ[i])
);
constraint forall(i in 1..I)(
    occ[i] <= MaxWork
);

/* Discount factors */
array[1..I] of float: discountFactor = [1 / pow(1+Discount, i-1) | i in 1..I];

/* Present‑value profit */
var float: profitPV;
constraint profitPV == sum(i in 1..I)( (revenue[i] - cost[i]) * discountFactor[i] );

/* Objective */
solve maximize profitPV;

/* Output */
output [
    "Profit (present value) = ", show(profitPV), "\n",
    "Operate = ", show(operate), "\n",
    "Production = ", show(production), "\n"
];