% Tourism package allocation - minimize total cost
% Data embedded directly in model

int: max_total_tours = 50;

int: rating_X = 5;
int: rating_Y = 3;
int: rating_Z = 7;

int: min_total_rating = 100;

int: min_diff_XY = 10; % X must be at least 10 more than Y

int: cost_X = 500;
int: cost_Y = 300;
int: cost_Z = 700;

% "Specific upper limits on resource allocation" are not numerically given,
% so we use the only explicit operational limit (total <= 50) as the binding cap.
var 0..max_total_tours: X;
var 0..max_total_tours: Y;
var 0..max_total_tours: Z;

constraint X + Y + Z <= max_total_tours;
constraint rating_X * X + rating_Y * Y + rating_Z * Z >= min_total_rating;
constraint X >= Y + min_diff_XY;

var int: total_cost = cost_X * X + cost_Y * Y + cost_Z * Z;

solve minimize total_cost;

output [
  "X=", show(X), " Y=", show(Y), " Z=", show(Z), "\n",
  "Total tours=", show(X+Y+Z), "\n",
  "Total rating=", show(rating_X*X + rating_Y*Y + rating_Z*Z), "\n",
  "Minimum total cost ($)=", show(total_cost), "\n"
];