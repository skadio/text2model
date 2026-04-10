% Textile factory production planning (two products, two shifts)
% All data embedded as requested.

include "globals.mzn";

% ----------------------------
% Data (from problem statement)
% ----------------------------
int: regular_hours = 110;          % weekly production time to be fully utilized
int: max_overtime  = 10;           % overtime should not exceed 10 hours/week

int: rate_m_per_h  = 1000;         % meters produced per hour (both products)

int: min_curtain_m = 70000;        % minimum weekly sales demand
int: min_clothing_m = 45000;

float: profit_curtain = 2.5;       % yuan per meter
float: profit_clothing = 1.5;

% ----------------------------
% Decision variables
% ----------------------------
var 0..regular_hours + max_overtime: total_hours;  % total production hours in week
var 0..max_overtime: overtime;                     % overtime hours

% Production split in hours (integer hours)
var 0..regular_hours + max_overtime: h_curtain;
var 0..regular_hours + max_overtime: h_clothing;

% Derived weekly output in meters
var 0..(regular_hours + max_overtime) * rate_m_per_h: m_curtain;
var 0..(regular_hours + max_overtime) * rate_m_per_h: m_clothing;

% Profit (not an objective here; computed for reporting)
var float: profit;

% ----------------------------
% Constraints (priorities p1-p3)
% ----------------------------

% p1: fully utilize 110 regular hours (i.e., total hours = 110 + overtime)
constraint total_hours = regular_hours + overtime;

% Flow conservation: total time split between the two fabrics
constraint h_curtain + h_clothing = total_hours;

% Production at fixed rate
constraint m_curtain  = h_curtain  * rate_m_per_h;
constraint m_clothing = h_clothing * rate_m_per_h;

% p2: overtime should not exceed 10 hours/week (hard constraint)
constraint overtime <= max_overtime;

% p3: meet minimum sales requirements (hard constraints)
constraint m_curtain  >= min_curtain_m;
constraint m_clothing >= min_clothing_m;

% Profit calculation (for output)
constraint profit = profit_curtain * int2float(m_curtain)
                  + profit_clothing * int2float(m_clothing);

% ----------------------------
% Objective (p4)
% ----------------------------
% p4: minimize overtime as much as possible
solve minimize overtime;

% ----------------------------
% Output
% ----------------------------
output [
  "Overtime(hours) = ", show(overtime), "\n",
  "Total hours     = ", show(total_hours), "\n",
  "Curtain hours   = ", show(h_curtain), "  -> meters: ", show(m_curtain), "\n",
  "Clothing hours  = ", show(h_clothing), "  -> meters: ", show(m_clothing), "\n",
  "Profit(yuan)    = ", show(profit), "\n"
];