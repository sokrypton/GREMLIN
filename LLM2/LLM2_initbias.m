function w1=LLM2_initbias(X,nStates);
  h = hist(X, [1:nStates]); %nStatesxnNodes
  h=h+1; %pseudocount
  h = h./repmat(sum(h,1), [nStates 1]); %prob
  h = log(h);
  h = h-repmat(h(nStates,:), [nStates 1]); %since last state is fixed to 0
  w1 = h(1:nStates-1,:);
  w1=w1';
