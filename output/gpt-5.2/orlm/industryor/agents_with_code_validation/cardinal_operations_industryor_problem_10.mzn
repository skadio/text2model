% Two-product motorcycle production planning (embedded data)

%----------------------------
% Sets / indices
%----------------------------
int: nProducts = 2;                      % A,B
set of int: PRODUCTS = 1..nProducts;

int: nProcesses = 3;                     % Manufacturing, Assembly, Inspection
set of int: PROCESSES = 1..nProcesses;

int: MFG  = 1;
int: ASM  = 2;
int: INSP = 3;

%----------------------------
% Data (from Table 3.2)
%----------------------------
array[PRODUCTS] of int: selling_price = [650, 725];     % Yuan/unit

array[PROCESSES] of int: capacity = [120, 80, 40];      % hours/week
array[PROCESSES] of int: process_cost = [12, 8, 10];    % Yuan/hour

% hours/unit by product (row) and process (col)
array[PRODUCTS, PROCESSES] of int: time_per_unit =
  array2d(PRODUCTS, PROCESSES,
    [ 20, 5, 3,      % Type A: MFG, ASM, INSP
      0,  7, 6 ]);   % Type B: MFG, ASM, INSP

int: min_profit = 3000;   % p1
int: min_xA = 5;          % p2

%----------------------------
% Derived bounds
%----------------------------
int: xA_ub = min([
  capacity[MFG]  div time_per_unit[1, MFG],
  capacity[ASM]  div time_per_unit[1, ASM],
  capacity[INSP] div time_per_unit[1, INSP]
]);

int: xB_ub = min([
  capacity[ASM]  div time_per_unit[2, ASM],
  capacity[INSP] div time_per_unit[2, INSP]
]);

%----------------------------
% Decision variables
%----------------------------
var 0..xA_ub: xA;
var 0..xB_ub: xB;

array[PROCESSES] of var 0..max(capacity): used_time;
array[PROCESSES] of var 0..max(capacity): idle_time;

var int: total_revenue;
var int: total_process_cost;
var int: profit;

%----------------------------
% Constraints
%----------------------------
constraint used_time[MFG]  = time_per_unit[1, MFG]  * xA + time_per_unit[2, MFG]  * xB;
constraint used_time[ASM]  = time_per_unit[1, ASM]  * xA + time_per_unit[2, ASM]  * xB;
constraint used_time[INSP] = time_per_unit[1, INSP] * xA + time_per_unit[2, INSP] * xB;

constraint forall(p in PROCESSES) (used_time[p] <= capacity[p]);

constraint forall(p in PROCESSES) (idle_time[p] = capacity[p] - used_time[p]);

constraint total_revenue = selling_price[1] * xA + selling_price[2] * xB;

constraint total_process_cost =
    process_cost[MFG]  * used_time[MFG]
  + process_cost[ASM]  * used_time[ASM]
  + process_cost[INSP] * used_time[INSP];

constraint profit = total_revenue - total_process_cost;

constraint profit >= min_profit;  % p1
constraint xA >= min_xA;          % p2

%----------------------------
% Objective (maximize profit)
%----------------------------
solve maximize profit;

%----------------------------
% Output
%----------------------------
output [
  "xA=", show(xA), " xB=", show(xB), "\n",
  "profit=", show(profit), "\n",
  "used_time=", show(used_time), "\n",
  "idle_time=", show(idle_time), "\n"
];