% Hiring optimization: minimize total cost subject to staffing requirements
var int: teachers;
var int: assistants;
var int: staff;

constraint teachers >= 5;
constraint assistants >= 3;
constraint staff >= 2;

constraint teachers + assistants + staff <= 15;

var int: total_cost = 20 * teachers + 10 * assistants + 5 * staff;

solve minimize total_cost;

output [
  "teachers=", show(teachers), "\n",
  "assistants=", show(assistants), "\n",
  "staff=", show(staff), "\n",
  "total_cost=", show(total_cost), "\n"
];