function [TargetFitness,TargetPosition]=FDB_LFD_Case_1(egitim_seti,test_seti,k)

% fitness degerini hesapla ve bir dizi içerisinde tut


[N, dim, maxFEs, lb, ub] = problem_terminate();
%N=populationSize
threshold=2;%

if size(ub,1)==1
    ub=ones(dim,1)*ub;%
    lb=ones(dim,1)*lb;
end

Positions=Initialization(N,dim,ub,lb);
PositionsFitness = zeros(1,N);
Positions_temp=Positions;

 for i=1:size(Positions,1) 
     PositionsFitness(1,i) = agirlikli_knn(egitim_seti,test_seti,Positions(i,:),k,dim);
 end
   
[sorted_fitness,sorted_indexes]=sort(PositionsFitness);

for newindex=1:N
    Sorted_Positions(newindex,:)=Positions(sorted_indexes(newindex),:); 
end

TargetPosition=Sorted_Positions(1,:);
TargetFitness=sorted_fitness(1);
vec_flag=[1,-1];
NN=[0,1];
%maxFEs=30;
%% Main loop
FES=0;
while FES<maxFEs
    [m,ll]=sort(NN);
    for i=1:size(Positions,1)
        S_i=zeros(1,dim);
        NeighborN=0;
        for j=1:N
            flag_index = floor(2*rand()+1);
            var_flag=vec_flag(flag_index);
            if i~=j
                dis=Distance(Positions(i,:),Positions(j,:));
                if (dis<threshold)
                    NeighborN=NeighborN+1;
                    D=(PositionsFitness(j)/(PositionsFitness(i)+eps));
                    D(NeighborN)=((.9*(D-min(D)))./(max(D(:))-min(D)+eps))+.1;
                    if FES==NN
                        rand_leader_index = floor(N*rand()+1);
                        X_rand = Positions(rand_leader_index, :);                        
                    else
%                More Opportunities for Discovering Unvisited Pattern Solutions
                        R=rand();
                        CSV=.5;
                        if R<CSV
                            rand_leader_index = floor(2*rand()+1);
                            X_rand = Positions(ll(rand_leader_index), :);
                            Positions_temp(j,:)=LevyFlights(Positions(j,:),X_rand,lb,ub);
                        else
                            Positions_temp(j,:)=lb(1)+rand(1,dim)*(ub(1)-lb(1));
                        end                       
                    end
                    pos_temp_nei{NeighborN}=Positions(j,:); 
                end
            end
        end
        for p=1:NeighborN
            s_ij=var_flag*D(NeighborN).*(pos_temp_nei{p})/NeighborN;
            S_i=S_i+s_ij;
        end    
        S_i_total= S_i;
        rand_leader_index = floor(N*rand()+1);
        X_rand = Positions(rand_leader_index, :);    
        X_new = TargetPosition+10*S_i_total+rand*.00005*((TargetPosition+.005*X_rand)/2-Positions(i,:));

        %% Fitness Distance Balance(FDB)
        fdbIndex = fitnessDistanceBalance(Positions,PositionsFitness);
        X_new=LevyFlights(X_new,Positions(fdbIndex,:),lb,ub);       
        Positions_temp(i,:)=X_new;
        NN(i)=NeighborN;
    end
    Positions=Positions_temp;
    
 for i=1:size(Positions,1)
     PositionsFitness(1,i) = agirlikli_knn(egitim_seti,test_seti,Positions(i,:),k,dim);
     FES = FES + 1;                
 end
     
    [xminn,x_pos_min]=min(PositionsFitness);
    if xminn<TargetFitness
        TargetPosition=Positions(x_pos_min,:);
        TargetFitness=xminn;
    end   
end


end

function CP=LevyFlights(CP,DP,Lb,Ub)
        n=size(CP,1);
        beta=3/2;
        sigma=(gamma(1+beta)*sin(pi*beta/2)/(gamma((1+beta)/2)*beta*2^((beta-1)/2)))^(1/beta);     
        for j=1:n,
            s=CP(j,:);          
            u=randn(size(s))*sigma;
            v=randn(size(s));
            step=u./abs(v).^(1/beta);
            stepsize=0.01*step.*(s-DP);
            s=s+stepsize.*randn(size(s));
            CP(j,:)=simplebounds(s,Lb(:,1),Ub(:,1));
        end
    end

% Application of simple constraints
function s=simplebounds(s,Lb,Ub)
        % Apply the lower bound
        ns_tmp=s;
        I=ns_tmp<Lb(1)';
        ns_tmp(I)=Lb(I);
                
        J=ns_tmp>Ub(1)';
        ns_tmp(J)=Ub(J);
       
        s=ns_tmp;
end
    
   % Örneğin, N=10, dim=2, up=[2, 3], down=[-1, -2] olarak verildiğinde, 
   % fonksiyon 10x2 boyutunda bir X matrisi döndürecektir. Bu matris,
   % her bir satırı bir başlangıç noktasını temsil eden 10 adet noktayı içerecektir.
   % Her bir noktanın değerleri, üst ve alt sınırlar arasında rastgele olarak oluşturulacaktır.    
function [X]=Initialization(N,dim,up,down)

if size(up,1)==1
    X=rand(N,dim).*(up-down)+down;
end


if size(up,1)>1
    for i=1:dim
        high=up(i);low=down(i);
        X(:,i)=rand(1,N).*(high-low)+low;
    end
end
end

function d = Distance(a,b)
d=sqrt((a(1)-b(1))^2+(a(2)-b(2))^2);
end
