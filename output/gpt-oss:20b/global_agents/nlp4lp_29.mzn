% --------------------------------------------------------------------
% MiniZinc model for the five‑year production and manpower optimisation
% --------------------------------------------------------------------

include "globals.mzn";

int: K;                                     % number of years

array[1..K] of float: ManpowerOne;          % manpower per unit for operation 1
array[1..K] of float: ManpowerTwo;          % manpower per unit for operation 2
array[1..K] of float: Stock0;               % stock of each product at year 0
array[1..K] of float: Capacity0;            % initial capacity of each product
array[1..K] of float: Demand;               % demand each year (year 0 has no demand)

array[1..K,1..K] of float: InputOne;       % input coefficient (op. 1)
array[1..K,1..K] of float: InputTwo;       % input coefficient (op. 2)

% --------------------------------------------------------------------
% Decision variables
% --------------------------------------------------------------------
array[0..K-1,1..K] of var float: capacity; % productive capacity each year
array[0..K-1,1..K] of var float: x1;       % production of op. 1
array[0..K-1,1..K] of var float: x2;       % production of op. 2
array[0..K,1..K] of var float: stock;      % stock at the beginning of each year

% --------------------------------------------------------------------
% Initialisation
% --------------------------------------------------------------------
constraint forall(j in 1..K) (
    stock[0,j] = Stock0[j]
);

constraint forall(j in 1..K) (
    capacity[0,j] = Capacity0[j]
);

% Capacity for year 1 equals initial capacity (no increase yet)
constraint
    if K >= 2 then
        forall(j in 1..K)( capacity[1,j] = Capacity0[j] )
    else
        true
    endif;

% Capacity growth rule – increase occurs two years after production
constraint forall(t in 2..K-1, j in 1..K) (
    capacity[t,j] = capacity[t-2,j] + x1[t-2,j] + x2[t-2,j]
);

% --------------------------------------------------------------------
% Production limits
% --------------------------------------------------------------------
constraint forall(t in 0..K-1, j in 1..K) (
    x1[t,j] >= 0 /\ x2[t,j] >= 0
);

constraint forall(t in 0..K-1, j in 1..K) (
    x1[t,j] + x2[t,j] <= capacity[t,j]
);

% --------------------------------------------------------------------
% Stock dynamics
% --------------------------------------------------------------------
constraint forall(t in 0..K-1, j in 1..K) (
    let {
        var float: consumption_j =
            sum(k in 1..K)( InputOne[k,j]*x1[t,k] + InputTwo[k,j]*x2[t,k] );
        var float: demand_t = if t >= 1 then Demand[j] else 0.0 endif;
    } in
        stock[t+1,j] = stock[t,j] - consumption_j - demand_t + x1[t,j] + x2[t,j]
);

% Stock can never be negative
constraint forall(t in 0..K, j in 1..K)(
    stock[t,j] >= 0
);

% --------------------------------------------------------------------
% Objective – maximise total manpower requirement over all years
% --------------------------------------------------------------------
var float: totalManpower = sum(t in 0..K-1, j in 1..K)(
    ManpowerOne[t+1]*x1[t,j] + ManpowerTwo[t+1]*x2[t,j]
);

solve maximize totalManpower;

% --------------------------------------------------------------------
% Output
% --------------------------------------------------------------------
output [
    "Total manpower = ", show(totalManpower), "\n",
    "Production by year:\n",
    concat([ "  Year ", show(t+1), ":\n",
             concat([ "    Industry ", show(j), ": x1 = ", show(x1[t,j]),
                      ", x2 = ", show(x2[t,j]), "\n" ] ) | j in 1..K ])
    | t in 0..K-1 ]
];