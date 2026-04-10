% Snow remover hiring optimization (all data embedded)

int: hours_needed = 300;
int: budget = 6500;

int: hours_seasonal = 6;
int: pay_seasonal = 120;

int: hours_permanent = 10;
int: pay_permanent = 250;

% Decision variables: number of workers of each type
var 0..ceil(hours_needed div hours_seasonal) + 100: seasonal;
var 0..ceil(hours_needed div hours_permanent) + 100: permanent;

% Constraints
constraint hours_seasonal * seasonal + hours_permanent * permanent >= hours_needed;
constraint pay_seasonal * seasonal + pay_permanent * permanent <= budget;

% Objective: minimize total number of snow removers
solve minimize seasonal + permanent;

output [
  "seasonal=", show(seasonal), "\n",
  "permanent=", show(permanent), "\n",
  "total_workers=", show(seasonal + permanent), "\n",
  "total_hours=", show(hours_seasonal * seasonal + hours_permanent * permanent), "\n",
  "total_cost=", show(pay_seasonal * seasonal + pay_permanent * permanent), "\n"
];