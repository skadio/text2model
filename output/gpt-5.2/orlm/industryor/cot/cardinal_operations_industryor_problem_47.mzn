% Parameters (with values embedded)
int: nModels = 2;
set of int: MODELS = 1..nModels;
int: A = 1;
int: B = 2;

array[MODELS] of int: time_I = [4, 6];          % hours/unit in Process I
array[MODELS] of int: time_II = [3, 2];         % hours/unit in Process II
array[MODELS] of int: profit_reg = [300, 450];  % yuan/unit (regular time)

int: cap_I = 150;    % weekly capacity Process I (hours)
int: cap_II = 70;    % weekly regular capacity Process II (hours)
int: maxOT_II = 30;  % max overtime Process II (hours)

int: minProfit = 10000;
int: minA = 10;
int: minB = 15;

array[MODELS] of int: profit_penalty_ot = [20, 25]; % yuan/unit reduction if produced in overtime

% Upper bounds for production (safe bounds derived from capacities/minimums)
int: maxA = 50;  % e.g., bounded by I: floor(150/4)=37, but allow slack via constraints anyway
int: maxB = 50;

% Variables
var 0..maxA: xA;                 % units of model A produced (total)
var 0..maxB: xB;                 % units of model B produced (total)

var 0..maxA: xA_ot;              % units of A produced using overtime in Process II
var 0..maxB: xB_ot;              % units of B produced using overtime in Process II

var 0..maxOT_II: ot_II;          % overtime hours used in Process II

% Constraints
% Minimum production (p2)
constraint xA >= minA;
constraint xB >= minB;

% Link overtime-produced units cannot exceed total units
constraint xA_ot <= xA;
constraint xB_ot <= xB;

% Process I usage must be exactly 150 hours (p3)
constraint time_I[A]*xA + time_I[B]*xB = cap_I;

% Process II: regular capacity fully utilized; overtime allowed up to 30 hours (p3, p4)
% Total Process II time = regular capacity + overtime
constraint time_II[A]*xA + time_II[B]*xB = cap_II + ot_II;

% Overtime hours correspond to overtime-produced units in Process II
constraint time_II[A]*xA_ot + time_II[B]*xB_ot = ot_II;

% Profit requirement (p1), accounting for reduced profit on overtime-produced units (p4)
var int: total_profit =
  profit_reg[A]*xA + profit_reg[B]*xB
  - profit_penalty_ot[A]*xA_ot - profit_penalty_ot[B]*xB_ot;

constraint total_profit >= minProfit;

% Objective
% Not explicitly given beyond meeting goals; maximize total profit under the goals.
solve maximize total_profit;