#=Задача 1. Написать и протестировать функцию, получающую на вход список смежностей некоторого графа, 
и возвращающую вектор индексов его вершин, полученных в порядке поиска в глубину.
Указание. За основу взять соответствующий код, разобранный в лекции 8.=#
function dfs(graph, node, visited)
    if node not in visited
        visited.push!(node)
        for k in graph[node]
            dfs(graph, str(k), visited)
        end
    end
    return visited
end
#=Задача 2. Написать и протестировать функцию, получающую на вход список смежностей некоторого графа, 
и возвращающую вектор индексов его вершин, полученных в порядке поиска в ширину.
Указание. За основу взять соответствующий код, разобранный в лекции 8.=#
function bfs(graph, start)
    explored = collect(0)
    queue = [start]
    while queue 
        node = queue[0]
        queue.delete!(0)
        if node not in explored
            explored.push!(node)
            neighbours = graph[node]
            for neighbour in neighbours
                queue.push!(neighbour)
            end
        end
    end
    return explored
end
#=Задача 3. Написать и протестировать функцию, получающую на вход список смежностей некоторого графа, 
и возвращающую вектор валентностей его вершин по выходу.
Указание. Поиск в глубину или в ширину использовать не надо (задача решается совсем просто).=#
function ves(graph)
    result = collect(0)
    for i in 1:length(graph)
        result.push!(graph[i][2])
    end
    return result
end
#=Задача 4. Написать и протестировать функцию, получающую на вход список смежностей некоторого графа, 
и возвращающую вектор валентностей его вершин по входу.
Указание. Воспользоваться идеей алгоритма поиска в глубину (или в ширину), но при этом массив, 
представляющий собой индикатор множества посещенных вершин, не отменяя этой его функции, приспособить для хранения 
в нём подсчитываемых валентностей вершин графа по входу.=#
function bfs(graph, start)
    explored = collect(0)
    queue = [start]
    while queue 
        node = queue[0]
        queue.delete!(0)
        if node not in explored
            explored.push!(node[2])
            neighbours = graph[node]
            for neighbour in neighbours
                queue.push!(neighbour[2])
            end
        end
    end
    return explored
end
#=Задача 5. Написать и протестировать функцию, получающую на вход список смежностей некоторого графа, 
и возвращающую значение true, если он является сильно связным, и значение false - в противном случае.
Указание. За основу взять соответствующий код, разобранный в лекции 8.=#
function strongly_connected(graph::ConnectList)
    for s in 1:length(graph)
        if all_achievable(s, graph) == false
            return false
        end
    end
    return true
end

function all_achievable(started_ver::Integer, graph::ConnectList)
    mark = zeros(Bool,length(graph))
    attempt_achievable!(started_ver, graph, mark)
    return count(m->m==0, mark) == 0 #all(mark .== 1)
end
#=Задача 6. Написать и протестировать функцию, получающую на вход список смежностей некоторого графа, 
и возвращающую значение true, если он является слабо связным, и значение false - в противном случае.=#
function strongly_connected(graph::ConnectList)
    for s in 1:length(graph)
        if all_achievable(s, graph) == false
            return true # не сильно связны = слабо связный
        end
    end
    return false #сильно связны = не слабо связный
end

function all_achievable(started_ver::Integer, graph::ConnectList)
    mark = zeros(Bool,length(graph))
    attempt_achievable!(started_ver, graph, mark)
    return count(m->m==0, mark) == 0 #all(mark .== 1)
end
#=Задача 7. Написать и протестировать функцию, получающую на вход список смежностей некоторого графа, 
и возвращающую число компонент связности в неорграфе.
Указание. Воспользоваться идеей, предложенной в лекции 8=#
function svazka(s::ConnectList)
    board = [0]*200
    for i in 1:200
        board[i] = [0] * 200


    for i in range(n)
        for j in range(m)
            if s[j] == '.'
                board[i][j] = -1
                virs = 0
            end
        end
    end
    for y in 1:n
        for x in 1:m
            if board[y][x] == 0
                virs += 1
                dfs(y, x)
            end
        end
    end
    return virs
end

function dfs(y, x)
    if y < 0 || y >= n || x < 0 || x >= m || board[y][x] != 0
        return
    end
    board[y][x] = 1
    dfs(y - 1, x)
    dfs(y + 1, x)
    dfs(y, x - 1)
    dfs(y, x + 1)
