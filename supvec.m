
RBF_kernel = @(lambda) @(x1, x2) exp(-lambda*norm(x1-x2)^2)

function model = supvec_train(trainingDataTrue, trainingDataFalse, K = @(x1, x2) x1'*x2, softness = Inf)
	K = @(x1, x2) K(x1', x2');
	X = [trainingDataTrue ; trainingDataFalse];
	y = [ones(size(trainingDataTrue)(1), 1) ; -ones(size(trainingDataFalse)(1), 1)];
	N = size(y)(1);
	H = zeros(N, N);
	for i = 1:N
		for j = 1:N
			H(i, j) = y(i)*y(j)*K(X(i, [1, end]), X(j, [1, end]));
		endfor
	endfor
	alphas = qp([], H,-ones(N, 1),y',0,zeros(N, 1),softness*ones(N, 1));
	M = 0;
	supx = [];
	supy = [];
	c = [];
	b = 0;
	for i = 1:N
		if(alphas(i) != 0)
			M = M+1;
			supx = [supx ; X(i, [1, end])];
			supy = [supy ; y(i)];
			c = [c ; alphas(i)*supy(M)];
			b = b + alphas(i)*supy(M)*K(supx(M, [1, end]), supx(1, [1, end]));
		endif
	endfor
	b = supy(1)-b;
	d = [];
	for i = 1:M
		d(i) = i;
	endfor
	model = @(x) sign(arrayfun(@(i) K(supx(i, [1, end]), x), d)*c+b);
endfunction

X1 = [0 0; 1 1]
X2 = [1 0; 0 1]

model = supvec_train(X1, X2, RBF_kernel(1))
%model = supvec_train(X1, X2)

f = @(x,y) model([x,y])

N = 18
M = zeros(N, N);
for i = 1:N
	for j = 1:N
		M(i, j) = f(i/N, (N-j)/N);
	endfor
endfor
M

ezplot(f, [0, 1])

