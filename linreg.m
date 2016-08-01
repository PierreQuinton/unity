
function model = linreg_train(trainingData, trainingTargets, lambda = 0)
	Z = [ones(size(trainingData)(1), 1), trainingData];
	w = (pinv(Z'*Z+lambda*eye(size(Z)(2)))*Z')*trainingTargets;
	model = @(x) [ones(size(x)(1), 1), x]*w;
endfunction

X = [1 2 ; 2 3 ; 3 4 ; 6 7]
y = [ 3  ;  4  ;  5  ;  8 ]

model = linreg_train(X, y, 0.01);

result = model([1 2; 4 5; 2 4])

