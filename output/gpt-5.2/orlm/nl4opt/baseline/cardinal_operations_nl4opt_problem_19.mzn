% Repairman scheduling / profit maximization

% Data (embedded)
int: insp_wash = 30;
int: fix_wash  = 90;
int: insp_free = 20;
int: fix_free  = 125;

int: insp_cap = 5000;
int: time_cap = 20000;

int: profit_wash = 250;
int: profit_free = 375;

% Decision variables
var 0..insp_cap div insp_wash: washing;
var 0..insp_cap div insp_free: freezer;

% Constraints
constraint insp_wash * washing + insp_free * freezer <= insp_cap;
constraint fix_wash  * washing + fix_free * freezer <= time_cap;

% Objective
var int: earnings = profit_wash * washing + profit_free * freezer;
solve maximize earnings;

output [
  "washing_machines=", show(washing), "\n",
  "freezers=", show(freezer), "\n",
  "earnings=$", show(earnings), "\n"
];