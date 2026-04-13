include "globals.mzn";

% Data (embedded as required)
int: pkg_reg = 500;
int: pol_reg = 200;

int: pkg_hyb = 300;
int: pol_hyb = 100;

int: max_pollution = 7000;
int: min_packages  = 20000;

% Decision variables: number of vans of each type
% Upper bounds derived from pollution limit (safe/tight bounds)
var 0..(max_pollution div pol_reg): reg_vans;
var 0..(max_pollution div pol_hyb): hyb_vans;

% Constraints
constraint pol_reg * reg_vans + pol_hyb * hyb_vans <= max_pollution;
constraint pkg_reg * reg_vans + pkg_hyb * hyb_vans >= min_packages;

% Objective: minimize total number of vans
var 0..(max_pollution div min(pol_reg, pol_hyb)): total_vans;
constraint total_vans = reg_vans + hyb_vans;

solve minimize total_vans;

output [
  "regular_vans = ", show(reg_vans), "\n",
  "hybrid_vans  = ", show(hyb_vans), "\n",
  "total_vans   = ", show(total_vans), "\n",
  "packages     = ", show(pkg_reg*reg_vans + pkg_hyb*hyb_vans), "\n",
  "pollution    = ", show(pol_reg*reg_vans + pol_hyb*hyb_vans), "\n"
];