#sort(x) - х не меняет, возвращает копию х отсортированную
#sort!(x) - отсортированный х, он сам меняется
#sortperm!(x) - вектор индексов перестановки х
#sortperm(x) - массив сам не меняется, только копия

# Задача 1 : Написать все функции через пузырек

function bubblesort!(a)
    n = length(a)

    for k = 1:n-1
        for i = 1:n-k
            if a[i]>a[i+1]
                a[i],a[i+1]=a[i+1],a[i]
            end
        end
    end
    return a
end

bubblesort(a)=bubblesort!(copy(a)) #лучше писать не copy, а deepcopy

function bubblesort(a)
    n = length(a)
    a=deepcopy(a)
    for k= 1:n-1
        for i = 1:n-k
            if a[i]>a[i+1]
                a[i],a[i+1]=a[i+1],a[i]
            end
        end
    end
    return a
end

function bubblesortperm!(a) # b- вектор индексов
    n = length(a)
    
    b=collect(1:length(a))  # составляем массив из индексов массива а

    for k= 1:n-1
        for i = 1:n-k
            if a[i]>a[i+1]
                a[i],a[i+1]=a[i+1],a[i]
                b[i],b[i+1]=b[i+1],b[i]
            end
        end
    end
    return b
end

bubblesortperm(a)=bubblesortperm!(deepcopy(a))

function bubblesortperm(a)
    n = length(a)

    b=collect(1:length(a)) 
    b= deepcopy(b)

    for k= 1:n-1
        for i = 1:n-k
            if a[i]>a[i+1]
                a[i],a[i+1]=a[i+1],a[i]
                b[i],b[i+1]=b[i+1],b[i]
            end
        end
    end
    return b
end

# Срезы массива А[i,j]  A[[2,3,5], [1,2]] i=строки j=столбцы вот элементы пересечения этих строк и столбцов - срез массива(копия части массива)
# B = view(A,I,J) 
# c = @A[I,J] два способа записи ссылки на срез
# A[:,k] - срез k столбца 
# function bubblesort!(A::Matrix)
# sum(A,dim = 1) dim=1 - по столбцам столбцам dim=2 по строкам сумма
# length(findall(function(x->x==0),A)) - число 0 в A

# Задача 2 : отсортировать все столбцы матрицы
function matrix_sort_1!(a::Matrix)
    x = view(a,:,1)
    n = length(x)

    for k= 1:n-1
        for i = 1:n-k
            B = view(a,:,i)
            C = view(a,:,i+1)
            if B > C
                B,C=C,B
            end
        end
    end
    return a
end
# Задача 3 : отсортировать столбцы матрицы в порядке возрастания их суммы
function matrix_sort_2!(a::Matrix)
    x = view(a,:,1)
    n = length(x)

    for k= 1:n-1
        for i = 1:n-k
            B = view(a,:,i)
            Bsum = sum(B)
            C = view(a,:,i+1)
            Csum = sum(C)
            if Bsum > Csum
                B,C=C,B
            end
        end
    end
    return a
end
# Задача 4 : отсортировать столбцы матрицы в порядке возрастания кол-ва нулей в них
function matrix_sort_3!(a::Matrix)
    x = view(a,:,1)
    n = length(x)

    for k= 1:n-1
        for i = 1:n-k
            B = view(a,:,i)
            l = length(findall((x==0),B))
            C = view(a,:,i+1)
            m = length(findall((x==0),C))
            if  l > m #!!!!!!!!!! но если писать l > m , то все подчеркивает синим 
                B,C=C,B
            end
        end
    end
    return a
end
# Задача 5 : отсортировать столбцы матрицы, сложность о(n)