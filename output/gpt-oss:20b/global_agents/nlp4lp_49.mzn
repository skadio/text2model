include "globals.mzn";

% ----- Parameters -----
int: A;                     % number of alloys
int: S;                     % number of steel types

array[1..A] of int: AvailableAlloy;   % available amount of each alloy
array[1..A] of float: CarbonContent;  % % carbon in each alloy
array[1..A] of float: NickelContent;  % % nickel in each alloy
array[1..A] of int:   AlloyPrice;     % price per ton of each alloy

array[1..S] of int:   SteelPrice;     % selling price per ton of each steel
array[1..S] of float: CarbonMin;      % minimum % carbon required
array[1..S] of float: NickelMax;      % maximum % nickel allowed

% ----- Decision variables -----
array[1..S,1..A] of var 0.0..inf: x;   % amount of alloy a used in steel s
array[1..S] of var 0.0..inf: p;        % total amount of steel s produced
var float: profit;                     % total profit

% ----- Linking steel production to alloy use -----
constraint forall(s in 1..S)(
    p[s] = sum(a in 1..A)( x[s,a] )
);

% ----- Alloy availability constraints -----
constraint forall(a in 1..A)(
    sum(s in 1..S)( x[s,a] ) <= AvailableAlloy[a]
);

% ----- Steel composition constraints -----
constraint forall(s in 1..S)(
    sum(a in 1..A)( CarbonContent[a] * x[s,a] ) >=
    CarbonMin[s] * p[s]
);
constraint forall(s in 1..S)(
    sum(a in 1..A)( NickelContent[a] * x[s,a] ) <=
    NickelMax[s] * p[s]
);

% ----- Alloy 1 share constraint (max 40%) -----
constraint forall(s in 1..S)(
    x[s,1] <= 0.4 * p[s]
);

% ----- Profit definition -----
constraint profit == sum(s in 1..S)(
            SteelPrice[s] * p[s]
          - sum(a in 1..A)( AlloyPrice[a] * x[s,a] )
          );

% ----- Objective -----
solve maximize profit;

% ----- Output -----
output [
    "Profit = ", show(profit), "\n",
    "Steel production: ", show(p), "\n",
    "Alloy usage matrix (rows: steels, columns: alloys):\n",
    concat([ show(x[s]) ++ "\n" | s in 1..S ])
];