end
#=Задача 8. Написать и протестировать функцию, получающую на вход список смежностей некоторого графа,
и возвращающую вектор, длина которого равна числу компонент связности, и каждый элемент которого содержит индекс 
какой-либо вершины из соответсвующей компоненты связности.
Указание. За основу взять алгоритм решения предыдущей задачи, но, вместо того, чтобы заводить счетчик числа компонент связности, 
завести динамический массив, в который помещать индекс каждой новой стартовой вершины.=#
function svazka(s::ConnectList)
    board = [0]*200
    for i in 1:200
        board[i] = [0] * 200


    for i in range(n)
        for j in range(m)
            if s[j] == '.'
                board[i][j] = -1
                virs = collect(0)
            end
        end
    end
    for y in 1:n
        for x in 1:m
            if board[y][x] == 0
                virs.push(x)
                dfs(y, x)
            end
        end
    end
    return virs
end

function dfs(y, x)
    if y < 0 || y >= n || x < 0 || x >= m || board[y][x] != 0
        return
    end
    board[y][x] = 1
    dfs(y - 1, x)
    dfs(y + 1, x)
    dfs(y, x - 1)
    dfs(y, x + 1)
end
#=Задача 9. Написать и протестировать функцию, получающую на вход список смежностей некоторого графа, 
и возвращающую true, если граф двудольный, и false - в противном случае.
Указание. Воспользоваться идеей, предложенной в лекции 8.=#
function attempt_devide!(start_ver::T, graph::ConnectList{T}, mark::AbstractVector{<:Integer}) where T   

    queue = [startver] # queue - очередь
    mark[startver] = 1 
    while !isempty(queue)
        v = popfirst!(queue)
        for u in graph[v]
            next_num = (mark[v] % 2) + 1
            if mark[u] == 0    
                push!(queue, u)
                mark[u] = next_num
            elseif mark[u] == next_num
                return false
            end
        end
    end
    return true
end
#=Задача 10. Написать и протестировать функцию, получающую на вход список смежностей некоторого графа и 
индексы каких-либо двух его вершин, и возвращающую кратчайший путь из первой вершины во вторую в виде вектора 
из индексов последовательности вершин, через которые проходит этот путь.
Указание. Алгоритм реализовать на базе поиска в ширину. Воспользоваться соответствующими подпрограммами, разобранными в лекции 8.=#
function shortest_dist(start_ver::T, finish_ver::T, graph::ConnectList{T}) where T
    start_ver = 1
    finish_ver = 2
    n = length(graph)
    dists = zeros(Int, n)
    queue  = [start_ver] # - в очередь помещена стартовая вершина
    dist[start_ver] = 1 # - вершина stat_ver "помечена", как помещавшаяся в очередь (значением на 1 большем расстояния до start_ver)
    while !isempty(queue)
        v = popfirst!(queue) # - очередная вершина взята из очереди
        if v == finish_ver return dist[v]-1 end
        for u in graph[v] # - перебор смежных с v вершин
            if dist[u] == 0
                push!(queue, u) # - все смежные с v вершины последовательно помещаются в очередь
                dist[u] = dist[v] + 1 # - вершина u "помечена", как помещавшаяся в очередь (значением на 1 большем расстояния от u до start_ver)
            end
        end
    end
end
#=Задача 11. Написать и протестировать функцию, получающую на вход список смежностей некоторого орграфа, 
и возвращающую последовательность
индексов его вершин в порядке соответствующем топологической сортировке этого графа, или значение nothing, если граф содержит циклы.
Указание. Воспользоваться соответствующими кодом, разобранным в лекции 8.=#
function topological_sort(graph)

    function dfs!(v) # функция dfs! изменяет внешний массив  mark
        mark[v]=true # - помечен факт "входа" в вершину 
        for u in graph[v]
            if !mark[u] # в случае если mark[u] == 1 ребро (v,u) будет проигнорировано
                dfs!(u)
            end
        end
        # имеет место факт "выхода" из вершины
       push!(series_ver, v)
    end

    n = length(graph)
    mark = zeros(Bool,n)
    series_ver = []
    
    for s in 1:n
        if !mark[s]
            dfs!(s)
        end
    end

    return reverse(series_ver)
end