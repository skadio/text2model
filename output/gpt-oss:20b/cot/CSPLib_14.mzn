% Parameters
int: height;
int: width;
int: maxship;
array[1..width, 1..height] of int: hint;
array[1..width] of int: rowsum;
array[1..height] of int: colsum;
array[1..maxship] of int: ship;

% Variables
array[1..height, 1..width] of var 0..1: board;

% Constraints
include "battleships.mzn";
constraint battleships(board, ship, maxship, hint, rowsum, colsum);

% Objective
solve satisfy;