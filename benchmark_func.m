% Acknowledgement:
% This function is provided by Dr. P. N. Suganthan, and we have done minor
% revisions.

function f = benchmark_func(x, func_num, o, A, M, a, alpha, b)

persistent fhd f_bias

% benchmark_func.m is the main function for 25 test functions , all
% minimize
% problems
% e.g. f = benchmark_func(x , func_num)
% x is the variable , f is the function value
% func_num is the function num ,



if func_num == 1 fhd=str2func('basic_sphere_fnc'); %[-100,100]
elseif func_num == 2 fhd=str2func('basic_schwefel_222'); %[-10,10]
elseif func_num == 3 fhd=str2func('basic_schwefel_102'); %[-100,100]
elseif func_num == 4 fhd=str2func('basic_schwefel_221'); %[-100,100]
elseif func_num == 5 fhd=str2func('basic_rosenbrok_func'); %[-30,30]
elseif func_num == 6 fhd=str2func('basic_step');    %[-100,100]
elseif func_num == 7 fhd=str2func('basic_quartic_with_noise');    %[-1.28,1.25]
elseif func_num == 8 fhd=str2func('basic_schwefel206');  %[-500,500]
elseif func_num == 9 fhd=str2func('basic_rastrigin');    %[-5.12,5.12]
elseif func_num == 10 fhd=str2func('basic_ackley');    %[-32,32]
elseif func_num == 11 fhd=str2func('basic_griewank');    %[-600,600]
elseif func_num == 12 fhd=str2func('basic_penalized1');    %[-50,50]
else  fhd=str2func('basic_penalized2');    %[-50,50]    

end

f = feval(fhd, x, o, A, M, a, alpha, b);%feval是函数句柄，这句的意思是 f = fhd( x, o, A, M, a, alpha, b)



function f=basic_sphere_fnc(x, o, A, M, a, alpha, b)
[ps, D] = size(x);
f = sum(x .^2, 2);

function  f=basic_schwefel_222(x, o, A, M, a, alpha, b)
[ps, D]=size(x);
f=0;
f=sum(abs(x),2)+prod(abs(x),2);

function f=basic_schwefel_102(x, o, A, M, a, alpha, b)
[ps, D] = size(x);
f = 0;
for i = 1 : D
    f = f + sum(x(:, 1 : i), 2).^2;
end

function f=basic_schwefel_221(x, o, A, M, a, alpha, b)
[ps,D]=size(x);
f=max(abs(x), [], 2);

function f=basic_rosenbrok_func(x, o, A, M, a, alpha, b)
[ps,D]=size(x);    
f = sum(100 .* (x(:, 1 : D - 1) .^ 2 - x(:, 2 : D)) .^ 2 + (x(:, 1 : D - 1) - 1) .^ 2, 2);

function f=basic_step(x, o, A, M, a, alpha, b)
y=floor(x+0.5);
f=sum(y.^2, 2);

function f=basic_quartic_with_noise(x, o, A, M, a, alpha, b)
[ps,D]=size(x);
 f=sum(repmat(1:D,ps,1).*x(:,1:D).^4,2)+rand(ps,1);

 function f=basic_schwefel206(x, o, A, M, a, alpha, b)
 [ps,D]=size(x);
 f=sum((-x).*sin(sqrt(abs(x))),2)+repmat(418.9829*D,ps,1);
 
 function f=basic_rastrigin(x, o, A, M, a, alpha, b)
 [ps,D]=size(x);
 f = sum(x .^ 2 - 10 .* cos(2 .* pi .* x) + 10, 2);
 
 function f=basic_ackley(x, o, A, M, a, alpha, b)
 [ps, D] = size(x);
f = sum(x .^ 2, 2);
f = 20 - 20 .* exp(-0.2 .* sqrt(f ./ D)) - exp(sum(cos(2 .* pi .* x), 2) ./ D) + exp(1);

 function f=basic_griewank(x, o, A, M, a, alpha, b)
[ps, D] = size(x);
f = 1;
for i = 1 : D
    f = f .* cos(x(:, i) ./ sqrt(i));
end
f = sum(x .^ 2, 2) ./ 4000 - f + 1;
 
 function f=basic_penalized1(x, o, A, M, a, alpha, b)
 [ps, D] = size(x);
 y=(x+1)./4+1;
 f=pi./D.*(sum(y(:,1:D-1).^2.*(1+sin(pi.*y(:,2:D))),2)+(y(:,D)-1).^2+10.*(sin(pi.*y(:,1))).^2);
 u=penalized_u(x,10,100,4);
 f=f+sum(u,2);
 
  function f=basic_penalized2(x, o, A, M, a, alpha, b)
  [ps, D] = size(x);
  f=0.1.*((sin(3.*pi.*x(:,1))).^2+sum((x(:,1:D-1)-1).^2.*(1+sin(3.*pi.*x(:,2:D)).^2),2)+(x(:,D)-1).^2.*(1+sin(2*pi*x(:,D)).^2));
  u=penalized_u(x,5,100,4);
  f=f+sum(u,2);
 
 function fitness_u=penalized_u(x,a,k,m)
  [ps,D]=size(x);
  fitness_u=zeros(ps,D);
  for i=1:ps
      for j=1:D
          if x(i,j)>a 
              fitness_u(i,j)=k.*(x(i,j)-a).^m;
          elseif x(i,j)<=a && x(i,j)>=-a
              fitness_u(i,j)=0;
          else
              fitness_u(i,j)=k.*(-x(i,j)-a).^m;
          end
      end
  end
  
 
     
     
         

     
 
         


 













    
    
