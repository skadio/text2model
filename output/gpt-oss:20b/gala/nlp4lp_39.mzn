include "globals.mzn";

% --- data ------------------------------------------------------------
int: K;                       % number of alloys
int: M;                       % number of metals
int: AlloyQuantity;           % total amount of alloy to produce

array[1..M] of float: Target;                      % target amounts for each metal
array[1..K, 1..M] of float: Ratio;                % composition of each alloy (ratio per metal)
array[1..K] of float: Price;                      % price per unit of each alloy

% --- variables ------------------------------------------------------
array[1..K] of var 0.0 .. float(AlloyQuantity): x;  % quantity of each alloy used

% --- auxiliary -----------------------------------------------------
var float: totalCost = sum(k in 1..K)( x[k] * Price[k] );

% --- constraints ---------------------------------------------------
constraint sum(x) = AlloyQuantity;                % total alloy amount

constraint forall(m in 1..M)(
    sum(k in 1..K)( x[k] * Ratio[k, m] ) = Target[m]
);

% --- objective -----------------------------------------------------
solve minimize totalCost;

% --- output ---------------------------------------------------------
output [
    "Total Cost: ", show(totalCost), "\n",
    "Alloy Quantities: ", show(x), "\n"
];