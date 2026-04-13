% Parameters (with values embedded)
int: nModels = 2;
set of int: MODELS = 1..nModels;
int: A = 1;
int: B = 2;

array[MODELS] of int: profit = [300, 450];

int: nProc = 2;
set of int: PROCS = 1..nProc;
int: P1 = 1; % Process I
int: P2 = 2; % Process II

array[PROCS, MODELS] of int: timeReq = 
  [| 4, 6,   % Process I: A,B
     3, 2 |];% Process II: A,B

array[PROCS] of int: cap = [150, 70];

int: minProfit = 10000;
array[MODELS] of int: minProd = [10, 15];

% Variables
array[MODELS] of var 0..1000: x;                 % units produced (A,B), bounded sufficiently large
var int: totalProfit;
array[PROCS] of var 0..10000: usedTime;          % total hours used per process
var 0..10000: overtimeP2;                        % overtime allowed only for Process II

% Constraints
constraint forall(m in MODELS) (x[m] >= minProd[m]);

constraint totalProfit = sum(m in MODELS) (profit[m] * x[m]);
constraint totalProfit >= minProfit;

constraint forall(p in PROCS) (
  usedTime[p] = sum(m in MODELS) (timeReq[p,m] * x[m])
);

% p3: Process I exactly 150 hours
constraint usedTime[P1] = cap[P1];

% p3: Process II fully utilized, overtime allowed if necessary:
% usedTime[P2] = capacity + overtime, with overtime >= 0
constraint usedTime[P2] = cap[P2] + overtimeP2;

% Objective
solve maximize totalProfit;