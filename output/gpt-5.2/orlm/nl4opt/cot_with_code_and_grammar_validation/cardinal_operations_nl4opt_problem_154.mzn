% Parameters
int: reg_capacity = 500;
int: reg_pollution = 200;

int: hyb_capacity = 300;
int: hyb_pollution = 100;

int: max_pollution = 7000;
int: min_packages = 20000;

% Upper bounds derived from requirements (safe finite bounds)
int: max_reg = (min_packages + reg_capacity - 1) div reg_capacity;
int: max_hyb = (min_packages + hyb_capacity - 1) div hyb_capacity;

% Variables
var 0..max_reg: reg_vans;
var 0..max_hyb: hyb_vans;

% Constraints
constraint
  reg_capacity * reg_vans + hyb_capacity * hyb_vans >= min_packages;

constraint
  reg_pollution * reg_vans + hyb_pollution * hyb_vans <= max_pollution;

% Objective
solve minimize reg_vans + hyb_vans;