% Goal Programming / Multi-objective model for the microcomputer production problem
% All data embedded.

%%%%%%%%%%%%
% DATA
%%%%%%%%%%%%
int: profitA = 300;
int: profitB = 450;

int: p1_profit_min = 10000;

int: minA = 10;
int: minB = 15;

int: t1A = 4;  int: t1B = 6;  int: cap1 = 150;   % Process I
int: t2A = 3;  int: t2B = 2;  int: cap2 = 70;    % Process II regular time

int: ot_cap2 = 30;                                % Process II max overtime

int: ot_penaltyA = 20;                            % profit reduction per OT unit
int: ot_penaltyB = 25;

% Big-M bounds for production variables (safe upper bounds from capacities)
int: UB_A = 1000;
int: UB_B = 1000;

%%%%%%%%%%%%
% DECISION VARIABLES
%%%%%%%%%%%%
var 0..UB_A: xA;     % total units of A produced
var 0..UB_B: xB;     % total units of B produced

% Split production into regular-time (process II within cap2) and overtime-driven part
% (Overtime applies only to process II; process I is fixed at 150 hours)
var 0..UB_A: xA_reg;
var 0..UB_B: xB_reg;
var 0..UB_A: xA_ot;
var 0..UB_B: xB_ot;

% Deviational variables (goal programming style)
% p1: profit >= 10000 (minimize shortfall)
var 0..1000000: d_profit_minus;

% p2: minimum productions (minimize shortfalls)
var 0..UB_A: d_A_minus;
var 0..UB_B: d_B_minus;

% p3: Process I exactly 150 (enforced as hard constraint), Process II ideally fully utilized
% For process II: regular time underuse is undesirable, overtime is allowed but undesirable.
var 0..cap2: d_proc2_under;     % unused regular capacity (cap2 - regular usage)
var 0..ot_cap2: h2_ot;          % overtime hours actually used in process II

% Derived expressions
var int: h1 = t1A*xA + t1B*xB;                          % process I hours
var int: h2_reg = t2A*xA_reg + t2B*xB_reg;              % process II regular hours
var int: h2_total = t2A*xA + t2B*xB;                    % total process II hours demand

% Profit with overtime penalties applied to overtime-produced units
var int: total_profit = profitA*xA + profitB*xB
                        - ot_penaltyA*xA_ot - ot_penaltyB*xB_ot;

%%%%%%%%%%%%
% CONSTRAINTS
%%%%%%%%%%%%
% Production splitting
constraint xA = xA_reg + xA_ot;
constraint xB = xB_reg + xB_ot;

% Process I must be exactly 150 hours (hard requirement)
constraint h1 = cap1;

% Process II capacity: regular-time + overtime
constraint h2_reg <= cap2;
constraint h2_ot <= ot_cap2;

% Overtime hours must cover any demand beyond regular usage
% (h2_total = h2_reg + h2_ot)
constraint h2_total = h2_reg + h2_ot;

% Profit goal: total_profit + d_minus >= 10000
constraint total_profit + d_profit_minus >= p1_profit_min;

% Minimum production goals: xA + d_minus >= minA, xB + d_minus >= minB
constraint xA + d_A_minus >= minA;
constraint xB + d_B_minus >= minB;

% Process II "ideally fully utilized": cap2 - h2_reg = underuse (minimize)
constraint d_proc2_under = cap2 - h2_reg;

%%%%%%%%%%%%
% OBJECTIVE (lexicographic / preemptive priorities)
%%%%%%%%%%%%
% Priority order:
%  1) satisfy profit threshold (minimize shortfall)
%  2) satisfy minimum contract quantities (minimize total shortfall)
%  3) fully utilize regular process II hours (minimize underuse) and avoid overtime (minimize overtime)
%
% Implemented as a weighted single objective with large multipliers.
int: W1 = 100000000;   % profit shortfall is highest priority
int: W2 = 100000;      % contract shortfalls next
int: W3 = 100;         % process II underuse next
int: W4 = 1;           % overtime last (still discouraged)

var int: objective =
    W1 * d_profit_minus
  + W2 * (d_A_minus + d_B_minus)
  + W3 * d_proc2_under
  + W4 * h2_ot;

solve minimize objective;

%%%%%%%%%%%%
% OUTPUT
%%%%%%%%%%%%
output [
  "xA=", show(xA), " (reg=", show(xA_reg), ", ot=", show(xA_ot), ")\n",
  "xB=", show(xB), " (reg=", show(xB_reg), ", ot=", show(xB_ot), ")\n",
  "Process I hours h1=", show(h1), " (must be 150)\n",
  "Process II regular hours h2_reg=", show(h2_reg), " / ", show(cap2), "\n",
  "Process II overtime hours h2_ot=", show(h2_ot), " / ", show(ot_cap2), "\n",
  "Total profit=", show(total_profit), "\n",
  "Deviations: profit_shortfall=", show(d_profit_minus),
  ", A_shortfall=", show(d_A_minus),
  ", B_shortfall=", show(d_B_minus),
  ", proc2_underuse=", show(d_proc2_under), "\n",
  "Objective=", show(objective), "\n"
];