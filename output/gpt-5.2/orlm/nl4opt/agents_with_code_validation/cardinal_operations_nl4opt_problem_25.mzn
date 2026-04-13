% Minimum daily requirements (grams)
float: min_Z1 = 5.0;
float: min_D3 = 10.0;

% Content per pill (grams)
float: Z1_per_Zodiac = 1.3;
float: Z1_per_Sunny  = 1.2;
float: D3_per_Zodiac = 1.5;
float: D3_per_Sunny  = 5.0;

% Cost per pill (dollars)
int: cost_Zodiac = 1;
int: cost_Sunny  = 3;

% Decision variables: number of pills (nonnegative integers)
var 0..100: num_Zodiac;
var 0..100: num_Sunny;

% Medicine requirements
constraint
  Z1_per_Zodiac * int2float(num_Zodiac) + Z1_per_Sunny * int2float(num_Sunny) >= min_Z1;

constraint
  D3_per_Zodiac * int2float(num_Zodiac) + D3_per_Sunny * int2float(num_Sunny) >= min_D3;

% Objective: minimize total cost
var 0..1000: total_cost = cost_Zodiac * num_Zodiac + cost_Sunny * num_Sunny;

solve minimize total_cost;

output [
  "num_Zodiac = ", show(num_Zodiac), "\n",
  "num_Sunny  = ", show(num_Sunny), "\n",
  "total_cost = $", show(total_cost), "\n"
];