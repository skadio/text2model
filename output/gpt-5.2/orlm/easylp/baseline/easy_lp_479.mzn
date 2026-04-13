% Resource allocation: minimize annual cost of teachers and classrooms

int: teacher_cost = 5000;
int: classroom_cost = 3000;

% Decision variables (nonnegative integers)
var 0..1000: T; % number of teachers
var 0..1000: C; % number of classrooms

% Constraints
constraint T >= C;                 % at least as many teachers as classrooms
constraint 30*T - C >= 0;          % teaching quality constraint
constraint 20*T + C >= 100;        % minimum requirement

% Objective: minimize total annual cost
var int: total_cost = teacher_cost*T + classroom_cost*C;
solve minimize total_cost;

output [
  "Teachers = ", show(T), "\n",
  "Classrooms = ", show(C), "\n",
  "Minimum total annual cost (USD) = ", show(total_cost), "\n"
];