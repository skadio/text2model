include "globals.mzn";

/* Data (embedded from problem description) */
int: hv_gal = 10000;      % high-volume pipe capacity per day
int: lv_gal = 5000;       % low-volume pipe capacity per day
int: hv_tech = 12;        % technicians needed per high-volume pipe
int: lv_tech = 5;         % technicians needed per low-volume pipe

int: demand = 150000;     % minimum total gallons per day
int: tech_available = 160;

int: min_lv = 8;          % at least 8 low-volume pipes
int: max_hv_percent = 35; % at most 35% of pipes are high-volume

/* Decision variables */
var 0..1000: hv;          % number of high-volume pipes
var 0..1000: lv;          % number of low-volume pipes
var 0..2000: total = hv + lv;

/* Constraints */
constraint hv_gal * hv + lv_gal * lv >= demand;          % meet demand
constraint hv_tech * hv + lv_tech * lv <= tech_available; % technicians limit
constraint lv >= min_lv;                                  % minimum low-volume

% At most 35% high-volume: hv / (hv+lv) <= 0.35  -> 100*hv <= 35*(hv+lv)
constraint total > 0;
constraint 100 * hv <= max_hv_percent * total;

/* Objective: minimize total number of pipes */
solve minimize total;

/* Output */
output [
  "High-volume pipes (hv) = ", show(hv), "\n",
  "Low-volume pipes  (lv) = ", show(lv), "\n",
  "Total pipes           = ", show(total), "\n",
  "Total gallons/day     = ", show(hv_gal*hv + lv_gal*lv), "\n",
  "Technicians used      = ", show(hv_tech*hv + lv_tech*lv), "\n",
  "High-volume share (%) = ", show( (100.0 * int2float(hv)) / int2float(hv+lv) ), "\n"
];