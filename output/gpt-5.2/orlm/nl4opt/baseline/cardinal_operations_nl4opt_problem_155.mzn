% Baby food optimization: maximize fat subject to folate cap and ratio constraints

int: fat_apple = 2;
int: folate_apple = 5;

int: fat_carrot = 4;
int: folate_carrot = 3;

int: folate_max = 100;

% Decision variables: servings (nonnegative integers)
var int: apple;
var int: carrot;

constraint apple >= 0;
constraint carrot >= 0;

% Must eat three times as many apple as carrot
constraint apple = 3 * carrot;

% Must eat at least 2 servings of carrot
constraint carrot >= 2;

% Folate limit
constraint folate_apple * apple + folate_carrot * carrot <= folate_max;

% Objective: maximize fat intake
var int: total_fat = fat_apple * apple + fat_carrot * carrot;
solve maximize total_fat;

output [
  "apple_servings = ", show(apple), "\n",
  "carrot_servings = ", show(carrot), "\n",
  "total_fat = ", show(total_fat), "\n",
  "total_folate = ", show(folate_apple * apple + folate_carrot * carrot), "\n"
];