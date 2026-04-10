% Goal programming model for shoe store staffing/overtime
% Data is embedded as requested.

include "globals.mzn";

%--------------------------
% Data
%--------------------------
int: nF = 5;                      % full-time clerks
int: nP = 4;                      % part-time clerks

int: baseHoursF = 160;
int: baseHoursP = 80;

int: volF = 5;                    % pairs/hour
int: volP = 2;

float: wageF = 1.0;               % yuan/hour (regular)
float: wageP = 0.6;

float: otWageF = 1.5;             % yuan/hour (overtime)
float: otWageP = 0.7;

float: profitPerPair = 0.3;

int: targetSales = 5500;

% Upper bound for overtime hours (large enough, keeps domains finite)
int: maxOT = 2000;

%--------------------------
% Decision variables
%--------------------------
array[1..nF] of var 0..maxOT: otF;     % overtime hours for each full-time clerk
array[1..nP] of var 0..maxOT: otP;     % overtime hours for each part-time clerk

% Goal-programming deviation variables (nonnegative)
var 0..1000000: d1_minus;              % shortfall from sales goal
var 0..1000000: d1_plus;               % surplus over sales goal (not penalized here, but kept for balance)

%--------------------------
% Derived quantities
%--------------------------
var 0..1000000: salesPairs =
    sum(i in 1..nF)(volF * (baseHoursF + otF[i])) +
    sum(j in 1..nP)(volP * (baseHoursP + otP[j]));

var 0..1000000: totalOT = sum(i in 1..nF)(otF[i]) + sum(j in 1..nP)(otP[j]);

var float: totalProfit =
    profitPerPair * int2float(salesPairs)
  - ( wageF * int2float(nF * baseHoursF) + wageP * int2float(nP * baseHoursP)
    + otWageF * int2float(sum(i in 1..nF)(otF[i]))
    + otWageP * int2float(sum(j in 1..nP)(otP[j])) );

%--------------------------
% Constraints (Goals)
%--------------------------

% p1: Achieve monthly sales of 5500 pairs (goal equation with deviations)
constraint salesPairs + d1_minus - d1_plus = targetSales;

% p2: Full employment of all clerks is ensured by fixing base hours per clerk.
% (All clerks work their regular monthly hours; overtime is optional.)

% p3: Minimize overtime hours (handled in objective).

%--------------------------
% Lexicographic goal programming objective:
% 1) minimize sales shortfall d1_minus
% 2) then minimize total overtime hours
% Implemented by a large weight M.
%--------------------------
int: M = 1000000;  % big-M to enforce priority of p1 over p3
solve minimize M * d1_minus + totalOT;

%--------------------------
% Output
%--------------------------
output [
  "Overtime full-time (hours) = ", show(otF), "\n",
  "Overtime part-time (hours) = ", show(otP), "\n",
  "Sales (pairs) = ", show(salesPairs), "\n",
  "Sales shortfall d1_minus = ", show(d1_minus), "\n",
  "Sales surplus  d1_plus  = ", show(d1_plus), "\n",
  "Total overtime = ", show(totalOT), "\n",
  "Total profit (yuan) = ", show(totalProfit), "\n"
];