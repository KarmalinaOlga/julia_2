#=Задача 1. Написать функцию, получающую на вход весовую матрицу некоторого графа 
(в которой некоторым ребрам может быть приписан бесконечно большой вес), и возвращающую кортеж из числа, 
равного стоимости оптимального гамильтонова цикла, и вектор, в качестве своих элементов содержащий вектора с перестановками 
индексов вершин графа, соответствующих всем оптимальным гамильтоновым циклам.=#

#=Задача 2. Реализовать и протестировать алгоритм Форда-Беллмана.=#
function BellmanFord(graph, V, E, src)
    # Инициализировать расстояние всех вершин как 0.
    dis = [maxsize] * V
    # инициализировать расстояние источника как 0
    dis[src] = 0
    # Расслабьте все края | V | - 1 раз. Простой
    # кратчайший путь от src до любого другого
    # вершина может иметь самое большее | V | - 1 ребро
    for i in 1:V - 1

        for j in 1:E
            if dis[graph[j][0]] + graph[j][2] < dis[graph[j][1]]
                dis[graph[j][1]] = dis[graph[j][0]] + graph[j][2]
            end
        end
    end
    # проверка на отрицательный вес циклов.
    # Вышеуказанный шаг гарантирует кратчайшее
    # расстояния, если граф не содержит
    # отрицательный весовой цикл. Если мы получим
    # короче путь, то есть цикл.

    for i in 1:E
        x = graph[i][0]
        y = graph[i][1]
        weight = graph[i][2]
        if dis[x] != maxsize && dis[x] + weight < dis[y]
            print("Graph contains negative weight cycle")
        end
    end

    print("Vertex Distance from Source")

    for i in range(V)
        print("%d\t\t%d" % (i, dis[i]))
    end
end
#=Задача 3. Оценить асимптотическую сложность спроектированного алгоритма Форда-Беллмана (почему правильный ответ - $O(n^3)$?). 
Как можно было бы модернизировать разработанный алгоритм, чтобы его алгоритмическая сложность оценивалась как $O(n\cdot n_e)$, 
где $n_e$ - число ребер (конечного веса) в графе? (подсказка: если в графе много фактически отсутствующих ребер, 
то для представления такого графа целесообразно воспользоваться разреженными массивами, см. лекцию 7, пункт 1.4).=#

#=Задача 4. Реализовать и протестировать алгоритм Флойда, включив в этот алгоритм проверку 
отсутствия циклов отрицательного суммарного веса.=#
createBiMatrix(mat)
  bimatrix = [(math.inf, None) for _ in 1:length(mat)]

function floyd(mat)
    for from in 1:length(mat)
        for to in 1:length(mat[0])
          if mat[from][to] < bimatrix[to][0]
            bimatrix[to] = (mat[from][to], from)
          end
        end
      return bimatrix
    end
end
#=Задача 5. Написать функцию floyd_next(G::Matrix), отличающуюся от определенной выше функции 
floyd(G::Matrix) тем, что она возвращает не только матрицу минимальных стоимостей "переездов" C, но и матрицу next, 
т.е. возвращает кортеж (C, next).=#
function floyd(G::Matrix)
    n=size(A,1)
    C=Array{eltype(G),2}(undef,n,n) # - это тоже самое, что и Matrix{eltype(G)}(undef,n,n)
    C=G
    for k in 1:n, i in 1:n, j in 1:n
        if C[i,j] > C[i,k]+C[k,k,j]
            C[i,j] = C[i,k]+C[k,j]
        end
    end
    return C
end
#=Задача 6. Написать функцию optpath_floyd(next::AbstractMatrix, i::Integer, j::Integer), 
которая бы по аналогии с функцией optpath_ford_bellman возвращала бы оптимальный путь, 
ведущий из заданной вершины i в заданную вершину j, если существует такой путь конечной стоимости, или - значение nothing, 
в противном случае.=#
function optpath_floyd(graph, i, j)
    explored = collect(0)
    queue = [i]
    while queue 
        node = queue.pop(0)
        if node not in explored
            explored.push!(node)
            neighbours = graph[node]
            for neighbour in neighbours
                queue.push!(neighbour)
            end
        end
    end
    return length(explored[j])
end
#=Задача 7. Реализовать алгоритм Дейкстры, написав функцию dijkstra(G::AbstractMatrix, s::Integer), 
возвращающую вектор минимальных стоимостей путей из заданной вершины с индексом s во все остальные вершины.=#
function extract(Q, w)
    m=0
    minimum=w[0]
    for i in 1:length(w)
        if w[i]<minimum
            minimum=w[i]
            m=i
        end
    end
    return m, Q[m]
end

function dijkstra(G, s, t='B')
    Q=[s]
    p={s:None}
    w=[0]
    d={}
    for i in G
        d[i]=float(Inf)
        Q.push!(i)
        w.push!(d[i])
    end
    d[s]=0
    S=[]
    n=length(Q)
    while Q
        u=extract(Q,w)[1]
        S.push!(u)
        Q.remove(u)
        for v in G[u]
            if d[v]>=d[u]+G[u][v]
                d[v]=d[u]+G[u][v]
                p[v]=u
            end
        end
    end
    return d, p
end