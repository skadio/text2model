% Hiring teachers and assistants to meet teaching load at minimum cost

int: teacher_cost = 3000;
int: assistant_cost = 1000;

int: teacher_effort = 25;
int: assistant_effort = 10;
int: required_effort = 500;

int: max_diff = 20;

var 0..1000: teachers;
var 0..1000: assistants;

constraint teacher_effort * teachers + assistant_effort * assistants >= required_effort;
constraint abs(teachers - assistants) <= max_diff;

var int: total_cost = teacher_cost * teachers + assistant_cost * assistants;

solve minimize total_cost;

output [
  "teachers=", show(teachers), "\n",
  "assistants=", show(assistants), "\n",
  "total_cost=", show(total_cost), "\n"
];