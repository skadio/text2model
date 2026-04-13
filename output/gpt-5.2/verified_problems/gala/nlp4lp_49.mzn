% Steel blending / production planning (LP)
% Maximize profit from producing steels using limited alloys
%
% Data expected in .dzn:
%   int: A; int: S;
%   array[1..A] of float: AvailableAlloy;
%   array[1..A] of float: CarbonContent;
%   array[1..A] of float: NickelContent;
%   array[1..A] of float: AlloyPrice;
%   array[1..S] of float: SteelPrice;
%   array[1..S] of float: CarbonMin;
%   array[1..S] of float: NickelMax;

int: A;
int: S;

array[1..A] of float: AvailableAlloy;
array[1..A] of float: CarbonContent;
array[1..A] of float: NickelContent;
array[1..A] of float: AlloyPrice;

array[1..S] of float: SteelPrice;
array[1..S] of float: CarbonMin;
array[1..S] of float: NickelMax;

% Decision variables:
% x[a,s] = tons of alloy a used in steel s
array[1..A, 1..S] of var float: x;

% y[s] = tons of steel s produced
array[1..S] of var float: y;

% Nonnegativity
constraint forall(a in 1..A, s in 1..S)( x[a,s] >= 0.0 );
constraint forall(s in 1..S)( y[s] >= 0.0 );

% Mass balance: produced steel equals sum of alloys used
constraint forall(s in 1..S)(
  y[s] = sum(a in 1..A)( x[a,s] )
);

% Alloy availability constraints
constraint forall(a in 1..A)(
  sum(s in 1..S)( x[a,s] ) <= AvailableAlloy[a]
);

% Quality constraints:
% Carbon: weighted average >= CarbonMin[s]
constraint forall(s in 1..S)(
  sum(a in 1..A)( CarbonContent[a] * x[a,s] ) >= CarbonMin[s] * y[s]
);

% Nickel: weighted average <= NickelMax[s]
constraint forall(s in 1..S)(
  sum(a in 1..A)( NickelContent[a] * x[a,s] ) <= NickelMax[s] * y[s]
);

% At most 40% of alloy 1 in any steel: x[1,s] <= 0.4 * y[s]
constraint forall(s in 1..S)(
  x[1,s] <= 0.4 * y[s]
);

% Objective: maximize profit = revenue - raw material cost
var float: revenue = sum(s in 1..S)( SteelPrice[s] * y[s] );
var float: cost    = sum(a in 1..A, s in 1..S)( AlloyPrice[a] * x[a,s] );
var float: profit  = revenue - cost;

solve maximize profit;

output
[
  "Profit = ", show(profit), "\n",
  "Revenue = ", show(revenue), "\n",
  "Cost = ", show(cost), "\n\n",
  "Steel produced y[s] (tons) = ", show(y), "\n\n",
  "Alloy usage x[a,s] (tons):\n"
]
++
[
  "Alloy ", show(a), ": ", show([ x[a,s] | s in 1..S ]), "\n"
  | a in 1..A
];