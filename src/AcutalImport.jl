module ActualImport

using JSON3

const flagdict = Dict(
    "Red" => "#k/red",
    "Orange" => "#k/scheduled",
    "Yellow" => "#R",
    "Green" => "🟩",
    "Blue" => "#sync-check",
    "Purple" => "#hsa"
)


function (@main)(ARGS)
    budgetpath = ARGS[1]
    for (root, dirs, files) in walkdir(budgetpath)
        for file in filter(f -> f == "Budget.yfull", files)
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
end

end
