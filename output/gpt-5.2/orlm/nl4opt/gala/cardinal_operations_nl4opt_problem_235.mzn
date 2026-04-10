% Fertilizer blend optimization (all data embedded)

% Decision variables: kilograms of fertilizer A and B
var 0..1000: kgA;
var 0..1000: kgB;

% Nutrient totals
var int: nitrogen    = 13*kgA +  8*kgB;
var int: phosphoric  =  5*kgA + 14*kgB;
var int: vitaminA    =  6*kgA +  6*kgB;
var int: vitaminD    =  5*kgA +  9*kgB;

% Requirements
constraint nitrogen   >= 220;
constraint phosphoric >= 160;
constraint vitaminA   <= 350;

% Objective: minimize vitamin D
solve minimize vitaminD;

output [
  "kgA = ", show(kgA), "\n",
  "kgB = ", show(kgB), "\n",
  "minimum vitamin D = ", show(vitaminD), "\n",
  "nitrogen = ", show(nitrogen), "\n",
  "phosphoric acid = ", show(phosphoric), "\n",
  "vitamin A = ", show(vitaminA), "\n"
];