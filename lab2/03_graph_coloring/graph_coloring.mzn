%%%%%%%%%%%%%
% PARAMETERS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Should be loaded from the data file
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
%%%%%%%%%%%% 
% VARIABLES         
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Variables with correct domains 
% - preserve the names from the output          
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
include "cumulative.mzn";
int: nodesNumber;
var 1..nodesNumber: colorsNumber;
array[1..nodesNumber]  of var 1..nodesNumber: nodes ;
array[1..nodesNumber, 1..nodesNumber] of bool: edges;

%%%%%%%%%%%%%%%%
% CONSTRAINTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% tip:
% - number of used colors = the highest used color number                     
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
constraint forall(i, j in 1..nodesNumber where edges[i,j] /\ j < i)(nodes[i] != nodes[j]); 

%%%%%%%%
% GOAL  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Minimize the number of used colors
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
colorsNumber = max(nodes);
solve minimize colorsNumber;

%%%%%%%%%%%%%%%%%%%%%%%%
% OUTPUT EXAMPLE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% - colorsNumber - number of used colors
% - nodes - array of vertices with assigned colors                
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
output [show(colorsNumber), " colors\n",] ++
       [show(nodes[i]) ++ " " | i in 1..nodesNumber]
