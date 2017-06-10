function [newSolution] = Insert(solution,Index_1,Index_2)
newSolution = solution;
if Index_1 > Index_2 %Jika yg dipindahkan ada di sebelah kanan
    newSolution(Index_2) = solution(Index_1);
    newSolution(Index_2 + 1 : Index_1) = solution(Index_2 : Index_1 - 1);
else %Jika yg dipindahkan ada di sebelah kiri
    newSolution(Index_2) = solution(Index_1);
    newSolution(Index_1 : Index_2 - 1) = solution(Index_1+ 1 : Index_2);
end