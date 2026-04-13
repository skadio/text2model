% Resource allocation cost minimization for an educational institution

% Parameters (embedded from the problem description)
int: cost_teacher = 5000;
int: cost_staff   = 3000;
int: cost_room    = 200;

int: min_teachers = 5;
int: min_staff    = 2;
int: min_rooms    = 1;

int: max_teacher_staff = 100;

% Decision variables
var min_teachers..max_teacher_staff: teachers;
var min_staff..max_teacher_staff: staff;
var min_rooms..max_teacher_staff: rooms; % rooms can't exceed teachers+staff cap meaningfully

% Constraints
% For every classroom, at least one teacher
constraint teachers >= rooms;

% For every classroom, at least two staff
constraint staff >= 2 * rooms;

% Total teachers and staff cannot exceed 100
constraint teachers + staff <= max_teacher_staff;

% Objective: minimize total cost
var int: total_cost = cost_teacher * teachers + cost_staff * staff + cost_room * rooms;

solve minimize total_cost;

output [
  "teachers = ", show(teachers), "\n",
  "staff = ", show(staff), "\n",
  "classrooms = ", show(rooms), "\n",
  "minimum_total_cost = $", show(total_cost), "\n"
];