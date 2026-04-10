% Parameters
int: min_calcium = 15;
int: min_vitamin = 20;
int: min_protein = 20;

int: cost_regular = 20;
int: cost_premium = 35;

int: calcium_regular = 4;
int: vitamin_regular = 7;
int: protein_regular = 10;

int: calcium_premium = 12;
int: vitamin_premium = 10;
int: protein_premium = 16;

% Upper bounds (safe bounds based on meeting each requirement with only one brand)
int: ub_regular =
  max( max( (min_calcium + calcium_regular - 1) div calcium_regular,
            (min_vitamin + vitamin_regular - 1) div vitamin_regular ),
       (min_protein + protein_regular - 1) div protein_regular );

int: ub_premium =
  max( max( (min_calcium + calcium_premium - 1) div calcium_premium,
            (min_vitamin + vitamin_premium - 1) div vitamin_premium ),
       (min_protein + protein_premium - 1) div protein_premium );

% Variables
var 0..ub_regular: bags_regular;
var 0..ub_premium: bags_premium;

% Constraints
constraint calcium_regular * bags_regular + calcium_premium * bags_premium >= min_calcium;
constraint vitamin_regular * bags_regular + vitamin_premium * bags_premium >= min_vitamin;
constraint protein_regular * bags_regular + protein_premium * bags_premium >= min_protein;

% Objective
solve minimize cost_regular * bags_regular + cost_premium * bags_premium;