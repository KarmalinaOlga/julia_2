#=Задача 1. Написать функцию convert(tree::ConnectList{T}, root::T) where T, получающую на вход дерево, 
представленное списком смежностей tree и индексом его корня root, и возвращающая представление того же дерева 
в виде вложенных векторов.=#
ConnectList{T}=Vector{Vector{T}}
NestedVectors = Vector

function convert_to_nested(tree::ConnectList{T},root::T) where T
    nested_tree = []
    for subroot in tree[root]
        push!(nested_tree, convert(tree, subroot))
    end
    push!(nested_tree, root)
    return nested_tree
end
#=Задача 2. Написать функцию convert(tree::NestedVectors), получающую на вход дерево, 
представленное вложенными векторами, и возвращающая кортеж из списка смежностей типа ConnectList этого дерева и индекса его корня.=#
function convert_to_dict(tree::NestedVectors)
    T=typeof(tree[end])
    connect_tree = Dict{T,Vector{T}}()
    
    function recurs_trace(tree)
        connect_tree[tree[end]]=[]
        for subtree in tree[1:end-1] # - перебор всех поддеревьев
            push!(connect_tree[tree[end]], recurs_trace(subtree))
        end
        return tree[end] # - индекс конрня
    end

    recurs_trace(tree)
    return connect_tree
end
function convert_to_list(tree::Dict{T,Vector{T}}) where T
    list_tree=Vector{Vector{T}}(undef,length(tree))
    for subroot in eachindex(list_tree)
        list_tree[subroot]=tree[subroot]
    end
    return list_tree
end
#=Задача 3.Написать функцию convert(tree::ConnectList{T}, root::T) where T, получающую на вход дерево, представленное списком 
смежностей tree и индексом его корня root, и возвращающая ссылку на связанные стркутруры типа Tree{T}, представляющие то же самое 
дерево, где
struct Tree{T}
    index::T
    sub::Vector{Tree{T}}}
    Tree{T}(index) where T = new(index, Tree{T}[])
end=#

#=Задача 4. Написать функцию convert(tree::Tree{T}) where T, получающую на вход ссылку на связанные структуры типа Tree{T}, 
представляющие некоторое дерево, и возвращающая кортеж из списка смежностей типа ConnectList этого дерева и индекса его корня.=#

#=функция, возвращающая высоту заданного дерева
функция, возвращаюшая число всех вершин заданного дерева
функция, возвращающая число всех листьев заданного дерева
функция, возвращающая наибольшую валентность по выходу вершин заданного дерева
функция, возвращающая среднюю длину пути к вершинам заданного дерева=#
function height(tree::Tree) #функция, возвращающая высоту заданного дерева

    h=0
    for sub in tree.sub
        h = max(h,height(sub))
    end
    return h+1
end

function vernumber(tree::Tree) #функция, возвращаюшая число всех вершин заданного дерева
    N=1
    for sub in tree.sub
        N += vernumber(sub)
    end
    return N
end

function leavesnumber(tree::Tree) #функция, возвращающая число всех листьев заданного дерева
    if isempty(tree.sum)
        return 1
    end
    N=0
    for sub in tree.sub
        N += leavesnumber(sub)
    end
    return N
end

function maxvalence(tree::Tree) #функция, возвращающая наибольшую валентность по выходу вершин заданного дерева
    p=length(tree.sub)
    for i in tree.sub
        p = max(p, maxvalence(sub))
    end
    return p
end
function meanpath(tree::Tree) #функция, возвращающая среднюю длину пути к вершинам заданного дерева

    function sumpath_numver()
        N=1
        S=0
        for sub in tree.sub
            s, n = sumpath_numver(sub)
            S += s
            N += n
        end
        return S, N
    end

    S, N = sumpath_numver()
    return S/N
end
#=Задача 6. Написать функцию, получающую на вход имя некоторого типа (встоенного или пользовательского) языка Julia и распечатывающая
список всех дочерних типов в следующем формате:

ЗаданныйТип
    Подтип_1_певого_уровня
        Подтип_1_второго_уровня
            Подтип_1_1_третьего_уровня
            Подтип_1_2_третьего_уровня
            Подтип_1_3_третьего_уровня
            Подтип_1_4_третьего_уровня
        Подтип_2_второго_уровня
            Подтип_2_1_третьего_уровня
            Подтип_2_2_третьего_уровня
            Подтип_2_3_третьего_уровня
Этот формат показан условно: число иерархических уровней в действилельности может быть любым другим, и число подтипов на каждом 
уровне тоже может быть каким угодно.=#

#=Была написана функция find_general(tree::NestedVectors, setver::Set), получающая на вход через первый аргумент 
самодерево, представленное вложенными векторами, а через второй - множество индексов заданных вершин этого дерева. 
Функция возвращает индекс ближайшей к ним родительской вершины.

Задача 7. Требуется переписать эту функцию, используя в качестве исходных данных, представляющих дерево, список смежностей типа 
ConnectList и индекс его корня.=#
function find_general(rootindex::T, tree::ConnectList{T}) where T

    number_visited = 0 # - cчетчик числа посещённых вершин из набора setver
    general = 0 # - в этой переменной формируется результат (начальное значение не должно только входить в диапазон индексов вершин дерева)

    function recurstrace(tree, parent=0) # - выполняет рекурсивную обработку дерева сверху-вниз      
        is_mutable_general = false # при движение по дереву вглубь от корня внешнюю переменную general изменять не надо 

        for subindex in tree[rootindex]
            if number_visited < length(tree)
                toptrace(subindex, tree)
            end
        end

        # number_visited = число ранее посещенных вершин из заданного набора setver
        if tree[end] < length(tree)
            number_visited +=1
            if number_visited == 1
                general = tree[end]
            end                        
        end
        # теперь - обратное движение по дереву - из глубины к корню
        if general==tree[end] 
            is_mutable_general = true # т.е. при движении к корню, внешнюю переменную general снова нужно отслеживать
        end
        if is_mutable_general && number_visited < < length(tree)
            general = parent
        end

println((current=tree[end],parent=parent,general=general)) # - это для отладки
    end

    recurstrace(tree)
    return general
end
