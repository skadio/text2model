% Resource allocation / budgeting MILP in MiniZinc (all data embedded)

% Decision variables (integer allocations)
var int: teacher;     % teacher salaries
var int: classroom;   % classroom maintenance
var int: textbook;    % textbook costs
var int: online;      % online tools

% Minimum requirements
constraint teacher   >= 1500;
constraint classroom >= 500;
constraint textbook  >= 200;
constraint online    >= 100;

% Budget/relationship constraints
constraint teacher + classroom >= 3000;
constraint abs(textbook - online) <= 500;
constraint teacher + classroom + textbook + online <= 5000;
constraint teacher - classroom >= 1000;

% Objective: minimize total funding cost
% (cost coefficients: teacher 5, classroom 2, textbook 3, online 1)
var int: total_cost = 5*teacher + 2*classroom + 3*textbook + 1*online;

solve minimize total_cost;

output [
  "teacher = ", show(teacher), "\n",
  "classroom = ", show(classroom), "\n",
  "textbook = ", show(textbook), "\n",
  "online = ", show(online), "\n",
  "total_allocation = ", show(teacher + classroom + textbook + online), "\n",
  "minimum_total_cost = ", show(total_cost), "\n"
];