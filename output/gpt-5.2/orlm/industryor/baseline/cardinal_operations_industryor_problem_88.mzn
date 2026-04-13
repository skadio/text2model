% Linear programming model in MiniZinc (maximize profit)

% Decision variables: kilograms produced/sold per week
var float: A >= 0.0;
var float: B >= 0.0;

% Parameters (embedded data)
float: profitA = 30.0;
float: profitB = 10.0;

float: maxHours = 40.0;
float: hoursPerKgA = 6.0;
float: hoursPerKgB = 3.0;

float: minB_multipleOfA = 3.0;

float: maxStoreA = 4.0;

% Objective: maximize weekly profit
var float: Profit = profitA * A + profitB * B;
solve maximize Profit;

% Constraints
constraint hoursPerKgA * A + hoursPerKgB * B <= maxHours;  % production time limit
constraint B >= minB_multipleOfA * A;                      % market demand relation
constraint A <= maxStoreA;                                 % storage limit for A

output [
  "A (kg) = ", show(A), "\n",
  "B (kg) = ", show(B), "\n",
  "Profit (£) = ", show(Profit), "\n"
];