% Parameters

% Number of factories
int: nFactories = 2;
set of int: FACTORY = 1..nFactories;

% Number of teddy bear colors/products (black, white, brown)
int: nColors = 3;
set of int: COLOR = 1..nColors;

% Indices for readability
int: BLACK = 1;
int: WHITE = 2;
int: BROWN = 3;

% Cost per hour to run each factory
array[FACTORY] of int: costPerHour = [300, 600];

% Production per hour: producedPerHour[f,c] = units of color c produced by factory f in 1 hour
array[FACTORY, COLOR] of int: producedPerHour =
  array2d(FACTORY, COLOR,
    [
      % BLACK WHITE BROWN
         5,    6,    3,   % Factory 1
        10,   10,    0    % Factory 2
    ]);

% Minimum daily demand for each color (at least)
array[COLOR] of int: demandMin = [20, 5, 15];


% Variables

% Hours run per day for each factory (non-negative; integer LP formulation)
array[FACTORY] of var 0..1000000: hoursRun;

% Total produced per color (derived variable; non-negative integer)
array[COLOR] of var 0..1000000000: totalProduced;

% Total daily cost (derived variable; non-negative integer)
var 0..1000000000: totalCost;


% Constraints

% Link totalProduced to factory hours and per-hour production rates
constraint
  forall(c in COLOR) (
    totalProduced[c] =
      sum(f in FACTORY) (hoursRun[f] * producedPerHour[f, c])
  );

% Meet minimum demand requirements for each teddy bear color
constraint
  forall(c in COLOR) (
    totalProduced[c] >= demandMin[c]
  );

% Link totalCost to factory hours and per-hour operating costs
constraint
  totalCost =
    sum(f in FACTORY) (hoursRun[f] * costPerHour[f]);


% Objective
solve minimize totalCost;