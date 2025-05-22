% Parameters
int: A;                               % Number of different alloys
int: S;                               % Number of different steel types

array[1..A] of float: AvailableAlloy; % Available amount of each alloy (t)
array[1..A] of float: CarbonContent;  % Carbon content of each alloy   (%)
array[1..A] of float: NickelContent;  % Nickel content of each alloy   (%)
array[1..A] of float: AlloyPrice;     % Purchase price per ton of each alloy

array[1..S] of float: SteelPrice;     % Selling price per ton of each steel
array[1..S] of float: CarbonMin;      % Minimum required carbon content (%)
array[1..S] of float: NickelMax;      % Maximum allowed nickel content (%)

float: TotalAvailable = sum(a in 1..A)(AvailableAlloy[a]);

% Variables
array[a in 1..A, s in 1..S] of var 0.0..AvailableAlloy[a]: X;   % tons of alloy a used in steel s
array[1..S] of var 0.0..TotalAvailable: Y;                      % tons of steel s produced
var float: Profit;                                              % total profit

% Constraints
constraint
    forall(s in 1..S) (
        Y[s] = sum(a in 1..A)(X[a,s])               % steel quantity definition
    );

constraint
    forall(a in 1..A) (
        sum(s in 1..S)(X[a,s]) <= AvailableAlloy[a] % alloy availability
    );

constraint
    forall(s in 1..S) (
        sum(a in 1..A)((CarbonContent[a] - CarbonMin[s]) * X[a,s]) >= 0.0
    );

constraint
    forall(s in 1..S) (
        sum(a in 1..A)((NickelContent[a] - NickelMax[s]) * X[a,s]) <= 0.0
    );

constraint
    forall(s in 1..S) (
        X[1,s] <= 0.40 * Y[s]                       % at most 40% of alloy 1
    );

% Objective
constraint
    Profit =   sum(s in 1..S)(SteelPrice[s] * Y[s])
             - sum(a in 1..A, s in 1..S)(AlloyPrice[a] * X[a,s]);

solve maximize Profit;