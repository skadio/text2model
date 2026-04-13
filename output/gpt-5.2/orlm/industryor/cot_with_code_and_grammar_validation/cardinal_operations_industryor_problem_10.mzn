% Parameters
int: nProd = 2;
set of int: PROD = 1..nProd;

int: nProc = 3;
set of int: PROC = 1..nProc;

% Process indices: 1=Manufacturing, 2=Assembly, 3=Inspection
array[PROC] of int: cap = [120, 80, 40];              % hours/week
array[PROC] of int: cost = [12, 8, 10];              % Yuan/hour

% time[p, i] = hours per unit of product i on process p
array[PROC, PROD] of int: time = array2d(PROC, PROD,
  [ 20, 0,    % Manufacturing: A,B
     5, 7,    % Assembly: A,B
     3, 6 ]   % Inspection: A,B
);

array[PROD] of int: price = [650, 725];              % Yuan/unit

int: profit_target = 3000;
int: min_A = 5;

% Variables
array[PROD] of var 0..10000: x;                      % x[1]=Type A, x[2]=Type B (units/week)

array[PROC] of var 0..10000: used;                   % used hours per process
array[PROC] of var 0..10000: idle;                   % idle hours per process

var int: profit;                                     % weekly profit (Yuan)
var int: weighted_idle;                              % weighted idle (Yuan)

% Constraints
constraint
  forall(p in PROC) (
    used[p] = sum(i in PROD)(time[p,i] * x[i])
  );

constraint
  forall(p in PROC) (
    used[p] <= cap[p]              % no overtime
  );

constraint
  forall(p in PROC) (
    idle[p] = cap[p] - used[p]
  );

constraint
  x[1] >= min_A;

constraint
  profit = sum(i in PROD)(price[i] * x[i])
           - sum(p in PROC)(cost[p] * used[p]);

constraint
  profit >= profit_target;

constraint
  weighted_idle = sum(p in PROC)(cost[p] * idle[p]);

% Objective
solve maximize profit;