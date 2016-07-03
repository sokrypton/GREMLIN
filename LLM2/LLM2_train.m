function [model] = LLM2_train(X,options,model)

[param,useMex,edges,verbose] = myProcessOptions(options,'param','F','useMex',1,'edges',[],'verbose',1);

[nSamples,nNodes] = size(X);
nStates = max(X(:));

%% Initialize Edges
if isempty(edges) % Use all edges
    edges = zeros(0,2);
    for n1 = 1:nNodes
        for n2 = n1+1:nNodes
            edges(end+1,:) = [n1 n2];
        end
    end
end
nEdges = size(edges,1);
avgDeg = nEdges*2/nNodes; %(p-1) if all edges are allowed


%% Initialize Weights
[w1,w2] = LLM2_initWeights(param,nNodes,nStates,edges, X);
if nargin < 3
    % Cold-start with all parameters zero
    w = [w1(:);w2(:)];
else
    % Warm-start at previous model
    w = model.w;
end

%% Convert everything to int32
X = int32(X);
nStates = int32(nStates);
edges = int32(edges);

if(isfield(options, 'seqDepWeights'))
  Xreps=options.seqDepWeights;
  Xunique=X;
  disp('using sequence dependent weights');
else
  [Xunique,Xreps] = LLM_unique(X);
end;
funObj = @(w)LLM2_pseudo(w,param,X,Xreps,nStates,edges,useMex);

%% Optimize
if verbose
    options.Display = 'iter';
    options.verbose = 2;
else
  options.Display = 0;
  options.verbose = 0;
end

if(options.lambda_bias>0 | options.lambda_l2>0)
  if(isfield(options, 'lambda_vector'))
    options.lambda_l2 = get_l2_lambda_from_vector(options.lambda_l2, options, nStates);
  end;
  if(isfield(options, 'lambda_l2_scale_by_length') & options.lambda_l2_scale_by_length==1)
    options.lambda_l2 = options.lambda_l2*avgDeg;
  end;
  lambdaVect = [options.lambda_bias*ones(numel(w1),1);options.lambda_l2(:).*ones(numel(w2),1)];
  if(nnz(lambdaVect<0))
    disp(['Error!! ' num2str(nnz(lambdaVect)) ' regularization weights were negative. Please check inputs! Proceeding after setting them to small positive value' ]);
    lambdaVect(lambdaVect<0)=0.001; %lambdas shouldn't be negative
  end;
end;

regFunObj = @(w)penalizedL2(w,funObj,lambdaVect);
w = minFunc(regFunObj,w,options);

%% Make model struct
model.param = param;
model.useMex = useMex;
model.nStates = nStates;
model.w = w;
model.edges = edges;
model.nll = @nll;

end


%% Function for evaluating nll given data X
function f = nll(model,X)

% Convert everything to int32
nSamples = size(X,1);
X = int32(X);

 [Xunique,Xreps] = LLM_unique(X);
 f = LLM2_pseudo(model.w,model.param,Xunique,Xreps,model.nStates,model.edges,model.useMex);
end

function l2_vec = get_l2_lambda_from_vector(l2_scalar, options, nStates)
if(options.multiplicative_lam==1)
 l2_vec =l2_scalar.*options.lambda_vector; 
else
 l2_vec =l2_scalar+options.lambda_vector; 
end;
nStates2 = double(nStates);
 l2_vec  = repmat(l2_vec', [1 nStates2 nStates2]); %lambda_vector has one entry per edge; need one for each parameter
 l2_vec  = permute(l2_vec , [2 3 1]);

end
