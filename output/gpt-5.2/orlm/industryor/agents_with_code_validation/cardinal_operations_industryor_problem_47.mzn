% Parameters
% Processing times (hours per unit) for each process and model
int: time_I_A  = 4;
int: time_I_B  = 6;
int: time_II_A = 3;
int: time_II_B = 2;

% Regular weekly capacity (hours) for each process
int: cap_I  = 150;
int: cap_II = 70;

% Base profit (yuan per unit) for each model (regular time)
int: profit_A = 300;
int: profit_B = 450;

% Business goals / requirements
int: min_profit = 10000;
int: min_A = 10;
int: min_B = 15;

% Overtime rules for Process II
int: max_overtime_II = 30;     % hours/week
int: overtime_penalty_A = 20;  % yuan/unit (profit reduction if produced in overtime)
int: overtime_penalty_B = 25;  % yuan/unit (profit reduction if produced in overtime)

% Useful derived bounds (safe upper bounds for search domains)
int: maxA_by_I  = cap_I div time_I_A;                               % 37
int: maxB_by_I  = cap_I div time_I_B;                               % 25
int: maxA_by_II_total = (cap_II + max_overtime_II) div time_II_A;   % 33
int: maxB_by_II_total = (cap_II + max_overtime_II) div time_II_B;   % 50


% Variables
% Units produced on regular time for Process II (and thus overall, since Process I is not split)
var min_A..maxA_by_I: xA_reg;   % model A units produced using regular Process II time
var min_B..maxB_by_I: xB_reg;   % model B units produced using regular Process II time

% Units produced that require overtime in Process II
var 0..maxA_by_II_total: xA_ot; % model A units produced using overtime Process II time
var 0..maxB_by_II_total: xB_ot; % model B units produced using overtime Process II time

% Total units produced of each model
var min_A..(maxA_by_I + maxA_by_II_total): xA; % total A units
var min_B..(maxB_by_I + maxB_by_II_total): xB; % total B units

% Process usage (hours)
var 0..cap_I: used_I;                             % hours used in Process I (exactly cap_I)
var 0..cap_II: used_II_reg;                       % regular hours used in Process II
var 0..max_overtime_II: used_II_ot;               % overtime hours used in Process II
var 0..(cap_II + max_overtime_II): used_II_total; % total hours used in Process II

% Profit (yuan)
var 0..(profit_A*(maxA_by_I + maxA_by_II_total) + profit_B*(maxB_by_I + maxB_by_II_total)): total_profit;


% Constraints

% --- Production composition (link total units to regular + overtime for Process II) ---
constraint xA = xA_reg + xA_ot;
constraint xB = xB_reg + xB_ot;

% --- Process I capacity and exact utilization (p3) ---
% All produced units require Process I time; must be exactly cap_I hours.
constraint used_I = time_I_A * xA + time_I_B * xB;
constraint used_I = cap_I;

% --- Process II time accounting (regular vs overtime) ---
% Regular-time Process II hours correspond to regular units; must not exceed regular capacity.
constraint used_II_reg = time_II_A * xA_reg + time_II_B * xB_reg;
constraint used_II_reg <= cap_II;

% Overtime Process II hours correspond to overtime units; bounded by max overtime.
constraint used_II_ot = time_II_A * xA_ot + time_II_B * xB_ot;
constraint used_II_ot <= max_overtime_II;

% Total Process II hours
constraint used_II_total = used_II_reg + used_II_ot;

% --- Contract minimums (p2) ---
constraint xA >= min_A;
constraint xB >= min_B;

% --- Profit computation with overtime penalty (p4) and minimum profit goal (p1) ---
% Units produced in overtime earn reduced profit.
constraint
  total_profit =
      profit_A * xA + profit_B * xB
    - overtime_penalty_A * xA_ot
    - overtime_penalty_B * xB_ot;

constraint total_profit >= min_profit;


% Objective
solve maximize total_profit;