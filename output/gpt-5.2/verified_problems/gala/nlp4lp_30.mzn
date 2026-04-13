include "globals.mzn";

%----------------------------
% Input data (from .dzn)
%----------------------------
int: K;                                 % number of departments
int: L;                                 % number of locations (incl. London if applicable)
array[1..K, 1..L] of int: Benefit;      % Benefit[k,l] (thousands of pounds)
array[1..K, 1..K] of float: Communication; % communication quantity between departments
array[1..L, 1..L] of int: Cost;         % unit communication cost between locations (thousands)

%----------------------------
% Decision variables
%----------------------------
array[1..K] of var 1..L: loc;            % loc[k] = chosen location for department k

% At most 3 departments per location (global_cardinality hint)
array[1..L] of int: values = [i | i in 1..L];
array[1..L] of var 0..K: occ;
constraint global_cardinality(loc, values, occ);
constraint forall(l in 1..L)(occ[l] <= 3);

%----------------------------
% Objective components
%----------------------------

% Total benefit (maximize benefit == minimize negative benefit)
var int: totalBenefit =
  sum(k in 1..K)( Benefit[k, loc[k]] );

% Total communication cost:
% sum over ordered pairs (k,j): Communication[k,j] * Cost[loc[k], loc[j]]
% This can double-count if Communication is symmetric; we follow the given formula directly.
var float: totalCommCost =
  sum(k in 1..K, j in 1..K)(
    Communication[k,j] * int2float(Cost[loc[k], loc[j]])
  );

% Overall yearly cost = communication cost - benefit
var float: totalCost = totalCommCost - int2float(totalBenefit);

%----------------------------
% Solve
%----------------------------
solve minimize totalCost;

%----------------------------
% Output
%----------------------------
output [
  "loc = ", show(loc), "\n",
  "occ = ", show(occ), "\n",
  "totalBenefit = ", show(totalBenefit), "\n",
  "totalCommCost = ", show(totalCommCost), "\n",
  "totalCost = ", show(totalCost), "\n"
];