#!/usr/bin/env -S julia 

using Pkg
Pkg.activate(; temp=true)
Pkg.add("JSON3")

using JSON3

flagdict = Dict(
    "Red" => "🟥",
    "Orange" => "🟧",
    "Yellow" => "🟨",
    "Green" => "🟩",
    "Blue" => "🟦",
    "Purple" => "🟪"
)

budgetpath = ARGS[1]

for (root, dirs, files) in walkdir(budgetpath)
    for file in filter(f-> f == "Budget.yfull", files)
        path = joinpath(root, file)
        fh = JSON3.read(path, Dict)
        for t in fh["transactions"]
            flag = get(t, "flag", nothing)
            isnothing(flag) && continue
            t["memo"] = haskey(t, "memo") ? string("#", flagdict[flag], " | ", t["memo"]) : string("#", flagdict[flag])
        end
        JSON3.write(path, fh)
    end
end
