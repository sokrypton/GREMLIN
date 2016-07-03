function X = blosum_encoding(numeric_msa)
%0:C
%1:S,T,A,P,G
%2:D,E,N,Q
%3:H,R,K
%4:V,L,I,M
%5:F,Y,W
%6:-
state = cell(7,1);
state{1} = [aa2int('C')];
state{2} = [aa2int('S'), aa2int('T'), aa2int('A'), aa2int('P'), aa2int('G')];
state{3} = [aa2int('D'), aa2int('E'), aa2int('N'), aa2int('Q')];
state{4} = [aa2int('H'), aa2int('R'), aa2int('K')];
state{5} = [aa2int('V'), aa2int('L'), aa2int('I'), aa2int('M')];
state{6} = [aa2int('F'), aa2int('Y'), aa2int('W')];
state{7} = [21];
X = zeros(size(numeric_msa));
for i=1:7
  aas = state{i};
  for j=1:length(aas)
    X(numeric_msa==aas(j))=i;
  end;
end;
disp(['encoding alignment to 7 state alphabet' num2str(max(max(X)))]); 
