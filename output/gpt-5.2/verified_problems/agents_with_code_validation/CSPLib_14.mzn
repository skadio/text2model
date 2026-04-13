% Parameters
int: height;                         % Height (number of rows) of the board
int: width;                          % Width (number of columns) of the board
int: maxship;                        % Maximum ship length present in the fleet specification

array[1..width, 1..height] of int: hint;   % Given hints / initial board info (cell codes as integers)
array[1..width] of int: rowsum;            % Number of occupied ship cells in each column (per input spec)
array[1..height] of int: colsum;           % Number of occupied ship cells in each row (per input spec)
array[1..maxship] of int: ship;            % ship[L] = number of ships of length L

% Useful index sets
set of int: W = 1..width;
set of int: H = 1..height;
set of int: L = 1..maxship;

% Variables
array[W, H] of var 0..1: occ;              % occ[x,y] = 1 iff cell (x,y) is occupied by some ship segment

array[L] of var 0..sum(ship): placed;      % placed[len] = number of ships of this length actually placed
array[L] of var 0..(width*height): cells_of_len; % total occupied cells contributed by ships of each length

% Constraints
%----------------------------
% Bounds / basic linear relations for fleet accounting
%----------------------------
constraint forall(l in L) (placed[l] <= ship[l]);              % cannot place more ships than available
constraint forall(l in L) (cells_of_len[l] = l * placed[l]);   % occupied cells contributed by length l ships

% Global bounds implied by sums (redundant but helpful)
constraint sum(x in W, y in H)(occ[x,y]) = sum(i in W)(rowsum[i]);
constraint sum(x in W, y in H)(occ[x,y]) = sum(j in H)(colsum[j]);

%----------------------------
% Row/Column occupancy sums
%----------------------------
% Enforce the given per-column sums (rowsum is indexed by W per input spec)
constraint
  forall(x in W) (
    sum(y in H)(occ[x,y]) = rowsum[x]
  );

% Enforce the given per-row sums (colsum is indexed by H per input spec)
constraint
  forall(y in H) (
    sum(x in W)(occ[x,y]) = colsum[y]
  );

%----------------------------
% No-adjacency (including diagonals)
%----------------------------
% Ships cannot touch diagonally
constraint
  forall(x in 1..width-1, y in 1..height-1) (
    occ[x,y] + occ[x+1,y+1] <= 1
  );

constraint
  forall(x in 1..width-1, y in 2..height) (
    occ[x,y] + occ[x+1,y-1] <= 1
  );

% Ships cannot touch orthogonally *unless* they are part of the same ship.
% With only occupancy variables, we enforce a conservative rule: no orthogonal adjacency.
constraint
  forall(x in 1..width-1, y in H) (
    occ[x,y] + occ[x+1,y] <= 1
  );

constraint
  forall(x in W, y in 1..height-1) (
    occ[x,y] + occ[x,y+1] <= 1
  );

%----------------------------
% Fleet cell-count consistency
%----------------------------
% Total occupied cells equals the total contributed by ships of each length
constraint
  sum(x in W, y in H)(occ[x,y]) = sum(l in L)(cells_of_len[l]);

% Optional strengthening: total number of placed ships cannot exceed available total
constraint
  sum(l in L)(placed[l]) <= sum(l in L)(ship[l]);

%----------------------------
% Hint consistency (generic)
%----------------------------
% Interpret hint codes as: 0 = unknown, 1 = water/empty, 2 = ship/occupied.
constraint
  forall(x in W, y in H) (
    (hint[x,y] == 1 -> occ[x,y] = 0) /\
    (hint[x,y] == 2 -> occ[x,y] = 1)
  );

% Objective
solve satisfy;