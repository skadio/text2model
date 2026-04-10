% Parameters
% Factories
int: nFactories = 2;
set of int: FACTORY = 1..nFactories;

% Bear colors/products
int: nColors = 3;
set of int: COLOR = 1..nColors;

% Color indices for readability
int: BLACK = 1;
int: WHITE = 2;
int: BROWN = 3;

% Cost per hour for each factory
array[FACTORY] of int: costPerHour = [300, 600];

% Production per hour: prodPerHour[f, c]
% Factory 1: 5 black, 6 white, 3 brown
% Factory 2: 10 black, 10 white, 0 brown
array[FACTORY, COLOR] of int: prodPerHour =
  array2d(FACTORY, COLOR,
    [ 5,  6,  3,
     10, 10,  0 ]);

% Minimum daily demand for each color
array[COLOR] of int: demandMin = [20, 5, 15];


% Variables
% Hours to run each factory per day (non-negative, continuous)
array[FACTORY] of var float: hours;

% Total produced per color per day (non-negative, continuous)
array[COLOR] of var float: produced;

% Total daily production cost (non-negative, continuous)
var float: totalCost;


% Constraints
% Non-negativity bounds
constraint forall(f in FACTORY) (hours[f] >= 0.0);
constraint forall(c in COLOR) (produced[c] >= 0.0);
constraint totalCost >= 0.0;

% Production definition: total produced per color equals sum of factory outputs
constraint forall(c in COLOR) (
  produced[c] = sum(f in FACTORY)(hours[f] * prodPerHour[f, c])
);

% Cost definition: total cost equals sum of hourly running costs
constraint totalCost = sum(f in FACTORY)(hours[f] * costPerHour[f]);

% Demand satisfaction: meet or exceed minimum demand for each color
constraint forall(c in COLOR) (
  produced[c] >= demandMin[c]
);


% Objective
solve minimize totalCost;