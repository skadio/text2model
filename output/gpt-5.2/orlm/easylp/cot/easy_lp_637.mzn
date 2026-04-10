% Parameters (with values embedded)
int: min_teacher = 1500;
int: min_classroom = 500;
int: min_textbook = 200;
int: min_online = 100;

int: min_teacher_plus_classroom = 3000;
int: max_textbook_minus_online = 500;
int: max_total_allocation = 5000;
int: min_teacher_minus_classroom = 1000;

int: cost_teacher = 5;
int: cost_classroom = 2;
int: cost_textbook = 3;
int: cost_online = 1;

% Variables
var min_teacher..max_total_allocation: teacher;
var min_classroom..max_total_allocation: classroom;
var min_textbook..max_total_allocation: textbook;
var min_online..max_total_allocation: online;

var 0..(cost_teacher*max_total_allocation
      + cost_classroom*max_total_allocation
      + cost_textbook*max_total_allocation
      + cost_online*max_total_allocation): total_cost;

% Constraints
constraint teacher + classroom >= min_teacher_plus_classroom;
constraint textbook - online <= max_textbook_minus_online;
constraint teacher + classroom + textbook + online <= max_total_allocation;
constraint teacher - classroom >= min_teacher_minus_classroom;

constraint total_cost = cost_teacher * teacher
                      + cost_classroom * classroom
                      + cost_textbook * textbook
                      + cost_online * online;

% Objective
solve minimize total_cost;

output [
  "teacher = ", show(teacher), "\n",
  "classroom = ", show(classroom), "\n",
  "textbook = ", show(textbook), "\n",
  "online = ", show(online), "\n",
  "minimum_total_cost = ", show(total_cost), "\n"
];