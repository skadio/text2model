% Goal programming model for textile factory production planning
% All data embedded

%--------------------------
% Parameters
%--------------------------
int: hours_available = 110;
int: overtime_limit = 10;

int: rate_m_per_hour = 1000;

int: min_curtain_m = 70000;
int: min_clothing_m = 45000;

float: profit_curtain = 2.5;
float: profit_clothing = 1.5;

%--------------------------
% Decision variables
%--------------------------
var 0..1000: hours_curtain;   % production hours for curtain fabric
var 0..1000: hours_clothing;  % production hours for clothing fabric

var 0..1000: overtime;        % overtime hours

% Deviational variables for goal constraints
var 0..1000000: d1_minus; var 0..1000000: d1_plus;   % for full use of 110 hours
var 0..1000000: d2_plus;                              % overtime exceeding 10
var 0..1000000: d3c_minus;                            % curtain sales shortfall
var 0..1000000: d3l_minus;                            % clothing sales shortfall

% Derived production/sales (assume all produced is sold up to demand; goals enforce minimums)
var 0..1000000000: curtain_m;
var 0..1000000000: clothing_m;

%--------------------------
% Linking constraints
%--------------------------
constraint curtain_m  = rate_m_per_hour * hours_curtain;
constraint clothing_m = rate_m_per_hour * hours_clothing;

% Total hours with overtime: hours_curtain + hours_clothing = hours_available + overtime
constraint hours_curtain + hours_clothing = hours_available + overtime;

%--------------------------
% Goals (as equations with deviational variables)
%--------------------------

% p1: Weekly production time must fully utilize 110 hours
% Interpret as: total scheduled hours should be exactly 110 (without counting overtime),
% i.e., (hours_curtain + hours_clothing) - overtime = 110.
constraint (hours_curtain + hours_clothing - overtime) + d1_minus - d1_plus = hours_available;

% p2: Overtime should not exceed 10 hours per week (penalize only excess)
constraint overtime - overtime_limit <= d2_plus;

% p3: At least 70,000 m curtain and 45,000 m clothing must be sold (penalize shortfalls)
constraint curtain_m  + d3c_minus >= min_curtain_m;
constraint clothing_m + d3l_minus >= min_clothing_m;

%--------------------------
% Lexicographic objective for priorities p1 > p2 > p3 > p4
% Implemented as a single weighted sum with big-M style scaling.
% p1: minimize deviation from fully using 110 hours: (d1_minus + d1_plus)
% p2: minimize overtime excess beyond 10: d2_plus
% p3: minimize sales shortfalls: (d3c_minus + d3l_minus)
% p4: minimize overtime itself: overtime
%--------------------------
int: M1 = 1000000000;
int: M2 = 1000000;
int: M3 = 1000;

var int: objective =
    M1 * (d1_minus + d1_plus) +
    M2 * d2_plus +
    M3 * (d3c_minus + d3l_minus) +
    overtime;

solve minimize objective;

%--------------------------
% Reporting
%--------------------------
output [
  "hours_curtain = ", show(hours_curtain), "\n",
  "hours_clothing = ", show(hours_clothing), "\n",
  "overtime = ", show(overtime), "\n",
  "curtain_m = ", show(curtain_m), "\n",
  "clothing_m = ", show(clothing_m), "\n",
  "profit = ", show(profit_curtain * int2float(curtain_m) + profit_clothing * int2float(clothing_m)), "\n",
  "deviations: d1-=", show(d1_minus), " d1+=", show(d1_plus),
  " d2+=", show(d2_plus),
  " d3c-=", show(d3c_minus), " d3l-=", show(d3l_minus), "\n",
  "objective = ", show(objective), "\n"
];