include "globals.mzn";

/* ---------- Data ---------- */
int: K;                                 % number of years
array[1..K,1..K] of float: InputOne;    % input of resource type 1
array[1..K,1..K] of float: InputTwo;    % input of resource type 2
array[1..K] of float: ManpowerOne;      % manpower for resource type 1
array[1..K] of float: ManpowerTwo;      % manpower for resource type 2
array[1..K] of int: Stock;              % initial stock of each product
array[1..K] of int: Capacity;           % production capacity of each product
float: ManpowerLimit;                   % yearly manpower limit

/* ---------- Variables ---------- */
array[1..K,1..K] of var float: prod;        % production of product k in year t
array[0..K,1..K] of var float: inv;         % inventory of product k at start of year t

/* ---------- Initial inventory ---------- */
constraint forall(k in 1..K)( inv[0][k] = Stock[k] );

/* ---------- Production capacity ---------- */
constraint forall(t in 1..K, k in 1..K)( prod[t][k] >= 0 );
constraint forall(t in 1..K, k in 1..K)( prod[t][k] <= Capacity[k] );

/* ---------- Inventory dynamics ---------- */
constraint forall(t in 1..K, k in 1..K)(
    inv[t][k] = inv[t-1][k] + prod[t][k]
                - sum(j in 1..K)( (InputOne[j][k] + InputTwo[j][k]) * prod[t][j] )
);
constraint forall(t in 1..K, k in 1..K)( inv[t][k] >= 0 );

/* ---------- Manpower limit ---------- */
constraint forall(t in 1..K)(
    sum(j in 1..K)( (ManpowerOne[j] + ManpowerTwo[j]) * prod[t][j] ) <= ManpowerLimit
);

/* ---------- Objective: maximize last two years' production ---------- */
var float: totalProd;
constraint totalProd = sum(t in 1..K where t >= K-1)(
    sum(k in 1..K)( prod[t][k] )
);
solve maximize totalProd;

/* ---------- Output ---------- */
output [
  "Total production in last two years: ", show(totalProd), "\n",
  "Production matrix:\n",
  concat([ show(t), ": ", show([prod[t][k] | k in 1..K]), "\n" | t in 1..K]),
  "Inventory levels (including year 0):\n",
  concat([ show(t), ": ", show([inv[t][k] | k in 1..K]), "\n" | t in 0..K])
];