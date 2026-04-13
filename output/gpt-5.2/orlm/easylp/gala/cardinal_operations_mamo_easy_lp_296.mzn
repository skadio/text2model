% School hiring cost minimization (all data embedded)

include "globals.mzn";

% Data (from problem statement)
int: min_teachers   = 5;
int: min_assistants = 3;
int: min_staff      = 2;
int: max_total_hires = 15;

int: cost_teacher   = 20;
int: cost_assistant = 10;
int: cost_staff     = 5;

% Decision variables (whole-number hires)
var min_teachers..max_total_hires: teachers;
var min_assistants..max_total_hires: assistants;
var min_staff..max_total_hires: staff;

% Constraints
constraint teachers + assistants + staff <= max_total_hires;

% Objective: minimize total cost
var int: total_cost = cost_teacher * teachers
                    + cost_assistant * assistants
                    + cost_staff * staff;

solve minimize total_cost;

output [
  "teachers=", show(teachers), "\n",
  "assistants=", show(assistants), "\n",
  "staff=", show(staff), "\n",
  "total_hires=", show(teachers + assistants + staff), "\n",
  "min_total_cost=", show(total_cost), "\n"
];