% Grain transport optimization (all data embedded)

% Parameters
int: capLarge = 25;          % kg per large bag
int: capTiny  = 6;           % kg per tiny bag
float: eLarge = 4.0;         % energy units per large bag
float: eTiny  = 1.5;         % energy units per tiny bag
float: E = 110.0;            % total energy available
int: minTiny = 20;           % at least 20 tiny bags

% Decision variables
var 0..1000: tiny;
var 0..1000: large;

% Constraints
constraint large = 2 * tiny;                         % twice as many large as tiny
constraint tiny >= minTiny;
constraint eLarge * int2float(large) + eTiny * int2float(tiny) <= E;

% Objective: maximize transported grain weight
var int: totalKg = capLarge * large + capTiny * tiny;

solve maximize totalKg;

output [
  "tiny = ", show(tiny), "\n",
  "large = ", show(large), "\n",
  "totalKg = ", show(totalKg), "\n",
  "energyUsed = ", show(eLarge * int2float(large) + eTiny * int2float(tiny)), "\n"
];