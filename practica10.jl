#=Так, решение уравнения методом Ньютона сводится к итерированию формулы $$x_{k+1}=x_{k}-\frac{f(x_{k})}{f^\prime(x_{k})}$$ 
начиная с заданного $x_0$. Итерационный процесс завершают при достижении условия $|x_{k+1}-x_k|\le \varepsilon_x$; иногда, 
для завершения итераций, дополнительно к данному условию проверяют еще условие $|f(x_{k+1})|\le \varepsilon_y$. 
Величины $\varepsilon_x, \ \varepsilon_y$ определяют допустимую погрешность вычислений и должны считаться заданными. 
При этом также следут задать максимально допустимое число итераций, 
при превышении которого считается, что итерационный процесс расходится (или - что скорость его сходимости недопустимо мала).
Задача 1. Реализовать метод Ньютона, написав функцию со следующим заголовком=#
#=newton(r::Function, x; ε_x=1e-8, ε_y=1e-8, nmaxiter=20)
где r- это функция одного аргумента, 
возвращающая при каждом x значение $$\frac{f(x)}{f^\prime(x)},$$ x - заданное начальное приближение.
В случае отсутствия сходимости (в случае превышения заданного максимального числа итераций) функция должна возвращать значение nothing.=#
function newton(f::Function, x; a=1e-8, derrirative=20)
    x0 = a
    xn = f(x0)
    xn1 = xn - f(xn) / derrirative(xn)
    while abs(xn1-xn) > math.pow(10,-3)
        xn = xn1
        xn1 = xn - f(xn) / derrirative(xn)
    end

    return xn1

end
#=Задача 2. Решить с помощью этой функции (newton) уравнение $\cos(x)=x$.
Решение:
julia> newton(x->(x-cos(x))/sin(x), 0.5)    0.739085133215161=#
#=Задача 3. Реализовать ещё один метод функции newton со следующим заголовком
newton(ff::Tuple{Function,Function}, x; ε_x=1e-8, ε_y=1e-8, nmaxiter=20)
где ff - это кортеж из двух функций, причем ff[1] - это функция одного аргумента, возвращающая значение $f(x)$, 
а ff[2] - функция одного аргумента, возвращающая значение $f^\prime(x)$.
Решение:
newton(ff::Tuple{Function,Function}, x; ε_x=1e-8, ε_y=1e-8, nmaxiter=20)=
    newton(x->ff[1](x)/ff[2](x), x; ε_x, ε_y, nmaxiter)
=#
#=Задача 4. Решить с помощью этого варианта функции newton уравнение $\cos(x)=x$.
Решение:
julia> newton((x->x-cos(x), x->sin(x)), 0.5) 
julia> newton((x->x-cos(x), sin), 0.5) # - так тоже можно=#
#=Задача 5. Реализовать еще один метод функции newton со следующим заголовком
newton(ff, x; ε_x=1e-8, ε_y=1e-8, nmaxiter=20)
где ff - это функция одного аргумента ($x$), возвращающая кортеж значений, 
состоящий из значения функции $f(x)$ в текущей точке и из значения её производной $f^\prime(x)$ в той же точке.=#
#=Задача 6. Решить с помощью последнего варианта функции newton уравнение $\cos(x)=x$.
Решение:
julia> newton(x->(x-cos(x),sin(x)), 0.5) =#
#=Задача 7. Реализовать еще один метод функции newton со следующим заголовком
newton(polynom_coeff::Vector{Number}, x; ε_x=1e-8, ε_y=1e-8, nmaxiter=20)=#
newton(polinom_coeff::Vector{Number}, x; ε_x=1e-8, ε_y=1e-8, nmaxiter=20)=
    newton(x->(y=evaldiffpoly(x, polynom_coeff); y[1]/y[2]), x; ε_x, ε_y, nmaxiter)

function evaldiffpoly(x,polynom_coeff)
    Q′=0
    Q=0
    for a in polinom_coeff
        Q′=Q′x+Q
        Q=Q*x+a
    end
    return Q, Q′
end
#=Задача 8 Разработать функцию, осуществляющую визуализацию проблемы Кэлли для заданного порядка n=#
n=length(colors) #предполагается, что порядок уравнения n будет определяться как
#Далее, вектор, состоящий из всех корней уравнения $z^n=1$ может быть определен как
root = [exp(im*2π*k/n) for k in 0:n-1]
#=Возвращает индекс корня (индекс вектора root), притягивающуго в свою ε-окрестность
итерационный процесс, начавшийся в точке z (не более чем за nmaxiter итераций)=#
function newton(z::Complex, root::Vector{Compex}, ε::AbstractFloat,nmaxiter::Integer) 
    n=length(root)
    for k in 1:nmaxiter  
        z -= (z - 1/z^(n-1))/n 
        # - это тоже самое, что и z = z - (z^n - 1)/(n*z^(n-1))
        root_index = findfirst(r->abs(r-z) <= ε, root) 
        # root_index - индекс "притянувшего" в свою ε-окрестность корня или nothing, если никакой корень так близко пока не "притянул"
        if !isnothing(root_index)
            return root_index
        end
    end
    return nothing
end
z = complex((rand(2) .- 0.5) .* squaresize)      
function visualisation(D, colors; markersize, backend::Function)
    backend() # подключается требуемая графическая библиотека
    p=plot()
    for i in 1:length(colors)
        plot!(p, real(D[i]), imag(D[i]),
            seriestype = :scatter,
            markersize = markersize,
            markercolor = colors[i])
    end
    plot!(p; ratio = :equal, legend = false)
    # ratio = :equal - определяет, что масштабы по осям координат будут одинаковые
    # legend = false - определяет, что на графике не будет выводится панель с подписями графиков
end
real.(D[i]), imag.(D[i])
