function [w1,w2] = LLM2_initWeights(param,nNodes,nStates,edges, X)

nEdges = size(edges,1);

if(exist('X', 'var'))
  w1=LLM2_initbias(X,nStates);
else
  w1 = zeros(nNodes,nStates-1);
end

switch param
    case {'I','C','S'}
        w2 = zeros(nEdges,1);
    case 'P'
        w2 = zeros(nStates,nEdges);
    case 'F'
        w2 = zeros(nStates,nStates,nEdges);
end
