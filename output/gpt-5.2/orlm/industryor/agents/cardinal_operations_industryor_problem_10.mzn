% Parameters
% Product types: 1 = Type A, 2 = Type B
int: nProducts = 2;
set of int: PRODUCTS = 1..nProducts;

% Process types: 1 = Manufacturing, 2 = Assembly, 3 = Inspection
int: nProcesses = 3;
set of int: PROCESSES = 1..nProcesses;

% Time required (hours/unit) for each product in each process
% rows = products (A,B), cols = processes (Mfg, Asm, Insp)
array[PRODUCTS, PROCESSES] of int: timePerUnit =
  array2d(PRODUCTS, PROCESSES,
    [ 20, 5, 3,   % Type A
      0,  7, 6 ]  % Type B
  );

% Weekly capacity available for each process (hours/week)
array[PROCESSES] of int: capacity = [120, 80, 40];

% Hourly process cost weights (Yuan/hour), used to weight idle time
array[PROCESSES] of int: processCost = [12, 8, 10];

% Selling price per unit (Yuan/unit)
array[PRODUCTS] of int: sellPrice = [650, 725];

% Minimum weekly profit requirement (Yuan/week)
int: minProfit = 3000;

% Minimum production requirement for Type A (units/week)
int: minTypeA = 5;


% Variables
% Production quantities (units/week)
array[PRODUCTS] of var 0..1000000: x;  % x[1]=Type A, x[2]=Type B

% Idle hours per process (hours/week), overtime not allowed so idle >= 0
array[PROCESSES] of var 0..1000000: idle;

% Total weekly profit (Yuan/week)
var 0..1000000000: profit;

% Total weighted idle cost (Yuan/week) to be minimized (p3)
var 0..1000000000: weightedIdle;


% Constraints
% --- Process capacity and idle-time accounting (no overtime) ---
constraint forall(pr in PROCESSES) (
  sum(p in PRODUCTS)(timePerUnit[p, pr] * x[p]) <= capacity[pr]
);

constraint forall(pr in PROCESSES) (
  idle[pr] = capacity[pr] - sum(p in PRODUCTS)(timePerUnit[p, pr] * x[p])
);

constraint forall(pr in PROCESSES) (
  idle[pr] >= 0
);

% --- Minimum production requirement for Type A (p2) ---
constraint x[1] >= minTypeA;

% --- Profit definition and minimum profit requirement (p1) ---
constraint profit = sum(p in PRODUCTS)(sellPrice[p] * x[p]);
constraint profit >= minProfit;

% --- Weighted idle-time measure (p3) ---
constraint weightedIdle = sum(pr in PROCESSES)(processCost[pr] * idle[pr]);


% Objective
% Maximize profit first, then (among max-profit solutions) minimize weighted idle time
solve lexicographic [ maximize profit, minimize weightedIdle ];

output [
  "x_TypeA = ", show(x[1]), "\n",
  "x_TypeB = ", show(x[2]), "\n",
  "profit = ", show(profit), "\n",
  "idle_mfg = ", show(idle[1]), "\n",
  "idle_asm = ", show(idle[2]), "\n",
  "idle_insp = ", show(idle[3]), "\n",
  "weightedIdle = ", show(weightedIdle), "\n"
];