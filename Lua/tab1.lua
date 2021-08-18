function range(num1, num2)
    local numbers = {}
    for i=num1,num2-1 do
        table.insert(numbers,i)
    end
    return numbers
end

for i in range(1,10) do
    print(i)
end

--it's basically for i in range but in lua :joy: