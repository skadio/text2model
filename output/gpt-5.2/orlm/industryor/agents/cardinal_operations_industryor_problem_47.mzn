% Parameters
% Processing times (hours per unit)
int: time_I_A = 4;
int: time_I_B = 6;
int: time_II_A = 3;
int: time_II_B = 2;

% Regular profits (yuan per unit)
int: profit_A = 300;
int: profit_B = 450;

% Process capacities (hours per week)
int: cap_I = 150;          % Process I must be exactly fully used
int: cap_II = 70;          % Regular capacity for Process II
int: max_overtime_II = 30; % Maximum overtime allowed for Process II

% Profit reductions in overtime (yuan per unit)
int: overtime_penalty_A = 20;
int: overtime_penalty_B = 25;

% Business requirements
int: min_profit = 10000;
int: min_A = 10;
int: min_B = 15;

% Upper bounds derived from capacities (for bounded decision variables)
int: max_A_by_I  = cap_I div time_I_A;
int: max_B_by_I  = cap_I div time_I_B;
int: max_A_by_II = (cap_II + max_overtime_II) div time_II_A;
int: max_B_by_II = (cap_II + max_overtime_II) div time_II_B;

int: max_A = min(max_A_by_I, max_A_by_II);
int: max_B = min(max_B_by_I, max_B_by_II);

% Variables
% Units produced (total) per week
var min_A..max_A: units_A; % total units of model A
var min_B..max_B: units_B; % total units of model B

% Split production into regular-time and overtime for Process II (profit differs in overtime)
var 0..max_A: reg_A;       % model A units processed in regular time for Process II
var 0..max_B: reg_B;       % model B units processed in regular time for Process II
var 0..max_A: ot_A;        % model A units processed in overtime for Process II
var 0..max_B: ot_B;        % model B units processed in overtime for Process II

% Process II overtime hours used
var 0..max_overtime_II: overtime_hours_II;

% Total profit
var min_profit..(profit_A * max_A + profit_B * max_B): total_profit;

% Constraints
%--- Production split consistency (total units = regular + overtime) ---
constraint units_A = reg_A + ot_A;
constraint units_B = reg_B + ot_B;

%--- Process I usage must be exactly 150 hours (fully utilized) ---
constraint time_I_A * units_A + time_I_B * units_B = cap_I;

%--- Process II regular capacity limit (regular-time hours cannot exceed 70) ---
constraint time_II_A * reg_A + time_II_B * reg_B <= cap_II;

%--- Process II overtime hours definition (overtime hours equal overtime units' hours) ---
constraint overtime_hours_II = time_II_A * ot_A + time_II_B * ot_B;

%--- Process II overtime limit (at most 30 hours) ---
constraint overtime_hours_II <= max_overtime_II;

%--- Total profit computation with overtime penalties ---
constraint total_profit =
    profit_A * reg_A
  + profit_B * reg_B
  + (profit_A - overtime_penalty_A) * ot_A
  + (profit_B - overtime_penalty_B) * ot_B;

%--- Minimum profit requirement ---
constraint total_profit >= min_profit;

% Objective
solve maximize total_profit;