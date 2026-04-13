% Parameters
% Factory capacity (max total units)
int: capacity = 300;

% Demand requirement coefficients and threshold: 3*X + 4*Y >= 800
int: demandCoeffX = 3;
int: demandCoeffY = 4;
int: demandMin = 800;

% Unit manufacturing costs
int: costX = 50;
int: costY = 70;

% Upper bound for each product quantity (cannot exceed total capacity)
int: maxPerProduct = capacity;

% Variables
% Integer production quantities
var 0..maxPerProduct: xQty;  % units of product X
var 0..maxPerProduct: yQty;  % units of product Y

% Total cost (bounded using maxPerProduct)
var 0..(costX*maxPerProduct + costY*maxPerProduct): totalCost;

% Constraints
% Total production capacity: X + Y cannot exceed factory capacity
constraint xQty + yQty <= capacity;

% Market demand requirement: 3*X + 4*Y must be at least the minimum demand threshold
constraint demandCoeffX * xQty + demandCoeffY * yQty >= demandMin;

% Production balance requirement: maintain or increase quantity of X compared to Y
constraint xQty >= yQty;

% Total cost definition: link totalCost to quantities and unit costs
constraint totalCost = costX * xQty + costY * yQty;

% Objective
solve minimize totalCost;