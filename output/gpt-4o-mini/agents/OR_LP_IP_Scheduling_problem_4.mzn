int: n;  % Size of the grid
array[1..n, 1..n] of int: huts;  % Grid representing the location of villagers

% Variables for the airdrop locations
array[1..2] of var 1..n: drop_row;  % Row indices for airdrop locations
array[1..2] of var 1..n: drop_col;  % Column indices for airdrop locations

% Objective: Minimize the sum of squared distances from huts to the nearest drop location
var int: total_distance = sum(i in 1..n, j in 1..n)(
    let {
        array[1..2] of int: distances = [ 
            (drop_row[1] - i)^2 + (drop_col[1] - j)^2,
            (drop_row[2] - i)^2 + (drop_col[2] - j)^2
        ]
    } in
    min(distances)
);

% Constraints: Choose exactly 2 distinct airdrop locations
constraint all_different(drop_row);
constraint all_different(drop_col);

% Solve & output
solve minimize total_distance;
output [ "Total Distance = ", show(total_distance), "\nDrop Locations = ", show(drop_row), ", ", show(drop_col), "\n" ];