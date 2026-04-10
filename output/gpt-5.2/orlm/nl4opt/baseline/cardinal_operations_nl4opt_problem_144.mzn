% Diet optimization: minimize cost while meeting vitamin/mineral requirements

var 0..100: veg;    % servings of vegetables
var 0..100: fruit;  % servings of fruits

% Nutrient requirements
constraint 2*veg + 4*fruit >= 20;  % vitamins
constraint 3*veg + 1*fruit >= 30;  % minerals

% Cost to minimize
var int: cost = 3*veg + 5*fruit;

solve minimize cost;

output [
  "Vegetable servings = ", show(veg), "\n",
  "Fruit servings = ", show(fruit), "\n",
  "Minimum cost = $", show(cost), "\n"
];