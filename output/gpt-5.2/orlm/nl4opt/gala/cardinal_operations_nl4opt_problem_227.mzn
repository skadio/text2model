% Fire department staffing (no external data; all embedded)

% Data
int: hours_needed = 300;
int: budget = 7000;

int: reg_hours = 10;
int: reg_cost  = 300;

int: eme_hours = 6;
int: eme_cost  = 100;

% Decision variables: number of regular and emergency fire fighters
var 0..(budget div reg_cost): regular;
var 0..(budget div eme_cost): emergency;

% Constraints
constraint reg_hours * regular + eme_hours * emergency >= hours_needed;
constraint reg_cost  * regular + eme_cost  * emergency <= budget;

% Objective: minimize total number of fire fighters
var 0..(budget div 100): total = regular + emergency;
solve minimize total;

output [
  "regular = ", show(regular), "\n",
  "emergency = ", show(emergency), "\n",
  "total = ", show(total), "\n",
  "hours = ", show(reg_hours*regular + eme_hours*emergency), "\n",
  "cost = ", show(reg_cost*regular + eme_cost*emergency), "\n"
];