#=Напомним, что итерируемым называется объект, например, - с именем iter, который может быть использован в цикле для определения перебираемых значений, так:
for val in iter
    # val - очередной элемент последовательности, определяемой объектом iter
    ....
end
или так
for ind in eachindex(iter) 
    # eachindex - это встроенная функция, получающая на вход некоторый итерируемый объет, и возвращающая другой 
    # итеррируемый объект - генератор (см. ниже), такой что:
    #   ind - номер (индекс) очередного элемента последовательности, определяемой объектом iter
    ....
end
или так:
for (ind, val) in enumerate(iter)     
    # enumerate - это встроенная функция, получающая на вход некоторый итерируемый объет, и возвращающая другой 
    # итеррируемый объект - генератор (см. ниже), такой что:
    #   ind - номер (индекс) очередного элемента последовательности, определяемой объектом iter;
    #   val - его значение
    ....
end=#

#=Задача 1. Определить тип, позволяющий итерировать все размещения с повторениями из n элементов по k.
Указания:
Реализовать два способа:
1.на основе лексикографического порядка (как в лекции);
2.с использованем встроенной функции digits, возвращающей n-ичные цифры заданного целого числа; 
при этом реализовать функцию digits самомтоятельно (достаточно обеспечить только функциональность, 
необходимую для решения данной задачи).
При этом обеспечить возможность передавать в конструктор типа не только число n, но и, при желании, 
возможность передавать вместо него некоторое n-элементное множество (AbstractSet), с тем чтобы при итерировании получать наборы 
элементов непосредственно этого множества.=#
#В лекции 6 сначала был определен абстрактный тип (пункт 6):

abstract type AbstractCombinObject
    # value::Vector{Int} - это поле предполагается у всех конкретных типов, наследующих от данного типа
end

Base.iterate(obj::AbstractCombinObject) = (get(obj), nothing)
Base.iterate(obj::AbstractCombinObject, state) = 
    if next!(obj) == false
        nothing
    else
        (get(obj), nothing)
    end

Base.get(obj::AbstractCombinObject) = obj.value
#а затем - производный от него двухпараметрический тип (см. лекцию 6, пункт 6.1):

struct RepPlacement{N,K} <: AbstractCombinObject
    value::Vector{Int}
end

RepPlacement{N,K}() where {N, K} = RepPlacement{N,K}(ones(Int, K))

function next!(placement::RepPlacement{N,K}) where {N, K}
    c = get(placement)
    i = findlast(item->item < N, c) # N - параметр (первый) типа RepPlacement
    if isnothing(i)
        return false
    end
    c[i] += 1
    c[i+1:end] .= 1
    return true
end
#Здесть параметры типа N, K - определяют число всех элементов в базовом наборе и число элементов в размещениях (во всех одно и то же) 
#выбранных значений из базового набора, соответственно.
#Однако последний тип (производный) можно было бы определить ещё и так (в соответствии со вторым пунктом задания - см. указания):

struct RepPlacement{K} <: AbstractCombinObject
    value::Vector{Int}
    set::Vector
end

RepPlacement{K}(n::Integer) where K = RepPlacement{K}(ones(Int, K),collect(1:n))
RepPlacement{K}(set::Set) where K = RepPlacement{K}(ones(Int, K),collect(set))

Base.get(placement::RepPlacement) = placement.set(placement.value)

function next!(placement::RepPlacement)
    c = placement.value
    n = length(placement.set)
    i = findlast(item->item < n, c)
    if isnothing(i)
        return false
    end
    c[i] += 1
    c[i+1:end] .= 1
    return true
end
#Замечание. Вместо того чтобы делать тип RepPlacement параметрическим, можно было бы просто добавить в структуру еще одно поле:

struct RepPlacement <: AbstractCombinObject
    value::Vector{Int}
    set::Vector
    k::Int
end

RepPlacement(n::Integer, k::Integer) = RepPlacement(ones(Int, k), collect(1:n), k)
RepPlacement(set::Set, n::Integer) = RepPlacement(ones(Int, k), collect(set), k) 

#=Задача 2. Определить тип, позволяющий итерировать все перестановки элементов заданного n элементного множества.
Указание. Обеспечить возможность передавать в конструктор типа как только число n, что соответствовало бы последовательности 
{1,2,...,n}, так и непосредственно какую-либо другую последовательность, представленную одномерным массивом.=#
function (a, l, r) # Функция для печати перестановок строки, Эта функция принимает три параметра: 1. Строка, 2. Начальный индекс строки, 3. Конечный индекс строки.
    if (l==r)
        print(toString(a))
    else
        for i in 1:l
            a[l], a[i] = a[i], a[l]
            permute(a, l+1, r)
            a[l], a[i] = a[i], a[l] # возврат
end

function toString(List)
    return ''.join(List)
end
#=Задача 3. Определить тип, позволяющий итерировать все k-элементные подмножества заданного n-элементного множества.
Указание. Обеспечить возможность передавать в конструктор типа как только число n, что соответствовало бы последовательности 
{1,2,...,n}, так и непосредственно какую-либо другую последовательность, представленную одномерным массивом.=#
function (k,s)
    power_set=collect(k)
    for x in new_array
        for i in range(len(power_set))
            if k == i
                tmp_list = deepcopy(power_set[i])
                tmp_list.insert(x) # вставка элемента
                power_set.insert!(tmp_list)
            end
        end
    end
    print(power_set)
end
#=Задача 4. Определить тип, позволяющий итерировать все размещения без повторений элементов заданного n элементного множества 
(в частности, последовательность {1,2,...,n} может задаваться просто числом n) по k.
Указание. Воспользоваться результатами решения задачи 3 и задачи 2.=#
function permutations(iterable)
    pool = tuple(iterable)
    n = length(pool)
    r = n if length is None else length
    if length > n:
        return
    indices = collect(range(n))
    cycles = collect(range(n, n-length, -1))
    yield tuple(pool[i] for i in indices[:r])
    while n:
        for i in reversed(range(length)):
            cycles[i] -= 1
            if cycles[i] == 0:
                indices[i:] = indices[i+1:] + indices[i:i+1]
                cycles[i] = n - i
            else:
                j = cycles[i]
                indices[i], indices[-j] = indices[-j], indices[i]
                yield tuple(pool[i] for i in indices[:r])
                break
            end
        end
    end
end
#=Задача 5. Определить тип, позволяющий итерировать все разбиения заданного натурального числа n на положительные слагаемые. 
При этом, по-прежднему представляя разбиения как невозрастающие последовательности, перечислять их в порядке, 
обратном лексикографическому.
Например, для n=4, должно получаться: 4, 3+1, 2+2, 2+1+1, 1+1+1+1.
Указание. Уменьшать нужно только самый правый член, не равный 1. Он должен быть уменьшен на 1, а все следующие члены должны быть 
взяты максимально возможными (т.е. - равными ему, пока хватает общей суммы, а значение последний члена - равным остатку от этой суммы).=#
function next_decomp(n,inp,res)
    if len(inp)==0
        return res
    else
        iinp=collect(0)
        rres=res
        for z in inp
            sz = sum(z)
            if sz==n
                zz = sorted(z)
                if not zz in rres
                    rres.insert!(zz)
                end
            else
                k=n-sz
                for i in range(1,k+1)
                    iinp.insert!([i]+z)
                end
        end
        return next_decomp(n,iinp,rres)
    end    
end  

function gen_sum(n)
    res=collect(0)
    for a in next_decomp(n,[[i] for i in range(1,n+1)],[])
        res.insert!(list(reversed(a)))
    end
    return sorted(res,reverse=True)
end 