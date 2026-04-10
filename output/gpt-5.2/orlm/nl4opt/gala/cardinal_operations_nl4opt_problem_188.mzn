% Furnace purchasing optimization (all data embedded)

include "globals.mzn";

% Data
int: heat_new = 10;      % apartments heated by one new furnace
int: heat_old = 15;      % apartments heated by one old furnace
int: kwh_new  = 200;     % kWh/day consumed by one new furnace
int: kwh_old  = 250;     % kWh/day consumed by one old furnace

int: min_apartments = 200;
int: max_kwh = 3500;

int: min_new = 5;        % at least 5 new furnaces
float: max_old_frac = 0.35; % at most 35% of furnaces are old

% Safe upper bounds (energy is the tightest here)
int: max_total = max_kwh div min(kwh_new, kwh_old);  % <= 17

% Decision variables
var 0..max_total: new_cnt;
var 0..max_total: old_cnt;

% Constraints
constraint new_cnt >= min_new;
constraint heat_new * new_cnt + heat_old * old_cnt >= min_apartments;
constraint kwh_new * new_cnt + kwh_old * old_cnt <= max_kwh;

% old_cnt <= 0.35 * (new_cnt + old_cnt)
% Multiply by 100 to avoid floats: 100*old <= 35*(new+old) -> 65*old <= 35*new
constraint 65 * old_cnt <= 35 * new_cnt;

% Objective: minimize total furnaces
solve minimize new_cnt + old_cnt;

output [
  "new_furnaces = ", show(new_cnt), "\n",
  "old_furnaces = ", show(old_cnt), "\n",
  "total_furnaces = ", show(new_cnt + old_cnt), "\n",
  "apartments_heated = ", show(heat_new * new_cnt + heat_old * old_cnt), "\n",
  "kwh_used = ", show(kwh_new * new_cnt + kwh_old * old_cnt), "\n"
];