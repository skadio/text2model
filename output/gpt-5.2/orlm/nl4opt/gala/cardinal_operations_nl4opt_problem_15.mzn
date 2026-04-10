include "globals.mzn";

% Data (embedded from problem statement)
int: demand = 320;                 % patients per day
int: cap_amb = 20;                 % patients per ambulance shift
int: cap_van = 15;                 % patients per van shift
int: cost_amb = 820;               % $ per ambulance shift
int: cost_van = 550;               % $ per van shift
int: max_van_pct = 60;             % at most 60% of shifts are vans

% Decision variables: number of shifts scheduled for each vehicle type
var 0..demand: amb_shifts;
var 0..demand: van_shifts;

% Total patients transported must meet demand
constraint cap_amb * amb_shifts + cap_van * van_shifts >= demand;

% Union limitation: van_shifts <= 60% of all shifts
% i.e., van_shifts <= 0.6 * (amb_shifts + van_shifts)
% Multiply to avoid fractions: 10*van <= 6*(amb+van) -> 4*van <= 6*amb
constraint 4 * van_shifts <= 6 * amb_shifts;

% Objective: minimize total cost
var int: total_cost = cost_amb * amb_shifts + cost_van * van_shifts;

solve minimize total_cost;

output [
  "Ambulance shifts = ", show(amb_shifts), "\n",
  "Van shifts       = ", show(van_shifts), "\n",
  "Total patients   = ", show(cap_amb*amb_shifts + cap_van*van_shifts), "\n",
  "Total cost       = $", show(total_cost), "\n"
];