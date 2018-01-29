%�������ӡ���ļ�
set(0,'diaryFile','save.txt')
diary
disp('-----------------------------------------');
disp('hour = ');
disp(hour(now));
disp('minute = ');
disp(minute(now));
disp('second = ');
disp(second(now));

%����������
clc;
%��ձ���
clear;
%�ر�����figure����
close all;
format long;
format compact;
tic

%parpool(2)

%���������ά��
n = 30;

disp('���Դ���');
totalTestBenchmarkTime = 30

testBenchmarkTime = 1

for problem = 1
    problem
    benchmarkResult = ones(1,30);
    benchmarkResultSum = 0;

    %������Դ����
    foodCount = 25;

    %�����Ⱥ��1������۷䣬2����۲�䣬3��������
    beeCount = 5;
    beeColony = ones(1,beeCount);
    for i = 26:45
        beeColony(1,i) = 2;
    end
    for i = 46:50
        beeColony(1,i) = 3;
    end

    %�����������
    totalTime = 3000;

    %������ʼ��
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
    rand('state', sum(100 * clock));%�������������״̬
    VRmin = repmat(lu(1, :), foodCount, 1);
    VRmax = repmat(lu(2, :), foodCount, 1);
    solution = VRmin + (VRmax - VRmin) .* rand(foodCount, n);%������ʼ��

    %ÿ����Դ���⣩�ļ�������
    trial = ones(1,foodCount)-1;

    %ÿ����Դ���⣩��δ���Ƽ�������
    limit = 3;

    %ÿ����Դ���⣩����Ӧ������
    fitness = ones(1,foodCount);

    %��ʷ��õ���Դ���⣩������Ӧ��
    bestSolution = ones(1,n);
    bestFitness = 0;

    %��ʼ����
    for time= 1:totalTime
        for bee = 1:beeCount
            switch beeColony(bee)
                %���ڲ��۷�
                case 1
                    newSolution = ones(1,n);
                    %�����µ���Դ
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
                    %�����ɵĺ��µ���Դ��̰��ѡ��
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
                %��Ӧ�����Դ���⣩���۷��ǹ۲��
                %��������Դ���⣩����Ӧ�Ȳ������̶ĵķ�ʽ�����ѡ��һ����Դ���⣩����ѡ�е���Դ���Ͳ��۷���ͬ������
                case 2
                    %���̶�
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
                    %����i��ֵ��Ϊ���̶�ѡ�е���Դ���⣩���������������Դ���⣩���в���
                    %�����µ���Դ
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
                    %�����ɵĺ��µ���Դ��̰��ѡ��
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
                %��Ӧ�����Դ���⣩���۷�������
                case 3
                    for food = 1:foodCount
                        %���ĳ����Դ��δ���Ƽ�������������
                        if trial(food) > limit
                            %����ԭ������Դi�������������Դ
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
    
    disp('��������=');
    disp(totalTime);
    disp('���ֵ=');
    temp = benchmarkResult(1);
    for i = 1:totalTestBenchmarkTime
        if temp<benchmarkResult(i)
            temp = benchmarkResult(i);
        end
    end
    disp(temp);
    disp('��Сֵ=');
    temp = benchmarkResult(1);
    for i = 1:totalTestBenchmarkTime
        if temp>benchmarkResult(i)
            temp  = benchmarkResult(i);
        end
    end
    disp(temp);
    disp('ƽ��ֵ=');
    disp(benchmarkResultSum/totalTestBenchmarkTime);
    disp('��׼��=');
    disp(std(benchmarkResult));
end

toc

%������ӡ
diary