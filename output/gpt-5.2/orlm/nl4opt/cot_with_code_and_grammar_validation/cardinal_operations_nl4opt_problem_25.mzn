% Medicine requirements (grams)
float: req_Z1 = 5.0;
float: req_D3 = 10.0;

% Content per pill (grams)
float: z1_Zodiac = 1.3;
float: z1_Sunny  = 1.2;
float: d3_Zodiac = 1.5;
float: d3_Sunny  = 5.0;

% Costs ($ per pill)
float: cost_Zodiac = 1.0;
float: cost_Sunny  = 3.0;

% Decision variables: number of pills (must be integers)
var 0..1000: xZ; % Zodiac pills
var 0..1000: xS; % Sunny pills

% Constraints
constraint z1_Zodiac * int2float(xZ) + z1_Sunny * int2float(xS) >= req_Z1;
constraint d3_Zodiac * int2float(xZ) + d3_Sunny * int2float(xS) >= req_D3;

% Objective: minimize total cost
var float: total_cost = cost_Zodiac * int2float(xZ) + cost_Sunny * int2float(xS);

solve minimize total_cost;

output [
  "Zodiac pills = ", show(xZ), "\n",
  "Sunny pills  = ", show(xS), "\n",
  "Total cost   = ", show(total_cost), "\n"
];