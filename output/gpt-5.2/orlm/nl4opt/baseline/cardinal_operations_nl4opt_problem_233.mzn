% Dog food mix: minimize cost while meeting nutrient minimums

int: min_calcium = 15;
int: min_vitamin = 20;
int: min_protein = 20;

int: cost_regular = 20;
int: cost_premium = 35;

int: cal_regular = 4;
int: vit_regular = 7;
int: pro_regular = 10;

int: cal_premium = 12;
int: vit_premium = 10;
int: pro_premium = 16;

% Decision variables: number of bags (assumed nonnegative integers)
var 0..100: regular_bags;
var 0..100: premium_bags;

% Nutrient constraints
constraint cal_regular * regular_bags + cal_premium * premium_bags >= min_calcium;
constraint vit_regular * regular_bags + vit_premium * premium_bags >= min_vitamin;
constraint pro_regular * regular_bags + pro_premium * premium_bags >= min_protein;

% Objective: minimize total cost
var int: total_cost = cost_regular * regular_bags + cost_premium * premium_bags;
solve minimize total_cost;

output [
  "regular_bags = ", show(regular_bags), "\n",
  "premium_bags = ", show(premium_bags), "\n",
  "total_cost = $", show(total_cost), "\n",
  "calcium = ", show(cal_regular * regular_bags + cal_premium * premium_bags), "\n",
  "vitamin_mix = ", show(vit_regular * regular_bags + vit_premium * premium_bags), "\n",
  "protein = ", show(pro_regular * regular_bags + pro_premium * premium_bags), "\n"
];