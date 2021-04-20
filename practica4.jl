# Пакет offsetArrays позволяет создавать массивы с любой индексацией
# Чтобы программировать без привязки к индексации есть несколько функций
# begin , end- 1 и последний элемент массива , begin + 1 - 2 элемент массива
# first(A) - возвращает первый элемент 
# firstindex (A) - индекс первого элемента
# last(A), lastindex(A) - последний и индекс последнего элемента 
# argmax, argmin - индекс первого максимального и первого минимального элемента
# findmax, findmin - индекс максимального и минимального элемета 
# Усовершенствование пузырьковой сортировки: (шейкерная сортировка)
# Задача 2-3:
function shenker!(a)
    len = length(a) # длина массива  
    flag = true
    start_index = 1 # перый индекс массива, можно написать firstindex (A)
    end_index = len - 1 # последний индекс массива, можно написать lastindex(A)

    while (flag == true)
        flag = false

        # проход слева на право 
        for i in start_index:end_index
            if (a[i] > a[i + 1])
                a[i] , a[i + 1] = a[i + 1] , a[i]
                flag = true
            end
        end

        if (not(flag))
            break
        end

        flag = false

        end_index = end_index - 1 

        # проход спарва на лево
        for i in (end_index - 1):-1:(start_index - 1) # можно использовать функции firstindex и lastindex
            if (a[i] > a[i + 1])
                a[i] , a[i + 1] = a[i + 1] , a[i]
                flag = true
            end
        end

        start_index = start_index + 1
    end

    return a

end

#Сортировка Шелла:
function shell(a)
    len = length(a)
    pol = len / 2

    while len >= 1
        for i in pol:len
            x = a[i]
            j = i
        end

        while j >= pol & a[j - pol] > x 
            a[j] = a[j - pol]
            j -= pol
        end

        a[j] = pol

        pol /= 2
    end
    return a
end

# Сортировка выбором наибольшего(наименьшего) элемента
function vibor(a) # Очеедной максимальный элемент перемещается в конец массива сразу после того, как сначала будет найден его индекс
    for i in reverse(eachindex(a))
        i_max = arg_max(@view a[begin:i])
        a[i_max] , a[i] = a[i] , a[i_max]
    end
    return a 
end

# Перестановка элементов в массиве без использования дополнительного массива
# Задача 4:
function slice(A::Vector{T},p::Vector{Int}) :: Vector{T} where T
    b :: Vector{T}
    k = 0
    for i in p
        b[k] = a[i]
        k += 1
    end

    return b
end
# Задача 5:
function permute_!(a::Vector{T}, perm::Vector{Int}) :: Vector{T} where T
    count = 0
    for i in 1:length(a)
        if i != p[i]
            count += 1
        end
    end

    i = 1
    k = p[i]
    x = a[k]
    y = a[i]
    a[i] = a[k]

    count -= 1

    while count!= 0
        k = y
        x = p.index(k)
        y = a[x]
        a[x] = a[k]

        count -= 1
    end

    return a
end
# Вставка / удаление элементов массива
# Задача 6:
function deleteat!(a,x) # удаление элементов
    index = poisk(a,x)
    count = length(a)
    for  i in index:count-1
        a[i] = a[i + 1]
        count -= 1
    end
end
function poisk(ptr,x)
    for  i in 0:count-1
        if (ptr[i] == value)
            return i;
        end
    end
    return -1;
end

function insert!(a,x,index) # вставка элемента по индексу
    for  i in (count - 1):-1:index
        a[i + 1] = a[i]
    end
    a[index] = x
    count += 1
end
# Выбор всех уникальных элементов массив
# Задача 7:
function unique!(a)
    a = sort!(a)
    for i in 0:length(a) - 2
        if a[i]==a[i+1]
            deleteat!(a,a[i+1])
        end
    end
    return a
end

function unique_(a)
    a = sort!(a)
    k = 0
    for i in 0:length(a) - 2
        if a[i]!=a[i+1]
            b[k] = a[i]
            k += 1
        end
    end
    return b
end

function allunique(a)
    a = sort!(a)
    for i in 0:length(a) - 2
        if a[i]==a[i+1]
            return false
        end
    end
    return true
end
# Обращение последовательности
# Задача 8:
function reverse!(a)
    len = length(a)
    n = len
    for i in 0:len/2
        a[i] , a[i+n] = a[i+n], a[i]
        n -= 2
    end
end
# Сдвиг массива 
# Задача 9:
function sdvig(a,m)
    count = length(a)
    count += m
    for i in (count - n):-1:0
        a[i + n] = a[i]
    end

    for j in 0:n-1
        a[j] = -1 # чтобы показать, что мы сдвинули числа, иначе на n первых или последних позициях у нас останутся наши исходные числа
    end

    count -= n # мы не увидим вышедшые за предел числа
end
# Размещение многомерного массива в памяти. Использование многомерного массива в качестве одномерного. Встроенная функция reshape
# Транспонирование матрицы
# Задача 10:
function transpose!(a::Matrix) # с использование доп массива 
    x = length(a) # строки 
    y = length(a[1])
    b :: Matrix
    for i in 1:a
        for j in 1:y 
            b[j][i] = a[i][j]
        end
    end
    return b
end
# Задача 11:
function transpose!(a::Matrix) # без использование доп массива
    x = length(a) # строки 
    y = length(a[1])
    b :: Matrix
    for i in 1:a/2+1
        for j in 1:y/2+1
            c = a[j][i]
            a[j][i] = a[i][j]
            a[i][j] = c
        end
    end
    return a
end