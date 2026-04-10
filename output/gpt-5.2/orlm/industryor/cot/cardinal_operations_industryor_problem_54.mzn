% Parameters (with values embedded)
int: N = 7;
set of int: Courses = 1..N;

% Course indices
int: Calculus = 1;
int: OperationsResearch = 2;
int: DataStructures = 3;
int: ManagementStatistics = 4;
int: ComputerSimulation = 5;
int: ComputerProgramming = 6;
int: Forecasting = 7;

% Category membership (1 if course counts toward category)
array[Courses] of int: isMath = [
  1,  % Calculus
  1,  % Operations Research (also Math)
  1,  % Data Structures (also Math)
  1,  % Management Statistics (also Math)
  0,  % Computer Simulation
  0,  % Computer Programming
  1   % Forecasting (also Math)
];

array[Courses] of int: isOR = [
  0,  % Calculus
  1,  % Operations Research
  0,  % Data Structures
  1,  % Management Statistics (also OR)
  1,  % Computer Simulation (also OR)
  0,  % Computer Programming
  1   % Forecasting (also OR)
];

array[Courses] of int: isCS = [
  0,  % Calculus
  0,  % Operations Research
  1,  % Data Structures (also CS)
  0,  % Management Statistics
  1,  % Computer Simulation (also CS)
  1,  % Computer Programming
  0   % Forecasting
];

int: reqMath = 2;
int: reqOR   = 2;
int: reqCS   = 2;

% Variables
array[Courses] of var 0..1: take;  % take[c] = 1 if course c is taken

% Constraints
constraint sum(c in Courses)(isMath[c] * take[c]) >= reqMath;
constraint sum(c in Courses)(isOR[c]   * take[c]) >= reqOR;
constraint sum(c in Courses)(isCS[c]   * take[c]) >= reqCS;

% Prerequisites:
% Computer Simulation or Data Structures requires Computer Programming first
constraint take[ComputerSimulation] <= take[ComputerProgramming];
constraint take[DataStructures]     <= take[ComputerProgramming];

% Management Statistics requires Calculus first
constraint take[ManagementStatistics] <= take[Calculus];

% Forecasting requires Management Statistics first
constraint take[Forecasting] <= take[ManagementStatistics];

% Objective
solve minimize sum(c in Courses)(take[c]);

output [
  "Minimum number of courses = ", show(sum(c in Courses)(take[c])), "\n",
  "Courses taken:\n",
  if fix(take[Calculus]) = 1 then " - Calculus\n" else "" endif,
  if fix(take[OperationsResearch]) = 1 then " - Operations Research\n" else "" endif,
  if fix(take[DataStructures]) = 1 then " - Data Structures\n" else "" endif,
  if fix(take[ManagementStatistics]) = 1 then " - Management Statistics\n" else "" endif,
  if fix(take[ComputerSimulation]) = 1 then " - Computer Simulation\n" else "" endif,
  if fix(take[ComputerProgramming]) = 1 then " - Computer Programming\n" else "" endif,
  if fix(take[Forecasting]) = 1 then " - Forecasting\n" else "" endif
];