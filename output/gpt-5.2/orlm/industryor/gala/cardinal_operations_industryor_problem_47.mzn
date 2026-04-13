% Factory microcomputer production planning with overtime and goal requirements
% All data embedded as requested.

include "globals.mzn";

%----------------------%
% Data (Table 3.1)
%----------------------%
int: t1A = 4;   % Process I hours per unit of A
int: t1B = 6;   % Process I hours per unit of B
int: cap1 = 150;

int: t2A = 3;   % Process II hours per unit of A
int: t2B = 2;   % Process II hours per unit of B
int: cap2 = 70;

int: profA = 300;
int: profB = 450;

int: minA = 10;
int: minB = 15;

int: minProfit = 10000;

int: otMax2 = 30;     % max overtime hours for Process II
int: penA = 20;       % profit reduction per unit produced in overtime (A)
int: penB = 25;       % profit reduction per unit produced in overtime (B)

%----------------------%
% Decision variables
%----------------------%
% Regular-time production (within standard capacities)
var 0..1000: A_reg;
var 0..1000: B_reg;

% Overtime production (only for Process II; uses extra Process II hours)
var 0..1000: A_ot;
var 0..1000: B_ot;

% Derived totals
var 0..2000: A = A_reg + A_ot;
var 0..2000: B = B_reg + B_ot;

% Overtime hours used in Process II
var 0..otMax2: ot2;

% Profit
var int: profit;

%----------------------%
% Constraints
%----------------------%

% p2: Contract minimums
constraint A >= minA;
constraint B >= minB;

% p3: Process I exactly fully utilized (150 hours)
constraint t1A * A + t1B * B = cap1;

% Process II: regular time limited, overtime allowed up to 30h
constraint t2A * A_reg + t2B * B_reg <= cap2;
constraint t2A * A_ot  + t2B * B_ot  = ot2;
constraint t2A * A + t2B * B = cap2 + ot2;

% p1: Profit requirement, with overtime penalty per unit produced in overtime
constraint profit =
    profA * A_reg + (profA - penA) * A_ot +
    profB * B_reg + (profB - penB) * B_ot;
constraint profit >= minProfit;

%----------------------%
% Objective
%----------------------%
% Since this is framed as a planning/goal model, maximize weekly profit
% while satisfying all requirements (including exact utilization of Process I).
solve maximize profit;

%----------------------%
% Output
%----------------------%
output [
  "A_reg=", show(A_reg), "  A_ot=", show(A_ot), "  A_total=", show(A), "\n",
  "B_reg=", show(B_reg), "  B_ot=", show(B_ot), "  B_total=", show(B), "\n",
  "Process I hours = ", show(t1A*A + t1B*B), " (must be ", show(cap1), ")\n",
  "Process II hours = ", show(t2A*A + t2B*B), " (cap ", show(cap2),
  " + overtime ", show(ot2), ", max ", show(otMax2), ")\n",
  "Profit = ", show(profit), "\n"
];