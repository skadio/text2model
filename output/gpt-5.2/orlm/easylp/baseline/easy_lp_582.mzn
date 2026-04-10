% Marketing budget allocation - minimize total cost (spend)
% All amounts are in dollars and must be integers.

int: BUDGET = 5000;

% Decision variables: spending per channel ($)
var 0..2500: tv;
var 0..2000: radio;
var 0..1200: online;
var 800..BUDGET: offline; % no explicit upper bound, but budget limits it

% Total spend
var 0..BUDGET: total_spend = tv + radio + online + offline;

constraint total_spend <= BUDGET;

% Constraints
% Difference in spending between TV and radio at least $1000 (absolute difference)
constraint abs(tv - radio) >= 1000;

% Online cannot exceed offline by more than $300
constraint online - offline <= 300;

% At least $1500 must be allocated to TV
constraint tv >= 1500;

solve minimize total_spend;

output [
  "tv = $", show(tv), "\n",
  "radio = $", show(radio), "\n",
  "online = $", show(online), "\n",
  "offline = $", show(offline), "\n",
  "minimum_total_cost = $", show(total_spend), "\n"
];