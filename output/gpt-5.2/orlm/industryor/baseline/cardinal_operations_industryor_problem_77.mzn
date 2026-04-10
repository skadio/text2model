% Goal Programming model for shoe store staffing with overtime
% Data embedded (no .dzn)

%-----------------------------
% Data
%-----------------------------
int: nF = 5;               % number of full-time clerks
int: nP = 4;               % number of part-time clerks

int: baseHoursF = 160;
int: baseHoursP = 80;

int: rateF = 5;            % pairs/hour
int: rateP = 2;

float: wageF = 1.0;        % yuan/hour
float: wageP = 0.6;

float: overtimeWageF = 1.5;
float: overtimeWageP = 0.7;

float: profitPerPair = 0.3;

int: salesTarget = 5500;

% A safe upper bound on overtime hours (can be adjusted)
int: maxOvertimePerClerk = 200;

% Big-M for goal constraints (not strictly needed here, but kept explicit)
int: M = 1000000;

%-----------------------------
% Decision variables
%-----------------------------
array[1..nF] of var 0..maxOvertimePerClerk: otF;   % overtime hours per full-time clerk
array[1..nP] of var 0..maxOvertimePerClerk: otP;   % overtime hours per part-time clerk

% Deviational variables for goals
% p1: sales target achievement (under/over)
var 0..M: d1_minus;  % shortfall in pairs
var 0..M: d1_plus;   % surplus in pairs

% p2: full employment of all clerks
% Interpreted as: do not underutilize contracted base hours.
% (Over base hours is captured as overtime and is handled in p3.)
var 0..M: d2F_minus; % total underemployment hours for full-time base hours (should be 0)
var 0..M: d2P_minus; % total underemployment hours for part-time base hours (should be 0)

% p3: minimize overtime hours (sum of overtime)
var 0..M: d3_plus;   % total overtime hours (to be minimized)

%-----------------------------
% Derived expressions
%-----------------------------
var int: totalSales =
    sum(i in 1..nF)(rateF * (baseHoursF + otF[i])) +
    sum(j in 1..nP)(rateP * (baseHoursP + otP[j]));

var int: totalBaseHoursF = nF * baseHoursF;
var int: totalBaseHoursP = nP * baseHoursP;

var int: totalOvertimeHours = sum(i in 1..nF)(otF[i]) + sum(j in 1..nP)(otP[j]);

var float: totalProfit =
    profitPerPair * int2float(totalSales);

var float: totalWageCost =
    wageF * int2float(totalBaseHoursF) +
    wageP * int2float(totalBaseHoursP) +
    overtimeWageF * sum(i in 1..nF)(int2float(otF[i])) +
    overtimeWageP * sum(j in 1..nP)(int2float(otP[j]));

%-----------------------------
% Goal constraints
%-----------------------------

% p1: Achieve monthly sales of 5500 pairs (goal equality with deviations)
constraint totalSales + d1_minus - d1_plus = salesTarget;

% p2: Ensure full employment of all sales clerks
% With only overtime as a decision, base hours are fixed; hence underemployment is forced to 0.
constraint totalBaseHoursF + d2F_minus = totalBaseHoursF;
constraint totalBaseHoursP + d2P_minus = totalBaseHoursP;

% p3: Minimize overtime hours
constraint totalOvertimeHours - d3_plus = 0;

%-----------------------------
% Lexicographic (preemptive) optimization:
% p1 highest priority, then p2, then p3.
% Implemented via weighted sum with sufficiently separated weights.
%-----------------------------
int: W1 = 1000000;
int: W2 = 1000;
int: W3 = 1;

solve minimize
    W1 * d1_minus +          % prioritize eliminating sales shortfall
    W2 * (d2F_minus + d2P_minus) +  % then eliminate underemployment
    W3 * d3_plus;            % finally minimize total overtime

%-----------------------------
% Output
%-----------------------------
output [
  "Total sales (pairs) = ", show(totalSales), "\n",
  "Sales shortfall d1- = ", show(d1_minus), " ; surplus d1+ = ", show(d1_plus), "\n",
  "Underemployment full-time hours d2F- = ", show(d2F_minus), "\n",
  "Underemployment part-time hours d2P- = ", show(d2P_minus), "\n",
  "Total overtime hours = ", show(totalOvertimeHours), "\n",
  "Overtime deviation d3+ = ", show(d3_plus), "\n",
  "Total profit (yuan) = ", show(totalProfit), "\n",
  "Total wage cost (yuan) = ", show(totalWageCost), "\n",
  "Full-time overtime per clerk = ", show(otF), "\n",
  "Part-time overtime per clerk = ", show(otP), "\n"
];