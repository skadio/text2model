% Parameters
int: K;
set of int: Mines = 1..K;

int: MaxWork;

array[Mines] of float: Royalty;
array[Mines] of float: Limit;
array[Mines] of float: Quality;

array[int] of float: RequiredQuality;      % length defines number of years

float: Price;
float: Discount;

% Derived sets and constants
set of int: Years = index_set(RequiredQuality);
int: I = card(Years);

float: GlobalUpperProd = max([Limit[k] | k in Mines]);
array[Years] of float: DiscFactor = [pow(1.0 + Discount, t - 1) | t in Years];

% Decision variables
array[Mines, Years] of var 0.0..GlobalUpperProd: x;   % production
array[Mines, Years] of var 0..1: w;                   % worked
array[Mines, Years] of var 0..1: y_open;              % open

% Constraints
constraint forall(k in Mines, t in Years)(
    x[k,t] <= Limit[k] * w[k,t]
);

constraint forall(k in Mines, t in Years)(
    w[k,t] <= y_open[k,t]
);

constraint forall(k in Mines, t in Years where t < max(Years))(
    y_open[k,t] >= y_open[k,t+1]
);

constraint forall(t in Years)(
    sum(k in Mines)(w[k,t]) <= MaxWork
);

constraint forall(t in Years)(
    sum(k in Mines)(x[k,t] * (Quality[k] - RequiredQuality[t])) = 0.0
);

% Objective
var float: NPV =
    sum(t in Years)(
        (Price * sum(k in Mines)(x[k,t]) -
         sum(k in Mines)(Royalty[k] * y_open[k,t]))
        / DiscFactor[t]
    );

solve maximize NPV;