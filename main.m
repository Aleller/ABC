clc;
clear all
close all
tic
format long;
format compact;

for problem = 8

    problem = problem

    %定义问题的维数
    n = 30;
    
    %设置测试函数的输入参数
    switch problem 
        case 1
            lu = [-100 * ones(1, n); 100 * ones(1, n)];%lu代表一个个体
            A = []; a = []; alpha = []; b = []; o=[]; M=[];
         
        case 2
            lu = [-10 * ones(1, n); 10 * ones(1, n)];
            A = []; a = []; alpha = []; b = [];o=[]; M=[];
        
        case 3
            lu = [-100 * ones(1, n); 100 * ones(1, n)];
            A = []; a = []; alpha = []; b = []; o=[]; M=[];
         
        case 4
            lu = [-100 * ones(1, n); 100 * ones(1, n)];
            A = []; a = []; alpha = []; b = []; o=[]; M=[];
        
        case 5
            lu = [-30 * ones(1, n); 30 * ones(1, n)];
            A = []; a = []; alpha = []; b = []; o=[]; M=[];
        
        case 6
            lu = [-100 * ones(1, n); 100 * ones(1, n)];
            A = []; a = []; alpha = []; b = []; o=[]; M=[];
         
        case 7
            lu = [-1.28 * ones(1, n); 1.25 * ones(1, n)];
            A = []; a = []; alpha = []; b = []; o=[]; M=[];
         
        case 8
            lu = [-500 * ones(1, n); 500 * ones(1, n)];
            A = []; a = []; alpha = []; b = []; o=[]; M=[];
            
        case 9
            lu = [-5.12 * ones(1, n); 5.12 * ones(1, n)];
            A = []; a = []; alpha = []; b = []; o=[]; M=[];
        
        case 10
            lu = [-32* ones(1, n); 32 * ones(1, n)];
            A = []; a = []; alpha = []; b = []; o=[]; M=[];
        
        case 11
            lu = [-600* ones(1, n); 600 * ones(1, n)];
            A = []; a = []; alpha = []; b = []; o=[]; M=[];
         
        case 12
            lu = [-50* ones(1, n); 50 * ones(1, n)];
            A = []; a = []; alpha = []; b = []; o=[]; M=[];
            
        case 13
            lu = [-50* ones(1, n); 50 * ones(1, n)];
            A = []; a = []; alpha = []; b = []; o=[]; M=[];
       
    end

    %种群的个体数
    ps = 1000;
    
    %迭代次数
    totalTime = 1000;
    
    %设置随机数流的状态
    rand('state', sum(100 * clock));
    
    VRmin = repmat(lu(1, :), ps, 1);
    VRmax = repmat(lu(2, :), ps, 1);
    pop = VRmin + (VRmax - VRmin) .* rand(ps, n);%产生初始种群
    
    %给迭代中用到的变量预先分配内存
    selectP = ones(ps, 1);
    accumulationP = ones(ps, 1);

    for time = 1 : totalTime
        %测试函数的返回值越小，个体适应度越高
        fit = benchmark_func(pop, problem, o, A, M, a, alpha, b);
        for i = 1:ps
            fit(i,1) = 1/fit(i,1);
        end

        %算出每个个体的选择概率
        fitSum = sum(fit);
        selectP = fit/fitSum;
        
        %算出每个个体的累积概率
        accumulationP(1,1) = selectP(1,1);
        for i = 2:ps
           accumulationP(i,1) = accumulationP(i-1,1) + selectP(i,1);
        end
        
        %用轮盘赌策略生成新种群
        pop_old = pop;
        for i = 1:ps
           temp = rand(1);
           for j = 1:ps
               if temp <= accumulationP(j,1)
                   break;
               end
           end
           %决定是否变异
           if rand(1)<1.1
               %变异
               temp_1 = rand(1);
               if temp_1<0.5
                   pop(i,1:n) = pop_old(j,1:n) * (1-temp_1);
               else
                   pop(i,1:n) = pop_old(j,1:n) * (1+(temp_1-0.5));
               end
           else
               %不变异
               pop(i,1:n) = pop_old(j,1:n);
           end
        end
    end
    
    result = benchmark_func(pop, problem, o, A, M, a, alpha, b);
    min(result)
end