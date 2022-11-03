println("Number of procs, total number of points, @time seconds, @time M allocations, @time memory, @time memory unit, @time % gc time, @time % compliation time, @benchmark time s, @benchmark % GC, @benchmark memory, @benchmark memory unit, @benchmark allocations")
for file in filter(x->endswith(x, ".log"), readdir())
    for line in eachline(open(file))
        if occursin("Number", line)
            # Number of procs, total number of points
            temp = split(lstrip(line), " ")
            print(temp[5], " ", temp[11], ", ")
        elseif occursin("seconds", line)
            # @time seconds, @time M allocations, @time memory, @time memory unit, @time % gc time, @time % compliation time
            line = replace(line, "(" => " ")
            line = replace(line, ")" => " ")
            line = replace(line, "%" => " ")
            line = replace(line, "," => " ")
            temp = split(lstrip(line), " ")
            print(temp[1], ", ", temp[4], ", ", temp[7], ", ", temp[8], ", ", temp[10], ", ", temp[15], ", ")
        elseif occursin("result", line)
            # @benchmark time s, @benchmark % GC
            line = replace(line, "," => " ")
            line = replace(line, "(" => " ")
            line = replace(line, "%" => " ")
            temp = split(lstrip(line), " ")
            print(temp[5], ", ", temp[8], ", ")
        elseif occursin("mean", line)
            # @benchmark time s, @benchmark % GC
            line = replace(line, "%" => " ")
            temp = split(lstrip(line), " ")
            print(temp[8], ", ", temp[20], ", ")
        elseif occursin("memory", line)
            # @benchmark memory, @benchmark memory unit, @benchmark allocations
            line = replace(line, "," => " ")
            temp = split(lstrip(line), " ")
            println(temp[6], ", ", temp[7], ", ", temp[10])
        elseif occursin("Memory", line)
            # @benchmark memory, @benchmark memory unit, @benchmark allocations
            line = replace(line, "," => " ")
            temp = split(lstrip(line), " ")
            temp[8] = replace(temp[8], "." => " ")
            println(temp[3], ", ", temp[4], ", ", temp[8])
        end
    end
end
