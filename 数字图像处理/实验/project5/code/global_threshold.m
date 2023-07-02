function level =global_threshold(I)
I = im2double(I);
[M,N] = size(I);
T0 = 0.001;         
T1 = (max(max(I)) +min(min(I)))/2;   
columns1 = 1;
columns2 = 1;
while 1
    for i = 1:M
        for j = 1:N
            if I(i,j)>T1
                G1(columns1) = I(i,j);  
                columns1 = columns1 + 1;
            else
                G2(columns2) = I(i,j); 
                columns2 = columns2 + 1;
            end
        end
    end
    ave1 = mean(G1);
    ave2 = mean(G2);
    T2 = (ave1 + ave2)/2;  
    if abs(T2 - T1)<T0        
        break;
    end
    T1 = T2;
    columns1 = 1;
    columns2 = 1;
end
level = T2;
end
