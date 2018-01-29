%将结果打印到文件
set(0,'diaryFile','save.txt')
diary
disp('-----------------------------------------');
disp('hour = ');
disp(hour(now));
disp('minute = ');
disp(minute(now));
disp('second = ');
disp(second(now));

%清空输出窗口
clc;
%清空变量
clear;
%关闭所有figure窗口
close all;
format long;
format compact;
tic

%parpool(2)

%定义问题的维数
n = 30;

disp('测试次数');
totalTestBenchmarkTime = 30

for problem = 1
    problem
    benchmarkResult = ones(1,30);
    benchmarkResultSum = 0;
    for testBenchmarkTime = 1:totalTestBenchmarkTime
        %定义蜜源数量
        foodCount = 25;

        %定义蜂群，1代表采蜜蜂，2代表观察蜂，3代表侦查蜂
        beeCount = 50;
        beeColony = ones(1,beeCount);
        for i = 26:45
            beeColony(1,i) = 2;
        end
        for i = 46:50
            beeColony(1,i) = 3;
        end

        %定义迭代次数
        totalTime = 3000;

        %产生初始解
        switch problem
            case 1
                lu = [-100 * ones(1, n); 100 * ones(1, n)];
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
        rand('state', sum(100 * clock));%设置随机数流的状态
        VRmin = repmat(lu(1, :), foodCount, 1);
        VRmax = repmat(lu(2, :), foodCount, 1);
        solution = VRmin + (VRmax - VRmin) .* rand(foodCount, n);%产生初始解

        %每个蜜源（解）的计数数组
        trial = ones(1,foodCount)-1;

        %每个蜜源（解）的未改善计数上限
        limit = 3;

        %每个蜜源（解）的适应度数组
        fitness = ones(1,foodCount);

        %历史最好的蜜源（解）及其适应度
        bestSolution = ones(1,n);
        bestFitness = 0;

        %开始迭代
        for time= 1:totalTime
            for bee = 1:beeCount
                switch beeColony(bee)
                    %对于采蜜蜂
                    case 1
                        newSolution = ones(1,n);
                        %生成新的蜜源
                        for j = 1:n
                            PHI = rand();
                            if(rand()>0.5)
                                PHI = -PHI;
                            end
                            k = randi([1,foodCount],1,1);
                            while k == bee
                                k = randi([1,foodCount],1,1);
                            end
                            newSolution(j) = solution(bee,j) + PHI * ( solution(bee,j) - solution(k,j) );
                        end
                        %评估旧的和新的蜜源，贪心选择
                        result = benchmark_func(solution(bee,1:n), problem, o, A, M, a, alpha, b);
                        newResult = benchmark_func(newSolution, problem, o, A, M, a, alpha, b);
                        if result>=0
                            fitness(1,bee) = 1/(1+result);
                        else
                            fitesss(1,bee) = 1 + abs(result);
                        end
                        if newResult>=0
                            newFit = 1/(1+newResult);
                        else
                            newFit = 1 + abs(newResult);
                        end
                        if fitness(bee) >= newFit
                            trial(bee) = trial(bee) + 1;
                        else
                            solution(bee,1:n) = newSolution;
                            fitness(bee) = newFit;
                            trial(bee) = 0;
                        end
                        if fitness(bee) > bestFitness
                            bestFitness = fitness(bee);
                            bestSolution = solution(bee,1:n);
                        end
                    %对应这个蜜源（解）的蜜蜂是观察蜂
                    %对所有蜜源（解）的适应度采用轮盘赌的方式，随机选中一个蜜源（解），对选中的蜜源做和采蜜蜂相同的事情
                    case 2
                        %轮盘赌
                        roulette = ones(1,foodCount);
                        rouletteSum = 0;
                        for i = 1:foodCount
                            rouletteSum = rouletteSum + fitness(i);
                        end
                        for i = 1:foodCount
                            roulette(i) = fitness(i)/rouletteSum;
                        end
                        for i = 2:foodCount
                            roulette(i) = roulette(i) + roulette(i-1);
                        end
                        gun = rand();
                        for i = 1:foodCount
                            if gun>roulette(i)
                                continue
                            end
                            break;
                        end
                        %现在i的值即为轮盘赌选中的蜜源（解），接下来对这个蜜源（解）进行操作
                        %生成新的蜜源
                        for j = 1:n
                            PHI = rand();
                            if(rand()>0.5)
                                PHI = -PHI;
                            end
                            k = randi([1,foodCount],1,1);
                            while k == i
                                k = randi([1,foodCount],1,1);
                            end
                            newSolution(j) = solution(i,j) + PHI * ( solution(i,j) - solution(k,j) );
                        end
                        %评估旧的和新的蜜源，贪心选择
                        result = benchmark_func(solution(i,1:n), problem, o, A, M, a, alpha, b);
                        newResult = benchmark_func(newSolution, problem, o, A, M, a, alpha, b);
                        if result>=0
                            fitness(1,i) = 1/(1+result);
                        else
                            fitesss(1,i) = 1 + abs(result);
                        end
                        if newResult>=0
                            newFit = 1/(1+newResult);
                        else
                            newFit = 1 + abs(newResult);
                        end
                        if fitness(i) >= newFit
                            trial(i) = trial(i) + 1;
                        else
                            solution(i,1:n) = newSolution;
                            fitness(i) = newFit;
                            trial(i) = 0;
                        end
                    %对应这个蜜源（解）的蜜蜂是侦查蜂
                    case 3
                        for food = 1:foodCount
                            %如果某个蜜源的未改善计数超过了上限
                            if trial(food) > limit
                                %丢弃原来的蜜源i，随机产生新蜜源
                                newSolution = ones(1,n);
                                for j = 1:n
                                    max = solution(food,j);
                                    min = solution(food,j);
                                    for i = 1:foodCount
                                        if max < solution(i,j)
                                            max = solution(i,j);
                                        end
                                        if min > solution(i,j)
                                            min = solution(i,j);
                                        end
                                    end
                                    newSolution(1,j) = min + rand() * (max - min);
                                end
                            end
                        end
                end
            end
        end
        benchmarkResult(testBenchmarkTime) = benchmark_func(bestSolution, problem, o, A, M, a, alpha, b);
        benchmarkResultSum = benchmarkResultSum + benchmarkResult(testBenchmarkTime);
    end
    
    disp('迭代次数=');
    disp(totalTime);
    disp('最大值=');
    temp = benchmarkResult(1);
    for i = 1:totalTestBenchmarkTime
        if temp<benchmarkResult(i)
            temp = benchmarkResult(i);
        end
    end
    disp(temp);
    disp('最小值=');
    temp = benchmarkResult(1);
    for i = 1:totalTestBenchmarkTime
        if temp>benchmarkResult(i)
            temp  = benchmarkResult(i);
        end
    end
    disp(temp);
    disp('平均值=');
    disp(benchmarkResultSum/totalTestBenchmarkTime);
    disp('标准差=');
    disp(std(benchmarkResult));
end

toc

%结束打印
diary